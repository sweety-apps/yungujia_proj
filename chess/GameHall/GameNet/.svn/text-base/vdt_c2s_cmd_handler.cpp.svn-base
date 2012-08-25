#include "common/utility.h"
#include <time.h>

#include "vdt_c2s_cmd_handler.h"
#include "GameNetInstance.h"
#include "asynio/asyn_io_operation.h"
#include "asynio/asyn_tcp_device.h"
#include "asynio/asyn_io_frame.h"
#include "command/GameCmdFactory.h"
#include "command/CmdExitRoom.h"
#include "command/CmdChat.h"
#include "command/CmdQuitGame.h"
#include "command/CmdAskStart.h"
#include "command/CmdSubmitAction.h"
#include "command/CmdPing.h"
#include "command/CmdReplay.h"
#include "command/CmdGameSvrDx.h"
#include "command/DataID.h"
#include "command/GameCmdFlexFactory.h"

using namespace std;

//LOG4CPLUS_CLASS_IMPLEMENT(vdt_c2s_cmd_handler, _s_logger, "GN.c2s_cmd_handler");
IMPL_LOGGER_EX(vdt_c2s_cmd_handler, GN);

vdt_c2s_cmd_handler::vdt_c2s_cmd_handler(const std::string &host, unsigned short port ,bool is_session_conn)
	: abstract_c2s_cmd_handler(host, port, is_session_conn), asyn_message_sender(this), _network_monitor(this)
{
    _connection_finished = false;
	_cur_game_room.GameID = -1;
	_cur_game_room.ZoneID = -1;
	_cur_game_room.RoomID = -1;
	_is_in_room = false;
    _is_valid = true;
    _is_network_valid = true;
	_is_kicked_out = false;
    _is_use_network_monitor = true;
    //(CGameNetInstance::GetInstance()->GetConfig("enableNetMonitor", 0) ? true : false);

	_resp_timeout = CGameNetInstance::GetInstance()->GetConfig("cmd_resp_timeout", RESP_TIMEOUT_MAX);

	_cur_ping_interval = DEFAULT_PING_INTERVAL; // 2 minutes (default value)
    _wait_dir_count = 0;
}

vdt_c2s_cmd_handler::~vdt_c2s_cmd_handler(void)
{
	LOG_DEBUG( "vdt_c2s_cmd_handler::~vdt_c2s_cmd_handler() called" );
	asyn_io_frame::get_instance()->remove_timeout_handler(this);
}



