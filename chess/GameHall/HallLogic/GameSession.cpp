#include "HallContext.h"
#include "GameSession.h"
#include "JniHelper.h"
#include "common/DxNetWrapper.h"
#include "GameSessionMgr.h"
#include "LoginUserStat.h"

IMPL_LOGGER(GameSession);

GameSession::GameSession()
: m_nConnID(0)
{
	m_bHasStartGame = false;
	m_nSitStatus = STANDUP;
	m_roomStatus = ROOM_CLOSED;
	m_nLastTryEnterTable = -1;
	m_nLastTryEnterSeat = -1;
	m_nCurrentTable = -1;
}

GameSession::~GameSession()
{

}

void GameSession::DescRoomStatus(string& sDesc)
{
	switch(m_roomStatus)
	{
	case ROOM_CLOSED:
		sDesc = "该房间已关闭!";
		break;

	case ROOM_OPENING:
		sDesc = "该房间正在打开...";
		break;

	case ROOM_OPENED:
		sDesc = "该房间已打开!";
		break;

	case ROOM_CLOSING:
		sDesc = "进入房间太频繁，请稍候再进...";
		break;

	default:
		sDesc = "房间状态: 未知";
	}
}

void GameSession::SetRoomInfo(const GAMEROOM& roomInfo)
{
	m_roomInfo = roomInfo;
}

void GameSession::GetRoomInfo(GAMEROOM &roomInfo)
{
    roomInfo.GameID = m_roomInfo.GameID;
    roomInfo.RoomID = m_roomInfo.RoomID;
    roomInfo.ZoneID = m_roomInfo.ZoneID;
}

void GameSession::GetLastTryEnterTableAndSeat( SHORT& nTableID, SHORT& nSeatID )
{
    nTableID = m_nLastTryEnterTable;
    nSeatID  = m_nLastTryEnterSeat;
}

void GameSession::SetLastTryEnterSeat( GAMESEAT& seatInfo )
{
    m_seatLastTryEnter = seatInfo;
}

BOOL GameSession::ShouldDispatchToGameTable(IGameCommand* pCmd)
{
	if(pCmd == NULL)
		return FALSE;

	int nTableID = -1;
	return CHallContext::GetInstance()->GetGameUtility()->IsGameTableAcceptCmd(pCmd, nTableID);
}

void GameSession::NotifyEvent2Game(const char* szEvent, IDataXNet* pDx, bool bAutoDeleteDx)
{
	JniHelper::Notify_JniGame(m_roomInfo.GameID, szEvent, pDx, bAutoDeleteDx);
}

void GameSession::OnRecvCmd(IGameCommand* pCmd)
{

}

void GameSession::OnNetworkError(int iErrorCode)
{
	LOG_ERROR("OnNetworkError() called, errorCode=" << iErrorCode);

	IDataXNet* pdxNotify = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
	pdxNotify->PutInt(DataID_Result, iErrorCode);
	NotifyEvent2Game("SessionNetError", pdxNotify);

	OnExitRoomResp(0);
}

void GameSession::OnEnterRoomResp(int, const std::vector<tagXLPLAYERINFO, std::allocator<tagXLPLAYERINFO> >&)
{

}

void GameSession::OnEnterRoomNotify(const XLPLAYERINFO&)
{

}

void GameSession::OnUserInfoModified(const XLPLAYERINFO&)
{

}

void GameSession::OnExitRoomResp(int nResult)
{
	LOG_INFO("OnExitRoomResp() called, result=" << nResult << ", m_nConnID=" << m_nConnID);

	ISessionConnection* pConn = GameSessionMgr::GetInstance()->FindSessionConnection(m_nConnID);
	if(pConn == NULL)
	{
		LOG_WARN("Can not find session connection when OnExitRoomResp() called, the connection maybe closed.");
		return;
	}

	pConn->Close();
	GameSessionMgr::GetInstance()->RemoveSessionConnection(m_nConnID);
	delete this;
}

