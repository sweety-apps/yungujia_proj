#include "HallLogic.h"
#include "GameSessionMgr.h"
#include "GameNet/GameUtil.h"
#include "GameDirInfoMgr.h"
#include "LoginUserStat.h"
#include "StatisticsMgr.h"
#include "common/utility.h"
#include "common/setting.h"

IMPL_LOGGER(CHallLogic);

///////////////////////////////////////////////////////////////////////////////
CHallLogic::CHallLogic()
{

}

CHallLogic::~CHallLogic()
{

}

CHallLogic* CHallLogic::GetInstance()
{
	static CHallLogic _instance;
	return &_instance;
}

void CHallLogic::Init(const char* szIMEIID)
{
	ysh_assert(szIMEIID);

	string sTmp = szIMEIID;
	if(*szIMEIID == '0')
	{
		sTmp = "406186592A1FVQ1B";
	}

	//sTmp = "4061800082A1FVQ1B";

	char szPeerID[17];
	memset(szPeerID, 0, 17);
	memcpy(szPeerID, sTmp.c_str(), min(16, sTmp.length()));

	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();
	GameUtility* pImpl = (GameUtility*)pGameUtil;
	pImpl->SetPeerID(szPeerID);
}

void CHallLogic::LoginAsGuest()
{
	if(g_nUserID != -1)
	{
		// already login as guest
		return;
	}

	CHallContext::GetInstance()->SetGameNetUserInfo(-1, NULL);
	QueryBlueDiamondInfo(-1);

	CStatisticsMgr::GetInstance()->ReportLogin();
}

void CHallLogic::QueryBlueDiamondInfo(XLUSERID nUserID)
{
	LOG_DEBUG("QueryBlueDiamondInfo() called.");

	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();
	string strPeerId = pGameUtil->GetPeerID();

	IDataXNet* pDxParam = pGameUtil->CreateDataX();
	pDxParam->PutInt64(DataID_UserID, nUserID); // -1
	pDxParam->PutBytes(DataID_PeerID, (byte*)strPeerId.c_str(), (int)strPeerId.length());
    pDxParam->PutInt(DataID_ChangeType, 1); // -1

	string strServer = setting::get_instance()->get_string("userConfig", "user_server", "user.minigame.ysh.com");
	int nPort = setting::get_instance()->get_int("userConfig", "user_port", 38083);
	LOG_DEBUG("QueryBlueDiamondInfo(): server=" << strServer << ", port=" << nPort << ", PeerID=" << strPeerId);

	IGameNet* pGameNet = CHallContext::GetInstance()->GetGameNet();
	pGameNet->SubmitDataXReqSpec(GN_CONN_USER, strServer.c_str(), (unsigned short)nPort, "QueryUserInfoReq", pDxParam);
}

bool CHallLogic::GetDirInfo(int nGameClassID, int nGameID, int nZoneID)
{
	IGameNetEx* pGameNet = CHallContext::GetInstance()->GetGameNet();
	if(pGameNet == NULL)
	{
		LOG_ERROR("GetDirInfo2() failed, because GameNet.dll load failed!");
		m_sLastError = "无法加载GameNet组件!";
		return false;
	}

	return false;
}

bool CHallLogic::AutoChooseRoom(int nGameClassID, int nGameID)
{
	LOG_DEBUG("AutoChooseRoom GameClassID=" << nGameClassID << ", GameID="<<nGameID);

	BOOL bAlreadyOpen = GameSessionMgr::GetInstance()->IsSameGameSessionConnExist((short)nGameID);
	LOG_DEBUG("bAlreadyOpen:" << int(bAlreadyOpen));

	if(bAlreadyOpen)
	{
		GameSession* pSession = (GameSession*)GameSessionMgr::GetInstance()->FindFirstGameRoomByGameID((short)nGameID);

		BOOL bGameRunning = GameSessionMgr::GetInstance()->IsGameRuning((short)nGameID);
		if(bGameRunning)
		{
			// 已经在玩游戏
			if(pSession)
			{
				pSession->NotifyEvent2Game("ModifyGameWndStatus", NULL);
			}
			return true;
		}

		// 快速进入游戏
		// TODO

		return false;
	}

	IGameNetEx* pGameNet = CHallContext::GetInstance()->GetGameNet();

	string strSvr = setting::get_instance()->get_string("userConfig", "query_dir_server", "query.room.dir.minigame.ysh.com");
	int nSvrPort = setting::get_instance()->get_int("userConfig", "dir_port", 28080);

	int nUserType = 0;
	if(g_nUserID > 1000000000)
	{
		nUserType = 1;
	}
	else
	{
		// TODO
		nUserType = 1;
	}

	string strTmp = "GBK";
	IDataXNet* pDataXNet = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();

	XLUSERGAMEINFO  scoreInfo = CLoginUserStat::GetInstance()->GetGameScore(nGameID);

	pDataXNet->PutUTF8String(DataID_DirEncode, (byte*)strTmp.c_str(), (int)(strTmp.length() + 1));
	pDataXNet->PutInt(DataID_GameClassID, nGameClassID);
	pDataXNet->PutInt(DataID_GameID, nGameID);
	pDataXNet->PutInt(DataID_UserType, nUserType);
	pDataXNet->PutInt(DataID_UserScore, scoreInfo.Points);
	pDataXNet->PutInt(DataID_Balance, 0);

	pGameNet->QueryDirInfoWithSkipRooms(strSvr.c_str(), (unsigned short)nSvrPort, "querySuitedZoons", pDataXNet);
}