// response_ptr的拥有权归调用者
bool vdt_c2s_cmd_handler::handle_response( IGameCommand *response_ptr )
{
	LOG_DEBUG("handle_response() called");
    if (!_is_valid)
    {
        LOG_INFO("handle_response() : session is Not Valid, Ignore!");
        return false;
    }

    if(_is_use_network_monitor)
    {        
        _network_monitor.OnRecvCommand(response_ptr);
    }

    switch(response_ptr->GetCmdType())
    {
    case GameCmdFactory::CMD_ID_GETDIR_RESP: 
    	asyn_io_frame::get_instance()->remove_timeout_handler(this, TIMER_ID_RESP_TIMEOUT);
        handle_get_dir_response(response_ptr);
        break;

    case GameCmdFactory::CMD_ID_GETUSERGAMEINFO_RESP:
        handle_get_userinfo_response(response_ptr);
        break;

    case GameCmdFactory::CMD_ID_PING_RESP:
        handle_ping_response(response_ptr);
        break;

    case GameCmdFactory::CMD_ID_NONSESSION_DATAX_RESP:
        handle_nonsession_datax_response(response_ptr);
        break;

	case GameCmdFactory::CMD_ID_USERSTATUSSVR_DATAX_RESP:
		handle_userstatussvr_datax_response(response_ptr);
		break;

	case GameCmdFactory::CMD_ID_USERGUIDE_SVR_DATAX_RESP:
		handle_userguidesvr_datax_response(response_ptr);
		break;

	case GameCmdFactory::CMD_ID_CHIP_SVR_DATAX_RESP:
        handle_chipsvr_datax_response(response_ptr);
		break;

    case GameCmdFactory::CMD_ID_BALANCE_SVR_DATAX_RESP:
        handle_balancesvr_datax_response(response_ptr);
        break;

	case GameCmdFactory::CMD_ID_TIMED_MATCH_DATAX_RESP:
		handle_timed_match_datax_response(response_ptr);
		break;

	case GameCmdFactory::CMD_ID_TABSTATUS_SVR_DATAX_RESP:
		handle_tab_status_datax_response(response_ptr);
		break;

    case GameCmdFactory::CMD_ID_ENTERROOM_RESP:
        on_recv_enterroom_resp(response_ptr);
    case GameCmdFactory::CMD_ID_GAMESVR_DATAX_RESP:
        {
            CmdGameSvrDataXResp* pDxResp = (CmdGameSvrDataXResp*)response_ptr;            
            if( strcasecmp(pDxResp->m_cmdName.c_str(), "EnterRoomResp") == 0 || strcasecmp(pDxResp->m_cmdName.c_str(), "EnterRoomTinnyResp") == 0)
            {
                on_recv_enterroom_resp(response_ptr);
            }
        }        
    case GameCmdFactory::CMD_ID_ENTERTABLE_RESP:
    case GameCmdFactory::CMD_ID_ASKSTART_RESP:
    case GameCmdFactory::CMD_ID_QUITGAME_RESP:
    case GameCmdFactory::CMD_ID_EXITROOM_RESP:
    case GameCmdFactory::CMD_ID_CHAT_RESP:
    case GameCmdFactory::CMD_ID_CHAT_NOTIFY:
    case GameCmdFactory::CMD_ID_GAMEACTION_NOTIFY:
    case GameCmdFactory::CMD_ID_USERINFO_CHG_NOTIFY:
    case GameCmdFactory::CMD_ID_USERSCORE_CHG_NOTIFY:
    case GameCmdFactory::CMD_ID_USERSTATUS_CHG_NOTIFY:
    case GameCmdFactory::CMD_ID_KICKOUT:
		if(response_ptr->GetCmdType() == GameCmdFactory::CMD_ID_KICKOUT)
		{
			_is_kicked_out = true;
		}
    case GameCmdFactory::CMD_ID_GAMESVR_DATAX:    
        handle_session_cmd_response(response_ptr);
        break;

    default:        
		if (GameCmdFlexFactory::GetInstance()->HasCoupleRespCmd(response_ptr))
		{
			handle_flex_datax_response(response_ptr); 
		}
		else
			LOG_WARN( "when handle_response, unknown type id:" << response_ptr->GetCmdType());
        break;
    }

	if(!is_session_connection()/* && m_query_dir_cmds.empty()*/)
	{
		// 短连接：收到响应后，标志该连接可关闭并释放资源
		// (_connection_finished 置为true后，handler在handle_io_complete()的最后通过调before_exit_io_complete()删除自己)
		// !! 不要直接在这里调用 delete this        
		if(_command_queue.empty() && _wait_dir_count <= 0)
        {
            _connection_finished = true;            
        }
        
        if(_wait_dir_count > 0)
        {
            receive();
        }
	}

	if(is_session_connection())
	{
		LOG_DEBUG("Remove resp timeout timer now.");
		asyn_io_frame::get_instance()->remove_timeout_handler(this, TIMER_ID_RESP_TIMEOUT);
	}

	return true;
}

void vdt_c2s_cmd_handler::handle_get_dir_response(IGameCommand* pCmdDirResp)
{
	CGameNetInstance::GetInstance()->OnRecvDirResp(m_conn_id, pCmdDirResp);

    _wait_dir_count--;
    LOG_DEBUG("handle_get_dir_response - connid=" << m_conn_id << ", dir count = " << _wait_dir_count);
}

void vdt_c2s_cmd_handler::handle_get_userinfo_response(IGameCommand* pCmdUserInfoResp)
{
	CGameNetInstance::GetInstance()->OnRecvUserInfoResp(pCmdUserInfoResp);
}

