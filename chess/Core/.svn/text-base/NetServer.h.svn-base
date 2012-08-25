#pragma once

#include "GameNetInf.h"
#include "common.h"
#include "CnChess_Protocol.h"
#include "CnChess_define.h"
#include "CnChess_PlayerInfo.h"
#include <jni.h>
#include <vector>
using namespace std;
class CCnChessLogic;

#pragma pack(push)
#pragma pack(1)
// 座位
typedef struct tagGAMESEAT
{
	unsigned short GameID;
	unsigned short ZoneID;
	unsigned short RoomID;
	unsigned short TableID;
	unsigned short SeatID;
}GAMESEAT;

// 游戏桌
typedef struct tagGAMETABLE
{
	unsigned short GameID;
	unsigned short ZoneID;
	unsigned short RoomID;
	unsigned short TableID;
}GAMETABLE;

// 房间
typedef struct tagGAMEROOM
{
	unsigned short GameID;
	unsigned short ZoneID;
	unsigned short RoomID;

	bool operator < (const tagGAMEROOM& rhs) const
	{
		return ( (GameID < rhs.GameID) || 
			(GameID == rhs.GameID && ZoneID < rhs.ZoneID) || 
			(GameID == rhs.GameID && ZoneID == rhs.ZoneID && RoomID < rhs.RoomID) );
	}

}GAMEROOM;

// 游戏积分信息
typedef struct tagXLGAMESCORE
{
	unsigned char Level; // 级别
	int	Points; // 积分
	int WinNum; // 胜局数
	int LoseNum; // 输局数
	int EqualNum; // 平局数
	int EscapeNum; // 逃跑局数
	int DropNum;  // 掉线次数
	int PointsDelta; // 本局积分改变量
}XLGAMESCORE;

/***********************************************************************************/
/* 服务器请求、响应的处理                                                                */
/* 传入一个接收消息的窗口句柄, 当接收到服务器响应时, 向窗口发送相应消息            */
/***********************************************************************************/

class CNetServer //: public ISessionCallback
{
public:
	CNetServer(void);
	virtual	~CNetServer(void);
	bool init(int nConnID, CCnChessLogic *pClient);	// 传入与服务器连接的id，回调对象的指针
	
public:
	// 向服务器提交请求
	// ISessionConnection的接口
	//int GetConnectionID(){return m_pSessionConnection->GetConnectionID();}
	//bool SendCommand(IGameCommand* pCmd){return m_pSessionConnection->SendCommand(pCmd);}
	//void Close(){return m_pSessionConnection->Close();}
	//	void EnterRoom(const GAMEROOM& roomInfo, const XLUSERINFO& userInfo){return m_pSessionConnection->EnterRoom(roomInfo, userInfo);}
	//	void ExitRoom(const GAMEROOM& roomInfo){return m_pSessionConnection->ExitRoom(roomInfo);}
	//void Chat(const GAMETABLE& tableInfo, const string& chatMsg, int nChatSeqNo){return m_pSessionConnection->Chat(tableInfo, chatMsg, nChatSeqNo);}
	void EnterGame(const GAMESEAT& seatInfo, GAME_USER_STATUS userStatus, const string& initialTableKey, const string& followPasswd);
	void GameReady(const GAMESEAT& seatInfo){/*return m_pSessionConnection->GameReady(seatInfo);*/}
	void SubmitGameAction(const GAMEROOM& roomInfo, const char* pszGameData, int nDataLen);
	void QuitGame(const GAMETABLE& tableInfo){/*return m_pSessionConnection->QuitGame(tableInfo);*/}
	uint32_t Call(const string &method, const void * param1=NULL, const void * param2=NULL, void * result=NULL){/*return m_pSessionConnection->Call(method, param1, param2, result);*/}
	void Replay(const GAMESEAT& seatInfo){/*return m_pSessionConnection->Replay(seatInfo);*/}
	
	
public:
	// ISessionCallbackCore
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 接收到命令(注意: pCmd对象在调用完后由ClientNet负责释放)
	// 注意: 如果是普通命令(如EnterRoomNotify，则既会调用OnEnterRoomNotify这样的包装函数，也会调用OnRecvCmd）
	//virtual void OnRecvCmd( IGameCommand* pCmd){}
	
	// 发生网络错误通知
	virtual void OnNetworkError(int iErrorCode);
	
	// 重连成功（连接断开后，重连成功）
	virtual void OnReconnectOK(int nReconnTimes){}
	
