#pragma once
#include "GameNet/vdt_tcp_cmd_handler.h"
#include "asynio/asyn_tcp_device.h"
#include "asynio/asyn_io_operation.h"
#include "common/SDLogger.h"
#include "common/GameNetInf.h"
#include <string>

// 创建连接的抽象类
class CmdHandlerFactory
{
public:
    CmdHandlerFactory()
    {
        m_ProxyType = CMDHANDLERFACTORY_NOMAL;
    }

    enum CmdHandlerFactory_Type {
        CMDHANDLERFACTORY_NOMAL = 1, // 正常连接
        CMDHANDLERFACTORY_SOCKET5_PROXY = 2, // SOCKET5代理
		CMDHANDLERFACTORY_HTTP_PROXY = 3, // HTTP代理
    };
    static CmdHandlerFactory* GetInstance();
    static vdt_tcp_cmd_handler* CreateCmdHandler(const std::string &host, unsigned short port, bool is_session_conn, bool is_tracer_enabled);
    
    int _setGamenetproxy(int type, const char* server, unsigned short port, const char* user, const char* passwd);
    vdt_tcp_cmd_handler* _createcmdhandler(const std::string &host, unsigned short port, bool is_session_conn, bool is_tracer_enabled);
    int ProxyType()
    {
        return m_ProxyType;
    }
private: 
    std::string    m_server;  // 代理服务器地址
    unsigned short m_port;   // 端口
    std::string    m_user;    // 用户名  
    std::string    m_passwd;  // 密码
    CmdHandlerFactory_Type m_ProxyType;
    DECL_LOGGER;
};
