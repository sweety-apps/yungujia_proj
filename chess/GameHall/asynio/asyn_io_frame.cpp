// asyn_io_frame.cpp: implementation of the asyn_io_frame class.
//
//////////////////////////////////////////////////////////////////////
#include <sys/epoll.h>
#include <asm-generic/errno.h>
#include <errno.h>
#include "common/utility.h"
#include "asyn_io_operation.h"
#include "asyn_io_frame.h"
#include "asyn_io_device.h"

asyn_io_frame *asyn_io_frame::s_instance = 0;

IMPL_LOGGER_EX(asyn_io_frame, GN);

//////////////////////////////////////////////////////////////////////
asyn_io_frame::asyn_io_frame() : _is_exit(true), _main_loop_id(0), _epfd(0)
{
}

asyn_io_frame::~asyn_io_frame()
{
}

bool asyn_io_frame::init()
{
	LOG_INFO("asyn_io_frame::init enter");
	_epfd = epoll_create(256);
	if( _epfd <= 0 )
	{
		LOG_ERROR("epoll_create failed! errno" << errno);
		return false;
	}

	_is_exit = false;

	int ret = pthread_create(&_main_loop_id, NULL, main_loop_thread, this);
	if( ret != 0 )
	{
		LOG_ERROR("pthread_create failed! errno=" << errno);
		return false;
	}

	struct sigaction sa;
	sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = timer_handler;
    sigemptyset(&sa.sa_mask);

    if(sigaction(SIGRTMIN, &sa, NULL) == -1)
    {
    	LOG_ERROR("sigaction fail! errno=" << errno);
    	return false;
    }

	LOG_INFO("asyn_io_frame::init succeeded");
	return true;
}

void asyn_io_frame::uninit()
{
	_is_exit = true;
	if( _main_loop_id )
	{
		pthread_join(_main_loop_id, NULL);
	}

	timer_list::iterator it;
	for(it = _tlist.begin(); it != _tlist.end(); it++)
	{
		timer_node* t_node = (*it);
		timer_delete(t_node->timerid);
		delete t_node;
		t_node = NULL;
	}

	_tlist.clear();
}

//////////////////////////////////////////////////////////////////////
asyn_io_frame *asyn_io_frame::get_instance(void)
{
	if( 0 == s_instance )
	{
		s_instance = new asyn_io_frame();
	}
	return s_instance;
}

void asyn_io_frame::close(void)
{
	if( 0 != s_instance )
	{
		s_instance->uninit();
		delete s_instance;
		s_instance = 0;
	}
}

void asyn_io_frame::timer_handler(int sig, siginfo_t* si, void* uc)
{
	timer_node* t_node = (timer_node*)(si->si_value.sival_ptr);
	if(t_node)
	{
		LOG_INFO("timer id=" << t_node->type << " occur");
		int orrun = timer_getoverrun(t_node->timerid);
		if(orrun != -1)
		{
			//LOG_DEBUG("overrun count = " << orrun);
		}

		if( t_node->handler )
		{
			t_node->handler->handle_timeout(t_node->type);
		}
	}

	//signal(sig, SIG_IGN);
}

void asyn_io_frame::add_timeout_handler(timeout_handler *handler_ptr,
		unsigned long millisecond, unsigned long timer_type, bool is_cycled)
{
	timer_list::iterator it;
	bool is_exist = false;
	for(it = _tlist.begin(); it != _tlist.end(); it++)
	{
		timer_node* t_node = (*it);
		if(t_node->handler == handler_ptr && t_node->type == timer_type)
		{
			is_exist = true;
			//t_node.millisecond = millisecond;
			//t_node.is_cycled = is_cycled;
			//t_node.last_occur_ms = utility::current_time_ms();
			break;
		}
	}

	if(is_exist)
	{
		LOG_WARN("timer:" << timer_type << " has exist!");
		return;
	}

	sigset_t mask;
	timer_t t_timerid;
	struct sigevent evp;

	sigemptyset(&mask);
    sigaddset(&mask, SIGRTMIN);
    if(sigprocmask(SIG_SETMASK, &mask, NULL) == -1)
    {
    	LOG_ERROR("sigprocmask failed! errno=" << errno);
    	return;
    }

	timer_node* new_node = new timer_node;
	new_node->handler = handler_ptr;
	new_node->type = timer_type;
	new_node->millisecond = millisecond;
	new_node->is_cycled = is_cycled;

	evp.sigev_notify = SIGEV_SIGNAL;
	evp.sigev_signo = SIGRTMIN;
	evp.sigev_value.sival_ptr = new_node;

	if( timer_create(CLOCK_REALTIME, &evp, &t_timerid) == -1 )
	{
		delete new_node;
		LOG_ERROR("timer_create failed! errno=" << errno);
		return;
	}
	new_node->timerid = t_timerid;

	struct itimerspec its;
	its.it_value.tv_sec = millisecond / 1000;
	its.it_value.tv_nsec = 1000 * (millisecond % 1000);
	if(is_cycled)
	{
		its.it_interval.tv_sec = its.it_value.tv_sec;
		its.it_interval.tv_nsec = its.it_value.tv_nsec;
	}
	else
	{
		its.it_interval.tv_sec = 0;
		its.it_interval.tv_nsec = 0;
	}

	if( timer_settime(t_timerid, 0, &its, NULL) == -1 )
	{
		delete new_node;
		LOG_ERROR("timer_settime failed! errno=" << errno);
		return;
	}
	new_node->last_occur_ms = utility::current_time_ms();

	_tlist.push_back(new_node);
	sigprocmask(SIG_UNBLOCK, &mask, NULL);
}

