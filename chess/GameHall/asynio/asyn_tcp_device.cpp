// asyn_tcp_device.cpp: implementation of the asyn_tcp_device class.
//
//////////////////////////////////////////////////////////////////////
#include <sys/socket.h>
#include <sys/epoll.h>
#include <time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>
#include <asm-generic/errno.h>
#include <errno.h>
#include "common/utility.h"
#include "asyn_io_operation.h"
#include "asyn_tcp_device.h"
#include "asyn_io_frame.h"
#include "asyn_io_handler.h"

IMPL_LOGGER_EX(asyn_tcp_device, GN);

#define RECV_BUFF_SIZE (256*1024)

//////////////////////////////////////////////////////////////////////
asyn_tcp_device::asyn_tcp_device() : _sock_fd(-1), _ev(EPOLLET | EPOLLERR | EPOLLHUP)
{
	_is_in_pool = false;
	_last_io_handler = NULL;
}

asyn_tcp_device::~asyn_tcp_device()
{

}

void asyn_tcp_device::clean()
{
	OperationList::iterator it;
	for(it = _send_ops.begin(); it != _send_ops.end(); it++)
	{
		if((*it))
		{
			delete (*it);
		}
	}
	_send_ops.clear();

	for(it = _recv_ops.begin(); it != _recv_ops.end(); it++)
	{
		if((*it))
		{
			delete (*it);
		}
	}
	_recv_ops.clear();

	LOG_TRACE("clean");
}

//////////////////////////////////////////////////////////////////////
bool asyn_tcp_device::connect(const std::string &host, unsigned short port, asyn_io_operation *operation_ptr)
{
	//operation_ptr->set_operation_state(true);
	bool t_op_ret = false;
	do
	{
		int sock_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		if(sock_fd == -1)
		{
			LOG_WARN("can not create socket fd when connect(). errno=" << errno);
			break;
		}

		utility::set_fd_block(sock_fd, false);
		string server_ip = utility::get_first_ip_from_domainname(host.c_str());

		/*
		if(server_ip == "211.98.169.216")
		{
			// 铁通特别处理
			vector<string> vecIP;
			vecIP.push_back("125.39.150.18");
			vecIP.push_back("119.147.41.69");
			vecIP.push_back("119.147.41.96");
			vecIP.push_back("125.39.150.17");
			vecIP.push_back("122.141.227.133");
			vecIP.push_back("125.39.150.27");
			vecIP.push_back("125.39.150.28");
			vecIP.push_back("121.10.137.139");
			vecIP.push_back("121.14.82.130");
			vecIP.push_back("121.14.82.139");

			srand((unsigned int)time(NULL));
			server_ip = vecIP[(rand()%vecIP.size())];
		}
		*/

		struct sockaddr_in addr;
		addr.sin_family = AF_INET;
		addr.sin_addr.s_addr = inet_addr(server_ip.c_str());
		addr.sin_port = htons(port);

		LOG_DEBUG("host=" << host << ", ip=" << server_ip);

		if(::connect(sock_fd, (struct sockaddr*)&addr, sizeof(addr)) == -1)
		{
			if(errno != EINPROGRESS)
			{
				LOG_WARN("connect() return -1, errno=" << errno<<",server_ip="<<server_ip.c_str()<<",port="<<port);
				::close(sock_fd);
				break;
			}
		}

		t_op_ret = true;
		_sock_fd = sock_fd;

		int rcvbuf;
		int rcvbufsize = sizeof(int);

		if( getsockopt(_sock_fd, SOL_SOCKET, SO_RCVBUF, (char*)&rcvbuf, &rcvbufsize) != -1 )
		{
			LOG_DEBUG("adjust recv buffer from " << rcvbuf << " to " << RECV_BUFF_SIZE);
			if(rcvbuf < RECV_BUFF_SIZE)
			{
				rcvbuf = RECV_BUFF_SIZE;
			}

			setsockopt(_sock_fd, SOL_SOCKET, SO_RCVBUF, (char*)&rcvbuf, rcvbufsize);
		}
	} while(false);

	if( t_op_ret )
	{
		if( operation_ptr )
		{
			operation_ptr->on_operation_complete();
			_last_io_handler = operation_ptr->m_io_handler_ptr;
		}
	}

	_is_in_pool = false;
	return t_op_ret;
}

