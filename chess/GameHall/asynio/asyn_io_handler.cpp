// aysn_io_handler.cpp: implementation of the aysn_io_handler class.
//
//////////////////////////////////////////////////////////////////////

#include <assert.h>

#define ysh_assert assert

#include "asyn_io_operation.h"
#include "asyn_io_handler.h"
using std::pair;

//LOG4CPLUS_CLASS_IMPLEMENT(asyn_io_handler, s_logger, "GN.asyn_io_handler");
IMPL_LOGGER_EX(asyn_io_handler, GN);

//////////////////////////////////////////////////////////////////////
asyn_io_handler::asyn_io_handler()
{
	LOG_DEBUG( "enter asyn_io_handler  ctor(), ptr:" << this);
	int i = 0;
}

asyn_io_handler::~asyn_io_handler()
{
	LOG_DEBUG( "enter asyn_io_handler  dtor(). ptr:" << this);

	delete_io_operations();

	LOG_DEBUG( "exit asyn_io_handler  dtor().");
}

//////////////////////////////////////////////////////////////////////
asyn_io_operation *asyn_io_handler::create_io_operation( unsigned long buffer_len )
{
	asyn_io_operation *operation_ptr = new asyn_io_operation( this, buffer_len );
	LOG_TRACE( "new operation: " << operation_ptr << " of size: " << buffer_len );
	return operation_ptr;
}

void asyn_io_handler::delete_io_operation( asyn_io_operation *operation_ptr )
{
	ysh_assert( operation_ptr->handler_ptr() == this );

	unregister_io_operation( operation_ptr );
	LOG_TRACE( "delete operation_ptr: " << operation_ptr << ", is_pending: " << operation_ptr->is_pending() );
	if( false != operation_ptr->is_pending() )
	{
		operation_ptr->cancel();
	}
	delete operation_ptr;
}

void asyn_io_handler::register_io_operation( asyn_io_operation *operation_ptr )
{
	ysh_assert( NULL != operation_ptr );

	scoped_lock lock(_mutex );
	pair< std::set<asyn_io_operation*>::iterator, bool > insert_result;
	insert_result = _registered_io_operations.insert( operation_ptr );
	ysh_assert( true == insert_result.second );

	LOG_TRACE( "insert operation_ptr: " << operation_ptr <<
									", current registered count: " << _registered_io_operations.size() );
}

void asyn_io_handler::unregister_io_operation( asyn_io_operation* operation_ptr )
{
	ysh_assert( NULL != operation_ptr );

	scoped_lock lock(_mutex );
	unsigned deleted_number = _registered_io_operations.erase(operation_ptr);
	ysh_assert(deleted_number > 0);
	LOG_TRACE(  "remove operation_ptr: " << operation_ptr <<
									", current registered count: " << _registered_io_operations.size() );
}

void asyn_io_handler::delete_io_operations(void)
{
	scoped_lock lock(_mutex );
	LOG_DEBUG( "close operations of all, current registered count: " << _registered_io_operations.size());
	std::set<asyn_io_operation *>::iterator it = _registered_io_operations.begin();
	while(it != _registered_io_operations.end())
	{
		asyn_io_operation *operation_ptr = *it;
		if( false != operation_ptr->is_pending() )
		{
			LOG_DEBUG(  "cancel operation_ptr: " << operation_ptr );
			operation_ptr->cancel();
		}
		LOG_DEBUG(  "delete operation_ptr: " << operation_ptr );
		delete operation_ptr;

		LOG_DEBUG(  "erase operation_ptr: " << operation_ptr );
		_registered_io_operations.erase(it ++);
	}
}

void asyn_io_handler::cancel_io_operations_of_pending(void)
{
	scoped_lock lock(_mutex );
	LOG_DEBUG( "cancel operations of all pending, current registered count: " << _registered_io_operations.size());
	std::set<asyn_io_operation *>::iterator it = _registered_io_operations.begin();
	while(it != _registered_io_operations.end())
	{
		asyn_io_operation *operation_ptr = *it;
		if( false != operation_ptr->is_pending() )
		{
			LOG_TRACE(  "cancel operation_ptr: " << operation_ptr );
			operation_ptr->cancel();
			delete operation_ptr;

			_registered_io_operations.erase(it ++);
		}
		else
		{
			it ++;
		}
	}
}

unsigned asyn_io_handler::get_io_operation_count()
{
	return _registered_io_operations.size();
}
