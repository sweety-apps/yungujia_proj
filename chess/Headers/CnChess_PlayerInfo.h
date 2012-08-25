﻿#pragma once

#ifndef _CNCHESS_PLAYER_INFO_H_091113_
#define _CNCHESS_PLAYER_INFO_H_091113_

//#include "DataX.h"
//#include "DataID.h"
//#include "GameNetUtil.h"
//#include "GameNetTypes.h"
//#include "GNInterface.h"
//#include "DxNetWrapper.h"
#include <string>
//#include "SDLogger.h"

#include "common.h"
#include "CnChess_define.h"

typedef __int64 XLUSERID;

class IDataXNet
{

};

// 用户基本信息
typedef struct tagXLUSERINFO
{
	std::string Username; // 账号
	std::string Nickname; // 昵称
	short ImageIndex;  // 头像编号
	bool IsVIPUser; // 是否VIP用户
}XLUSERINFO;

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

struct PlayerInfoExt : public XLPLAYERINFOEX
{
public:
	int nBalance;

	std::string strAreaName;
	std::string strCityName;
	int nGlobalRank;
	int nGlobalRankChg;
	int nAreaRank;
	int nAreaRankChg;
	int nCityRank;
	int nCityRankChg;

	int nPingCap;
	
	XLUSERID UserID;
	unsigned short SeatID;
	GAME_USER_STATUS UserStatus;
	unsigned short TableID;
	std::string LevelName;
	/*PlayerInfoExt(){}
	PlayerInfoExt(XLPLAYERINFOEX &info)
	{
		this->Score = info.Score;  // —∏¿◊ª˝∑÷
		this->RankName = info.RankName; // µ»º∂≥∆∫≈
		this->UserID = info.UserID;
		this->UserBasicInfo = info.UserBasicInfo;
		this->UserIP = info.UserIP; // ”√ªßÕ‚Õ¯ID
		this->TableID = info.TableID; 
		this->SeatID = info.SeatID;
		this->UserStatus = info.UserStatus; // ◊¥Ã¨,≤Œº˚USER_STATUS∏˜≥£¡ø
		this->Level = info.Level; // º∂±
		this->Points = info.Points; // ª˝∑÷
		this->WinNum = info.WinNum; //  §æ÷ ˝
		this->LoseNum = info.LoseNum; //  ‰æ÷ ˝
		this->EqualNum = info.EqualNum; // ∆Ωæ÷ ˝
		this->EscapeNum = info.EscapeNum; // Ã”≈‹æ÷ ˝
		this->OrgID = info.OrgID;  // À˘ Ù∞Ô≈…
		this->OrgPos = info.OrgPos;  // ∞Ô≈…µÿŒª
		this->DropNum = info.DropNum; // ¿€º∆µÙœﬂ¥Œ ˝
		this->LevelName = info.LevelName; // º∂±√˚≥∆
		this->IsMale = info.IsMale; // –‘±
	}*/
};

void InitPlayerInfoExt_From_XLPLAYERINFOEX(PlayerInfoExt &dest, XLPLAYERINFOEX &info);

void DataXNet2PlayerInfoExt(IDataXNet* pDataXNet, PlayerInfoExt& playerInfo);

//void DataXNet2XLGameScoreExt(IDataXNet* pDataXNet, XLGAMESCOREEXT& gameScoreExt);
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
#endif
