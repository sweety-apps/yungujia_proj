#include "XIdGen.h"
#include "GameNetInstance.h"
#include "vdt_tcp_cmd_handler.h"
#include "command/CmdGetDir.h"
#include "command/CmdExitRoom.h"
#include "command/CmdChat.h"
#include "command/CmdQuitGame.h"
#include "command/CmdAskStart.h"
#include "command/CmdChatNotify.h"
#include "command/CmdGameActionNotify.h"
#include "command/CmdKickout.h"
#include "command/CmdGameSvrDx.h"
#include "command/CmdNonSessionDx.h"
#include "command/CmdBalanceSvrDx.h"
#include "command/CmdGetUserGameInfo.h"
#include "GameUtil.h"
#include "command/DataID.h"
#include "command/CmdHandlerFactory.h"
#include "command/CmdCommon.h"
#include "command/GameCmdFlexFactory.h"

CGameNetInstance* CGameNetInstance::s_instance = NULL;
int XIDGen::m_nNextID = XIDGen::XID_MIN_LIMIT;
bool XIDGen::m_bInited = false;

//IMPL_LOGGER_EX(CGameNetInstance, GN);
IMPL_LOGGER(CGameNetInstance);

CGameNetInstance::CGameNetInstance()
{
//	m_pGameEvent = NULL;
	m_is_querying_dir = false;
	m_is_querying_userinfo = false;
//	m_query_dir_handler = NULL;
	m_query_userinfo_handler = NULL;
	
	m_tracer_enabled = false;

    m_is_using_proxy = false;
    m_proxy_port = 0;
}

CGameNetInstance* CGameNetInstance::GetInstance()
{
	static CGameNetInstance _instance;
	return &_instance;
}

BOOL CGameNetInstance::InitEvent(IGameNetEvent* pCallback)
{
	LOG_DEBUG("[CGameNetInstance::InitEvent] callback pointer=" << pCallback);
	if(pCallback == NULL)
		return FALSE;

	m_pGameEvents.insert(pCallback);
	FRAME_INSTANCE()->init();

	return TRUE;
}

BOOL CGameNetInstance::QueryDirInfo(const char* server_addr, unsigned short server_port, const string& strMethodName, const map<string, string>& mapParams)
{
	LOG_INFO( "try to query dir-server [" << server_addr << ":" << server_port << "], method=" << strMethodName);
    
	if(m_pGameEvents.empty())
	{
		LOG_ERROR( "GameNet event not initialized!");
		return FALSE;
	}
	if(m_is_querying_dir)
	{
//		LOG_WARN( "Dir info is querying, only one request can be handled this time!");
//		return FALSE;
	}

	string request = BuildQueryDirRequest(strMethodName, mapParams);
	if(request.empty())
	{
		return FALSE;
	}
	CmdGetDir* cmd_get_dir = new CmdGetDir();
	cmd_get_dir->m_request = request;

	ServerAddr svrAddr(server_addr, server_port);

	vdt_tcp_cmd_handler* pHandler = NULL;
	if(m_common_handlers.find(svrAddr) == m_common_handlers.end())
	{
		bool is_session_conn = false;
        // 从连接管理工厂创建连接
        pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
        //new vdt_tcp_cmd_handler(server_addr, server_port, is_session_conn, m_tracer_enabled);
		m_common_handlers[svrAddr] = pHandler;
	}
	else
	{
        pHandler = m_common_handlers[svrAddr];
        if(CmdHandlerFactory::GetInstance()->ProxyType() !=  pHandler->connect_type())
        {
            LOG_DEBUG("[CGameNetInstance::QueryDirInfo] ProxyType() !=  pHandler->connect_type()");
            bool is_session_conn = false;
            pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
            m_common_handlers[svrAddr] = pHandler;       
        }
	}
	ysh_assert(pHandler != NULL);

	if(strMethodName == "getClass")
	{
		pHandler->SetConnectionID(CONN_ID_GETDIR_RESP);
	}
	else if(strMethodName == "getOnlineNum")
	{
        pHandler->SetConnectionID(CONN_ID_GETDIR_ONLINE_RESP);
	}
	else if(strMethodName == "querySuitedZoons")
	{
        pHandler->SetConnectionID(CONN_ID_GETDIR_QUERY_ROOM_RESP);
	}
	else if(strMethodName == "queryNewHallVersion")
	{
		pHandler->SetConnectionID(CONN_ID_GETDIR_QUERY_VERSION_RESP);
	}
	else
	{
        pHandler->SetConnectionID(CONN_ID_GETDIR_COMMON);
	}
	
/*
	if(m_query_dir_handler == NULL)
	{
		m_query_dir_handler = new vdt_tcp_cmd_handler(server_addr, server_port, is_session_conn, m_tracer_enabled);
	}
*/
	pHandler->post_message(vdt_tcp_cmd_handler::MSG_ADD_COMMAND, (ULONG)cmd_get_dir, 0);
	m_is_querying_dir = true;

	return TRUE;
}

string CGameNetInstance::BuildQueryDirRequest(string strMethodName,const map<string, string>& mapParams)
{
	if(mapParams.size() > 16)
	{
		LOG_ERROR( "QueryDir params is too much!!");
		return "";
	}

	char buffer[4096];
	char* buf_ptr = buffer;

	buf_ptr += sprintf(buf_ptr, "<methodCall>");
	buf_ptr += sprintf(buf_ptr, "<methodName>%s</methodName>", strMethodName.c_str());
	buf_ptr += sprintf(buf_ptr, "<params>");
	for(map<string, string>::const_iterator it = mapParams.begin(); it != mapParams.end(); it++)
	{
		buf_ptr += sprintf(buf_ptr, "<%s>%s</%s>", it->first.c_str(), it->second.c_str(), it->first.c_str());
	}
	buf_ptr += sprintf(buf_ptr, "</params>");
	buf_ptr += sprintf(buf_ptr, "</methodCall>");

	return (string)buffer;
}

