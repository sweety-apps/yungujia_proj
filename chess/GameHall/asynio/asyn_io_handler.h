// aysn_io_handler.h: interface for the aysn_io_handler class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_AYSN_IO_HANDLER_H__9F9EFB65_A817_41C2_AEDD_8DC35E7DF86F__INCLUDED_)
#define AFX_AYSN_IO_HANDLER_H__9F9EFB65_A817_41C2_AEDD_8DC35E7DF86F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <set>
#include "common/mutex.h"
#include "asyn_message_events.h"
#include "timeout_handler.h"

class asyn_io_operation;
//////////////////////////////////////////////////////////////////////
class asyn_io_handler : public timeout_handler , public asyn_message_events
{
public:
	asyn_io_handler();
	virtual ~asyn_io_handler();

public:
	virtual void handle_io_complete(asyn_io_operation *operation_ptr)
	{
	}
	virtual void close() = 0;

	virtual void handle_network_error( bool recv_error = false,
			unsigned long error_code=20000,
			unsigned char type = -1) = 0;

public:
	asyn_io_operation *create_io_operation(unsigned long buffer_len = 0);
	void delete_io_operation(asyn_io_operation *operation_ptr);

	void cancel_io_operations_of_pending(void);
	void delete_io_operations(void);	

	void register_io_operation(asyn_io_operation *operation_ptr);
	void unregister_io_operation(asyn_io_operation *operation_ptr);

	unsigned get_io_operation_count();

private:
	std::set<asyn_io_operation*> _registered_io_operations;
	mutex						 _mutex;

public:
	DECL_LOGGER;
};

#endif // !defined(AFX_AYSN_IO_HANDLER_H__9F9EFB65_A817_41C2_AEDD_8DC35E7DF86F__INCLUDED_)
