// asyn_tcp_listener.cpp: implementation of the asyn_tcp_listener class.
//
//////////////////////////////////////////////////////////////////////

#include "asyn_io_operation.h"
#include "asyn_tcp_listener.h"

//////////////////////////////////////////////////////////////////////
asyn_tcp_listener::asyn_tcp_listener()
  : m_bind_port(0)
{

}

asyn_tcp_listener::~asyn_tcp_listener()
{
}

//////////////////////////////////////////////////////////////////////
unsigned short asyn_tcp_listener::get_bind_port(void)
{
//	ysh_assert(NULL != m_spAsynTcpListener);
	return m_bind_port;
}

void asyn_tcp_listener::bind(unsigned short port, asyn_io_operation *operation_ptr)
{
	// TODO bind
	m_bind_port = port;
}

void asyn_tcp_listener::accept(asyn_io_operation *operation_ptr)
{
	// TODO accept
	operation_ptr->set_operation_state(true);
}

void asyn_tcp_listener::close(void)
{
	// TODO close
}