void vdt_c2s_cmd_handler::handle_nonsession_datax_response(IGameCommand* pResp)
{
	CGameNetInstance::GetInstance()->OnRecvNonSessionDxResp(pResp);
}

void vdt_c2s_cmd_handler::handle_userstatussvr_datax_response(IGameCommand* pResp)
{
	CGameNetInstance::GetInstance()->OnRecvUserStatusSvrDxResp(pResp);
}

void vdt_c2s_cmd_handler::handle_chipsvr_datax_response(IGameCommand* pResp)
{
	CGameNetInstance::GetInstance()->OnRecvChipDxResp(pResp);
}

void vdt_c2s_cmd_handler::handle_flex_datax_response(IGameCommand* pResp)
{
	if (GameCmdFlexFactory::GetInstance()->HasCoupleRespCmd(pResp))
	{
		LOG_DEBUG("OnRecvCmd(): received flex datax response.");
		CGameNetInstance::GetInstance()->OnRecvFlexDxResp(pResp);
	}
	else
		CGameNetInstance::GetInstance()->Session_OnRecvResp(m_conn_id, pResp);
}

void vdt_c2s_cmd_handler::handle_ping_response(IGameCommand* pResp)
{
	if(pResp == NULL)
		return;
	
	CmdPingResp* ping_resp = (CmdPingResp*)pResp;
	int next_ping_interval = ping_resp->m_next_interval-5;
	if(next_ping_interval < MIN_PING_INTERVAL)
		next_ping_interval = MIN_PING_INTERVAL;
	if(next_ping_interval > MAX_PING_INTERVAL)
		next_ping_interval = MAX_PING_INTERVAL;

	if(next_ping_interval != _cur_ping_interval)
	{
		LOG_INFO( "Ping interval changed: " << _cur_ping_interval << " => " << next_ping_interval);

		asyn_io_frame::get_instance()->remove_timeout_handler(this, TIMER_ID_PING);
		asyn_io_frame::get_instance()->add_timeout_handler(this, next_ping_interval * 1000, TIMER_ID_PING, true);
		_cur_ping_interval = next_ping_interval;
	}
}

void vdt_c2s_cmd_handler::on_recv_enterroom_resp(IGameCommand* pResp)
{
	_is_in_room = true;

	if(_cur_ping_interval <= MIN_PING_INTERVAL)
		_cur_ping_interval = DEFAULT_PING_INTERVAL;

    char szEnableMonitor[64] = "";
    sprintf(szEnableMonitor, "enableNetMonitor_%d", _cur_game_room.GameID);

    _is_use_network_monitor = true;//_is_use_network_monitor && (CGameNetInstance::GetInstance()->GetConfig(szEnableMonitor, 0) ? true : false);

	LOG_DEBUG( "register PING timer now, interval=" << _cur_ping_interval << ", netmonitor=" << _is_use_network_monitor );
	asyn_io_frame::get_instance()->add_timeout_handler(this, _cur_ping_interval * 1000, TIMER_ID_PING, true);

	_network_monitor.OnEnterRoomResp();
}

void vdt_c2s_cmd_handler::handle_session_cmd_response(IGameCommand* pResp)
{
	CGameNetInstance::GetInstance()->Session_OnRecvResp(m_conn_id, pResp);
}

void vdt_c2s_cmd_handler::add_command( IGameCommand *cmd_ptr )
{
	execute_cmd(cmd_ptr);
}

void vdt_c2s_cmd_handler::handle_message(ULONG lMessageId, ULONG lParam1, ULONG lParam2)
{
	LOG_DEBUG( "vdt_c2s_cmd_handler::handle_message(): lMessageID="<<lMessageId << 
		", lParam1=" << lParam1 << ", lParam2=" << lParam2);

	switch(lMessageId)
	{
	case MSG_CLOSE_CONN:
		asyn_io_frame::get_instance()->remove_timeout_handler(this);
		handle_close_conn_message(lParam1, lParam2);
		break;

	case MSG_ADD_COMMAND:
		handle_add_command_message(lParam1, lParam2);
		break;

	default:
		LOG_WARN( "Unknown message ID in handle_message(): " << lMessageId);
	}
}