void GameSession::OnEnterGameResp(int nResult, const vector<XLPLAYERINFO>& tablePlayers)
{

}

void GameSession::OnEnterGameNotify(XLUSERID nEnterUserID, int nTableID, byte nSeatID, bool isLookOnUser)
{

}

void GameSession::OnGameReadyNotify(XLUSERID nReadyUserID)
{

}

void GameSession::OnGameStartNotify(int nTableID)
{

}

void GameSession::OnEndGameNotify(int nTableID)
{

}

void GameSession::OnQuitGameResp(int nResult)
{

}

void GameSession::OnQuitGameNotify(XLUSERID nQuitUserID)
{

}

void GameSession::OnExitRoomNotify(XLUSERID nExitUserID)
{

}

void GameSession::OnChatResp(int nChatSeqNo, int nResult)
{

}

void GameSession::OnChatNotify(const GAMETABLE& tableInfo, XLUSERID nChatUserID, const string& chatMsg)
{

}

void GameSession::OnGameActionResp(int nResult)
{

}

void GameSession::OnGameActionNotify(XLUSERID nSubmitUserID, const char* szGameDataBuf, int nDataLen)
{
	IDataXNet* pdxNotify = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
	pdxNotify->PutInt(DataID_GameID, m_roomInfo.GameID);
	pdxNotify->PutInt(DataID_ZoneID, m_roomInfo.GameID);
	pdxNotify->PutInt(DataID_RoomID, m_roomInfo.GameID);
	pdxNotify->PutInt64(DataID_UserID, nSubmitUserID);
	pdxNotify->PutBytes(DataID_Param1, (const byte* )szGameDataBuf, nDataLen);
	NotifyEvent2Game("GameActionNotify", pdxNotify);
}

void GameSession::OnUserScoreChanged(XLUSERID nChangeUserID, const XLGAMESCORE& scoreInfo)
{

}

void GameSession::OnCmdSimpeleResp(SIMPLE_RESP_CMD_ID nRespCmdID, int nResult)
{
	LOG_INFO("nRespCmdID = " << nRespCmdID << ", result=" << nResult);
	if(nRespCmdID == RESP_ID_READY_RESP)
	{
		//return 	OnGameReadyResp(nResult);
	}
	else if(nRespCmdID == RESP_ID_EXITROOM_RESP)
	{
		return OnExitRoomResp(nResult);
	}
}

void GameSession::OnPlayerStatusChanged(XLUSERID nPlayerID, PLAYER_STATUS_ACTION_ENUM nStatusAction)
{

}

void GameSession::OnKickout(KICKOUT_REASON_ENUM kickReason, XLUSERID nWhoKickMe)
{
	LOG_INFO("OnKickout() called, kickReason=" << (int)kickReason << ", kickUser=" << nWhoKickMe);
	string userName = "";
	string strKickOutInfo;
	switch (kickReason)
	{
		case KICKOUT_BY_TABLE_OWNER:strKickOutInfo = "桌主 " + userName + " 请您离开!";break;
		case KICKOUT_BY_VIP:strKickOutInfo = "会员 " + userName + " 请您离开!";break;
		case KICKOUT_BY_ADMIN:strKickOutInfo = "管理员请您离开!";break;
		case KICKOUT_MULTI_LOGIN:strKickOutInfo = "重复登陆!";break;
		case KICKOUT_OFFLINE_TIMEOUT: strKickOutInfo = "掉线超时"; break;
		case KICKOUT_DZ_SPECIAL: strKickOutInfo = "您的金币低于游戏要求，无法进行游戏，系统请你离开。"; break;
		case KICKOUT_GAME_ALREADY_START: strKickOutInfo = "游戏已经开始"; break;
		case KICKOUT_GAME_ALREADY_END: strKickOutInfo = "游戏已经结束"; break;
		case KICKOUT_BY_ESC_NUM: strKickOutInfo = "逃跑次数过多"; break;
		case KICKOUT_DROP: strKickOutInfo = "您已经掉线"; break;
		case KICKOUT_SCORE_LIMIT: strKickOutInfo = "您的级别已不符合该房间要求，请到其它房间进行游戏。"; break;

	}

	// TODO
	// Notify to GameHall UI
}

