#ifndef _CNCHESS_DEFINE_H_
#define _CNCHESS_DEFINE_H_

/************************************************************************/
/*  常量声明                                                            */
/************************************************************************/
//extern const VARIANT VARIANT_EMPTY;
//extern const VARIANT VARIANT_OPTIONAL;


/************************************************************************/
/*  宏                                                                  */
/************************************************************************/

// 定时器: 倒计时
#define TIMER_COUNTDOWN				1
#define INTERVAL_COUNTDOWN			1000
#define TIMEOUT_COUNT				(15 * 60)			// 超时阈值

#define CNCHESS_COMMON_MSG_TITLE	@"YSH游戏提醒您"

/************************************************************************/
/*  枚举                                                                */
/************************************************************************/

// 玩家状态
enum PLAYERSTATE
{
	PLAYER_UNKNOWN	= -1,			// 未知状态
	PLAYER_ENTERED	= 0,			// 已进入游戏，但未点开始按钮
	PLAYER_READY	   ,			// 已点开始按钮，但游戏还未开始
	PLAYER_PLAYING	   ,			// 正在下棋
	PLAYER_WAITING					// 在等待对手下棋或等待服务器响应
};

// 角色类型, 主要用于对外抛出事件
enum ROLETYPE
{
	ROLE_UNKNOWN	= -1,			// 未知, 如还未决出谁胜利时, 胜利者为ROLE_UNKNOWN
	ROLE_NONE		= 0,			// 无, 比如出现平局时, 胜利者为ROLE_NONE
	ROLE_ME			   ,			// 我
	ROLE_RIVAL		   ,			// 对手
	ROLE_STANDERBY					// 旁观者，与UserId组合来标识具体哪个旁观者
};

// 游戏的状态
enum GAMESTATE
{
	GAME_UNKNOWN	= -1,			// 未知
	GAME_WAITING	= 0,			// 等待开始, ->SETTING
	GAME_SETTING	   ,			// 设置时间, ->STARTED
	GAME_STARTED	   ,			// 游戏进行中, ->REQUEST, or OVER
	GAME_REQUEST	   ,			// 游戏请求, ->STARTED, or OVER
	GAME_OVER		   ,			// 游戏结束, ->WAITING
	GAME_EXIT						// 游戏正在退出
};

enum GAME_USER_STATUS
{
	STANDUP = 0, // 站立
	SITDOWN = 1, // 坐下
	GAMEREADY = 2, // 点了"开始"
	IS_PLAYING = 3, // 正在玩
	OFFLINE = 4, // 断线
	LOOKON = 5, // 旁观
	ROBOT = 6	// 机器人
};

#ifdef WIN32
#include "atltypes.h"
#else
struct CPoint
{
	long x;
	long y;
};
#endif

struct TimeStruct {
	int nRoundTime;
	int nStepAddedTime;
	int nStepTimeLimit;
};

// 转换自身为net、host字节序
//#define  CONVERT_SELF_TO_NET_BYTE_ORDER(x) (x) = htonl(x)
//#define  CONVERT_SELF_TO_HOST_BYTE_ORDER(x) (x) = ntohl(x)

#define RETRACT_PAY_BALANCE_COUNT  (1000)

#endif // _CNCHESS_DEFINE_H_
