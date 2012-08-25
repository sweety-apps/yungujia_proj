/*
** NetworkMonitor.cpp
** 
** resend command:
** 
**
*/

#include "NetworkMonitor.h"
#include "command/GameCmdBase.h"
#include "command/GameCmdFactory.h"
#include "vdt_c2s_cmd_handler.h"
#include "GameNetInstance.h"
#include "asynio/asyn_io_frame.h"
#include "command/CmdReplay.h"
#include <sys/times.h>

#ifndef WIN32
long GetTickCount()
{
	tms tm;
	return times(&tm);
}
#endif

IMPL_LOGGER_EX(NetworkMonitor, GN);

const DWORD NetworkMonitor::m_dwsMaxReSendTimes    = 6;
const DWORD NetworkMonitor::m_dwsMaxCacheCmdNum    = 10;
const DWORD NetworkMonitor::m_dwsMaxReconnectTimes = 5;

NetworkMonitor::NetworkMonitor(vdt_c2s_cmd_handler* pHandler)
: m_pHandler(pHandler)
, m_dwLastReSendTick(0)
, m_dwReconnectTimes(0)
, m_dwLastReconnectTick(0)
, m_bBreak(true)
, m_pEnterRoomCmd(NULL)
, m_bNeedReEnterRoom(true)
{

}

NetworkMonitor::~NetworkMonitor()
{
    CleanAllCache();   
	CleanEnterRoomCache();
}

void NetworkMonitor::OnSendCommand( IGameCommand* pCmd )
{  
    GameCmdBase* pTmp = dynamic_cast<GameCmdBase*>(pCmd);
    if(!pTmp)
    {
        return;
    }

    if( strcasecmp(pTmp->CmdName(), "Replay") == 0 )
    {
        LOG_TRACE("[NetworkMonitor] Game Replay");
        return;
    }

    // Clone it
    IGameCommand2* pNewCmd = dynamic_cast<IGameCommand2*>( GameCmdFactory::create_cmd_by_typeid(pTmp->GetCmdType()) );
    if(!pNewCmd)
    {
        // unknown cmd
        LOG_WARN("OnSendCommand - unknown cmd type: " << pTmp->GetCmdType());
        return;
    }

    bool b = pTmp->Clone(pNewCmd);       
    if(!b)
    {
        LOG_WARN("OnSendCommand - clone cmd failed! cmd type: " << pTmp->GetCmdType() << ", cmd name: " << pTmp->CmdName());
        return;
    }

	if( strcasecmp(pTmp->CmdName(), "EnterRoomReq") == 0 )
	{
		CleanEnterRoomCache();

		LOG_DEBUG("[NetworkMonitor] Cache enter room cmd");
		m_pEnterRoomCmd = pNewCmd;
		return;
	}
	if( strcasecmp(pTmp->CmdName(), "EnterRoomTinnyReq") == 0 )
	{
		CleanEnterRoomCache();

		LOG_DEBUG("[NetworkMonitor] Cache enter room cmd");
		m_pEnterRoomCmd = pNewCmd;
		return;
	}

    if(!m_bBreak)
    {
        CleanAllCache();
    }

    if(m_listCommand.size() > m_dwsMaxCacheCmdNum)
    {
        CommandNode aboreNode = m_listCommand.back();
        LOG_TRACE("[NetworkMonitor] Abort cmd: " << pTmp->CmdName());

        delete aboreNode.pCmd;
        aboreNode.pCmd = NULL;
        m_listCommand.pop_back();
    }

    CommandNode newNode;
    newNode.pCmd           = pNewCmd;
    newNode.dwReSendTimes  = 0;
    newNode.dwLastSendTick = newNode.dwFirstSendTick = GetTickCount();

    m_listCommand.push_front(newNode);

    LOG_TRACE("[NetworkMonitor] Cache cmd: " << pTmp->CmdName() << ", current cache size: " << m_listCommand.size());
}