bool CHallLogic::TryEnterRoom(int nGameID, int nZoneID, int nRoomID)
{
	LOG_INFO("gameid=" << nGameID << ", zoneid=" << nZoneID << ", roomid=" << nRoomID);

	ISessionConnection* pConn = GameSessionMgr::GetInstance()->FindSessionConnection(nGameID, nZoneID, nRoomID);
	if( pConn != NULL )
	{
		LOG_WARN("The room(GameID=" << nGameID << ", ZoneID=" << nZoneID << ", RoomID=" << nRoomID << ") already opened!!");
		return false;
	}

	if( GameSessionMgr::GetInstance()->IsSameGameSessionConnExist(nGameID) )
	{
		LOG_WARN("Open more than one room for gameid=" << nGameID);
		return false;
	}

	GAMEROOM roomInfo;
	roomInfo.GameID = nGameID;
	roomInfo.ZoneID = nZoneID;
	roomInfo.RoomID = nRoomID;

	GameRoomDetail roomDetail;
	bool bFound = GameDirInfoMgr::GetInstance()->GetRoomInfo(
			roomInfo, roomDetail);
	if(!bFound)
	{
		LOG_ERROR("cannot find room detail info");
		return false;
	}

	string sServer = roomDetail.sServer;
	int nSvrPort = roomDetail.nPort;

	LOG_INFO( "Game server is [" << sServer << ":" << nSvrPort << "].");

	IGameNetEx* pGameNet = CHallContext::GetInstance()->GetGameNet();

	GameSession* pSession = new GameSession();
	pConn = pGameNet->CreateSessionConnection(sServer.c_str(),
			(unsigned short)nSvrPort, pSession);
	ISessionConnectionEx* pConnEx = static_cast<ISessionConnectionEx*>(pConn);
	pSession->SetSessionID(pConn->GetConnectionID());
	pSession->SetRoomInfo(roomInfo);
	pSession->SetRoomStatus(GameSession::ROOM_OPENING);

	GameSessionMgr::GetInstance()->AddSessionConnection(
			roomInfo.GameID, roomInfo.ZoneID, roomInfo.RoomID, pConn, pSession);

	IDataXNet* pDataXNet = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
	CLoginUserStat::GetInstance()->UserInfo2DataXNet(pDataXNet);
	pConnEx->SendGenericCmd("EnterRoomTinnyReq", roomInfo, pDataXNet);
	return true;
}

bool CHallLogic::AutoEnterGame(int nGameID)
{
	GameSession* pSession =
			(GameSession*)GameSessionMgr::GetInstance()->FindFirstGameRoomByGameID(nGameID);
	if(!pSession)
	{
		LOG_WARN("Room for game[" << nGameID << "] not exist!");
		return false;
	}

	ISessionConnection* pConn =
			GameSessionMgr::GetInstance()->FindSessionConnection(pSession->GetSessionID());
	if(pConn == NULL)
	{
		LOG_WARN("Can not find such room when AutoEnterGame() called: GameID=" << nGameID);
		return false;
	}

	if(GameSession::ROOM_OPENING == pSession->GetRoomStatus())
	{
		LOG_WARN("room is opening");
		return true;
	}

	SHORT nLastTableID = -1;
	SHORT nLastSeatID  = -1;
	SHORT nEmptySeatNum = 0;
	SHORT nActionType = 2;

	IDataXNet* pDataX = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
	pDataX->PutShort(DataID_EmptySeatNum, nEmptySeatNum);
	pDataX->PutShort(DataID_ActionType, 2);
	pDataX->PutShort(DataID_TableID, nLastTableID);
	pDataX->PutShort(DataID_SeatID, nLastSeatID);

	GAMEROOM roomInfo;
	pSession->GetRoomInfo(roomInfo);

	LOG_INFO("TryEnterTableReq now, roomid=" << roomInfo.RoomID << ", zoneid=" << roomInfo.ZoneID
		<< ", gameid=" << roomInfo.GameID
		<< ", emptyseatnum=" << nEmptySeatNum << ", actiontype=" << nActionType
		<< ", skiptable=" << nLastTableID << ", skipseat=" <<nLastSeatID);

	pConn->SendGenericCmd("TryEnterTableReq", roomInfo, pDataX);
	return true;
}

