#ifndef _CNCHESS_PROTOCOL_H_
#define _CNCHESS_PROTOCOL_H_

#define PROTOCOL_VERTION 0x1
#define PROTOCOL_CMD_HELLO 0x0

#pragma pack( push,1 )


//game协议
//////////////////////////////////////////////////////////////////////////
//协议部分

#define CMD_DLL_REQ_SETTIMER		1
#define CMD_DLL_REQ_CONFIRMTIMER	2
#define CMD_DLL_REQ_MOVE			3
#define CMD_DLL_REQ_SURRENDER		4
#define CMD_DLL_REQ_DRAW			5
#define CMD_DLL_REQ_RETRACTMOVE		6

#define CMD_DLL_ANSWER_DRAW			11
#define CMD_DLL_ANSWER_RETRACTMOVE	12

#define CMD_DLL_NOTIFY_TIMEOUT		21
#define CMD_DLL_NOTIFY_SCORE		22

#define CMD_DLL_NOTIFY_CHOSE_PIECE	30

#define CMD_DLL_NOTIFY_SIDE_FLAG			90		// 服务器提示：双方颜色
#define CMD_DLL_NOTIFY_SET_TIMER			100		// 服务器提示：设置时间
#define CMD_DLL_NOTIFY_GAME_BEGIN			101		// 游戏开始，开始下子

#define CMD_DLL_NOTIFY_GAMEEND_BYWIN		102
#define CMD_DLL_NOTIFY_GAMEEND_BYESC		103
#define CMD_DLL_NOTIFY_GAMEEND_BYSURRENDER	104
#define CMD_DLL_NOTIFY_GAMEEND_BYDRAW		105
#define CMD_DLL_NOTIFY_GAMEEND_BYTIMEOUT	106
#define CMD_DLL_NOTIFY_GAMEEND_BYABORT		107

#define CMD_DLL_NOTIFY_GAMEEND_ERROR		109

#define CMD_DLL_NOTIFY_RESUME_GAME			110

#define CMD_DLL_NOTIFY_SERVERMODE           (111)   
#define CMD_PAY_BALANCE_TO_RIVAL            (112)   //支付雷豆给对方, 悔棋道具会用到该命令

#define CMD_BALANCE_NOT_ENOUGH              (113)

#define CMD_NOTIFY_RETRACT_MODE             (114)  // 通知悔棋模式， 通过道具悔还是普通悔，单独定义一个为了兼容老的客户端


#define CMD_NOTIFY_RETRACTBYTOOL_SUCCESS	(115)

#define CMD_NOTIFY_LEIDOU_STAT				(116)

#define CMD_NOTIFY_SHOULD_DRAW				(117)

#define CMD_NOTIFY_GAMEEND_TIME				(118)

#define CMD_NOTIFY_BALANCE_LIMIT_INFO		(119)

#define CMD_NOTIFY_KICKOUT_COUNTDOWN		(120)

#define PROTOCOL_VERTION 0x1

#define REQUEST			0
#define ANSWER_YES		1
#define ANSWER_YES_2	2
#define ANSWER_NO		-1

#define RETRACT_NOMAL  (0x01)
#define RETRACT_BYTOOL (0x02)


struct UserInformRequest
{
	unsigned char cType;//无论什么协议，第一个字节都是二级命令字
	long iData;
};

struct UserInformRequestEx
{
	unsigned char cType;//无论什么协议，第一个字节都是二级命令字
	long iData;
	long iDataEx;
};

struct UserMoveChessRequest
{
	unsigned char cType;//无论什么协议，第一个字节都是二级命令字
	char side;
	char fromx;
	char fromy;
	char tox;
	char toy;
	char bCheck;
	long nLeftTime;
};

struct ChessPoint
{
	char x;
	char y;
	bool operator==(const ChessPoint &rhs)
	{
		return x == rhs.x && y == rhs.y;
	}
};

struct ChessStep
{
	char	_man;				// 这一步所走动的棋子
	char	_eaten;				// 移动这一步后被吃掉的棋子，-1：没有吃字；否则是被吃的子
	char	_RoundSide;			// 是哪一方的移动 A Side 或 B Side
	char	_check;				// 移动后是否形成将军，与tRoundState组合而成
	ChessPoint	_SourcePos;		// 原来的位置
	ChessPoint	_DestPos;		// 移动后的位置

	bool operator==(const ChessStep &rhs)
	{
//		return _man == rhs._man && _SourcePos == rhs._SourcePos && _DestPos == rhs._DestPos;
		return _man == rhs._man && _DestPos == rhs._DestPos;
	}
	bool operator!=(const ChessStep &rhs)
	{
		return !(*this == rhs);
	}
};

// 客户端重启所需的游戏数据
struct ResumeGameData
{
	unsigned char cType;
	unsigned char nRedChair;	// 游戏相关数据
	unsigned char nGameStatus;
	unsigned char nTurnChair;
	unsigned char nCurReqCode;
	unsigned char nReqChair;
	long nTimeCount;			// 游戏请求的数据，计时
	long nRoundTime;
	long nStepTime;
	long nStepTimeLimit;
	long nCurStepTimeElapsed;
	long nLeftRoundTime[2];
	unsigned char nReqDrawCount[2];
	unsigned char nReqRetractCount[2];
	char nPiecePosArr[32*2];	// 象棋的纯逻辑数据
	long nStepCount;
	ChessStep *ChessStepArr; // 指向后面的缓冲区
};

struct BalanceStat
{
    unsigned char cType;
    long endCode;
    long winLeiDou;
    long loseLeiDou;
    long winChair;
	long svrTake;
};

struct GameEndTime
{
    unsigned char cType;
 /* long year;
    unsigned char mon;
    unsigned char day;
    unsigned char hour;
    unsigned char min;*/
    unsigned long sec;
};

struct SvrConfigInfo
{
	unsigned char cType;
	unsigned char cProtectorMode;
	char cBalanceType;
	int iNotifyBalance;
};

struct KickoutUnreadyInfo
{
	unsigned char cType;
	int iReason;
	int iShowNotify;
	int iCountdown_0;
	int iCountdown_1;
};

#pragma pack( pop )


#endif