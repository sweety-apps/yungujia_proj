// asyn_io_frame.h: interface for the asyn_io_frame class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ASYN_IO_FRAME_H__1D888AB8_BC84_4302_9C47_0D69BA200FFA__INCLUDED_)
#define AFX_ASYN_IO_FRAME_H__1D888AB8_BC84_4302_9C47_0D69BA200FFA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <list>
#include <signal.h>
#include <time.h>
#include <pthread.h>
#include "common/common.h"
#include "timeout_handler.h"

#define FRAME_INSTANCE() (asyn_io_frame::get_instance())

class asyn_io_operation;
//////////////////////////////////////////////////////////////////////

typedef struct
{
	timeout_handler* handler;
	unsigned long type;
	timer_t timerid;
	unsigned long millisecond;
	_u64 last_occur_ms;
	bool is_cycled;
} timer_node;

typedef std::list<timer_node*> timer_list;

class asyn_io_frame 
{
protected:
	asyn_io_frame();
	virtual ~asyn_io_frame();

	enum { MAX_EPOLL_EVENTS = 10 };

public:
	static asyn_io_frame *get_instance(void);
	static void close(void);

	bool init();
	void uninit();

public:
	//增加该异步io指定类型定时器
	void add_timeout_handler(timeout_handler *handler_ptr, unsigned long millisecond, unsigned long timer_type, bool is_cycled = false );

	//删除该异步io所有定时器
	void remove_timeout_handler(timeout_handler *handler_ptr, unsigned long timer_type);
	void remove_timeout_handler(timeout_handler *handler_ptr);

	bool is_in_frame_thread(void);

	int get_epoll_fd() { return _epfd; }

private:
	static void* main_loop_thread(void* p);
	static void timer_handler(int sig, siginfo_t* si, void* uc);
	void main_loop();

	void check_timer_events(_u64 current);

public:
	static asyn_io_frame *s_instance;
	timer_list _tlist;
	pthread_t _main_loop_id;
	int _epfd;
	bool _is_exit;
	DECL_LOGGER;
};

#endif // !defined(AFX_ASYN_IO_FRAME_H__1D888AB8_BC84_4302_9C47_0D69BA200FFA__INCLUDED_)
