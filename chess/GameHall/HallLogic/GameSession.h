#ifndef _HALLLOGIC_GAMESESSION_H_
#define _HALLLOGIC_GAMESESSION_H_

#include "common/common.h"
#include "common/GameNetInf.h"
#include "GameNet/command/DataID.h"

class GameSession : public ISessionCallbackEx
{
public:
	GameSession(void);
	~GameSession(void);

public:
	enum ROOM_STATUS_ENUM
	{
		ROOM_CLOSED = 0, // 已关闭
		ROOM_OPENING = 1, // 正在打开
		ROOM_OPENED = 2, // 已打开
		ROOM_CLOSING = 3 // 正在关闭
	};
	enum GAMEID_CONSTS
	{
		GAMEID_UPGRADE = 6,		// 升级
		GAMEID_KRIEGSPIEL = 7,	// 四国军旗
	};

	void SetSessionID(int nConnID) { m_nConnID = nConnID; }
	int GetSessionID() const { return m_nConnID; }

	void SetRoomStatus(ROOM_STATUS_ENUM status) { m_roomStatus = status; }
	ROOM_STATUS_ENUM GetRoomStatus() const { return m_roomStatus; }
	void DescRoomStatus(string& sDesc);

	void SetRoomInfo(const GAMEROOM& roomInfo);
	void GetRoomInfo(GAMEROOM &roomInfo);

	void GetLastTryEnterTableAndSeat(SHORT& nTableID, SHORT& nSeatID);
	void SetLastTryEnterSeat(GAMESEAT& seatInfo);

	void NotifyEvent2Game(const char* szEvent, IDataXNet* pDx, bool bAutoDeleteDx = true);
	void Replay();

// ISessionCallbackEx
public:
	virtual void OnRecvCmd(IGameCommand* pCmd);
	virtual void OnEnterRoomResp(int, const std::vector<tagXLPLAYERINFO, std::allocator<tagXLPLAYERINFO> >&);
	virtual void OnEnterRoomNotify(const XLPLAYERINFO&);
	virtual void OnUserInfoModified(const XLPLAYERINFO&);
	virtual void OnExitRoomResp(int);
	virtual void OnNetworkError(int iErrorCode);
	virtual void OnEnterGameResp(int nResult, const vector<XLPLAYERINFO>& tablePlayers);
	virtual void OnEnterGameNotify(XLUSERID nEnterUserID, int nTableID, byte nSeatID, bool isLookOnUser);
	virtual void OnGameReadyNotify(XLUSERID nReadyUserID);
	virtual void OnGameStartNotify(int nTableID);
	virtual void OnEndGameNotify(int nTableID);
	virtual void OnQuitGameResp(int nResult);
	virtual void OnQuitGameNotify(XLUSERID nQuitUserID);
	virtual void OnExitRoomNotify(XLUSERID nExitUserID);
	virtual void OnChatResp(int nChatSeqNo, int nResult);
	virtual void OnChatNotify(const GAMETABLE& tableInfo, XLUSERID nChatUserID, const string& chatMsg);
	virtual void OnGameActionResp(int nResult);
	virtual void OnGameActionNotify(XLUSERID nSubmitUserID, const char* szGameDataBuf,int nDataLen);
	virtual void OnUserScoreChanged(XLUSERID nChangeUserID, const XLGAMESCORE& scoreInfo);
	virtual void OnCmdSimpeleResp(SIMPLE_RESP_CMD_ID nRespCmdID, int nResult);
	virtual void OnPlayerStatusChanged(XLUSERID nPlayerID, PLAYER_STATUS_ACTION_ENUM nStatusAction);
	virtual void OnKickout(KICKOUT_REASON_ENUM kickReason, XLUSERID nWhoKickMe);
	virtual void OnGenericResp(const string& cmdName, int nResult, IDataXNet* pDataX);
	virtual void OnGenericNotify(const string& cmdName, const GAMEROOM& roomInfo, IDataXNet* pDataX);
	virtual unsigned int OnNotify(const char* szEvent);

private:
	void HandleUserConfigResp(int nResult, IDataXNet* pDataX);
	void HandleGenericChatResp(int nResult, IDataXNet* pDataX);
	void HandleKickPlayerResp(int nResult, IDataXNet* pDataX);
    void HandleTryEnterTableResp(int nResult, IDataXNet* pDataX);
    void HandleEnterRoomResp(int nResult, IDataXNet* pDataX);
    void HandleEnterTableResp(int nResult, IDataXNet* pDataX);
    void HandleResumeServerNotifyMsgResp(int nResult, IDataXNet* pDataX);

	void HandleChatNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleKickPlayerNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleUserStatusNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleInvitedToTableNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleInviteUserToTableResultNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
    void HandleUserInfoChanged(const GAMEROOM& roomInfo, IDataXNet* pDataX);
    void HandleUserScoreChanged(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleUserAchievement(const GAMEROOM& roomInfo, IDataXNet* pDataX);

	void HandleMatchInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleNewMatchInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleMatchTableInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleMatchStatusNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleMatchGameInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleMatchOrderInfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	void HandleEnterMatchGroupNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);

	void HandleEnterRoomTinnyResp(int nResult, IDataXNet* pDataX);
	void HandleGetLockedTableResp(int nResult, IDataXNet* pDataX);

	void HandleChipinfoNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);

private:
	BOOL ShouldDispatchToGameTable(IGameCommand* pCmd);
	void OnQuitGameCmd(SHORT nExtraStatus = 0);

private:
	int 				m_nConnID;
	GAMEROOM 			m_roomInfo;
	ROOM_STATUS_ENUM 	m_roomStatus;

	GAMESEAT 			m_seatGameInfo;
	GAMESEAT 			m_seatLastTryEnter;

	int 				m_nSitStatus;
	bool 				m_bHasStartGame;

	SHORT 				m_nLastTryEnterTable;
	SHORT 				m_nLastTryEnterSeat;
	SHORT 				m_nCurrentTable;

	DECL_LOGGER;
};

#endif // _HALLLOGIC_GAMESESSION_H_