string CGameNetInstance::BuildQueryDirRequestByDataX(const string strMethodName, IDataXNet* pdatax)
{
    int skiprooms = 0;
    bool ret = pdatax->GetIntArraySize( DataID_SkipRooms, skiprooms);
    if(!ret)
    {
       skiprooms = 0;
    }
    LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX skiprooms = " << skiprooms);
    char* buffer = new char[2048 + skiprooms * 50];
    if(NULL == buffer)
    {
        LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX error new buf");
        return "";
    }
    char* buf_ptr = buffer;

    buf_ptr += sprintf(buf_ptr, "<methodCall>");
    buf_ptr += sprintf(buf_ptr, "<methodName>%s</methodName>", strMethodName.c_str());
    buf_ptr += sprintf(buf_ptr, "<params>");

    byte DirEncode[10];
    int  length = 10;
    ret = pdatax->GetUTF8String(DataID_DirEncode, DirEncode, length);
    if(!ret || length <= 0 || length >= 10)
    {
        LOG_ERROR("[CGameNetInstance::BuildQueryDirRequestByDataX] wrong length");
        delete [] buffer;
        return "";
    }
    DirEncode[length] = '\0';
    buf_ptr += sprintf(buf_ptr, "<dirEncode>%s</dirEncode>", DirEncode);

    int tmp = 0;
    ret = pdatax->GetInt(DataID_GameClassID, tmp);
    if(ret)
    {
        LOG_TRACE("[CGameNetInstance::BuildQueryDirRequestByDataX] ret classid");
        buf_ptr += sprintf(buf_ptr, "<gameClassId>%d</gameClassId>", tmp);
    }
     
    tmp = 0;
    ret = pdatax->GetInt(DataID_GameID, tmp);
    if(ret)
    {
        LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX error GameID");
        buf_ptr += sprintf(buf_ptr, "<gameId>%d</gameId>", tmp);
    }

    tmp = 0;
    ret = pdatax->GetInt(DataID_ChooseType, tmp);
    if(ret)
    {
        LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX error chooseType");
        buf_ptr += sprintf(buf_ptr, "<chooseType>%d</chooseType>", tmp);
    }


    tmp = 0;
    ret = pdatax->GetInt(DataID_UserType, tmp);
    if(ret)
    {
        LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX error DataID_UserType");
        buf_ptr += sprintf(buf_ptr, "<userType>%d</userType>", tmp);
    }

	tmp = 0;
	ret = pdatax->GetInt(DataID_Param1, tmp);
	if(ret)
	{
		LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX error DataID_Param1");
		buf_ptr += sprintf(buf_ptr, "<param1>%d</param1>", tmp);
	}

    tmp = 0;
    ret = pdatax->GetInt(DataID_UserScore, tmp);
    if(ret)
    {
        LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX error DataID_UserScore");
        buf_ptr += sprintf(buf_ptr, "<userScore>%d</userScore>", tmp);
    }


    tmp = 0;
    ret = pdatax->GetInt(DataID_Balance, tmp);
    if(ret)
    {
        LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX error DataID_Balance");
        buf_ptr += sprintf(buf_ptr, "<userBalance>%d</userBalance>", tmp);
    }


    tmp = 0;
    ret = pdatax->GetInt(DataID_FromWhere, tmp);
    if(ret)
    {
        LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX error DataID_FromWhere");
        buf_ptr += sprintf(buf_ptr, "<fromWhere>%d</fromWhere>", tmp);
    }


    

    ret = pdatax->GetIntArraySize( DataID_SkipRooms, tmp);
    if(!ret)
    {
        LOG_ERROR("no skip room");
        goto Next;
    }
    buf_ptr += sprintf(buf_ptr, "<skipRooms>");
    for(int i = 0; i < tmp; i++)
    {
        int roomId = 0;
        ret = pdatax->GetIntArrayElement(DataID_SkipRooms, i, roomId);
        if(!ret)
        {
            LOG_ERROR("CGameNetInstance::BuildQueryDirRequestByDataX error here");
            break;
        }

        buf_ptr += sprintf(buf_ptr, "<item><roomId>%d</roomId></item>", roomId);
    }

    buf_ptr += sprintf(buf_ptr, "</skipRooms>");

Next:
    buf_ptr += sprintf(buf_ptr, "</params></methodCall>");
    LOG_TRACE("CGameNetInstance::BuildQueryDirRequestByDataX total length = " << long(buf_ptr - buffer));
    string str(buffer);
    delete [] buffer;
    LOG_TRACE(str); //  暂时打印出
    return str;
}

BOOL CGameNetInstance::QueryUserGameInfo(const char* server_addr, unsigned short server_port, XLUSERID nUserID)
{
	if(m_pGameEvents.empty()) // == NULL)
	{
		LOG_ERROR( "GameNet event not initialized!");
		return FALSE;
	}
	if(m_is_querying_userinfo)
	{
		LOG_WARN( "User info is querying, only one request can be handled this time!");
		return FALSE;
	}

	CmdGetUserGameInfo* pGetUserGameInfo = new CmdGetUserGameInfo();
	pGetUserGameInfo->ChangeUserID(nUserID);
	pGetUserGameInfo->m_gameID = -1;

	bool is_session_conn = false;
	if(m_query_userinfo_handler == NULL)
	{
        m_query_userinfo_handler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
         //new vdt_tcp_cmd_handler(server_addr, server_port, is_session_conn, m_tracer_enabled);
		m_query_userinfo_handler->SetConnectionID(CONN_ID_GETUSERINFO_RESP);
	}
	m_query_userinfo_handler->post_message(vdt_tcp_cmd_handler::MSG_ADD_COMMAND, (ULONG)pGetUserGameInfo, 0);

	return TRUE;
}

ISessionConnection* CGameNetInstance::CreateSessionConnection(const char* server_addr, unsigned short server_port, ISessionCallback* pCallback)
{
	if(server_addr == NULL)
	{
		LOG_ERROR( "Invalid parameter: session server address is NULL!");
		return FALSE;
	}
	if(pCallback == NULL)
	{
		LOG_ERROR( "Invalid parameter: ISessionCallback pointer is NULL!");
	}

	bool is_session_conn = true;
    vdt_tcp_cmd_handler* session_handler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);	
    //new vdt_tcp_cmd_handler(server_addr, server_port, is_session_conn, m_tracer_enabled);	
	int nConnID = XIDGen::GetNextID();
	session_handler->SetConnectionID(nConnID);
//	ISessionCallbackEx* pCallbackEx = static_cast<ISessionCallbackEx*>(pCallback);
	m_map_session_events[nConnID] = std::make_pair(session_handler, pCallback);

    LOG_DEBUG("CreateSessionConnection - connid=" << nConnID);

	return session_handler;
}


ISessionConnection* CGameNetInstance::RegisterSessionEvent(int nConnID,ISessionCallback* pCallback)
{
	ysh_assert("RegisterSessionEvent() not allowed!" && false);
	return NULL;
}

void CGameNetInstance::Close()
{
    if (m_query_userinfo_handler != NULL)
        m_query_userinfo_handler->Close();
    for (map<ServerAddr, vdt_tcp_cmd_handler*>::iterator it = m_common_handlers.begin(); it != m_common_handlers.end(); it++)
    {
        it->second->Close();
    }
}

