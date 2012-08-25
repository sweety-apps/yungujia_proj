/*
 *  CnChessLogic.h
 *  yshGameCnChess
 *
 *  Created by Tony Zhang on 10/28/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef CnChessLogic_H_
#define CnChessLogic_H_

#include <vector>
#include <map>
#include <string>
#include <jni.h>
#include <android/log.h>


#include "xqgame.h"
#include "CnChess_PlayerInfo.h"
#include "NetServer.h"

#define LOGI(logtag,infoMsg) __android_log_print(4,logtag,infoMsg)

#define nil 0
class CCnChessAI;

struct XLGAMESCOREEX : public XLGAMESCORE
{
	std::string LevelName;
};

typedef struct tagXLMAGICTOOL
{
	short ToolClassID;
	int   ToolBatchID;
	int   UsedTime;
	int   Duration;
} XLMAGICTOOL, *LPXLMAGICTOOL;

struct XLGAMESCOREEXT : public XLGAMESCOREEX
{
	XLUSERID UserID;
	long Score;  // 杩��绉��
	std::string RankName; // 绛�骇绉板�

	std::vector<XLMAGICTOOL> vecMagicTool; // �����〃
};


//
// 用户的游戏相关属性
typedef struct tagXLUSERGAMEINFO
{
	short GameID; // 游戏ID
	int	Points; // 积分
	int WinNum; // 胜局数
	int LoseNum; // 输局数
	int EqualNum; // 平局数
	int EscapeNum; // 逃跑局数
	int OrgID;  // 所属帮派
	int OrgPos;  // 帮派地位
	int DropNum; // 掉线次数
}XLUSERGAMEINFO;

#pragma pack(pop)

// �ㄦ��烘�淇℃�
struct XLUSERINFOEX : public XLUSERINFO
{
	byte IsMale;  // �ㄦ��у�,���涓虹���    long Score;  // 杩��绉��
    std::string RankName; // 绛�骇绉板�
};




// hhj+ 涓�涓��������
typedef union tagGAMEDATA
{
	GAMEROOM	GameRoom;
	GAMETABLE	GameTable;
	GAMESEAT	GameSeat;
	struct
	{
		unsigned short GameID;
		unsigned short ZoneID;
		unsigned short RoomID;
		unsigned short TableID;
		unsigned short SeatID;
		__int64 UserID;
	};
} GAMEDATA;


class NSDate
{
	
};

enum NOTIFYTYPE
{
	NOTIFY_NOTYPE,
	NOTIFY_CHOSED,
	NOTIFY_UNCHOSED,
	NOTIFY_WARNING,
	NOTIFY_VIOLATIONMOVES,
	NOTIFY_MOVEAPIECE,
	NOTIFY_GAMEOVER,
	NOTIFY_PRACTICEHANDLERESULT,
	NOTIFY_NOCHOSED,
	NOTIFY_CANNOTMOVE,
	NOTIFY_SETTIME,
	NOTIFY_CONFIRMTIME,
	NOTIFY_GAMESTARTED,
	NOTIFY_USERQUITGAME,
	NOTIFY_RETRACTMOVES,
	NOTIFY_CantSendRetractMoveThisTime,
	NOTIFY_CantRetractToolMuchOnceTime,
	NOTIFY_CantRetractForJustUse,
	NOTIFY_CantRetractForMoreTimes,
	NOTIFY_RequestRetractMoveInvalid,
	NOTIFY_RequestRetractMoveRefused,
	NOTIFY_RequestRetractMove,
	NOTIFY_RequestDraw

};
class CCnChessLogic
{
public:
	CCnChessLogic();
	~CCnChessLogic();
	vector<int> ParseDescribeStr(char ch[256]);
	vector<int> ParseDescribeStr2(char ch[256]);
	jstring stoJstring( JNIEnv* env, const char* pat );
	uint32_t Fire_Notify(const char *method, int param1 = nil, int param2 = nil,NOTIFYTYPE type = NOTIFY_NOTYPE,vector<int>* Vec = 0);
	uint32_t Call(const std::string &method, const void* param1 = NULL, const void* param2 = NULL,void* result = NULL);
        bool isAttached;
	JavaVM *_vm;
       jclass jcls;
	jobject _thiz;
protected:
	uint32_t m_lastHResult;
	string m_lastError;
	typedef uint32_t (CCnChessLogic::* CallPtr)(const void* param1, const void* param2, void* result);
	typedef std::map<const std::string, CallPtr> CallMap;
	CallMap m_mapCall;
	void InitCallMap();
	
	uint32_t GetLastErrorInt(const void* param1, const void* param2, void* result);
	uint32_t AiMove(const void* param1, const void* param2, void* result);
	uint32_t GetLastErrorStr(const void* param1, const void* param2, void* result);
	uint32_t GetVersionInt(const void* param1, const void* param2, void* result);
	uint32_t GetVersionStr(const void* param1, const void* param2, void* result);
	
	uint32_t Init(const void* param1, const void* param2, void* result);				// �����
	uint32_t GetReady(const void* param1, const void* param2, void* result);			// ���濮��
	uint32_t RequestSurrender(const void* param1, const void* param2, void* result);	// ���杈��
	uint32_t RequestDraw(const void* param1, const void* param2, void* result);			// ���妫��
    uint32_t RequestRetractByGameProp(const void* param1, const void* param2, void* result);
    uint32_t RequestRetractMove(const void* param1, const void* param2, void* result);	// ���妫��
	
	uint32_t PracticeRetractMove(const void *param1, const void *param2, void *result);
	uint32_t DoublePracticeRetractMove(const void *param1, const void *param2, void *result);
	
	uint32_t GetUserID(const void* param1, const void* param2, void* result);			// 寰���ㄦ��ф�
	uint32_t UserClick(const void* param1, const void* param2, void* result);			// ����瑰�浜�欢
	uint32_t ShowReplay(const void* param1, const void* param2, void* result);			// ��氨
	uint32_t ConfirmMove(const void* param1, const void* param2, void* result);			// 纭��璧板�

	uint32_t ReplyDraw(const void* param1, const void* param2, void* result);			// ���妫�����澶�
	uint32_t ReplyRetractMove(const void* param1, const void* param2, void* result);	// ���妫�����澶�

	uint32_t ReplySetTime(const void* param1, const void* param2, void* result);		// 璁剧疆浜����
	uint32_t ReplyConfirmTime(const void* param1, const void* param2, void* result);	// 纭��浜����
	uint32_t IsCursorHand(const void* param1, const void* param2, void* result);		// 榧��������
	uint32_t LoadReplayFile(const void* param1, const void* param2, void* result);		// 璇诲�妫�氨��欢
	uint32_t SaveReplayFile(const void* param1, const void* param2, void* result);		// 淇��妫�氨��欢
	uint32_t SetAutoSaveReplay(const void* param1, const void* param2, void* result);	// ������淇��妫�氨
	
	uint32_t QuitGame(const void* param1, const void* param2, void* result);			// ������娓告����浠�
	uint32_t OnCommBtnClicked(const void* param1, const void* param2, void* result);	// �ㄦ��瑰�浜���风����
    uint32_t IsPointStatusSafe(const void* param1, const void* param2, void* result);
    uint32_t SetProtectMagicTool(const void* param1, const void* param2, void* result);
    uint32_t GetUnSafeKingPos(const void* param1, const void* param2, void* result);
    uint32_t HandleReplayReq(const std::string &method, const void* param1, const void* param2, void* result);
    uint32_t HandlePracticeReq(const std::string &method, const void* param1, const void* param2, void* result);
    uint32_t PrevExit(const void* param1, const void* param2, void* result);
	
    uint32_t StartGameHall(const void* param1, const void* param2, void* result);
    uint32_t ReportCorpId(const void* param1, const void* param2, void* result);
    uint32_t GetUserInfoByUserID(const void* param1, const void* param2, void* result);
    uint32_t GetUserInfoByRoleID(const void* param1, const void* param2, void* result);
    
    uint32_t CanUseRetractPropNow(const void* param1, const void* param2, void* result);
	
    uint32_t MakeFriend(const void* param1, const void* param2, void* result);
	
    uint32_t IsPlayer(const void* param1, const void* param2, void* result);
    uint32_t GetMySeat(const void* param1, const void* param2, void* result);
    uint32_t GetTotalUserInfoByRoleID(const void* param1, const void* param2, void* result);
	
    uint32_t GetMyUserID(const void* param1, const void* param2, void* result);
public:
	// ����ㄥ�搴�����������NetServer���锛�
    void OnSvrRespIEnterGame(int nResult, const vector<PlayerInfoExt>& tablePlayers);		// ����ㄥ�搴� ����ユ父��
    void OnSvrRespUserEnterGame(const PlayerInfoExt &PlayerInfo, bool isLookOnUser);	// ����ㄥ�搴� ��汉杩��娓告�
	void OnSvrRespUserQuitGame(XLUSERID nQuitUserID);		// ����ㄥ�搴� ��汉���娓告�

	void OnSvrRespGetReady(XLUSERID nReadyUserID);			// ����ㄥ�搴� ��汉宸插�澶�ソ
	void OnSvrRespSideFlag(int iRedSide);					// ����ㄥ�搴� ���棰��
	void OnSvrRespGameStart(int nTime, int nTimeEx);		// ����ㄥ�搴� 娓告�寮��浜�
	void OnSvrRespMovedAPiece(UserMoveChessRequest* pstMove);		// ����ㄥ�搴� ���������涓��涓�釜妫��
	void OnSvrRespReqDraw(XLUSERID nUserID, int iData);						// ����ㄥ�搴� 璇锋����
	void OnSvrRespAnswerDraw(XLUSERID nUserID, int iData);						// ����ㄥ�搴� 璇锋���������
	void OnSvrRespReqRetractMove(XLUSERID nUserID, int iData, int mode);					// ����ㄥ�搴� 璇锋����
	void OnSvrRespAnswerRetractMove(XLUSERID nUserID, int iData, int iTime);			// ����ㄥ�搴� 璇锋�������浣�
	void OnSvrRespGameEndCode(unsigned char nEndCode, int nCodeEx);			// ����ㄥ�搴� 娓告�缁����唬��
	void OnSvrRespSetGameOver();			// ����ㄥ�搴� 娓告�缁��
	void OnSvrRespUserScoreChanged(const std::vector<XLGAMESCOREEXT>& scoreInfoArr);		// ����ㄥ�搴� 娓告�寰��

	void OnSvrRespSetTime(int iRedSide);			// ����ㄥ�搴� 璁剧疆�堕�
	void OnSvrRespConfirmTime(int iTime, int nTimeEx);			// ����ㄥ�搴� 纭���堕�
	void OnSvrRespUserChoseAPiece(XLUSERID nSubmitUserID, int iData);				// ����ㄥ�搴� 瀵规���腑/�����腑涓��妫��

	void OnSvrRespEnterGameFailed(int nResult);				// ����ㄥ�搴� 杩��娓告�澶辫触OnPlayerStatusChanged

	void OnSvrRespReloadGameData(ResumeGameData *pGameData);				// ����ㄥ�搴� ��疆�版�
	void OnSvrRespPlayerStatusChanged(XLUSERID nPlayerID, PLAYER_STATUS_ACTION_ENUM nStatusAction);	// ����ㄥ�搴� �ㄦ��舵��瑰�
	void OnSvrRespMagicToolInfo(XLUSERID nPlayerID, const IDataXNet &dx);		// ����ㄥ�搴� �ㄦ����淇℃�

    void OnNotifyMyCnChessMagicToolsInfo(XLUSERID nPlayerID, IDataXNet *pDataXNet);
    void OnSvrSetServerMode(long srvmode);   // �������ㄧ�妯″�
	
    void SaveGameRecord(bool);
    void NotifyWillBeKilledChesses();
    
	
    const GAMEDATA& GetGameSeatInfo();
	
    void ondrawAchess(int srcindex, int destindex, CPoint from, CPoint to);
    void onretractmove(int srcindex, int destindex, CPoint from, CPoint to);
    void ReportUserAction(const std::string& bstrParam);
    void HandleUserLevelChanged(IDataXNet* pDataX);
	
    void NotifyUseRetractToolSuccess(LONG Chair);
	
    void NotifyLeidouStat(void* data);
	
    void NotifyGameEndTime(void* data);
	void practicehandleresult();
private:
	void checkClickResult(CPoint p, bool bWarn = true);			// 妫��浜�欢���浼��璧锋�瀛���舵����锛��涓��绉诲�锛��瀛��灏��绛��
	void checkPracticeClickResult(CPoint p, bool needAi = true, bool bWarn = true);			// 妫��浜�欢���浼��璧锋�瀛���舵����锛��涓��绉诲�锛��瀛��灏��绛��
	void retractMoves(bool bMyReq, int n, int iTime);	// �ц�������浣��浣�
	void submitGameAction(unsigned char cType, int iData);		// ��氦�戒护璇锋�
	void submitGameActionEx(unsigned char cType, int iData, int iDataEx);
	unsigned short GetSeatInfoFromHall();							// 浠�ぇ������瀛���稿�淇℃�
	
	void notifyUserInfo(int p, const PlayerInfoExt &info);
	void checkGameScore();
	int reportXlScore(bool bWin, XLUSERID userID);
	
	
	
public:
    PlayerInfoExt m_PlayerInfo_Mine;
    PlayerInfoExt m_PlayerInfo_Rival;
	
    int m_ReplayRetractMode; // ��嚎����惰�������妫�ā寮�
    CXQGame m_XQGame;
	bool GetFlagSide() {return m_bRedSide;}
	bool GetIsMyTurn() {return m_bMyTurn;}
	//bool GetIsReady() {return m_bReady;}
	int GetGameStatus(){return (int)m_GameStatus;}
	bool GetIsGameStarted() {return m_bGameSarted;}
	void SetFlagRedSide(bool flagside) {m_bRedSide = flagside;}
	void SwitchFlagSide()
	{
		if (m_bRedSide) {
			m_bRedSide = false;
		}
		else {
			m_bRedSide = true;
		}
	}
	void ShowAlert(string type);
private:
	
	CPoint m_pChosedPiece;
	bool m_bRedSide;
	bool m_bGameSarted;
	bool m_bReady;
	bool m_bMyTurn;
	bool m_bPlayer;	// ������瀹讹����瑙��锛�
	int m_GameEndCode;
	int m_GameEndCodeEx;	// 1锛�孩���2锛�����3锛��妫��4锛���归�璺�
	int m_MoveResult;
	int m_nStepCount;
	bool m_bNeedAi;
	
public:
	int m_nRequestTimesCount_Draw;
	int m_nRequestTimesCount_Retract;
	
	
	GAMESTATE m_GameStatus;				// �板����褰��GAME_EXIT锛��璇ユ�m_bReady��_bGameSarted涔��涓����public:
	GAMEDATA m_MyInfo;
	CNetServer m_NetServer;				// 璐�矗����戒护锛�苟灏���″����搴�互娑����舰寮��缁��绐��
private:
	std::vector<PlayerInfoExt> m_TablePlayerInfo;	// table涓����釜player��俊��

	XLGAMESCOREEXT m_nUserScore[2];
	bool m_bInATable;
    bool m_bOpenProtectMagic; 
    long m_lServerMode;   // ����ㄧ���ā寮�� ���灏辫�缃�袱绉�ā寮�� 0琛ㄧず姝ｅ父�块�锛�琛ㄧず�����垂浣跨��块�
	
	//xxCCnChessReplay m_replay;
	
    bool m_bUserHandleProtect;
    vector<XLMAGICTOOL> m_myMagicToolsVec;  // ��������〃

private:
	CPoint m_TempPoint;
	
private:
	int m_nRecvScoreCount;
	bool m_bRecvGameEnd;
    CCnChessAI* m_AiInterface;

	
    bool m_bPracticeStart;
    NSDate *m_startTime;
public:
    bool m_bMiniHall;
	bool isNeedMainThread;
	
private:
    bool m_bJustRetractMove; // ���������妫� 璇ュ�����ㄧ��疯蛋涓��瀛��娓��, �ㄤ��ゆ�������缁�����
	
    bool m_bUseRetractTool;
    LONG m_RetractSeqCount; // 杩�画��������
    bool m_bCanRequestRetract; // �����互������璇锋�
    long m_bRetractRefuseCount; // ���娆℃�
	
    bool m_bMyReqRetract; // ������������
private:
	DECL_LOGGER
};
#endif