void vdt_c2s_cmd_handler::handle_close_conn_message(ULONG lParam1, ULONG lParam2)
{
	close();
}

void vdt_c2s_cmd_handler::handle_add_command_message(ULONG lParam1, ULONG lParam2)
{
	LOG_DEBUG("handle_add_command_message() called.");

	IGameCommand* pCmd = (IGameCommand*)lParam1;
	bool hasResp = IsCommandHasResp(pCmd);
	bool bIsGameActionCmd = (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_SUBMIT_ACTION);
    bool bIsGetDirCmd = (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_GETDIR);

//  if(!bIsGetDirCmd)
    {
	    execute_cmd(pCmd);
    	
	    // 超时检查定时器(检查发出去的命令是否有回应)
	    if(is_session_connection())
	    {
		    if(hasResp)
		    {
			    LOG_DEBUG("Add resp timeout timer now.");
			    asyn_io_frame::get_instance()->add_timeout_handler(this, _resp_timeout, TIMER_ID_RESP_TIMEOUT, false);	
		    }
	    }
    }
//     else
//     {
//         m_query_dir_cmds.push_back(pCmd);
//         if(m_query_dir_cmds.size() == 1)
//         {
//             CheckQueryDirCmdPool();
//         }
//     }

    if(bIsGetDirCmd)
    {
        _wait_dir_count++;
        asyn_io_frame::get_instance()->add_timeout_handler(this, _resp_timeout, TIMER_ID_RESP_TIMEOUT, false);
    }
}

bool vdt_c2s_cmd_handler::IsCommandHasResp(IGameCommand* pCmd)
{
	unsigned short nCmdType = pCmd->GetCmdType();
	bool bIsGameActionCmd = (nCmdType == GameCmdFactory::CMD_ID_SUBMIT_ACTION);
	if(bIsGameActionCmd)
		return false;

	if(nCmdType == GameCmdFactory::CMD_ID_GAMESVR_DATAX)
	{
		CmdGameSvrDataX* pDataXCmd = (CmdGameSvrDataX*)pCmd;
		if(strcasecmp(pDataXCmd->m_cmdName.c_str(), "InvitedUserToTableResp") == 0)
		{
			return false;
		}
        else if(strcasecmp(pDataXCmd->m_cmdName.c_str(), "AbortServerNotifyMsgReq") == 0)
        {
            return false;
        }
	}
	
	return true;
}

void vdt_c2s_cmd_handler::handle_timeout(unsigned long timer_type)
{
    if(timer_type == TIMER_ID_PING)
	{
		send_ping_cmd();
	}
	else if(timer_type == TIMER_ID_RESP_TIMEOUT)
	{
		handle_resp_timeout();	
	}
    else if(timer_type == TIMER_ID_CHECK_NETWORK)
    {
        handle_check_network_timeout();
    }
    else if(timer_type == TIMER_ID_RECONNECT)
    {
        handle_reconnect_timeout();
    }
	else
	{
		LOG_WARN("Unknown timer type: " << timer_type);
	}
}

void vdt_c2s_cmd_handler::send_ping_cmd()
{
	if(!_is_in_room)
	{
		LOG_WARN( "not in the room, so DO NOT send ping now!");
		return;
	}

	LOG_DEBUG( "try to send ping cmd now");

	CmdPing* pCmd = new CmdPing();
	pCmd->m_roomInfo = _cur_game_room;
	execute_cmd(pCmd);

	LOG_DEBUG("Add resp timeout timer now.");
	asyn_io_frame::get_instance()->add_timeout_handler(this, _resp_timeout, TIMER_ID_RESP_TIMEOUT, false);	
}