void NetworkMonitor::OnRecvCommand( IGameCommand* pCmd )
{
    BOOL bFound = FALSE;
    CommandNode node;
    GameCommandList::iterator it;

    // search couple cmd from cache
    for(it = m_listCommand.begin(); it != m_listCommand.end(); it++)
    {
        node = (*it);
        if( node.pCmd && (node.pCmd)->IsCoupleRespCmd(pCmd) )
        {
            LOG_TRACE("[NetworkMonitor] remove cache command [" << (node.pCmd)->CmdName() << "] because found couple resp package");
            bFound = TRUE;
        }
    }

    if(bFound)
    { 
        m_listCommand.remove(node);
        delete node.pCmd;
        node.pCmd = NULL;

        LOG_TRACE("[NetworkMonitor] current cache size: " << m_listCommand.size());
    }
}

void NetworkMonitor::OnNetworkError(unsigned long error_code, unsigned char type, bool toRecon)
{
    ysh_assert(m_pHandler);

    if(m_dwReconnectTimes >= m_dwsMaxReconnectTimes)
    {        
        LOG_TRACE("[NetworkMonitor] Reconnect " << m_dwsMaxReconnectTimes << " times failed!");
        m_bBreak = false;

        int nConnID = m_pHandler->GetConnectionID();
        if(nConnID < 0)
		{
			CGameNetInstance::GetInstance()->OnNetworkErrorDetail(nConnID, error_code);
		}
		else
		{
			CGameNetInstance::GetInstance()->Session_OnNetworkError(nConnID, error_code);
		}
        asyn_io_frame::get_instance()->remove_timeout_handler(m_pHandler);
        return;
    }

    //if(m_bBreak)
    {
        asyn_io_frame::get_instance()->remove_timeout_handler(m_pHandler);
		if(toRecon)
		{
		    asyn_io_frame::get_instance()->add_timeout_handler(m_pHandler, vdt_c2s_cmd_handler::RECONNECT_INVERVAL, vdt_c2s_cmd_handler::TIMER_ID_RECONNECT, true);
		}
    }

    m_bBreak = true;
    LOG_TRACE("[NetworkMonitor] error code: " << error_code << ", type=" << type);
}

void NetworkMonitor::OnNoSessionNetworkError(unsigned long error_code)
{
	ysh_assert(m_pHandler);

	if(m_dwReconnectTimes >= 3)
	{
		LOG_TRACE("[OnNoSessionNetworkError] Reconnect 3 times failed!");
		m_bBreak = false;
		int nConnID = m_pHandler->GetConnectionID();
		if(nConnID < 0)
		{
			CGameNetInstance::GetInstance()->OnNetworkErrorDetail(nConnID, error_code);
		}
		else
		{
			CGameNetInstance::GetInstance()->Session_OnNetworkError(nConnID, error_code);
		}
		asyn_io_frame::get_instance()->remove_timeout_handler(m_pHandler);
		return;
	}
	asyn_io_frame::get_instance()->remove_timeout_handler(m_pHandler);
	asyn_io_frame::get_instance()->add_timeout_handler(m_pHandler, vdt_c2s_cmd_handler::RECONNECT_INVERVAL, vdt_c2s_cmd_handler::TIMER_ID_RECONNECT, true);

	m_bBreak = true;
	LOG_TRACE("[OnNoSessionNetworkError] error code: " << error_code);
}

