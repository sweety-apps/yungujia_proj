//#include "stdafx.h"
#include "CnChess_PlayerInfo.h"
//#include "DataStructSwitcher.h"

//void DataXNet2PlayerInfoExt(IDataXNet* pDataXNet, PlayerInfoExt& playerInfo)
//{
//	DataXNet2PlayerInfoEx(pDataXNet, playerInfo);
//	DxNetWrapper wrapper(pDataXNet);
//	//
//	playerInfo.nBalance = wrapper.GetInt(DataID_Balance);
//
//	playerInfo.strAreaName = wrapper.GetUTF8String(DataID_AreaName);
//	playerInfo.strCityName = wrapper.GetUTF8String(DataID_CityName);
//
//	playerInfo.nGlobalRank = wrapper.GetInt(DataID_GlobalRank);
//	playerInfo.nGlobalRankChg = wrapper.GetInt(DataID_GlobalRankChg);
//	playerInfo.nAreaRank = wrapper.GetInt(DataID_AreaRank);
//	playerInfo.nAreaRankChg = wrapper.GetInt(DataID_AreaRankChg);
//	playerInfo.nCityRank = wrapper.GetInt(DataID_CityRank);
//	playerInfo.nCityRankChg = wrapper.GetInt(DataID_CityRankChg);
//
//	playerInfo.nPingCap = wrapper.GetInt(DataID_PingGap);
//}

void InitPlayerInfoExt_From_XLPLAYERINFOEX(PlayerInfoExt &dest, XLPLAYERINFOEX &info)
{
	dest.Score = info.Score;  // —∏¿◊ª˝∑÷
	dest.RankName = info.RankName; // µ»º∂≥∆∫≈
	dest.UserID = info.UserID;
	dest.UserBasicInfo = info.UserBasicInfo;
	dest.UserIP = info.UserIP; // ”√ªßÕ‚Õ¯ID
	dest.TableID = info.TableID; 
	dest.SeatID = info.SeatID;
	dest.UserStatus = (GAME_USER_STATUS)info.UserStatus; // ◊¥Ã¨,≤Œº˚USER_STATUS∏˜≥£¡ø
	dest.Level = info.Level; // º∂±
	dest.Points = info.Points; // ª˝∑÷
	dest.WinNum = info.WinNum; //  §æ÷ ˝
	dest.LoseNum = info.LoseNum; //  ‰æ÷ ˝
	dest.EqualNum = info.EqualNum; // ∆Ωæ÷ ˝
	dest.EscapeNum = info.EscapeNum; // Ã”≈‹æ÷ ˝
	dest.OrgID = info.OrgID;  // À˘ Ù∞Ô≈…
	dest.OrgPos = info.OrgPos;  // ∞Ô≈…µÿŒª
	dest.DropNum = info.DropNum; // ¿€º∆µÙœﬂ¥Œ ˝
	dest.LevelName = info.LevelName; // º∂±√˚≥∆
	dest.IsMale = info.IsMale; // –‘±
}

/*
PDataX& PlayerInfoExt2DataX(const PlayerInfoExt& playerInfo, PDataX &data)
{
	XLPlayerInfo2DataXEx(playerInfo, data.p);
	//
	data[DataID_Balance] = playerInfo.nBalance;

	data[DataID_AreaName] = CComBSTR(CA2W(playerInfo.strAreaName.c_str(), 936));
	data[DataID_CityName] = CComBSTR(CA2W(playerInfo.strCityName.c_str(), 936));

	data[DataID_GlobalRank] = playerInfo.nGlobalRank;
	data[DataID_GlobalRankChg] = playerInfo.nGlobalRankChg;
	data[DataID_AreaRank] = playerInfo.nAreaRank;
	data[DataID_AreaRankChg] = playerInfo.nAreaRankChg;
	data[DataID_CityRank] = playerInfo.nCityRank;
	data[DataID_CityRankChg] = playerInfo.nCityRankChg;

	data[DataID_PingGap] = playerInfo.nPingCap;

	return data;
}*/

//void DataXNet2XLGameScoreExt(IDataXNet* pDataXNet, XLGAMESCOREEXT& gameScoreExt)
//{
//    if(pDataXNet == NULL)
//    {
//        return;
//    }
//	
//    DxNetWrapper wrapper(pDataXNet);
//    gameScoreExt.UserID = wrapper.GetInt64(DataID_UserID);
//    gameScoreExt.Level = (unsigned char)wrapper.GetShort(DataID_UserLevel);
//	
//    char szLevelName[256] = { 0 };
//    int nBufferLen = sizeof(szLevelName);
//    pDataXNet->GetBytes(DataID_LevelName, (byte*)szLevelName, nBufferLen);
//    gameScoreExt.LevelName = szLevelName;
//	
//    gameScoreExt.Points      = wrapper.GetInt(DataID_UserPoints);
//    gameScoreExt.WinNum      = wrapper.GetInt(DataID_UserWinNum);
//    gameScoreExt.LoseNum     = wrapper.GetInt(DataID_UserLoseNum);
//    gameScoreExt.EqualNum    = wrapper.GetInt(DataID_UserEqualNum);
//    gameScoreExt.EscapeNum   = wrapper.GetInt(DataID_UserEscapeNum);
//    gameScoreExt.DropNum     = wrapper.GetInt(DataID_UserDropNum);
//    gameScoreExt.PointsDelta = wrapper.GetInt(DataID_ChangeValue);
//	
//	//MagicToolListDataXNet2Vector(pDataXNet, gameScoreExt.vecMagicTool);
//}