void vdt_c2s_cmd_handler::handle_resp_timeout()
{
	LOG_WARN("No response time out!");

    if(_is_use_network_monitor)
    {
        _network_monitor.CleanAllCache();
    }

    _is_valid = false;

	if(m_conn_id < 0)
	{
		CGameNetInstance::GetInstance()->OnNetworkErrorDetail(m_conn_id, NET_ERROR_TIMEOUT);
	}
	else
	{
		CGameNetInstance::GetInstance()->Session_OnNetworkError(m_conn_id, NET_ERROR_TIMEOUT);
	}
}

void vdt_c2s_cmd_handler::handle_network_error( bool recv_error , unsigned long error_code, unsigned char type)
{
    LOG_ERROR("handle_network_error: recv_error=" << recv_error << ", error_code=" << error_code << ", type=" << type);
	if(is_session_connection())
	{	
		LOG_ERROR("handle_network_error: connID=" << m_conn_id << ", reconnect=" << _is_use_network_monitor);
		 
        if(!_is_use_network_monitor)
        {
        	CGameNetInstance::GetInstance()->Session_OnNetworkError(m_conn_id, error_code);
            asyn_io_frame::get_instance()->remove_timeout_handler(this);

            _is_network_valid = false;
        }
        else
        {  
            _network_monitor.OnNetworkError(error_code, type, !(_is_kicked_out && error_code == 0));
        }
	}
	else
	{
		LOG_ERROR("session not connect, handle_network_error: connID=" << m_conn_id);
		
		//if (!_is_use_network_monitor)
		{
			CGameNetInstance::GetInstance()->OnNetworkErrorDetail(m_conn_id, error_code);
			_connection_finished = true;

			asyn_io_frame::get_instance()->remove_timeout_handler(this);
		}
		/*
		else
		{
			_network_monitor.OnNoSessionNetworkError(error_code);
		}
		*/
	}

	_is_kicked_out = false;
}

void vdt_c2s_cmd_handler::before_exit_io_complete(asyn_io_operation *operation_ptr, bool has_more_cmd)
{
    if(_connection_finished && !has_more_cmd)
    {
//        delete this;
		close_connection();
    }
}


bool vdt_c2s_cmd_handler::SendCommand(IGameCommand* cmd)
{
    if(_socket_ptr && _is_use_network_monitor)
    {  
        _network_monitor.OnSendCommand(cmd);

        if( _network_monitor.IsBreak() )
        {
			LOG_ERROR("vdt_c2s_cmd_handler::SendCommand() _network_monitor BREAK");
            return false;
        }
    }

    if(!_is_network_valid)
    {
		LOG_ERROR("vdt_c2s_cmd_handler::SendCommand() _is_network_valid FALSE");
        return false;
    }

	post_message(MSG_ADD_COMMAND, (ULONG)cmd, 0);
//	add_command(cmd);
	return true;
}

void vdt_c2s_cmd_handler::Close()
{
	LOG_DEBUG( "vdt_c2s_cmd_handler::Close() called.");

	_is_in_room = false;
	CGameNetInstance::GetInstance()->Session_OnClose(m_conn_id);

	post_message(MSG_CLOSE_CONN, 0, 0);
}

void vdt_c2s_cmd_handler::EnterRoom(const GAMEROOM& roomInfo, const XLUSERINFOEX& userInfo)
{
	/*
	CmdEnterRoom* pEnterRoom = new CmdEnterRoom();

	memcpy(&(pEnterRoom->m_roomInfo), &roomInfo, sizeof(GAMEROOM));
	GameCmdBase::copy_xluserinfo(pEnterRoom->m_userInfo, userInfo);
	pEnterRoom->m_userInfo.IsMale = userInfo.IsMale;

	_cur_game_room = roomInfo;

	SendCommand(pEnterRoom);
	*/
}

void vdt_c2s_cmd_handler::ExitRoom(const GAMEROOM& roomInfo)
{
	CmdExitRoom* pExitRoom = new CmdExitRoom();

	memcpy(&(pExitRoom->m_roomInfo), &roomInfo, sizeof(GAMEROOM));

	_is_in_room = false;
	_cur_game_room.GameID = -1; 
	_cur_game_room.ZoneID = -1;
	_cur_game_room.RoomID = -1;

	SendCommand(pExitRoom);
}