void NetworkMonitor::TryReSendCommand( int nMaxCommandToSend )
{
    ysh_assert(m_pHandler);

    LOG_TRACE("[NetworkMonitor] TryReSendCommand(" << nMaxCommandToSend << "), cache size=" << m_listCommand.size());

    if(m_bBreak)
    {        
        return;
    }

    m_dwReconnectTimes = 0;
    
    GameCommandList::reverse_iterator it;

    int nTotalResend = 0;
    DWORD dwTick = GetTickCount();    
    
    for(it = m_listCommand.rbegin(); it != m_listCommand.rend(); it++)
    {
        CommandNode& node = (*it);
        if( node.pCmd && 
            (strcasecmp(node.pCmd->CmdName(), "EnterRoomReq") != 0 && strcasecmp(node.pCmd->CmdName(), "EnterRoomTinnyReq") != 0 )
			&&
            ((GetTickCount()-node.dwFirstSendTick > MAX_RESEND_INTERVAL) || node.dwReSendTimes >= m_dwsMaxReSendTimes) )
        {
            int nConnID = m_pHandler->GetConnectionID();
			if(nConnID < 0)
			{
				CGameNetInstance::GetInstance()->OnNetworkErrorDetail(nConnID, NET_ERROR_TIMEOUT);
			}
			else
			{
				CGameNetInstance::GetInstance()->Session_OnNetworkError(nConnID, NET_ERROR_TIMEOUT);
			}
            return;
        }

        if( node.dwLastSendTick /*+ GetReSendInterval(node.dwReSendTimes)*/ <= dwTick )
        {
            // need resend
            LOG_TRACE("[NetworkMonitor] resend command: " << (node.pCmd)->CmdName());

            // make a copy , because after sending, the command will be destroy
            IGameCommand2* pNewCmd = dynamic_cast<IGameCommand2*>( GameCmdFactory::create_cmd_by_typeid((node.pCmd)->GetCmdType()) );
            if(!pNewCmd)
            {
                // unknown cmd
                LOG_WARN("TryReSendCommand - unknown cmd type: " << (node.pCmd)->GetCmdType());
                continue;
            }

            bool b = (node.pCmd)->Clone(pNewCmd); 
            if(!b)
            {
                LOG_WARN("TryReSendCommand - clone cmd failed! cmd type: " << (node.pCmd)->GetCmdType() << ", cmd name: " << (node.pCmd)->CmdName());
                continue;
            }

            m_pHandler->post_message(vdt_c2s_cmd_handler::MSG_ADD_COMMAND, (ULONG)pNewCmd, 0);
         
            node.dwLastSendTick = GetTickCount();
            (node.dwReSendTimes)++;
            nTotalResend++;
            if(nTotalResend >= nMaxCommandToSend)
            {
                return;
            }
        }        
    }
}

DWORD NetworkMonitor::GetReSendInterval( DWORD dwSendTimes )
{
    return 10*1000;
}

void NetworkMonitor::CleanDeadCommand()
{
    GameCommandList::iterator it;
    GameCommandList deadCmdList;

    for(it = m_listCommand.begin(); it != m_listCommand.end(); it++)
    {        
        if((*it).dwReSendTimes >= m_dwsMaxReSendTimes)
        {
            deadCmdList.push_back((*it));
        }
    }

    for(it = deadCmdList.begin(); it != deadCmdList.end(); it++)
    {    
        LOG_TRACE("[NetworkMonitor] clean dead command: " << ((*it).pCmd)->CmdName());
        
        m_listCommand.remove((*it));
        delete (*it).pCmd;
        (*it).pCmd = NULL;
    }    
}

void NetworkMonitor::CleanAllCache()
{
    LOG_TRACE("[NetworkMonitor] clean all command, size: " << m_listCommand.size());

    GameCommandList::iterator it;

    for(it = m_listCommand.begin(); it != m_listCommand.end(); it++)
    {
        delete (*it).pCmd;
        (*it).pCmd = NULL;
    }

    m_listCommand.clear();
}

DWORD NetworkMonitor::GetReconnectInterval( DWORD dwReconnectTimes )
{
	return 1000;
}