bool CHallLogic::QuitGame(int nGameID, int nTableID)
{
	GameSession* pSession =
			(GameSession*)GameSessionMgr::GetInstance()->FindFirstGameRoomByGameID(nGameID);
	if(!pSession)
	{
		LOG_WARN("Room for game[" << nGameID << "] not exist!");
		return false;
	}

	ISessionConnection* pConn =
			GameSessionMgr::GetInstance()->FindSessionConnection(pSession->GetSessionID());
	if(pConn == NULL)
	{
		LOG_WARN("Can not find such room when QuitGame() called: GameID=" << nGameID);
		return false;
	}

	GAMEROOM roomInfo;
	pSession->GetRoomInfo(roomInfo);

	GAMETABLE gameTable;
	gameTable.GameID = (unsigned short)roomInfo.GameID;
	gameTable.RoomID = (unsigned short)roomInfo.RoomID;
	gameTable.TableID = (unsigned short)nTableID;
	gameTable.ZoneID = (unsigned short)roomInfo.ZoneID;
	pConn->QuitGame(gameTable);

	return true;
}

bool CHallLogic::GameReady(int nGameID, int nTableID, int nSeatID)
{
	GameSession* pSession =
			(GameSession*)GameSessionMgr::GetInstance()->FindFirstGameRoomByGameID(nGameID);
	if(!pSession)
	{
		LOG_WARN("Room for game[" << nGameID << "] not exist!");
		return false;
	}

	ISessionConnection* pConn =
			GameSessionMgr::GetInstance()->FindSessionConnection(pSession->GetSessionID());
	if(pConn == NULL)
	{
		LOG_WARN("Can not find such room when QuitGame() called: GameID=" << nGameID);
		return false;
	}

	GAMEROOM roomInfo;
	pSession->GetRoomInfo(roomInfo);

	GAMESEAT gameSeat;
	gameSeat.GameID  = (unsigned short)roomInfo.GameID;
	gameSeat.RoomID  = (unsigned short)roomInfo.RoomID;
	gameSeat.ZoneID  = (unsigned short)roomInfo.ZoneID;
	gameSeat.TableID = (unsigned short)nTableID;
	gameSeat.SeatID  = (unsigned short)nSeatID;
	pConn->GameReady(gameSeat);

	return true;
}

bool CHallLogic::ExitRoom(int nGameID)
{
	GameSession* pSession =
			(GameSession*)GameSessionMgr::GetInstance()->FindFirstGameRoomByGameID(nGameID);
	if(!pSession)
	{
		LOG_WARN("Room for game[" << nGameID << "] not exist!");
		return false;
	}

	ISessionConnection* pConn =
			GameSessionMgr::GetInstance()->FindSessionConnection(pSession->GetSessionID());
	if(pConn == NULL)
	{
		LOG_WARN("Can not find such room when QuitGame() called: GameID=" << nGameID);
		return false;
	}

	ISessionConnectionEx* pConnEx = static_cast<ISessionConnectionEx*>(pConn);

	GAMEROOM roomInfo;
	pSession->GetRoomInfo(roomInfo);
	pSession->SetRoomStatus(GameSession::ROOM_CLOSING);
	pConnEx->ExitRoom(roomInfo);

	return true;
}

bool CHallLogic::SubmitGameAction(int nGameID, const char* pBuf, int nLen)
{
	GameSession* pSession =
			(GameSession*)GameSessionMgr::GetInstance()->FindFirstGameRoomByGameID(nGameID);
	if(!pSession)
	{
		LOG_WARN("Room for game[" << nGameID << "] not exist!");
		return false;
	}

	ISessionConnection* pConn =
			GameSessionMgr::GetInstance()->FindSessionConnection(pSession->GetSessionID());
	if(pConn == NULL)
	{
		LOG_WARN("Can not find such room when QuitGame() called: GameID=" << nGameID);
		return false;
	}

	string sData = utility::ch2str((unsigned char *)pBuf, nLen);
	LOG_DEBUG("Data=" << sData);

	GAMEROOM roomInfo;
	pSession->GetRoomInfo(roomInfo);
	pConn->SubmitGameAction(roomInfo, pBuf, nLen);

	return true;
}

bool CHallLogic::Replay(int nGameID)
{
	GameSession* pSession =
			(GameSession*)GameSessionMgr::GetInstance()->FindFirstGameRoomByGameID(nGameID);
	if(!pSession)
	{
		LOG_WARN("Room for game[" << nGameID << "] not exist!");
		return false;
	}

	LOG_DEBUG("Replay from game");
	pSession->Replay();
}
