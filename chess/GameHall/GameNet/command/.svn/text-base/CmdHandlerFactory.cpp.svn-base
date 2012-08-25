#include "CmdHandlerFactory.h"

IMPL_LOGGER(CmdHandlerFactory)

CmdHandlerFactory* CmdHandlerFactory::GetInstance()
{
    static  CmdHandlerFactory _instance;
    return &_instance;
}

vdt_tcp_cmd_handler* CmdHandlerFactory::CreateCmdHandler(const std::string &host, unsigned short port, bool is_session_conn, bool is_tracer_enabled)
{
    return CmdHandlerFactory::GetInstance()->_createcmdhandler(host, port, is_session_conn, is_tracer_enabled);
}

int CmdHandlerFactory::_setGamenetproxy(int type, const char* server, unsigned short port, const char* user, const char* passwd)
{
    LOG_TRACE("[CmdHandlerFactory::_setGamenetproxy] "<<type<<";"<<server<<";"<<port<<";"<<user<<";"<<passwd);

    if( CMDHANDLERFACTORY_NOMAL != type && CMDHANDLERFACTORY_SOCKET5_PROXY != type && CMDHANDLERFACTORY_HTTP_PROXY != type)
    {
        return -1;
    }

    if(NULL == server || NULL == user || NULL == passwd)
    {
        return -1;
    }

    m_ProxyType = (CmdHandlerFactory_Type)type;
    m_server = server;
    m_port   = port;
    m_user   = user;
    m_passwd = passwd;

    LOG_TRACE("[CmdHandlerFactory::_setGamenetproxy]  finish"<<m_ProxyType<<";"<<server<<";"<<port<<";"<<user<<";"<<passwd);
    return 0;
}

vdt_tcp_cmd_handler* CmdHandlerFactory::_createcmdhandler(const std::string &host, unsigned short port, bool is_session_conn, bool is_tracer_enabled)
{
    LOG_TRACE("[CmdHandlerFactory::_createcmdhandler] enter");
    vdt_tcp_cmd_handler* pHander = NULL;
    switch(m_ProxyType)
    {
        case CMDHANDLERFACTORY_NOMAL:
             LOG_TRACE("[CmdHandlerFactory::_createcmdhandler] CMDHANDLERFACTORY_NOMAL");
             pHander =  new vdt_tcp_cmd_handler(host, port, is_session_conn, is_tracer_enabled);
             break;

        case CMDHANDLERFACTORY_SOCKET5_PROXY:
             LOG_TRACE("[CmdHandlerFactory::_createcmdhandler] CMDHANDLERFACTORY_SOCKET5_PROXY");
             //pHander =  new vdt_tcp_socket5proxy_cmd_handler(host, port, is_session_conn, is_tracer_enabled,
             //                                                m_server.c_str(), m_port, m_user.c_str(), m_passwd.c_str());
             break;

		case CMDHANDLERFACTORY_HTTP_PROXY:
			LOG_TRACE("[CmdHandlerFactory::_createcmdhandler] CMDHANDLERFACTORY_HTTP_PROXY");
			//pHander =  new vdt_tcp_httpproxy_cmd_handler(host, port, is_session_conn, is_tracer_enabled,
			//	m_server.c_str(), m_port, m_user.c_str(), m_passwd.c_str());
			break;

        default:
             break;
    }

    return pHander;
}