void vdt_c2s_cmd_handler::Chat(const GAMETABLE& tableInfo, const string& chatMsg, int nChatSeqNo)
{
	CmdChat* pChat = new CmdChat();

	memcpy(&(pChat->m_tableInfo), &tableInfo, sizeof(GAMETABLE));
	pChat->m_chat_msg = chatMsg;
	pChat->m_seq_no = nChatSeqNo;

	SendCommand(pChat);
}

void vdt_c2s_cmd_handler::EnterGame(const GAMESEAT& seatInfo, GAME_USER_STATUS userStatus, const string& initalTableKey, const string& followPasswd)
{
	/*
	CmdEnterTable* pEnterTable = new CmdEnterTable();

	memcpy(&(pEnterTable->m_seatInfo), &seatInfo, sizeof(GAMESEAT));
	pEnterTable->m_seat_status = userStatus;
	pEnterTable->m_table_key = initalTableKey;
	pEnterTable->m_follow_key = followPasswd;

	SendCommand(pEnterTable);
	*/
}

void vdt_c2s_cmd_handler::GameReady(const GAMESEAT& seatInfo)
{
	CmdAskStart* pAskStart = new CmdAskStart();
	memcpy(&(pAskStart->m_seatInfo), &seatInfo, sizeof(GAMESEAT));
	SendCommand(pAskStart);
}

void vdt_c2s_cmd_handler::SubmitGameAction(const GAMEROOM& roomInfo, const char* pszGameData, int nDataLen)
{
	CmdSubmitAction* pSubmitAction = new CmdSubmitAction();

	if(!pSubmitAction->SetActionData(pszGameData, nDataLen))
	{
		LOG_ERROR( "Game action data invalid, data_len=" << nDataLen);
		return;
	}
	memcpy(&(pSubmitAction->m_roomInfo), &roomInfo, sizeof(GAMEROOM));
	SendCommand(pSubmitAction);
}

void vdt_c2s_cmd_handler::QuitGame(const GAMETABLE& tableInfo)
{
	CmdQuitGame* pQuitGame = new CmdQuitGame();
	memcpy(&(pQuitGame->m_tableInfo), &tableInfo, sizeof(GAMETABLE));
	SendCommand(pQuitGame);
}

void vdt_c2s_cmd_handler::Replay(const GAMESEAT& seatInfo)
{
	CmdReplay* pReplay = new CmdReplay();
	memcpy(&(pReplay->m_seatInfo), &seatInfo, sizeof(GAMESEAT));
	SendCommand(pReplay);
}

void vdt_c2s_cmd_handler::SendGenericCmd(const char* cmdName, const GAMEROOM& roomInfo, IDataXNet* pCmdParams)
{
	CmdGameSvrDataX* pDxCmd = new CmdGameSvrDataX();
	pDxCmd->m_cmdName = cmdName;
	pDxCmd->m_roomInfo = roomInfo;
	pDxCmd->SetDataXParam(pCmdParams, true);

    if( strcasecmp(cmdName, "EnterRoomReq") == 0 || strcasecmp(cmdName, "EnterRoomTinnyReq") == 0 )
    {
        _cur_game_room = roomInfo;
    }
	
	SendCommand(pDxCmd);
}