	// 大厅通知
	//virtual uint32_t OnNotify(const string &event, const void *param1=NULL, const void *param2=NULL);
	
	// ISessionCallback
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 进入游戏（游戏桌）的响应信息
	virtual void OnEnterGameResp(int nResult, const vector<XLPLAYERINFO>& tablePlayers);
	// 通知消息：同桌有其它人进入
	virtual void OnEnterGameNotify(XLUSERID nEnterUserID, int nTableID, byte nSeatID, bool isLookOnUser);	
	
	// 通知消息：某用户游戏已准备好（点了"开始"）
	virtual void OnGameReadyNotify(XLUSERID nReadyUserID);	
	// 通知消息：游戏开始（同桌的所有玩家都点了开始）
	virtual void OnGameStartNotify(int nTableID);	
	
	// 游戏一局结束
	virtual void OnEndGameNotify(int nTableID); 
	
	// 退出游戏桌的响应信息
	virtual void OnQuitGameResp(int nResult);
	// 通知消息：同桌的某玩家退出
	//virtual void OnQuitGameNotify(XLUSERID nQuitUserID);	
	
	// 通知消息：同房间的某玩家退出
	//virtual void OnExitRoomNotify(XLUSERID nExitUserID);	
	// 响应消息：退出房间(关闭session连接的较好时机)
	virtual void OnExitRoomResp(int nResult);
	
	// 响应消息：发送聊天的响应结果(nResult: 0->成功，其它值->错误)
	virtual void OnChatResp(int nChatSeqNo, int nResult);	
	// 通知消息：同桌的某玩家发送聊天消息
	//virtual void OnChatNotify(const GAMETABLE& tableInfo, XLUSERID nChatUserID, const string& chatMsg);	
	
	// 响应消息：提交了游戏动作，服务端的响应；服务端只在非法动作时才发送此回应消息
	virtual void OnGameActionResp(int nResult);
	// 通知消息：同桌的某玩家提交了游戏动作（发牌，或下了一步棋...)
	virtual void OnGameActionNotify(XLUSERID nSubmitUserID, const char* szGameDataBuf,int nDataLen);
	
	// 通知消息：某玩家的积分有变化
	//virtual void OnUserScoreChanged(XLUSERID nChangeUserID, const XLGAMESCORE& scoreInfo);
	
	// 响应消息：服务端只返回一个整型结果值(nResult)的响应消息, nRespCmdID为响应命令ID
	//virtual void OnCmdSimpeleResp(SIMPLE_RESP_CMD_ID nRespCmdID, int nResult);	
	// 通知消息：某玩家的状态发生改变
	//virtual void OnPlayerStatusChanged(XLUSERID nPlayerID, PLAYER_STATUS_ACTION_ENUM nStatusAction);
	
	// 通知消息：自己被踢出(重复登陆或其它原因)；
	// 游戏客户端处理此事件，只需要直接退出进程，不需要弹出消息提示
	virtual void OnKickout(KICKOUT_REASON_ENUM kickReason, XLUSERID nWhoKickMe);
	// 基于IDataX通用命令的服务端响应
	//virtual void OnGenericResp(const string& cmdName, int nResult, IDataXNet* pDataX);
	// 基于IDataX通用命令的服务端通知
	//virtual void OnGenericNotify(const string& cmdName, const GAMEROOM& roomInfo, IDataXNet* pDataX);
	
private:
	void OnEnterGameResp(int nResult, const vector<PlayerInfoExt>& tablePlayers);
	//void OnEnterGameNotify(XLUSERID nEnterUserID, int nTableID, byte nSeatID, bool isLookOnUser, IDataXNet* pdata);
	
	//这些接口一律挪到JAVA层
	//void HandleKickPlayerNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	//void HandleUserStatusNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX);
	//void HandleKickPlayerResp(int nResult, IDataXNet* pDataX);
	//void HandleTryEnterTableResp( int nResult, IDataXNet* pDataX );
	//void HandleUserScoreChangedNotify(const GAMEROOM& room, IDataXNet* pDataX );
	//void HandleMagicToolChanged(const GAMEROOM& room, IDataXNet* pDataX );
 //   void HandleNotifyUserInfoReq(IDataXNet* pDataX);
	
protected:
	CCnChessLogic *m_pCnChessLogic;

private:
//	ISessionConnection* m_pSessionConnection;

private:
	DECL_LOGGER
};