BOOL CGameNetInstance::SubmitDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID )
{
	LOG_DEBUG("SubmitDataXReq()");
	if(server_addr == NULL)
	{
		LOG_WARN( "SubmitDataXReq(): server_addr is NULL!");
		return FALSE;
	}
	if(server_port == 0)
	{
		LOG_WARN( "SubmitDataXReq(): server_port is 0!");
		return FALSE;
	}
	if(cmdName == NULL)
	{
		LOG_WARN( "SubmitDataXReq(): cmdName is NULL!");
		return FALSE;
	}

	if (strcasecmp(server_addr, "status.user.minigame.ysh.com") == 0)
	{
		return SubmitUserStatusSvrDataXReq(server_addr, server_port, cmdName, pDataX, nCmdSrcID);
	}

	ServerAddr svrAddr(server_addr, server_port);
	
	vdt_tcp_cmd_handler* pHandler = NULL;
	if(m_common_handlers.find(svrAddr) == m_common_handlers.end())
	{
		LOG_DEBUG("Create new CmdHandler, addr=" << server_addr << " port=" << server_port << " trace=" << m_tracer_enabled);
		bool is_session_conn = false;
        pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
           //  new vdt_tcp_cmd_handler(server_addr, server_port, is_session_conn, m_tracer_enabled);
		m_common_handlers[svrAddr] = pHandler;
	}
	else
	{
        pHandler = m_common_handlers[svrAddr];
        if(CmdHandlerFactory::GetInstance()->ProxyType() !=  pHandler->connect_type())
        {
            LOG_DEBUG("[CGameNetInstance::QueryDirInfo] ProxyType() !=  pHandler->connect_type()");
            bool is_session_conn = false;
            pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
            m_common_handlers[svrAddr] = pHandler;       
        }
	}
	LOG_DEBUG("cmdhandler=" << pHandler);
	ysh_assert(pHandler != NULL);

	pHandler->SetConnectionID(CONN_ID_NONSESSION_DX_RESP);

	CmdNonSessionDataX* pDxCmd = new CmdNonSessionDataX();
	pDxCmd->m_nCmdSrcID = nCmdSrcID; // CMD_FROM_GAMEHALL;
	pDxCmd->m_cmdName = cmdName;
	pDxCmd->SetDataXParam(pDataX, true);

	pHandler->post_message(vdt_tcp_cmd_handler::MSG_ADD_COMMAND, (ULONG)pDxCmd, 0);
	return true;
}

BOOL CGameNetInstance::SubmitBalanceDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID )
{
    if(server_addr == NULL)
    {
        LOG_WARN( "SubmitDataXReq(): server_addr is NULL!");
        return FALSE;
    }
    if(server_port == 0)
    {
        LOG_WARN( "SubmitDataXReq(): server_port is 0!");
        return FALSE;
    }
    if(cmdName == NULL)
    {
        LOG_WARN( "SubmitDataXReq(): cmdName is NULL!");
        return FALSE;
    }

    ServerAddr svrAddr(server_addr, server_port);

    vdt_tcp_cmd_handler* pHandler = NULL;
    if(m_common_handlers.find(svrAddr) == m_common_handlers.end())
    {
        bool is_session_conn = false;
        pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
            //new vdt_tcp_cmd_handler(server_addr, server_port, is_session_conn, m_tracer_enabled);
        m_common_handlers[svrAddr] = pHandler;
    }
    else
    {
        pHandler = m_common_handlers[svrAddr];
        if(CmdHandlerFactory::GetInstance()->ProxyType() !=  pHandler->connect_type())
        {
            LOG_DEBUG("[CGameNetInstance::QueryDirInfo] ProxyType() !=  pHandler->connect_type()");
            bool is_session_conn = false;
            pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
            m_common_handlers[svrAddr] = pHandler;
        }
    }
    ysh_assert(pHandler != NULL);

	pHandler->SetConnectionID(CONN_ID_BALANCESVR_DX_RESP);

    CmdBalanceSvrDataX* pDxCmd = new CmdBalanceSvrDataX();
    pDxCmd->m_nCmdSrcID = nCmdSrcID; // CMD_FROM_GAMEHALL;
    pDxCmd->m_cmdName = cmdName;
    pDxCmd->SetDataXParam(pDataX, true);

    pHandler->post_message(vdt_tcp_cmd_handler::MSG_ADD_COMMAND, (ULONG)pDxCmd, 0);
    return true;
}

BOOL CGameNetInstance::SubmitTimedMatchDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID )
{
	// no implement
	return false;
}

BOOL CGameNetInstance::SubmitUserStatusSvrDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSeqNo )
{
	// no implement
	return false;
}

void CGameNetInstance::OnRecvDirResp(int nConnID, IGameCommand* pCmd)
{
	bool succ = true;
	CmdGetDirResp* get_dir_resp = (CmdGetDirResp*)pCmd;
	if(get_dir_resp->GetUserID() != g_nUserID)
	{
		succ = false;
	}

	if(!m_pGameEvents.empty())
	{
		for(set<IGameNetEvent*>::iterator it = m_pGameEvents.begin(); it != m_pGameEvents.end(); it++)
		{
			IGameNetEvent* pEvent = *it;
			IGameNetEventEx* pEventEx = static_cast<IGameNetEventEx*>(pEvent);
			if(succ)
			{
				pEventEx->OnQueryDirResp(get_dir_resp->m_response);
			}
			else
			{
				pEventEx->OnNetworkErrorWithConnID(nConnID, -1, -1);
			}
		}
	}
	else
	{
		LOG_WARN("m_pGameEvent is NULL! Gamenet event not registered!");
	}
	m_is_querying_dir = false;
}

void CGameNetInstance::OnRecvUserInfoResp(IGameCommand* pCmd)
{
    LOG_DEBUG("OnRecvUserInfoResp() called.");

    GameCmdBase* pCmdBaseResp = (GameCmdBase*)pCmd;
    if (pCmdBaseResp->GetUserID() != g_nUserID)
    {
        LOG_WARN("OnRecvUserInfoResp():  the response's userid is Not current userid, Ignore!!!");
        return;
    }

	CmdGetUserGameInfoResp* get_userinfo_resp = (CmdGetUserGameInfoResp*)pCmd;
	if(!m_pGameEvents.empty())
	{
		for(set<IGameNetEvent*>::iterator it = m_pGameEvents.begin(); it != m_pGameEvents.end(); it++)
		{
			IGameNetEvent* pEvent = *it;
			pEvent->OnQueryUserInfoResp(get_userinfo_resp->m_result, get_userinfo_resp->GetUserID(), get_userinfo_resp->m_userGamesInfo);
		}
		
	}
	else
	{
		LOG_WARN("m_pGameEvent is NULL! Gamenet event not registered!");
	}
}

void CGameNetInstance::OnRecvNonSessionDxResp(IGameCommand* pCmd)
{
	LOG_DEBUG("OnRecvNonSessionDxResp() called.");

	CmdNonSessionDataXResp* pDxResp = (CmdNonSessionDataXResp*)pCmd;

    GameCmdBase* pCmdBaseResp = (GameCmdBase*)pCmd;
    if (pCmdBaseResp->GetUserID() != g_nUserID && pDxResp->m_cmdName != "ReportInstallStateResp")
    {
        LOG_WARN("OnRecvNonSessionDxResp():  the response's userid is Not current userid, Ignore!!!");
        return;
    }

    if(!m_pGameEvents.empty())
	{
		bool bNeedClone = false;
		IDataXNet* pDataX = pDxResp->GetDataXParam(bNeedClone);
		if(pDataX == NULL)
			pDataX = GameUtility::GetInstance()->CreateDataX();
		pDataX->PutInt(DataID_CmdSrcID, pDxResp->m_nCmdSrcID);

		for(set<IGameNetEvent*>::iterator it = m_pGameEvents.begin(); it != m_pGameEvents.end(); it++)
		{
			IGameNetEvent* pEvent = *it;
			pEvent->OnRecvDataXResp(pDxResp->m_nResult, pDxResp->m_cmdName.c_str(), pDataX);
		}

	}
	else
	{
		LOG_WARN("m_pGameEvent is NULL! Gamenet event not registered!");
	}
}

