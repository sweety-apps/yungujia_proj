// asyn_io_operation.cpp: implementation of the asyn_io_operation class.
//
//////////////////////////////////////////////////////////////////////

#include "asyn_io_handler.h"
#include "asyn_io_operation.h"

//extern int asyn_io_operation_count;

//LOG4CPLUS_CLASS_IMPLEMENT( asyn_io_operation, s_logger, "GN.asyn_io_operation" );
IMPL_LOGGER_EX(asyn_io_operation, GN);

//////////////////////////////////////////////////////////////////////
asyn_io_operation::asyn_io_operation(asyn_io_handler *handler_ptr, unsigned long buffer_len)
	: m_io_handler_ptr(handler_ptr), m_is_pending(false), m_buf_pos(0), m_buf_len(0), m_buf_ptr(0)
{
	LOG_TRACE(  "enter asyn_io_operation(). ptr:" << this );

	ysh_assert(NULL != m_io_handler_ptr);
	m_io_handler_ptr->register_io_operation(this);
	if( 0 != buffer_len )
	{
		unsigned char * t_buff = alloc_buffer(buffer_len);
		ysh_assert(t_buff != NULL);
	}
}

asyn_io_operation::~asyn_io_operation()
{
	LOG_TRACE( "enter ~asyn_io_operation(). ptr:" << this );
	if(m_buf_ptr != m_init_buf)
	{
		delete m_buf_ptr;
		m_buf_ptr = 0;
	}

	m_buf_len = m_buf_pos = 0;
}

//////////////////////////////////////////////////////////////////////
void asyn_io_operation::on_operation_complete(  )
{
	set_operation_state( false );
	LOG_DEBUG(  "operation_ptr: " << this << " is complete, operate type: " << get_operation_type() << " of handler_ptr: " << m_io_handler_ptr );

	if( NULL == m_io_handler_ptr )
	{
		delete this;
	}
	else
	{
		do_complete_dispose();
	}
}

//////////////////////////////////////////////////////////////////////
void asyn_io_operation::do_complete_dispose()
{
	m_io_handler_ptr->handle_io_complete(this);
}

void asyn_io_operation::cancel()
{
	// TODO
	m_is_pending     = false; 
	m_io_handler_ptr = NULL;
}

//////////////////////////////////////////////////////////////////////
unsigned char *asyn_io_operation::alloc_buffer( unsigned long buf_len )
{
	if(buf_len == 0)
	{
		return NULL;
	}

	if(buf_len < AIO_OP_INIT_BUFFER_LEN)
	{
		m_buf_ptr = m_init_buf;
		m_buf_len = buf_len;
		return m_buf_ptr;
	}

	unsigned char *t_buff = new unsigned char[buf_len];
	if(!t_buff)
	{
		return NULL;
	}

	m_buf_len = buf_len;
	m_buf_ptr = t_buff;
	return m_buf_ptr;
}

bool asyn_io_operation::get_complete_result( DWORD& bytes_transfered, DWORD& error_code )
{
	error_code = m_error_code;
	bytes_transfered = m_bytes_transfered;
	return true;
}

void asyn_io_operation::set_complete_result( DWORD error_code, DWORD bytes_transfered )
{
	m_error_code = error_code;
	m_bytes_transfered = bytes_transfered;
}
/*
void asyn_io_operation::take_result_interface(IUnknown **ppInterface)
{

}

void asyn_io_operation::get_result_interface(IUnknown **ppInterface)
{

}

void asyn_io_operation::set_result_interface(IUnknown *pInterface)
{

}
*/

unsigned asyn_io_operation::get_operate_pos( void )
{
	return m_buf_pos;
}

void asyn_io_operation::set_operate_pos( unsigned pos )
{
	m_buf_pos = pos;
}

void asyn_io_operation::set_socket_address( unsigned long lRemoteIp, unsigned short lRemotePort)
{
	//HRESULT lr1 = m_spAsynIoOperation->SetSocketAddress( lRemoteIp, lRemotePort ); ysh_assert( SUCCEEDED( lr1 ) );
}

void asyn_io_operation::get_socket_address( unsigned long *pRemoteIp, unsigned short* pRemotePort)
{
	//HRESULT lr1 = m_spAsynIoOperation->GetSocketAddress( pRemoteIp, pRemotePort ); ysh_assert( SUCCEEDED( lr1 ) );
}

