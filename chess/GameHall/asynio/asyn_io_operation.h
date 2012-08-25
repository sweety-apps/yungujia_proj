// asyn_io_operation.h: interface for the asyn_io_operation class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ASYN_IO_OPERATION_H__886175D1_143D_4509_8056_403B3915518B__INCLUDED_)
#define AFX_ASYN_IO_OPERATION_H__886175D1_143D_4509_8056_403B3915518B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "common/common.h"
#include "asyn_io_operation_events.h"

const int OP_SOCK_RECV		= 2;
const int OP_SOCK_SEND		= 3;
const int OP_SOCK_CONNECT	= 4;
const int OP_SOCK_ACCEPT    = 5;

class asyn_io_handler;
//////////////////////////////////////////////////////////////////////
class asyn_io_operation : public asyn_io_operation_events
{
	friend class asyn_io_handler;

public:
	asyn_io_operation(asyn_io_handler *handler_ptr, unsigned long buffer_len = 0);
	virtual ~asyn_io_operation();

public: // interface of asyn_io_operation_events
	virtual void on_operation_complete();

public:
	virtual void do_complete_dispose();
	// 取消正在进行的异步io，就是把handler_ptr置为NULL
	void cancel();

public:
	// 分配的内存由这个类管理
	unsigned char *alloc_buffer( unsigned long buf_len );
	unsigned char *buffer_ptr()
	{
		return m_buf_ptr;
	}
	unsigned long buffer_len()
	{
		return m_buf_len;
	}

	// 收到完成通知后，asyn_io_manager调用handler_ptr去处理
	// 如果是NULL值，asyn_io_manager认为这个完成通知不需要
	// 进行处理，asyn_io_manager会删除asyn_io_operation对象
	asyn_io_handler *handler_ptr()
	{
		return m_io_handler_ptr;
	}

	// 成功发起一个异步操作后，返回true，其他情况返回false
	bool is_pending(void)
	{
		return m_is_pending;
	}
	void set_operation_state(bool is_pending)
	{
		m_is_pending = is_pending;
	}

	// 当io完成时，调用以下函数取完成结果，返回true表示io成功完成
	// 返回false表示io失败，调用get_error_code得到失败代码
	bool get_complete_result( DWORD& bytes_transfered, DWORD& error_code );
	void set_complete_result( DWORD error_code, DWORD bytes_transfered );

	//void take_result_interface(IUnknown **ppInterface);
	//void get_result_interface(IUnknown **ppInterface);
	//void set_result_interface(IUnknown *pInterface);

	// 异步io完成后，这个函数返回这个io的类型，取值范围见最上方的常量定义
	long get_operation_type( void )
	{
		return m_operation_type;
	}
	void set_operation_type( long operation_type )
	{
		m_operation_type = operation_type;
	}

	void set_socket_address( unsigned long lRemoteIp, unsigned short lRemotePort);
	void get_socket_address( unsigned long *pRemoteIp, unsigned short* pRemotePort);

	unsigned get_operate_pos( void );
	void set_operate_pos( unsigned pos );

protected:
	enum { AIO_OP_INIT_BUFFER_LEN = 2048 };

public:
	asyn_io_handler *m_io_handler_ptr;
	bool			 m_is_pending;
	long 			 m_operation_type;
	DWORD 			 m_error_code;
	DWORD 			 m_bytes_transfered;
	unsigned char 	*m_buf_ptr;
	unsigned long  	 m_buf_len;
	unsigned long  	 m_buf_pos;
	unsigned char    m_init_buf[AIO_OP_INIT_BUFFER_LEN];

	DECL_LOGGER; //LOG4CPLUS_CLASS_DECLARE(s_logger);
};

#endif // !defined(AFX_ASYN_IO_OPERATION_H__886175D1_143D_4509_8056_403B3915518B__INCLUDED_)