void asyn_tcp_device::set_recv_timeout(unsigned timeout_seconds)
{
	if( _sock_fd != -1 )
	{
		utility::set_socket_recv_timeout(_sock_fd, timeout_seconds);
	}
}

void asyn_tcp_device::refresh_ev()
{
	bool t_need_send = !_send_ops.empty();
	bool t_need_recv = !_recv_ops.empty();

	LOG_TRACE("send=" << _send_ops.size() << ", recv=" << _recv_ops.size());

	if(!t_need_send && !t_need_recv)
	{
		_ev = EPOLLET | EPOLLERR | EPOLLHUP;
		if(_is_in_pool)
		{
			_is_in_pool = false;
			epoll_ctl(FRAME_INSTANCE()->get_epoll_fd(), EPOLL_CTL_DEL, _sock_fd, NULL);
		}
		return;
	}

	if(t_need_send)	_ev |= EPOLLOUT;
	else _ev &= (~EPOLLOUT);

	if(t_need_recv)	_ev |= EPOLLIN;
	else _ev &= (~EPOLLIN);

	struct epoll_event ev;
	ev.data.ptr = this;
	ev.events = _ev;

	if(_is_in_pool)
	{
		epoll_ctl(FRAME_INSTANCE()->get_epoll_fd(), EPOLL_CTL_MOD, _sock_fd, &ev);
	}
	else
	{
		_is_in_pool = true;
		epoll_ctl(FRAME_INSTANCE()->get_epoll_fd(), EPOLL_CTL_ADD, _sock_fd, &ev);
	}
}

bool asyn_tcp_device::read(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos)
{
	if( -1 == _sock_fd && FRAME_INSTANCE() )
	{
		return false;
	}

	operation_node* t_node_ptr = new operation_node();
	t_node_ptr->operation_ptr = operation_ptr;
	t_node_ptr->expected_bytes = expected_bytes;
	t_node_ptr->buffer_pos = buffer_pos;
	t_node_ptr->device_ptr = this;

	_recv_ops.push_back(t_node_ptr);
	refresh_ev();

	operation_ptr->set_operation_state(true);
	return true;
}

bool asyn_tcp_device::read_all(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos)
{
	// TODO readall
	//operation_ptr->set_operation_state(true);
	return false;
}

bool asyn_tcp_device::write(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos)
{
	if( -1 == _sock_fd && FRAME_INSTANCE() )
	{
		return false;
	}

	operation_node* t_node_ptr = new operation_node();
	t_node_ptr->operation_ptr = operation_ptr;
	t_node_ptr->expected_bytes = expected_bytes;
	t_node_ptr->buffer_pos = buffer_pos;
	t_node_ptr->device_ptr = this;

	_send_ops.push_back(t_node_ptr);
	refresh_ev();

	operation_ptr->set_operation_state(true);	
	return true;
}

bool asyn_tcp_device::write_all(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos)
{
	// TODO writeall
	//operation_ptr->set_operation_state(true);
	return false;
}