void CGameNetInstance::OnRecvUserStatusSvrDxResp(IGameCommand* pCmd)
{
	// not implement
}

void CGameNetInstance::OnNetworkError(int nErrorCode)
{
	if(m_is_querying_dir)
	{
		m_is_querying_dir = false;
	}
	if(m_is_querying_userinfo)
	{
		m_is_querying_userinfo = false;
	}
	if(!m_pGameEvents.empty())
	{
		for(set<IGameNetEvent*>::iterator it = m_pGameEvents.begin(); it != m_pGameEvents.end(); it++)
		{
			IGameNetEvent* pEvent = *it;
			pEvent->OnNetworkError(nErrorCode);
		}

	}
	else
	{
		LOG_WARN("m_pGameEvent is NULL! Gamenet event not registered.");
	}
}

void CGameNetInstance::Session_OnRecvResp(int nSessionID, IGameCommand* pCmd)
{
	map<int, std::pair<vdt_tcp_cmd_handler*, ISessionCallback*> >::iterator it;

	it = m_map_session_events.find(nSessionID);
	if(it == m_map_session_events.end())
	{
		LOG_ERROR("Can not find session callback ptr by sessionID(" << nSessionID << ") !!");
		return;
	}

	ISessionCallback* pCallback = it->second.second;
    LOG_DEBUG("Session_OnRecvResp - SessionCallback=" << it->second.second);

	HandleSessionResponse(pCallback, pCmd);
}

void CGameNetInstance::HandleSessionResponse(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
    LOG_DEBUG("HandleSessionResponse() called.");

	if(pCallback == NULL || pCmdResp == NULL)
		return;

    GameCmdBase* pCmdBaseResp = (GameCmdBase*)pCmdResp;
    if (pCmdBaseResp->GetUserID() != g_nUserID)
    {
        LOG_WARN("HandleSessionResponse():  the response's userid is Not current userid, Ignore!!!");
        return;
    }

	switch(pCmdResp->GetCmdType())
	{
	case GameCmdFactory::CMD_ID_ENTERROOM_RESP:
		HandleEnterRoomResp(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_ENTERTABLE_RESP:
		HandleEnterTableResp(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_ASKSTART_RESP:
		HandleAskStartResp(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_QUITGAME_RESP:
		pCallback->OnRecvCmd(pCmdResp);
		HandleQuitGameResp(pCallback, pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_EXITROOM_RESP:
		pCallback->OnRecvCmd(pCmdResp);
		HandleExitRoomResp(pCallback, pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_CHAT_RESP:
		HandleChatResp(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_CHAT_NOTIFY:
		HandleChatNotify(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_GAMEACTION_NOTIFY:
		HandleGameActionNotify(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_USERINFO_CHG_NOTIFY:
		HandleUserInfoChgNotify(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_USERSCORE_CHG_NOTIFY:
		HandleUserScoreChgNotify(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_USERSTATUS_CHG_NOTIFY:
		HandleUserStatusChgNotify(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_KICKOUT:
		pCallback->OnRecvCmd(pCmdResp);
		HandleKickoutNotify(pCallback, pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_GAMESVR_DATAX:
		//pCallback->OnRecvCmd(pCmdResp);
		HandleDataXNotify(pCallback, pCmdResp);
        pCallback->OnRecvCmd(pCmdResp);
		break;

	case GameCmdFactory::CMD_ID_GAMESVR_DATAX_RESP:
        LOG_DEBUG("HandleSessionResponse() CMD_ID_GAMESVR_DATAX_RESP.");
		HandleDataXResp(pCallback, pCmdResp);
		pCallback->OnRecvCmd(pCmdResp);
		break;


	default:
		LOG_WARN( "It's not common cmd(type id:" << pCmdResp->GetCmdType() << "), so let callback to handle the command ptr.");
		pCallback->OnRecvCmd(pCmdResp);
		break;
	}

    LOG_DEBUG("HandleSessionResponse() finished.");
}

void CGameNetInstance::Session_OnNetworkError(int nSessionID,int nErrorCode)
{
	map<int, std::pair<vdt_tcp_cmd_handler*, ISessionCallback*> >::iterator it;

	it = m_map_session_events.find(nSessionID);
	if(it == m_map_session_events.end())
	{
		LOG_ERROR( "Can not find session callback ptr by sessionID(" << nSessionID << ") !!");
		return;
	}

	ISessionCallback* pCallback = it->second.second;
	pCallback->OnNetworkError(nErrorCode);
}

void CGameNetInstance::Session_OnReconnectOK(int nSessionID)
{
    map<int, std::pair<vdt_tcp_cmd_handler*, ISessionCallback*> >::iterator it;

    it = m_map_session_events.find(nSessionID);
    if(it == m_map_session_events.end())
    {
        LOG_ERROR( "Can not find session callback ptr by sessionID(" << nSessionID << ") !!");
        return;
    }

    ISessionCallback* pCallback = it->second.second;
    pCallback->OnNotify("NeedReplay");
}

void CGameNetInstance::Session_OnClose(int nSessionID)
{
	map<int, std::pair<vdt_tcp_cmd_handler*, ISessionCallback*> >::iterator it;

	it = m_map_session_events.find(nSessionID);
	if(it == m_map_session_events.end())
	{
		LOG_WARN( "Can not find session-callback info by sessionID(" << nSessionID << ") when Session_OnClose() called.");
		return;
	}

    LOG_DEBUG("Session_OnClose - Close session(" << nSessionID << ")");
	m_map_session_events.erase(nSessionID);
}

void CGameNetInstance::HandleEnterRoomResp(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_ENTERROOM_RESP);

	//CmdEnterRoomResp* pEnterRoomResp = (CmdEnterRoomResp*)pCmdResp;
	//ISessionCallbackEx* pCallbackEx = static_cast<ISessionCallbackEx*>(pCallback);
	//pCallbackEx->OnEnterRoomResp(pEnterRoomResp->m_result, pEnterRoomResp->m_roomPlayers);
}

void CGameNetInstance::HandleEnterTableResp(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_ENTERTABLE_RESP);

	//CmdEnterTableResp* pEnterTableResp = (CmdEnterTableResp*)pCmdResp;
	//LOG_DEBUG("pCallback->OnEnterGameResp(): tablePlayers size is " << pEnterTableResp->m_tablePlayers.size());
	//pCallback->OnEnterGameResp(pEnterTableResp->m_result, pEnterTableResp->m_tablePlayers);
}

void CGameNetInstance::HandleAskStartResp(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_ASKSTART_RESP);
	
//	LOG_INFO((s_logger, "Ignore cmd from server: " << pCmdResp->CmdName());
	CmdAskStartResp* pCmdReadyResp = (CmdAskStartResp*)pCmdResp;
	pCallback->OnCmdSimpeleResp((SIMPLE_RESP_CMD_ID)GameCmdFactory::CMD_ID_ASKSTART_RESP, pCmdReadyResp->m_result);
}

void CGameNetInstance::HandleQuitGameResp(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_QUITGAME_RESP);
	
	CmdQuitGameResp* pCmdQuitGameResp = (CmdQuitGameResp*)pCmdResp;
	pCallback->OnQuitGameResp(pCmdQuitGameResp->m_result);
}

void CGameNetInstance::HandleExitRoomResp(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_EXITROOM_RESP);

//	LOG_INFO((s_logger, "Ignore cmd from server: " << pCmdResp->CmdName());
	CmdExitRoomResp* pCmdExitResp = (CmdExitRoomResp*)pCmdResp;
	pCallback->OnCmdSimpeleResp((SIMPLE_RESP_CMD_ID)GameCmdFactory::CMD_ID_EXITROOM_RESP, pCmdExitResp->m_result);
}

void CGameNetInstance::HandleChatResp(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_CHAT_RESP);

	CmdChatResp* pCmdChatResp = (CmdChatResp*)pCmdResp;
	pCallback->OnChatResp(pCmdChatResp->m_seq_no, pCmdChatResp->m_result);
}

void CGameNetInstance::HandleChatNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_CHAT_NOTIFY);
	
	CmdChatNotify* pCmdChatNotify = (CmdChatNotify*)pCmdResp;
	pCallback->OnChatNotify(pCmdChatNotify->m_tableInfo, pCmdChatNotify->m_sender_userID, pCmdChatNotify->m_chat_msg);
}

void CGameNetInstance::HandleGameActionNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_GAMEACTION_NOTIFY);
	
	CmdGameActionNotify* pCmdGameActNotify = (CmdGameActionNotify*)pCmdResp;
	pCallback->OnGameActionNotify(pCmdGameActNotify->m_submit_userID, pCmdGameActNotify->m_action_data.c_str(), pCmdGameActNotify->m_action_data.length());
}

void CGameNetInstance::HandleKickoutNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_KICKOUT);

	CmdKickoutNotify* pCmdKickout = (CmdKickoutNotify*)pCmdResp;
	pCallback->OnKickout((KICKOUT_REASON_ENUM)(pCmdKickout->m_reason), pCmdKickout->m_whoKickMe);
}