void asyn_io_frame::remove_timeout_handler(timeout_handler *handler_ptr, unsigned long timer_type)
{
	timer_list::iterator it;
	bool is_exist = false;
	for(it = _tlist.begin(); it != _tlist.end(); it++)
	{
		timer_node* t_node = (*it);
		if(t_node->handler == handler_ptr && t_node->type == timer_type)
		{
			is_exist = true;
			break;
		}
	}

	if(is_exist)
	{
		LOG_INFO("remove timer:" << timer_type);
		timer_t t_timerid = (*it)->timerid;
		timer_delete(t_timerid);
		delete (*it);
		_tlist.erase(it);
	}
}

void asyn_io_frame::remove_timeout_handler(timeout_handler *handler_ptr)
{
	timer_list::iterator it;
	timer_list new_list;
	bool is_need_copy = false;
	for(it = _tlist.begin(); it != _tlist.end(); it++)
	{
		timer_node* t_node = (*it);
		if(t_node->handler != handler_ptr)
		{
			new_list.push_back(t_node);
		}
		else
		{
			is_need_copy = true;
			timer_delete(t_node->timerid);
			delete t_node;
			t_node = NULL;
		}
	}

	if( is_need_copy )
	{
		_tlist.clear();
		for(it = new_list.begin(); it != new_list.end(); it++)
		{
			_tlist.push_back((*it));
		}
	}
}

void asyn_io_frame::check_timer_events(_u64 current)
{
	timer_list::iterator it;

	for(it = _tlist.begin(); it != _tlist.end(); )
	{
		timer_node* t_node = (*it);
		if( t_node->last_occur_ms + t_node->millisecond <= current )
		{
			t_node->last_occur_ms = current;
			if( t_node->handler )
			{
				t_node->handler->handle_timeout(t_node->type);
			}

			if( !t_node->is_cycled )
			{
				it = _tlist.erase(it);
				continue;
			}
		}

		it++;
	}
}

bool asyn_io_frame::is_in_frame_thread(void)
{
	return true;
}

void* asyn_io_frame::main_loop_thread(void* p)
{
	asyn_io_frame *this_ptr = (asyn_io_frame*)p;
	if( this_ptr )
	{
		this_ptr->main_loop();
	}

	return NULL;
}

void asyn_io_frame::main_loop()
{
	LOG_INFO("Thread: in main loop");
	while( !_is_exit )
	{
		struct epoll_event events[20];

		int ret = epoll_wait(_epfd, events, MAX_EPOLL_EVENTS, -1);
		if(ret == -1)
		{
			if(errno == EINTR)
			{
				continue;
			}
			else
			{
				// report to monitor
				LOG_ERROR("epoll_wait() returns -1, errno=" << errno);
				break;
			}
		}
		else
		{
			//_u64 start = utility::current_time_ms();
			//static _u64 last_check_time = utility::current_time_ms();

			//if(start > last_check_time + 100)
			//{
			//	last_check_time = start;
			//	check_timer_events(start);
			//}

			list<epoll_event> triggered_events;

			for(int i = 0; i < ret; i++)
			{
				LOG_DEBUG("i=" << i << ", event=" << events[i].events);
				triggered_events.push_back(events[i]);
			}

			list<epoll_event>::iterator it;
			for(it = triggered_events.begin(); it != triggered_events.end(); it++)
			{
				asyn_io_device* t_device = (asyn_io_device*)((*it).data.ptr);
				if(t_device)
				{
					LOG_DEBUG("do_operation events=" << (*it).events);
					t_device->do_operation((*it).events);
				}
				else
				{
					LOG_WARN("device pointer is NULL!");
				}
			}
		}
	}
}