void GameSession::OnGenericResp(const string& cmdName, int nResult, IDataXNet* pDataX)
{
	LOG_DEBUG("cmdName = " << cmdName << ", result = " << nResult);

	if(strcasecmp(cmdName.c_str(), "GetUserConfigResp") == 0)
	{
		HandleUserConfigResp(nResult, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "ChatResp") == 0)
	{
		HandleGenericChatResp(nResult, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "KickPlayerResp") == 0)
	{
		HandleKickPlayerResp(nResult, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "TryEnterTableResp") == 0)
	{
		HandleTryEnterTableResp(nResult, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "EnterRoomResp") == 0)
	{
		HandleEnterRoomResp(nResult, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "EnterRoomTinnyResp") == 0)
	{
		HandleEnterRoomTinnyResp(nResult, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "EnterTableResp") == 0)
	{
		HandleEnterTableResp(nResult, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "ResumeServerNotifyMsgResp") == 0)
	{
		HandleResumeServerNotifyMsgResp(nResult, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "QuitGameResp") == 0)
	{
		SHORT nExtraStatus;
		if(!(pDataX->GetShort(DataID_ExtraStatus, nExtraStatus)))
		{
			nExtraStatus = -1;
		}

		if(nResult == 0)
		{
			OnQuitGameCmd(nExtraStatus);
		}
	}
	else if(strcasecmp(cmdName.c_str(), "GetLockedTableResp") == 0)
	{
		HandleGetLockedTableResp(nResult, pDataX);
	}
	else
	{
		LOG_WARN("OnGenericResp(): Unknown cmdName: " << cmdName);
	}
}