void CGameNetInstance::HandleUserInfoChgNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_USERINFO_CHG_NOTIFY);

	/*
	CmdUserInfoChgNotify* pInfoChgNotify = (CmdUserInfoChgNotify*)pCmdResp;
	
	int nChangeType = pInfoChgNotify->m_change_type;
	if(nChangeType == CmdUserInfoChgNotify::ENTER_ROOM)
	{
		ISessionCallbackEx* pCallbackEx = static_cast<ISessionCallbackEx*>(pCallback);
		pCallbackEx->OnEnterRoomNotify(pInfoChgNotify->m_playerInfo);
	}
	else if(nChangeType == CmdUserInfoChgNotify::MODIFY_USERINFO)
	{
		ISessionCallbackEx* pCallbackEx = static_cast<ISessionCallbackEx*>(pCallback);
		pCallbackEx->OnUserInfoModified(pInfoChgNotify->m_playerInfo);
	}
	else
	{
		LOG_WARN( "Unknown change type( " << nChangeType << ") in cmd [" << pCmdResp->CmdName() << "] !");
	}
	*/
}

void CGameNetInstance::HandleUserScoreChgNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_USERSCORE_CHG_NOTIFY);

	//CmdUserScoreChgNotify* pScoreChgNotify = (CmdUserScoreChgNotify*)pCmdResp;
	//pCallback->OnUserScoreChanged(pScoreChgNotify->m_change_userID, pScoreChgNotify->m_scoreInfo);
}

void CGameNetInstance::HandleUserStatusChgNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	/*
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_USERSTATUS_CHG_NOTIFY);

	CmdUserStatusChgNotify* pStatusChgNotify = (CmdUserStatusChgNotify*)pCmdResp;
	int nChangeType = pStatusChgNotify->m_change_type;

	if(nChangeType == ENTER_TABLE_PLAY)
	{
		LOG_INFO( "UserStatusChgNotify(" << nChangeType << ") => OnEnterGameNotify(sitdown) ");
		pCallback->OnEnterGameNotify(pStatusChgNotify->m_change_userID,pStatusChgNotify->m_seatInfo.TableID, pStatusChgNotify->m_seatInfo.SeatID, false);
	}
	else if(nChangeType == ENTER_TABLE_LOOKON)
	{
		LOG_INFO( "UserStatusChgNotify(" << nChangeType << ") => OnEnterGameNotify(lookon) ");
		pCallback->OnEnterGameNotify(pStatusChgNotify->m_change_userID, pStatusChgNotify->m_seatInfo.TableID, pStatusChgNotify->m_seatInfo.SeatID, true);
	}
	else if(nChangeType == USER_READY)
	{
		LOG_INFO( "UserStatusChgNotify(" << nChangeType << ") => OnGameReadyNotify ");
		pCallback->OnGameReadyNotify(pStatusChgNotify->m_change_userID);
		pCallback->OnPlayerStatusChanged(pStatusChgNotify->m_change_userID, PLAYER_IS_READY);
	}
	else if(nChangeType == GAME_START)
	{
		LOG_INFO( "UserStatusChgNotify(" << nChangeType << ") => OnGameStartNotify ");
		pCallback->OnGameStartNotify(pStatusChgNotify->m_seatInfo.TableID);
	}
	else if(nChangeType == EXIT_TABLE)
	{
		LOG_INFO("UserStatusChgNotify(" << nChangeType << ") => OnQuitGameNotify ");
		pCallback->OnQuitGameNotify(pStatusChgNotify->m_change_userID);
		pCallback->OnPlayerStatusChanged(pStatusChgNotify->m_change_userID, PLAYER_EXIT_TABLE);
	}
	else if(nChangeType == EXIT_ROOM)
	{
		LOG_INFO( "UserStatusChgNotify(" << nChangeType << ") => OnExitRoomNotify ");
		pCallback->OnExitRoomNotify(pStatusChgNotify->m_change_userID);
		pCallback->OnPlayerStatusChanged(pStatusChgNotify->m_change_userID, PLAYER_EXIT_ROOM);
	}
	else if(nChangeType == GAME_END)
	{
		LOG_INFO( "UserStatusChgNotify(" << nChangeType << ") => OnEndGameNotify ");
		pCallback->OnEndGameNotify(pStatusChgNotify->m_seatInfo.TableID);
	}
	else if(nChangeType == USER_DROPOUT)
	{
		LOG_INFO( "UserStatusChgNotify(" << nChangeType << ") => OnDropout ");
		pCallback->OnPlayerStatusChanged(pStatusChgNotify->m_change_userID, PLAYER_DROPOUT);
	}
	else if(nChangeType == USER_DROP_RESUME)
	{
		LOG_INFO( "UserStatusChgNotify(" << nChangeType << ") => OnDropResume ");
		pCallback->OnPlayerStatusChanged(pStatusChgNotify->m_change_userID, PLAYER_DROP_RESUME);
	}
	else if(nChangeType == USER_DROP_TIMEOUT)
	{
		LOG_INFO( "UserStatusChgNotify(" << nChangeType << ") => OnDropTimeout ");
		pCallback->OnPlayerStatusChanged(pStatusChgNotify->m_change_userID, PLAYER_DROP_TIMEOUT);
	}
	else
	{
		LOG_WARN( "Unknown change type( " << nChangeType << ") in cmd [" << pCmdResp->CmdName() << "] !");
	}
	*/
}

