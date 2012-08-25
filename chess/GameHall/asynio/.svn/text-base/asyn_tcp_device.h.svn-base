// asyn_tcp_device.h: interface for the asyn_tcp_device class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ASYN_TCP_DEVICE_H__8123429C_8D64_458F_B7C8_53CF70A62EA2__INCLUDED_)
#define AFX_ASYN_TCP_DEVICE_H__8123429C_8D64_458F_B7C8_53CF70A62EA2__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "common/common.h"
#include <string>
#include <list>
#include "asyn_io_device.h"

using std::list;

class asyn_io_operation;
class asyn_io_handler;

typedef std::list<operation_node*> OperationList;

/////////////////////////////////////////////////////////////
class asyn_tcp_device : public asyn_io_device
{
public:
	asyn_tcp_device();
	virtual ~asyn_tcp_device();

public:
	bool connect(const std::string &host, unsigned short port, asyn_io_operation *operation_ptr);
	void set_recv_timeout( unsigned timeout_seconds );

	virtual bool read(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos = 0);
	virtual bool read_all(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos = 0);

	virtual bool write(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos = 0);
	virtual bool write_all(asyn_io_operation *operation_ptr, unsigned expected_bytes, unsigned buffer_pos = 0);
	virtual void close(void);

	virtual void do_operation(int events);

	//bool get_local_address( sockaddr_in& result );
	//bool get_remote_address( sockaddr_in& result );

	void set_rev_buffer(unsigned long bytes);

private:
	void refresh_ev();
	void clean();

private:
	int 			_sock_fd;
	OperationList 	_send_ops;
	OperationList 	_recv_ops;
	int 			_ev;
	bool 			_is_in_pool;
	asyn_io_handler* _last_io_handler;
	DECL_LOGGER;
};

#endif // !defined(AFX_ASYN_TCP_DEVICE_H__8123429C_8D64_458F_B7C8_53CF70A62EA2__INCLUDED_)
