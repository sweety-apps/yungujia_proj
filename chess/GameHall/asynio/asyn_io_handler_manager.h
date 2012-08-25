// asyn_io_handler_manager.h: interface for the asyn_io_handler_manager class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ASYN_IO_HANDLER_MANAGER_H__4EC23900_93D4_4D3C_8F22_E447578BF883__INCLUDED_)
#define AFX_ASYN_IO_HANDLER_MANAGER_H__4EC23900_93D4_4D3C_8F22_E447578BF883__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "common/mutex.h"
#include <set>

using std::set;

class asyn_io_handler;

class asyn_io_handler_manager  
{
private:
	asyn_io_handler_manager();
	virtual ~asyn_io_handler_manager();
	
public:
	static asyn_io_handler_manager *get_instance();
	void register_io_handler(asyn_io_handler *io_handler_ptr);
	void unregister_io_handler(asyn_io_handler *io_handler_ptr);
	void delete_all_io_handlers();

private:
	static asyn_io_handler_manager *s_instance;
	set<asyn_io_handler*> m_registered_io_handlers;
	mutex m_mutex;
	DECL_LOGGER;
};

#endif // !defined(AFX_ASYN_IO_HANDLER_MANAGER_H__4EC23900_93D4_4D3C_8F22_E447578BF883__INCLUDED_)