void CGameNetInstance::HandleDataXNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	LOG_DEBUG("HandleDataXNotify() called.");

	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_GAMESVR_DATAX);

	CmdGameSvrDataX* pDxCmd = (CmdGameSvrDataX*)pCmdResp;
	IDataXNet* pDxParam = pDxCmd->GetDataXParam(false);
	LOG_DEBUG("HandleDataXNotify(): call OnGenericNotify() now.");
	pCallback->OnGenericNotify(pDxCmd->m_cmdName, pDxCmd->m_roomInfo, pDxParam);
}

void CGameNetInstance::HandleDataXResp(ISessionCallback* pCallback, IGameCommand* pCmdResp)
{
	ysh_assert(pCmdResp != NULL && pCmdResp->GetCmdType() == GameCmdFactory::CMD_ID_GAMESVR_DATAX_RESP);

	CmdGameSvrDataXResp* pDxResp = (CmdGameSvrDataXResp*)pCmdResp;
	IDataXNet* pDxParam = pDxResp->GetDataXParam(false);
	pCallback->OnGenericResp(pDxResp->m_cmdName, pDxResp->m_nResult, pDxParam);
}

void CGameNetInstance::SetConfig( const char* key, int value )
{
    LOG_DEBUG("SetConfig - key=" << key << ", value=" << value);
    m_map_configs[key] = value;
}

int CGameNetInstance::GetConfig( const char* key, int default_value )
{
    if( m_map_configs.find(key) == m_map_configs.end() )
    {
        return default_value;
    }

    return m_map_configs[key];
}

void CGameNetInstance::OnRecvBalanceSvrDxResp(IGameCommand* pCmd)
{
    LOG_DEBUG("OnRecvBalanceSvrDxResp() called.");

    CmdBalanceSvrDataXResp* pDxResp = (CmdBalanceSvrDataXResp*)pCmd;

    GameCmdBase* pCmdBaseResp = (GameCmdBase*)pCmd;
    if (pCmdBaseResp->GetUserID() != g_nUserID && pDxResp->m_cmdName != "ReportInstallStateResp")
    {
        LOG_WARN("OnRecvBalanceSvrDxResp():  the response's userid is Not current userid, Ignore!!!");
        return;
    }

    if(!m_pGameEvents.empty())
    {
        bool bNeedClone = false;
        IDataXNet* pDataX = pDxResp->GetDataXParam(bNeedClone);
        if(pDataX == NULL)
            pDataX = GameUtility::GetInstance()->CreateDataX();
        pDataX->PutInt(DataID_CmdSrcID, pDxResp->m_nCmdSrcID);

        for(set<IGameNetEvent*>::iterator it = m_pGameEvents.begin(); it != m_pGameEvents.end(); it++)
        {
            IGameNetEvent* pEvent = *it;
            pEvent->OnRecvDataXResp(pDxResp->m_nResult, pDxResp->m_cmdName.c_str(), pDataX);
        }

    }
    else
    {
        LOG_WARN("m_pGameEvent is NULL! Gamenet event not registered!");
    }
}

void CGameNetInstance::OnRecvUserGuideSvrDxResp(IGameCommand* pCmd)
{
	// not implement
}

void CGameNetInstance::OnRecvTimedMatchDxResp(IGameCommand* pCmd)
{
	// not implement
}

void CGameNetInstance::OnRecvTabStatusDxResp(IGameCommand* pCmd)
{
	// not implement
}

void CGameNetInstance::OnRecvChipDxResp(IGameCommand* pCmd)
{
	// not implement
}

void CGameNetInstance::OnRecvFlexDxResp(IGameCommand* pCmd)
{
	LOG_DEBUG("OnRecvFlexDxResp() called.");

	CmdCommonResp* pDxResp = (CmdCommonResp*)pCmd;

	GameCmdBase* pCmdBaseResp = (GameCmdBase*)pCmd;
	if (pCmdBaseResp->GetUserID() != g_nUserID && pDxResp->m_cmdName != "ReportInstallStateResp")
	{
		LOG_WARN("OnRecvFlexDxResp():  the response's userid is Not current userid, Ignore!!!");
		return;
	}

	if(!m_pGameEvents.empty())
	{
		bool bNeedClone = false;
		IDataXNet* pDataX = pDxResp->GetDataXParam(bNeedClone);
		if(pDataX == NULL)
			pDataX = GameUtility::GetInstance()->CreateDataX();
		pDataX->PutInt(DataID_CmdSrcID, pDxResp->m_nCmdSrcID);
		GameCmdFlexFactory::GetInstance()->AdjustRespCmd(pDxResp);

		for(set<IGameNetEvent*>::iterator it = m_pGameEvents.begin(); it != m_pGameEvents.end(); it++)
		{
			IGameNetEvent* pEvent = *it;
			pEvent->OnRecvDataXResp(pDxResp->m_nResult, pDxResp->m_cmdName.c_str(), pDataX);
		}

	}
	else
	{
		LOG_WARN("m_pGameEvent is NULL! Gamenet event not registered!");
	}
}

int CGameNetInstance::SetProxy(int type, const char* server_addr, unsigned short server_port, const char* username, const char* pwd)
{
    return  CmdHandlerFactory::GetInstance()->_setGamenetproxy(type, server_addr, server_port, username, pwd);
}

