#pragma once
#include "vdt_c2s_cmd_handler.h"
#include "asynio/asyn_tcp_device.h"
#include "asynio/asyn_io_operation.h"
#include "common/SDLogger.h"
#include "common/GameNetInf.h"
#include <string>

//#define D_TCP_RECONN_TIMES 3
//#define D_TCP_RECONN_INTERVAL_1 5
//#define D_TCP_RECONN_INTERVAL_2 30
class vdt_tcp_cmd_handler :
	public vdt_c2s_cmd_handler
{
public:
	vdt_tcp_cmd_handler(const std::string &host, unsigned short port,bool is_session_conn, bool is_tracer_enabled);
	virtual ~vdt_tcp_cmd_handler(void);

	virtual bool is_connected() { return _is_connected; }
	virtual void connect();
    virtual int connect_type()
    {
        return 1;
    }

private:
    DECL_LOGGER; //LOG4CPLUS_CLASS_DECLARE(s_logger);
};