void GameSession::OnGenericNotify(const string& cmdName, const GAMEROOM& roomInfo, IDataXNet* pDataX)
{
	LOG_DEBUG("OnGenericNotify() called, cmdName='" << cmdName << ", GameID=" << roomInfo.GameID <<
			 ", ZoneID=" << roomInfo.ZoneID << ", RoomID=" << roomInfo.RoomID);

	if( m_roomStatus != ROOM_OPENED)
	{
		LOG_ERROR("OnGenericNotify(), m_roomStatus=" << (int)m_roomStatus << ", cmdName ignored!!!");
		return;
	}

	if(strcasecmp(cmdName.c_str(), "ChatNotifyReq") == 0)
	{
		HandleChatNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "KickPlayerNotifyReq") == 0)
	{
		HandleKickPlayerNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyUserStatusReq") == 0)
	{
		HandleUserStatusNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "InvitedUserToTableReq") == 0)
	{
		HandleInvitedToTableNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "InviteUserResultReq") == 0)
	{
		HandleInviteUserToTableResultNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyUserInfoReq") == 0)
	{
		HandleUserInfoChanged(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyUserScoreChangeReq") == 0)
	{
		HandleUserScoreChanged(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyAchievementReq") == 0)
	{
		HandleUserAchievement(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyMatchInfoReq") == 0)
	{
		HandleMatchInfoNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyMatchInfoNewReq") == 0)
	{
		HandleNewMatchInfoNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyMatchTableInfoReq") == 0)
	{
		HandleMatchTableInfoNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyMatchStatusReq") == 0)
	{
		HandleMatchStatusNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyMatchGameInfoReq") == 0)
	{
		HandleMatchGameInfoNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyMatchOrderInfoReq") == 0)
	{
		HandleMatchOrderInfoNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyEnterMatchGroupReq") == 0)
	{
		HandleEnterMatchGroupNotify(roomInfo, pDataX);
	}
	else if(strcasecmp(cmdName.c_str(), "NotifyChipInfoReq") == 0)
	{
		HandleChipinfoNotify(roomInfo, pDataX);
	}
	else
	{
		LOG_WARN("OnGenericNotify(): Unknown cmdName: " << cmdName);
	}
}

///////////////////////////////////////////////////////////////////////////////
void GameSession::HandleUserConfigResp(int nResult, IDataXNet* pDataX)
{

}

void GameSession::HandleGenericChatResp(int nResult, IDataXNet* pDataX)
{

}

void GameSession::HandleKickPlayerResp(int nResult, IDataXNet* pDataX)
{

}

void GameSession::HandleTryEnterTableResp(int nResult, IDataXNet* pDataX)
{
	LOG_DEBUG("HandleTryEnterTableResp(): result=" << nResult);
	if(nResult != 0)
	{
		LOG_WARN("HandleTryEnterTableResp(): result=" << nResult
				<< ", try enter table failed!");
		pDataX->PutInt(DataID_Result, nResult);
		NotifyEvent2Game("TryEnterTableResp", pDataX, false);
		return;
	}

	DxNetWrapper wrapper(pDataX);

	SHORT nTableID = wrapper.GetShort(DataID_TableID, -1);
	SHORT nSeatID = wrapper.GetShort(DataID_SeatID, -1);
	SHORT nActionType = wrapper.GetShort(DataID_ActionType, -1);
	int nExtraStatus = wrapper.GetShort(DataID_ExtraStatus, -1);

	LOG_DEBUG("HandleTryEnterTableResp(): tableid=" << nTableID <<
			", seatid=" << nSeatID << ", actiontype=" << nActionType);

	if(nTableID < 0 || nSeatID < 0)
	{
		LOG_WARN("HandleTryEnterTableResp(): desired table not found!");
		return;
	}

	if(2 == nActionType)
	{
		m_bHasStartGame = false;
		bool bIsLookOn = false;

		int nDataXArraySize = 0;
		bool bRet = pDataX->GetDataXArraySize(DataID_Param1, nDataXArraySize);
		if(!bRet)
		{
			LOG_ERROR("[SessionEventHandler::HandleTryEnterTableResp]: can't get tableplayer count!");
			return;
		}

		LOG_TRACE("HandleTryEnterTableResp(): num of player=" << nDataXArraySize);
		for(int i = 0; i < nDataXArraySize; i++)
		{
			IDataXNet *pDataXNet = NULL;
			bRet = pDataX->GetDataXArrayElement(DataID_Param1, i, &pDataXNet);
			ysh_assert(bRet);

			// UserID
			XLUSERID userid;
			bRet = pDataXNet->GetInt64(DataID_UserID, userid);
			ysh_assert(bRet);

			if (g_nUserID != userid)
			{
				// not myself
				continue;
			}

			SHORT iUserStatus;
			bRet = pDataXNet->GetShort(DataID_UserStatus, iUserStatus);
			ysh_assert(bRet);

			if(LOOKON == (GAME_USER_STATUS)iUserStatus)
			{
				// TODO
				// LOOKON
			}

			// 成功坐下
			m_seatGameInfo.GameID = m_roomInfo.GameID;
			m_seatGameInfo.RoomID = m_roomInfo.RoomID;
			m_seatGameInfo.ZoneID = m_roomInfo.ZoneID;
			m_seatGameInfo.SeatID = nSeatID;
			m_seatGameInfo.TableID = nTableID;
			m_nSitStatus = iUserStatus;

			if(1 == nExtraStatus || 2 == nExtraStatus)
			{
				// 房间加锁\解锁
			}

			LOG_INFO("HandleTryEnterTableResp: MyTableID="<<m_seatGameInfo.TableID<<" MySeatID="<<m_seatGameInfo.SeatID);
			break;
		}

		// TODO
		// Notify HallUI
	}
	else if(1 == nActionType)
	{
		// find seat but not sit in
		m_nLastTryEnterTable = nTableID;
		m_nLastTryEnterSeat  = nSeatID;
	}

	pDataX->PutInt(DataID_Result, nResult);
	NotifyEvent2Game("TryEnterTableResp", pDataX, false);
}

void GameSession::HandleEnterRoomResp(int nResult, IDataXNet* pDataX)
{

}

void GameSession::HandleEnterTableResp(int nResult, IDataXNet* pDataX)
{

}

void GameSession::HandleResumeServerNotifyMsgResp(int nResult, IDataXNet* pDataX)
{

}

void GameSession::HandleChatNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleKickPlayerNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{
	LOG_DEBUG("HandleKickPlayerNotify() called.");

	if(pDataX == NULL)
	{
		LOG_WARN("HandleKickPlayerNotify(): pDataX param is NULL!");
		return;
	}

	DxNetWrapper wrapper(pDataX);
	unsigned short nTableID = (unsigned short)wrapper.GetShort(DataID_TableID, -1);
	short nReason = wrapper.GetShort(DataID_KickReason);
	__int64 nKickUserID = wrapper.GetInt64(DataID_UserID);

	LOG_DEBUG("HandleKickPlayerNotify(): tableID=" << nTableID << ", kickReason=" << nReason << ", kickUserID=" << nKickUserID);

	OnQuitGameCmd();

	if(nTableID == (unsigned short)-1)
	{
		OnKickout((KICKOUT_REASON_ENUM)nReason, nKickUserID);
	}
	else
	{
		LOG_DEBUG("HandleKickPlayerNotify(): tableID=" << nTableID << ", game client(not game hall) should handle the event.");
	}

	NotifyEvent2Game("KickPlayerNotifyReq", pDataX, false);
}

void GameSession::HandleUserStatusNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{
	LOG_DEBUG("HandleUserStatusNotify() called.");

	if(pDataX == NULL)
	{
		LOG_ERROR("HandleUserStatusNotify(): pDataX param is NULL!");
		return;
	}

	DxNetWrapper wrapper(pDataX);
	XLUSERID nUserID = wrapper.GetInt64(DataID_UserID, -1);
	short nTableID = wrapper.GetShort(DataID_TableID, -1);
	short nSeatID = wrapper.GetShort(DataID_SeatID, -1);
	int nChangeType = wrapper.GetShort(DataID_ChangeType, -1);
	int nExtraStatus = wrapper.GetShort(DataID_ExtraStatus, -1);

	LOG_DEBUG("HandleUserStatusNotify(): nUserID=" << nUserID << ", TableID=" << nTableID <<
		", SeatID=" << nSeatID << ", ChangeType=" << nChangeType);

	if(nChangeType == ENTER_TABLE_PLAY)
	{
		LOG_INFO( "HandleUserStatusNotify(): " << nChangeType << " => EnterGame(sitdown) ");
		OnEnterGameNotify(nUserID,nTableID, (byte)nSeatID, false);
	}
	else if(nChangeType == ENTER_TABLE_LOOKON)
	{
		LOG_INFO( "HandleUserStatusNotify(): " << nChangeType << " => EnterGame(lookon) ");
		OnEnterGameNotify(nUserID, nTableID, (byte)nSeatID, true);
	}
	else if(nChangeType == USER_READY)
	{
		LOG_INFO( "HandleUserStatusNotify(): " << nChangeType << " => GameReady ");
		OnGameReadyNotify(nUserID);
		OnPlayerStatusChanged(nUserID, PLAYER_IS_READY);
	}
	else if(nChangeType == GAME_START)
	{
		LOG_INFO( "HandleUserStatusNotify(): " << nChangeType << " => GameStart ");
		OnGameStartNotify(nTableID);
	}
	else if(nChangeType == EXIT_TABLE)
	{
		LOG_INFO( "HandleUserStatusNotify(): " << nChangeType << " => QuitGame ");
		OnQuitGameNotify(nUserID);
		OnPlayerStatusChanged(nUserID, PLAYER_EXIT_TABLE);
	}
	else if(nChangeType == EXIT_ROOM)
	{
		LOG_INFO( "HandleUserStatusNotify(): " << nChangeType << " => ExitRoom ");
		OnExitRoomNotify(nUserID);
		OnPlayerStatusChanged(nUserID, PLAYER_EXIT_ROOM);
	}
	else if(nChangeType == GAME_END)
	{
		LOG_INFO( "HandleUserStatusNotify(): " << nChangeType << " => GameEnd ");
		OnEndGameNotify(nTableID);
	}
	else if(nChangeType == USER_DROPOUT)
	{
		LOG_INFO( "HandleUserStatusNotify(): " << nChangeType << " => Dropout ");
		OnPlayerStatusChanged(nUserID, PLAYER_DROPOUT);
	}
	else if(nChangeType == USER_DROP_RESUME)
	{
		LOG_INFO( "HandleUserStatusNotify(): " << nChangeType << " => Dropresume ");
		OnPlayerStatusChanged(nUserID, PLAYER_DROP_RESUME);
	}
	else
	{
		LOG_WARN( "Unknown change type( " << nChangeType << ") in HandleUserStatusNotify()!");
	}

	if(1 == nExtraStatus || 2 == nExtraStatus)
	{
		// 房间加锁\解锁
		// TODO: not implement
	}

	if(nTableID == m_seatGameInfo.TableID)
	{
		NotifyEvent2Game("NotifyUserStatusReq", pDataX, false);
	}
}

void GameSession::HandleInvitedToTableNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleInviteUserToTableResultNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleUserInfoChanged(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{
	LOG_DEBUG("HandleUserInfoChanged() called");

	if( roomInfo.GameID != m_roomInfo.GameID ||
		roomInfo.ZoneID != m_roomInfo.ZoneID ||
		roomInfo.RoomID != m_roomInfo.RoomID )
	{
		LOG_ERROR("HandleUserInfoChanged - roomid not right, gameid=" << roomInfo.GameID <<
			", zoneid=" << roomInfo.ZoneID << ", roomid=" << roomInfo.RoomID);
		return;
	}

	DxNetWrapper wrapper(pDataX);
	SHORT nChangeType = wrapper.GetShort(DataID_ChangeType, 0);
	if(0 == nChangeType)
	{
		return;
	}

	XLUSERID userid = wrapper.GetInt64(DataID_UserID, 0);
	short nTableID = wrapper.GetShort(DataID_TableID, -1);
	LOG_DEBUG("HandleUserInfoChanged - changetype=" << nChangeType << ", userid=" << userid
			<< ", tableid=" << nTableID);

	switch(nChangeType)
	{
	case 1:
		{
			// other user enter table
			if(nTableID == m_seatGameInfo.TableID)
			{
				NotifyEvent2Game("NotifyUserInfoChanged", pDataX, false);
			}
		}
		break;

	case 2:
		{
			// TODO
			// userinfo changed, notify gameclient
			if(userid == g_nUserID)
			{
				CLoginUserStat::GetInstance()->OnGameScoreChanged(m_roomInfo.GameID, pDataX);
			}
		}
		break;
	}

}

void GameSession::HandleUserScoreChanged(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{
	int nPlayers = 0;
	bool bRet = pDataX->GetDataXArraySize(DataID_Param1, nPlayers);
	if(!bRet)
	{
		LOG_ERROR("[SessionEventHandler::HandleUserScoreChanged]: can't get tableplayer count!");
		return;
	}

	LOG_DEBUG("HandleUserScoreChanged - RoomID=" << roomInfo.RoomID << ", GameID=" << roomInfo.GameID << ", ZoneID=" << roomInfo.ZoneID);

	short nTableID = 0;
	for(int i = 0; i < nPlayers; i++)
	{
		IDataXNet *pDataXNet = NULL;
		bRet = pDataX->GetDataXArrayElement(DataID_Param1, i, &pDataXNet);

		if(!bRet)
		{
			LOG_WARN("HandleUserScoreChanged - can not get playerinfo (" << i << ")");
			continue;
		}

		XLUSERID userid = 0;
		pDataXNet->GetInt64(DataID_UserID, userid);
		pDataXNet->GetShort(DataID_TableID, nTableID);
		LOG_DEBUG("HandleUserScoreChanged - userid=" << userid << ", tableid=" << nTableID);

		if(userid == g_nUserID)
		{
			// 记录积分信息
			// TODO
			CLoginUserStat::GetInstance()->OnGameScoreChanged(m_roomInfo.GameID, pDataXNet);
		}
	}

	if(nTableID == m_seatGameInfo.TableID)
	{
		NotifyEvent2Game("NotifyUserScoreChangeReq", pDataX, false);
	}
}

void GameSession::HandleUserAchievement(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleMatchInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleNewMatchInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleMatchTableInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleMatchStatusNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleMatchGameInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleMatchOrderInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::HandleEnterMatchGroupNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

// EnterRoomTinnyResp
void GameSession::HandleEnterRoomTinnyResp(int nResult, IDataXNet* pDataX)
{
	LOG_DEBUG("result=" << nResult << ", nConnID=" << m_nConnID);

	pDataX->PutInt(DataID_Result, nResult);
	if(nResult != 0)
	{
		LOG_ERROR("Error! Result=" << nResult);
		JniHelper::Notify_JniHall("OnEnterRoomResp", pDataX, false);
		NotifyEvent2Game("OnEnterRoomResp", pDataX, false);
		m_roomStatus = ROOM_CLOSING;

		GameSessionMgr::GetInstance()->RemoveSessionConnection(m_nConnID);
		delete this;
		return;
	}

	m_roomStatus = ROOM_OPENED;

	bool bIsPlaying = false;
	bool bSimulateQuitGame = false;
	GAMESEAT gameSeat = {0};
	unsigned short nSitStatus = (unsigned short)-1;

	int nDataXArraySize = 0;
	bool bRet = pDataX->GetDataXArraySize(DataID_Param1, nDataXArraySize);
	if(!bRet)
	{
		LOG_ERROR("[SessionEventHandler::HandleEnterRoomTinnyResp]: can't get tableplayer count!");
		return;
	}

	for(int i = 0; i < nDataXArraySize; i++)
	{
		IDataXNet *pDataXNet = NULL;
		bRet = pDataX->GetDataXArrayElement(DataID_Param1, i, &pDataXNet);

		if(!bRet)
		{
			LOG_WARN("HandleEnterRoomTinnyResp - can not get playerinfo (" << i << ")");
			continue;
		}

		DxNetWrapper wrapper(pDataXNet);

		XLUSERID userid   = wrapper.GetInt64(DataID_UserID, -1);
		SHORT nTableID    = wrapper.GetShort(DataID_TableID, -1);
		SHORT nSeatID     = wrapper.GetShort(DataID_SeatID, -1);
		SHORT iUserStatus = wrapper.GetShort(DataID_UserStatus, -1);

		LOG_DEBUG( "HandleEnterRoomTinnyResp(): g_nUserID="<<g_nUserID<<", UserID=" << userid << ", UserStatus=" << iUserStatus << ", TableID=" << nTableID << ", nSeatID=" << nSeatID);

		// 判断自己是否在玩着
		if(g_nUserID == userid)
		{
			gameSeat.GameID = m_roomInfo.GameID;
			gameSeat.RoomID = m_roomInfo.RoomID;
			gameSeat.ZoneID = m_roomInfo.ZoneID;
			if(nTableID != -1)
			{
				if(IS_PLAYING == iUserStatus)
				{
					gameSeat.SeatID = nSeatID;
					gameSeat.TableID = nTableID;
					nSitStatus = (unsigned char)iUserStatus;
					bIsPlaying = true;
				}
				else
				{
					nTableID    = (unsigned short)-1;
					nSeatID     = (unsigned char)-1;
					iUserStatus = STANDUP;
					bSimulateQuitGame = true;
				}
			}
			else
			{

			}
		}

		// 记录积分和雷豆信息
		if(userid == g_nUserID)
		{
			// TODO
			CLoginUserStat::GetInstance()->OnGameScoreChanged(m_roomInfo.GameID, pDataXNet);
		}
	}

	LOG_DEBUG("bIsPlaying:"<<bIsPlaying << " room users num:" << nDataXArraySize);

	IDataXNet* pdxNotifyGame = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
	pdxNotifyGame->PutInt(DataID_GameID, m_roomInfo.GameID);
	pdxNotifyGame->PutInt(DataID_ZoneID, m_roomInfo.GameID);
	pdxNotifyGame->PutInt(DataID_RoomID, m_roomInfo.GameID);
	pdxNotifyGame->PutInt(DataID_Result, nResult);
	NotifyEvent2Game("OnEnterRoomResp", pdxNotifyGame);

	ISessionConnection* pConn = GameSessionMgr::GetInstance()->FindSessionConnection(m_nConnID);
	// 断线重连
	if(bIsPlaying)
	{
		if(pConn == NULL)
		{
			LOG_WARN("Can not find session connection by connID(" << m_nConnID << ") when HandleEnterRoomResp() called.");
			return;
		}

		// TODO
	}
	else if(bSimulateQuitGame)
	{
		if(pConn)
		{
			LOG_DEBUG("Try to send 'QuitGame' cmd to server, because HandleEnterRoomTinnyResp() returned info maybe wrong, try to fix it.");

			GAMETABLE tableInfo;
			memcpy(&tableInfo, &gameSeat, sizeof(GAMETABLE));
			pConn->QuitGame(tableInfo);
			OnQuitGameCmd();

			IDataXNet* pdxNotify = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
			pdxNotify->PutInt(DataID_KickReason, KICKOUT_GAME_ALREADY_END);
			NotifyEvent2Game("CloseGameNotify", pdxNotify);
		}
	}
	/*
	 * TODO
	else if (g_pHallLogic->IsAutoEnterRoom(m_nConnID)) // 自动加入房间
	{
		LOG_DEBUG("HandleEnterRoomTinnyResp IsAutoEnterRoom...");
		g_pHallLogic->AutoEnterRoomAndGame();
	}
	*/
}

void GameSession::HandleGetLockedTableResp(int nResult, IDataXNet* pDataX)
{

}

void GameSession::HandleChipinfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{

}

void GameSession::OnQuitGameCmd(SHORT nExtraStatus)
{
    LOG_DEBUG("OnQuitGameCmd - extrastatus=" << nExtraStatus);

    // TODO
    //JniHelper::Notify_JniHall("OnQuitGameResp", m_dxRoomInfo, dx);
}

unsigned int GameSession::OnNotify(const char* szEvent)
{
	if(!szEvent)
	{
		return 0;
	}

	LOG_DEBUG("szEvent=" << szEvent);
	if( strcasecmp(szEvent, "NeedReplay") == 0 )
	{
		LOG_DEBUG("Notify needreplay to game");
		IDataXNet* pdxNotify = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
		pdxNotify->PutInt(DataID_Param1, m_nConnID);
		NotifyEvent2Game("NeedReplay", pdxNotify);

		//Replay();
	}
	return 0;
}

void GameSession::Replay()
{
	ISessionConnection* pConn = GameSessionMgr::GetInstance()->FindSessionConnection(m_nConnID);
	if(pConn)
	{
		pConn->Replay(m_seatGameInfo);
	}
}