void vdt_c2s_cmd_handler::handle_check_network_timeout()
{
    //_network_monitor.CleanDeadCommand();
    //_network_monitor.TryReSendCommand(3);

    LOG_DEBUG( "handle_check_network_timeout() called." );

    asyn_io_frame::get_instance()->remove_timeout_handler(this, vdt_c2s_cmd_handler::TIMER_ID_CHECK_NETWORK);
    asyn_io_frame::get_instance()->remove_timeout_handler(this, vdt_c2s_cmd_handler::TIMER_ID_RECONNECT);

    // send cache cmd immediately
	_network_monitor.SetBreak(false);
	// TODO
	if(_network_monitor.GetNeedReEnterRoom())
	{
		_network_monitor.ResendEnterRoomReq();
	}
	else
	{
		send_ping_cmd();
		asyn_io_frame::get_instance()->add_timeout_handler(this, 60 * 1000, vdt_c2s_cmd_handler::TIMER_ID_PING, true);

		_network_monitor.ResetCacheCmdTick();
		_network_monitor.TryReSendCommand(10);

		// try to notify game
		CGameNetInstance::GetInstance()->Session_OnReconnectOK(m_conn_id);
	}
}

void vdt_c2s_cmd_handler::handle_connect_result( asyn_io_operation * result )
{
    LOG_DEBUG( "handle_connect_result() called." );		

    _is_connected = true;
    _is_network_valid = true;

	int nRecvBuf = CGameNetInstance::GetInstance()->GetConfig("socket_recv_buffer", 23); 

	LOG_DEBUG( "handle_connect_result() - set recv buffer to" << nRecvBuf );
	asyn_tcp_device* tcp_socket = (asyn_tcp_device*)_socket_ptr;
	tcp_socket->set_rev_buffer(nRecvBuf);

    LOG_DEBUG( "try to send queued cmd ..." );		
    if( !is_session_connection() )
    {
        send_queued_command();
        return;
    }

    if( !_is_use_network_monitor )
    {
        send_queued_command();
        return;
    }

    if(!_is_connected)
    {
        LOG_WARN( "connection not established!" );
        return;
    }

    do 
    {    
        if(_command_queue.empty())
            break;

        if(_pooled_send_operation_mgr->is_pool_empty())
        {
            LOG_WARN( "No idle sending io-operation available to send queued cmd!" );
            break;
        }

        IGameCommand* cmd_ptr = _command_queue.front();
        _command_queue.pop_front();

        LOG_INFO( "try to send command in queue, cmd details:" << cmd_ptr->Description()); 
        if(_is_use_network_monitor)
        {
            _network_monitor.OnSendCommand(cmd_ptr);
        }
    } while(false);

    if( _is_use_network_monitor )
    {
        _network_monitor.OnConnectOk();
    }
}

void vdt_c2s_cmd_handler::handle_reconnect_timeout()
{
    if(_is_use_network_monitor)
    {
        _network_monitor.TryReconnect();
    }
}

void vdt_c2s_cmd_handler::handle_balancesvr_datax_response(IGameCommand* pResp)
{
    LOG_DEBUG("handle_balancesvr_datax_response() called.");
    CGameNetInstance::GetInstance()->OnRecvBalanceSvrDxResp(pResp);
}

void vdt_c2s_cmd_handler::handle_userguidesvr_datax_response(IGameCommand* pResp)
{
	LOG_DEBUG("handle_userguidesvr_datax_response() called.");
	CGameNetInstance::GetInstance()->OnRecvUserGuideSvrDxResp(pResp);
}

void vdt_c2s_cmd_handler::handle_timed_match_datax_response(IGameCommand* pResp)
{
	LOG_DEBUG("handle_timed_match_datax_response() called.");
	CGameNetInstance::GetInstance()->OnRecvTimedMatchDxResp(pResp);
}

void vdt_c2s_cmd_handler::handle_tab_status_datax_response(IGameCommand* pResp)
{
	LOG_DEBUG("handle_tab_status_datax_response() called.");
	CGameNetInstance::GetInstance()->OnRecvTabStatusDxResp(pResp);
}

void vdt_c2s_cmd_handler::CheckQueryDirCmdPool()
{
    LOG_DEBUG("CheckQueryDirCmdPool - pool size = " << m_query_dir_cmds.size());

    if(m_query_dir_cmds.empty())
    {
        return;
    }

    IGameCommand* pCmd = m_query_dir_cmds.front();
    //m_query_dir_cmds.pop_front();

    if(pCmd)
    {
        execute_cmd(pCmd);
    }
}
