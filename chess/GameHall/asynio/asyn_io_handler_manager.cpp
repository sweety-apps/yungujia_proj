// asyn_io_handler_manager.cpp: implementation of the asyn_io_handler_manager class.
//
//////////////////////////////////////////////////////////////////////

#pragma warning(disable: 4267)

#include "asyn_io_handler_manager.h"
#include "asyn_io_handler.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

asyn_io_handler_manager *asyn_io_handler_manager::s_instance = NULL;
//LOG4CPLUS_CLASS_IMPLEMENT(asyn_io_handler_manager, s_logger, "GN.asyn_io_handler_manager");
IMPL_LOGGER_EX(asyn_io_handler_manager, GN);

asyn_io_handler_manager::asyn_io_handler_manager()
{
	
}

asyn_io_handler_manager::~asyn_io_handler_manager()
{

}

asyn_io_handler_manager *asyn_io_handler_manager::get_instance()
{
	if(NULL == s_instance)
	{
		s_instance = new asyn_io_handler_manager();
	}
	return s_instance;
}

void asyn_io_handler_manager::register_io_handler(asyn_io_handler *io_handler_ptr)
{
	ysh_assert(NULL != io_handler_ptr);	

	scoped_lock lock(m_mutex);
	m_registered_io_handlers.insert(io_handler_ptr);
	LOG_DEBUG( "insert io_handler_ptr: " << io_handler_ptr << 
		", current registered count: " << m_registered_io_handlers.size());
}

void asyn_io_handler_manager::unregister_io_handler(asyn_io_handler *io_handler_ptr)
{
	ysh_assert(NULL != io_handler_ptr);
	scoped_lock lock(m_mutex);
	m_registered_io_handlers.erase(io_handler_ptr);
	LOG_DEBUG("remove io_handler_ptr: " << io_handler_ptr << 
		", current registered count: " << m_registered_io_handlers.size());
}

void asyn_io_handler_manager::delete_all_io_handlers()
{
	LOG_DEBUG("try to delete all io handlers, current registered count: " << m_registered_io_handlers.size());

	for(std::set<asyn_io_handler*>::iterator it = m_registered_io_handlers.begin(); it != m_registered_io_handlers.end(); )
	{
		delete *it;
		LOG_DEBUG( "delete io_handler_ptr: " << *it); 
		m_registered_io_handlers.erase(it++);
	}
}