BOOL CGameNetInstance::QueryDirInfoWithSkipRooms(const char* server_addr, unsigned short server_port, const string& strMethodName,IDataXNet* pParams)
{
    LOG_INFO( "try to query dir-server [" << server_addr << ":" << server_port << "], method=" << strMethodName);

    if(m_pGameEvents.empty())
    {
        LOG_ERROR( "GameNet event not initialized!");
        return FALSE;
    }

    if(NULL == pParams)
    {
        LOG_ERROR("[CGameNetInstance::QueryDirInfoWithSkipRooms] error NULL==params");
        return FALSE;
    }

    if(m_is_querying_dir)
    {
        //		LOG_WARN( "Dir info is querying, only one request can be handled this time!");
        //		return FALSE;
    }

    string request = BuildQueryDirRequestByDataX(strMethodName, pParams);
    if(request.empty())
    {
        return FALSE;
    }
    CmdGetDir* cmd_get_dir = new CmdGetDir();
    cmd_get_dir->m_request = request;

    ServerAddr svrAddr(server_addr, server_port);

    vdt_tcp_cmd_handler* pHandler = NULL;
    if(m_common_handlers.find(svrAddr) == m_common_handlers.end())
    {
        bool is_session_conn = false;
        // 从连接管理工厂创建连接
        pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
        //new vdt_tcp_cmd_handler(server_addr, server_port, is_session_conn, m_tracer_enabled);
        m_common_handlers[svrAddr] = pHandler;
    }
    else
    {
        pHandler = m_common_handlers[svrAddr];
        if(CmdHandlerFactory::GetInstance()->ProxyType() !=  pHandler->connect_type())
        {
            LOG_DEBUG("[CGameNetInstance::QueryDirInfo] ProxyType() !=  pHandler->connect_type()");
            bool is_session_conn = false;
            pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
            m_common_handlers[svrAddr] = pHandler;       
        }
    }
    ysh_assert(pHandler != NULL);
	if(strMethodName == "getClass")
	{
		pHandler->SetConnectionID(CONN_ID_GETDIR_RESP);
	}
	else if(strMethodName == "getOnlineNum")
	{
		pHandler->SetConnectionID(CONN_ID_GETDIR_ONLINE_RESP);
	}
	else if(strMethodName == "querySuitedZoons")
	{
		pHandler->SetConnectionID(CONN_ID_GETDIR_QUERY_ROOM_RESP);
	}
	else if(strMethodName == "queryNewHallVersion")
	{
		pHandler->SetConnectionID(CONN_ID_GETDIR_QUERY_VERSION_RESP);
	}
	else
	{
		pHandler->SetConnectionID(CONN_ID_GETDIR_COMMON);
	}
    /*
    if(m_query_dir_handler == NULL)
    {
    m_query_dir_handler = new vdt_tcp_cmd_handler(server_addr, server_port, is_session_conn, m_tracer_enabled);
    }
    */
    pHandler->post_message(vdt_tcp_cmd_handler::MSG_ADD_COMMAND, (ULONG)cmd_get_dir, 0);
    m_is_querying_dir = true;

    return TRUE;
}

BOOL CGameNetInstance::SubmitDataXReqSpec( int nSvrType, const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID )
{	
	if(server_addr == NULL)
	{
		LOG_WARN( "SubmitDataXReqSpec(): server_addr is NULL!");
		return FALSE;
	}
	if(server_port == 0)
	{
		LOG_WARN( "SubmitDataXReqSpec(): server_port is 0!");
		return FALSE;
	}
	if(cmdName == NULL)
	{
		LOG_WARN( "SubmitDataXReqSpec(): cmdName is NULL!");
		return FALSE;
	}

	LOG_INFO("[CGameNetInstance::SubmitDataXReqSpec] type=" << nSvrType << 
		", server=" << server_addr << ", port=" << server_port << ", cmd=" << cmdName);

	ServerAddr svrAddr(server_addr, server_port);

	vdt_tcp_cmd_handler* pHandler = NULL;
	if(m_common_handlers.find(svrAddr) == m_common_handlers.end())
	{
		bool is_session_conn = false;
		pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
		m_common_handlers[svrAddr] = pHandler;
	}
	else
	{
		pHandler = m_common_handlers[svrAddr];
		if(CmdHandlerFactory::GetInstance()->ProxyType() !=  pHandler->connect_type())
		{
			LOG_DEBUG("[CGameNetInstance::SubmitDataXReqSpec] ProxyType() !=  pHandler->connect_type()");
			bool is_session_conn = false;
			pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
			m_common_handlers[svrAddr] = pHandler;
		}
	}
	ysh_assert(pHandler != NULL);

	LOG_DEBUG("[CGameNetInstance::SubmitDataXReqSpec] handler=" << pHandler);

	GameCmdBase* pCmd = NULL;
	switch(nSvrType)
	{
	case GN_CONN_UNKNOWN: // gamesvr
		{
			pHandler->SetConnectionID(CONN_ID_NONSESSION_DX_RESP);

			CmdNonSessionDataX* pDxCmd = new CmdNonSessionDataX();
			pDxCmd->m_nCmdSrcID = nCmdSrcID;
			pDxCmd->m_cmdName = cmdName;
			pDxCmd->SetDataXParam(pDataX, true);
			pCmd = pDxCmd;
		}
		break;

	case GN_CONN_USER_STATE: // userstatus svr
		{
			pHandler->SetConnectionID(CONN_ID_USERSTATUSSVR_DX_RESP);

			//CmdUserStatusSvrDataX* pDxCmd = new CmdUserStatusSvrDataX();
			//pDxCmd->m_nSeqNo = nCmdSrcID;
			//pDxCmd->m_cmdName = cmdName;
			//pDxCmd->SetDataXParam(pDataX, true);
			//pCmd = pDxCmd;
		}
		break;

	case GN_CONN_BALANCE: // balance svr
		{
			pHandler->SetConnectionID(CONN_ID_BALANCESVR_DX_RESP);

			//CmdBalanceSvrDataX* pDxCmd = new CmdBalanceSvrDataX();
			//pDxCmd->m_nCmdSrcID = nCmdSrcID;
			//pDxCmd->m_cmdName = cmdName;
			//pDxCmd->SetDataXParam(pDataX, true);
			//pCmd = pDxCmd;
		}
		break;

	case GN_CONN_USER_GUIDE: // user guide svr
		{
			pHandler->SetConnectionID(CONN_ID_USERGUIDESVR_DX_RESP);

			//CmdUserGuideSvrDataX* pDxCmd = new CmdUserGuideSvrDataX();
			//pDxCmd->m_nCmdSrcID = nCmdSrcID;
			//pDxCmd->m_cmdName = cmdName;
			//pDxCmd->SetDataXParam(pDataX, true);
			//pCmd = pDxCmd;
		}
		break;

	case GN_CONN_TAB_STATE: // tab status svr
		{
			pHandler->SetConnectionID(CONN_ID_TAB_STATUS_DX_RESP);

			//CmdTabStatusSvrDataX* pDxCmd = new CmdTabStatusSvrDataX();
			//pDxCmd->m_nCmdSrcID = nCmdSrcID;
			//pDxCmd->m_cmdName = cmdName;
			//pDxCmd->SetDataXParam(pDataX, true);
			//pCmd = pDxCmd;
		}
		break;

	case GN_CONN_STAT: // stat svr
		{
			pHandler->SetConnectionID(CONN_ID_STATSVR_DX_RESP);

			CmdNonSessionDataX* pDxCmd = new CmdNonSessionDataX();
			pDxCmd->m_nCmdSrcID = nCmdSrcID;
			pDxCmd->m_cmdName = cmdName;
			pDxCmd->SetDataXParam(pDataX, true);
			pCmd = pDxCmd;
		}
		break;

	case GN_CONN_USER: // user svr
		{
			pHandler->SetConnectionID(CONN_ID_USERSVR_DX_RESP);

			CmdNonSessionDataX* pDxCmd = new CmdNonSessionDataX();
			pDxCmd->m_nCmdSrcID = nCmdSrcID;
			pDxCmd->m_cmdName = cmdName;
			pDxCmd->SetDataXParam(pDataX, true);
			pCmd = pDxCmd;
		}
		break;

	case GN_CONN_CHIP: // chip svr
		{
			pHandler->SetConnectionID(CONN_ID_CHIPSVR_DX_RESP);

			//CmdChipSvrDataX* pDxCmd = new CmdChipSvrDataX();
			//pDxCmd->m_nCmdSrcID = nCmdSrcID;
			//pDxCmd->m_cmdName = cmdName;
			//pDxCmd->SetDataXParam(pDataX, true);
			//pCmd = pDxCmd;
		}
		break;

	default:
		{
            LOG_DEBUG("[CGameNetInstance::SubmitDataXReqSpec] Unreginize server type, type=" << nSvrType);

			pHandler->SetConnectionID(CONN_ID_NONSESSION_DX_RESP);

			CmdNonSessionDataX* pDxCmd = new CmdNonSessionDataX();
			pDxCmd->m_nCmdSrcID = nCmdSrcID;
			pDxCmd->m_cmdName = cmdName;
			pDxCmd->SetDataXParam(pDataX, true);
			pCmd = pDxCmd;
		}
		break;
	}

	if(pCmd)
	{
		pHandler->post_message(vdt_tcp_cmd_handler::MSG_ADD_COMMAND, (ULONG)pCmd, 0);
	}
	
	return true;
}

