// asyn_tcp_listener.h: interface for the asyn_tcp_listener class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ASYN_TCP_LISTENER_H__1C6A45A1_35E6_4931_8C8E_ABA8FFD30F17__INCLUDED_)
#define AFX_ASYN_TCP_LISTENER_H__1C6A45A1_35E6_4931_8C8E_ABA8FFD30F17__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "common/common.h"

class asyn_io_operation;
//////////////////////////////////////////////////////////////////////
class asyn_tcp_listener  
{
public:
    asyn_tcp_listener();
    virtual ~asyn_tcp_listener();

public:
    unsigned short get_bind_port(void);
    void bind(unsigned short port, asyn_io_operation *operation_ptr);

    void accept(asyn_io_operation *operation_ptr);

    void close(void);    

private:
	unsigned short m_bind_port;
};

#endif // !defined(AFX_ASYN_TCP_LISTENER_H__1C6A45A1_35E6_4931_8C8E_ABA8FFD30F17__INCLUDED_)