void asyn_tcp_device::do_operation(int events)
{
	int op_ret = 0;
	char* buffer_ptr = NULL;
	DWORD error_code, bytes_tranfered = 0;

	asyn_io_operation* operation_ptr = NULL;
	operation_node* t_node_ptr = NULL;

	if(events & (EPOLLHUP | EPOLLERR))
	{
		// error occured
		// remove tcp device
		// reconnect
		LOG_ERROR("events=" << events << ", send ops=" << (int)_send_ops.size()
				<< ", recv ops=" << (int)_recv_ops.size()
				<< ", _last_io_handler=" << _last_io_handler);
		epoll_ctl(FRAME_INSTANCE()->get_epoll_fd(), EPOLL_CTL_DEL, _sock_fd, NULL);

		/*
		if((events & EPOLLOUT) && !_send_ops.empty())
		{
			t_node_ptr = _send_ops.front();
			operation_ptr = t_node_ptr->operation_ptr;
			operation_ptr->set_complete_result(errno, 0);
			operation_ptr->on_operation_complete();
		}
		else if((events & EPOLLIN) && !_recv_ops.empty())
		{
			t_node_ptr = _recv_ops.front();
			operation_ptr = t_node_ptr->operation_ptr;
			operation_ptr->set_complete_result(errno, 0);
			operation_ptr->on_operation_complete();
		}
		*/

		bool recv_error = true;
		if(events & EPOLLOUT)
		{
			recv_error = false;
		}

		OperationList::iterator it;
		for(it = _send_ops.begin(); it != _send_ops.end(); it++)
		{
			if((*it))
			{
				operation_ptr = (*it)->operation_ptr;
				operation_ptr->set_operation_state(false);
			}
		}
		_send_ops.clear();

		for(it = _recv_ops.begin(); it != _recv_ops.end(); it++)
		{
			if((*it))
			{
				operation_ptr = (*it)->operation_ptr;
				operation_ptr->set_operation_state(false);
			}
		}
		_recv_ops.clear();

		if(_last_io_handler)
		{
			_last_io_handler->handle_network_error(recv_error, errno, 0);
		}

		return;
	}

	if((events & EPOLLOUT))
	{
		if(_send_ops.empty())
		{
			refresh_ev();
			return;
		}

		t_node_ptr = _send_ops.front();
		if(t_node_ptr)
		{
			_send_ops.remove(t_node_ptr);
			operation_ptr = t_node_ptr->operation_ptr;

			buffer_ptr = (char*)operation_ptr->buffer_ptr() + t_node_ptr->buffer_pos;
			op_ret = utility::send_nonblock_data(_sock_fd, buffer_ptr, t_node_ptr->expected_bytes);
			LOG_TRACE("send [" << t_node_ptr->expected_bytes << "] bytes, actual send " << op_ret);

			delete t_node_ptr;
			bytes_tranfered = op_ret;
			if( op_ret < 0 )
			{
				operation_ptr->set_complete_result(op_ret, bytes_tranfered);
			}
			else
			{
				operation_ptr->set_complete_result(0, bytes_tranfered);
			}

			_is_in_pool = false;
			epoll_ctl(FRAME_INSTANCE()->get_epoll_fd(), EPOLL_CTL_DEL, _sock_fd, NULL);
			refresh_ev();
			operation_ptr->on_operation_complete();
		}
	}

	if((events & EPOLLIN) && !_recv_ops.empty())
	{
		if(_recv_ops.empty())
		{
			refresh_ev();
			return;
		}

		t_node_ptr = _recv_ops.front();
		if(t_node_ptr)
		{
			_recv_ops.remove(t_node_ptr);
			operation_ptr = t_node_ptr->operation_ptr;

			int recv_len = t_node_ptr->expected_bytes;
			buffer_ptr = (char*)operation_ptr->buffer_ptr() + t_node_ptr->buffer_pos;
			op_ret = utility::recv_nonblock_data(_sock_fd, buffer_ptr, recv_len);
			LOG_TRACE("recv [" << t_node_ptr->expected_bytes << "] bytes, actual recv " << op_ret);

			delete t_node_ptr;
			bytes_tranfered = op_ret;
			if( op_ret < 0 )
			{
				operation_ptr->set_complete_result(op_ret, bytes_tranfered);
			}
			else
			{
				operation_ptr->set_complete_result(0, bytes_tranfered);
			}

			_is_in_pool = false;
			epoll_ctl(FRAME_INSTANCE()->get_epoll_fd(), EPOLL_CTL_DEL, _sock_fd, NULL);
			refresh_ev();
			operation_ptr->on_operation_complete();
		}
	}
}

void asyn_tcp_device::close(void)
{
	if( -1 != _sock_fd )
	{
		clean();
		epoll_ctl(FRAME_INSTANCE()->get_epoll_fd(), EPOLL_CTL_DEL, _sock_fd, NULL);
		::close(_sock_fd);
	}

	_is_in_pool = false;
}

/*
bool asyn_tcp_device::get_local_address( sockaddr_in& result )
{
	// TODO get local address
	return false;
}

bool asyn_tcp_device::get_remote_address( sockaddr_in& result )
{
	// TODO get remote address
	return false;
}
*/

void asyn_tcp_device::set_rev_buffer( unsigned long bytes )
{
    // TODO set_rev_buffer
}