void NetworkMonitor::TryReconnect()
{
    if(!m_bBreak || !m_pHandler)
    {
        return;
    }

    DWORD dwTick = GetTickCount();
    if(m_dwLastReconnectTick + GetReconnectInterval(m_dwReconnectTimes) <= dwTick)
    {
        LOG_TRACE("[NetworkMonitor] Reconnect [" << m_dwReconnectTimes << "], connid=" << m_pHandler->GetConnectionID() << ", tick=" << GetTickCount());        
        m_pHandler->close();
        m_dwLastReconnectTick = GetTickCount();
        m_dwReconnectTimes++;

        if(m_dwReconnectTimes >= m_dwsMaxReconnectTimes)
		{
			LOG_TRACE("[NetworkMonitor] TryReconnect " << m_dwReconnectTimes << " times failed!");
			m_bBreak = false;

			int nConnID = m_pHandler->GetConnectionID();
			if(nConnID < 0)
			{
				CGameNetInstance::GetInstance()->OnNetworkErrorDetail(nConnID, -1);
			}
			else
			{
				CGameNetInstance::GetInstance()->Session_OnNetworkError(nConnID, -1);
			}
			asyn_io_frame::get_instance()->remove_timeout_handler(m_pHandler);
			return;
		}

        m_pHandler->connect();
    }
}

void NetworkMonitor::OnConnectOk()
{    
    if(!m_pHandler->is_session_connection())
    {
        return;
    }

    LOG_TRACE("[NetworkMonitor] connect ok, connid=" << m_pHandler->GetConnectionID());

    //m_bBreak = false;
    m_dwReconnectTimes = 0;

    //m_pHandler->send_ping_cmd();
    //asyn_io_frame::get_instance()->add_timeout_handler(m_pHandler, 60 * 1000, vdt_c2s_cmd_handler::TIMER_ID_PING, true);

    // try receive the last command response
    m_pHandler->receive();
    asyn_io_frame::get_instance()->add_timeout_handler(m_pHandler, vdt_c2s_cmd_handler::CHECK_NETWORK_INTERVAL, vdt_c2s_cmd_handler::TIMER_ID_CHECK_NETWORK, false);
}

void NetworkMonitor::ResetCacheCmdTick()
{
	GameCommandList::iterator it;

	for(it = m_listCommand.begin(); it != m_listCommand.end(); it++)
	{        
		(*it).dwReSendTimes = 0;
		(*it).dwLastSendTick = (*it).dwFirstSendTick = GetTickCount();
	}
}

void NetworkMonitor::CleanEnterRoomCache()
{
	if(m_pEnterRoomCmd)
	{
		delete m_pEnterRoomCmd; 
		m_pEnterRoomCmd = NULL;
	}
}

void NetworkMonitor::ResendEnterRoomReq()
{
    if(m_pEnterRoomCmd)
	{
		LOG_DEBUG("[NetworkMonitor] ResendEnterRoomReq");
		
		// make a copy , because after sending, the command will be destroy
		IGameCommand2* pNewCmd = dynamic_cast<IGameCommand2*>( GameCmdFactory::create_cmd_by_typeid(m_pEnterRoomCmd->GetCmdType()) );
		if(!pNewCmd)
		{
			// unknown cmd
			LOG_WARN("ResendEnterRoomReq - unknown cmd type: " << m_pEnterRoomCmd->GetCmdType());
			return;
		}

		bool b = m_pEnterRoomCmd->Clone(pNewCmd); 
		if(!b)
		{
			LOG_WARN("ResendEnterRoomReq - clone cmd failed! cmd type: " << m_pEnterRoomCmd->GetCmdType() << ", cmd name: " << m_pEnterRoomCmd->CmdName());
			return;
		}

		m_pHandler->post_message(vdt_c2s_cmd_handler::MSG_ADD_COMMAND, (ULONG)pNewCmd, 0);
	}
}

void NetworkMonitor::OnEnterRoomResp()
{
	m_bNeedReEnterRoom = false;
    if(m_listCommand.empty())    
	{
		return;
	}

	ResetCacheCmdTick();
	TryReSendCommand(10);

	// try to notify game
	CGameNetInstance::GetInstance()->Session_OnReconnectOK(m_pHandler->GetConnectionID());
}
