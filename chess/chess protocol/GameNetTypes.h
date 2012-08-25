
#ifndef __GAME_NET_TYPES_H_20090221_33
#define __GAME_NET_TYPES_H_20090221_33

#include <string>
#include <vector>
#include "common.h"

typedef __int64 XLUSERID;

#pragma pack(push)
#pragma pack(1)

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

// 游戏桌
typedef struct tagGAMETABLE
{
	unsigned short GameID;
	unsigned short ZoneID;
	unsigned short RoomID;
	unsigned short TableID;
}GAMETABLE;

// 座位
typedef struct tagGAMESEAT
{
	unsigned short GameID;
	unsigned short ZoneID;
	unsigned short RoomID;
	unsigned short TableID;
	unsigned short SeatID;
}GAMESEAT;

// hhj+ 上3个结构的联合
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
    long Score;  // 积分
    std::string RankName; // 等级称号

    std::vector<XLMAGICTOOL> vecMagicTool; // 道具列表
};

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



// 用户基本信息
typedef struct tagXLUSERINFO
{
	std::string Username; // 账号
	std::string Nickname; // 昵称
	short ImageIndex;  // 头像编号
	bool IsVIPUser; // 是否VIP用户
}XLUSERINFO;

// 用户基本信息
struct XLUSERINFOEX : public XLUSERINFO
{
	byte IsMale;  // 用户性别,是否为男性
    long Score;  // 积分
    std::string RankName; // 等级称号
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


typedef struct tagXLPLAYERINFO
{
	XLUSERID UserID;
	XLUSERINFO UserBasicInfo;
	std::string UserIP; // 用户外网ID
	unsigned short TableID; 
	unsigned char SeatID;
	unsigned char UserStatus; // 状态,参见USER_STATUS各常量
	unsigned char Level; // 级别
	int	Points; // 积分
	int WinNum; // 胜局数
	int LoseNum; // 输局数
	int EqualNum; // 平局数
	int EscapeNum; // 逃跑局数
	int OrgID;  // 所属帮派
	int OrgPos;  // 帮派地位
	int DropNum; // 累计掉线次数
	std::string LevelName; // 级别名称
	bool IsMale; // 性别
}XLPLAYERINFO;

struct XLPLAYERINFOEX : public XLPLAYERINFO
{
    long Score;  // 积分
    std::string RankName; // 等级称号
};

#if 0
struct XLUSERREC
{
	XLUSERREC() : Username(NULL), Nickname(NULL), ImageIndex(0), IsVIPUser(VARIANT_FALSE) { }
	~XLUSERREC() 
	{
		if(Username)
			::SysFreeString(Username);
		if(Nickname)
			::SysFreeString(Nickname);
	}

	BSTR Username;
	BSTR Nickname;
	short ImageIndex;
	VARIANT_BOOL IsVIPUser;
} ;

struct XLPLAYERREC
{
	XLPLAYERREC() : UserIP(NULL), LevelName(NULL), RankName(NULL), UserID(0), TableID((uint16_t)-1), SeatID((BYTE)-1), UserStatus(0), Score(0) { }
	~XLPLAYERREC() 
	{
		if(UserIP)
			::SysFreeString(UserIP);
		if(LevelName)
			::SysFreeString(LevelName);
        if(RankName)
            ::SysFreeString(RankName);
	}

	LONGLONG UserID;
	struct XLUSERREC UserRec;
	BSTR UserIP;
	uint16_t TableID;
	BYTE SeatID;
	BYTE UserStatus;
	BYTE Level;
	LONG Points;
	LONG WinNum;
	LONG LoseNum;
	LONG EqualNum;
	LONG EscapeNum;
	LONG OrgID;
	LONG OrgPos;
	BSTR LevelName;  // added by luohj (20090506)
	VARIANT_BOOL IsMale; // added by luohj (20090506)
    LONG Score;
    BSTR RankName;
} ;
#endif

enum SIMPLE_RESP_CMD_ID{
	RESP_ID_READY_RESP = 205, // 开始
	RESP_ID_QUITGAME_RESP = 207, // 退出游戏（桌子）
	RESP_ID_EXITROOM_RESP = 209, // 退出房间
	RESP_ID_SUBMIT_ACTION_RESP = 211  // 提交游戏动作
};

enum PLAYER_STATUS_ACTION_ENUM
{
	PLAYER_IS_READY = 3,  // 准备好
	PLAYER_EXIT_TABLE = 5, // 退出游戏（桌子）
	PLAYER_EXIT_ROOM = 6, // 退出房间
	PLAYER_DROPOUT = 7, // 掉线
	PLAYER_DROP_RESUME = 8,  // 掉线恢复
	PLAYER_DROP_TIMEOUT = 10 // 掉线超时
};

enum KICKOUT_REASON_ENUM
{
	KICKOUT_BY_TABLE_OWNER = 1, // 被桌主踢
	KICKOUT_BY_VIP = 2, // 被VIP会员踢
	KICKOUT_BY_ADMIN = 3, // 被管理员踢
	KICKOUT_MULTI_LOGIN = 10,  // 重复登录
    KICKOUT_BY_ESC_NUM = 15, // 逃跑次数太多
	KICKOUT_OFFLINE_TIMEOUT = 103, // 离线超时
    KICKOUT_DZ_SPECIAL = 104, // 德州元宝不足
    KICKOUT_GAME_ALREADY_START = 105, // 游戏已经开始
    KICKOUT_GAME_ALREADY_END = 200, // 游戏已经结束
    KICKOUT_DROP = 201, // 断线游戏已经结束
    KICKOUT_SCORE_LIMIT = 106,
};

enum CMD_SOURCE_ID
{
	CMD_FROM_GAMEHALL = 0
};

enum USER_STATUS_CHANGE_ACTION
{
	ENTER_TABLE_PLAY = 1, // 正常坐下
	ENTER_TABLE_LOOKON = 2, // 坐下旁观
	USER_READY = 3, // 点了“开始”
	GAME_START = 4, // 游戏开始
	EXIT_TABLE = 5, // 退出游戏（游戏桌）
	EXIT_ROOM = 6, // 退出房间
	USER_DROPOUT = 7,  // 掉线
	USER_DROP_RESUME = 8, // 掉线恢复
	GAME_END = 9, // 游戏一局结束
	USER_DROP_TIMEOUT = 10 // 掉线超时
};

#define NET_ERROR_TIMEOUT	110080  // 网络超时错误

#endif // #ifndef __GAME_NET_TYPES_H_20090221_33