BOOL CGameNetInstance::SubmitFlexDataXReq(const char* server_addr, unsigned short server_port, const LONG nCmdReqID, const char* cmdReqName, const LONG nCmdRespID, const char* cmdRespName, IDataXNet* pDataX, int nCmdSrcID)
{
	if(server_addr == NULL)
	{
		LOG_WARN( "SubmitFlexDataXReq(): server_addr is NULL!");
		return FALSE;
	}
	if(server_port == 0)
	{
		LOG_WARN( "SubmitFlexDataXReq(): server_port is 0!");
		return FALSE;
	}
	if(nCmdReqID == 0)
	{
		LOG_WARN( "SubmitFlexDataXReq(): nCmdReqID is 0!");
		return FALSE;
	}
	if(cmdReqName == NULL)
	{
		LOG_WARN( "SubmitFlexDataXReq(): cmdReqName is NULL!");
		return FALSE;
	}
	if(nCmdRespID == 0)
	{
		LOG_WARN( "SubmitFlexDataXReq(): nCmdRespID is 0!");
		return FALSE;
	}
	if(cmdRespName == NULL)
	{
		LOG_WARN( "SubmitFlexDataXReq(): cmdRespName is NULL!");
		return FALSE;
	}

	LOG_DEBUG("SubmitFlexDataXReq() called, cmdReqID=" << nCmdReqID << " cmdReqName=" << cmdReqName 
		<< " cmdRespID=" << nCmdRespID << " cmdRespName=" << cmdRespName << ", cmdSrcID=" << nCmdSrcID);

	GameCmdFlexFactory::GetInstance()->AddGameCmdNode(nCmdSrcID, nCmdReqID, cmdReqName, nCmdRespID, cmdRespName);

	ServerAddr svrAddr(server_addr, server_port);

	vdt_tcp_cmd_handler* pHandler = NULL;
	if(m_common_handlers.find(svrAddr) == m_common_handlers.end())
	{
		bool is_session_conn = false;
		pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
		m_common_handlers[svrAddr] = pHandler;
	}
	else
	{
		pHandler = m_common_handlers[svrAddr];
		if(CmdHandlerFactory::GetInstance()->ProxyType() !=  pHandler->connect_type())
		{
			LOG_DEBUG("[CGameNetInstance::SubmitDataXReqSpec] ProxyType() !=  pHandler->connect_type()");
			bool is_session_conn = false;
			pHandler = CmdHandlerFactory::CreateCmdHandler(server_addr, server_port, is_session_conn, m_tracer_enabled);
			m_common_handlers[svrAddr] = pHandler;       
		}
	}
	ysh_assert(pHandler != NULL);
	
	pHandler->SetConnectionID(0); // 不能小于0
	CmdCommon* pDxCmd = new CmdCommon();
	pDxCmd->SetCmdReqID(nCmdReqID);
	pDxCmd->m_nCmdSrcID = nCmdSrcID;
	pDxCmd->m_cmdName = cmdReqName;
	pDxCmd->SetDataXParam(pDataX, true);
	GameCmdBase* pCmd = pDxCmd;

	if(pCmd)
	{
		pHandler->post_message(vdt_tcp_cmd_handler::MSG_ADD_COMMAND, (ULONG)pCmd, 0);
	}
	return true;
}

void CGameNetInstance::OnNetworkErrorDetail( int nConnID, int nErrorCode )
{	
	int nExtraCode = 0;

	if(m_is_querying_dir)
	{
		m_is_querying_dir = false;		
	}
	else
	{
		nExtraCode = 1;
	}

	if(m_is_querying_userinfo)
	{
		m_is_querying_userinfo = false;
	}

	LOG_DEBUG("[CGameNetInstance::OnNetworkErrorDetail] connid=" << nConnID << ", errorcode=" << nErrorCode <<
		", extracode=" << nExtraCode);

	if(!m_pGameEvents.empty())
	{
		int i = 0;
		for(set<IGameNetEvent*>::iterator it = m_pGameEvents.begin(); it != m_pGameEvents.end(); it++)
		{			
			IGameNetEvent* pEvent = *it;			
			IGameNetEventEx* pEventEx = static_cast<IGameNetEventEx*>(pEvent);

			LOG_DEBUG("[CGameNetInstance::OnNetworkErrorDetail] pEvent=" << pEventEx);

			if(NULL == pEventEx)
			{
                pEvent->OnNetworkError(nErrorCode);				
			}
			else
			{
				pEventEx->OnNetworkErrorWithConnID(nConnID, nErrorCode, nExtraCode);
			}
		}
	}
	else
	{
		LOG_WARN("m_pGameEvent is NULL! Gamenet event not registered.");
	}

	LOG_DEBUG("[CGameNetInstance::OnNetworkErrorDetail] Exit");
}
