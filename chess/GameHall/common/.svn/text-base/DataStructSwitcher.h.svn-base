#ifndef _DATA_STRUCT_SWITCHER_H_
#define _DATA_STRUCT_SWITCHER_H_

IMPL_LOGGER_GLOBAL(g_logger, "globle");

CComBSTR Int64ToBSTR(__int64 nTemp)
{
    WCHAR szTemp[128];

    swprintf(szTemp, L"%I64d", nTemp);

    return CComBSTR(szTemp);
}

__int64 VariantBstrToInt64(CComVariant& vSrc)
{
    if(vSrc.vt == VT_I4 || vSrc.vt == VT_UI4)
        return vSrc.lVal;
    else if(vSrc.vt == VT_I8 || vSrc.vt == VT_UI8)
        return vSrc.llVal;
    else if(vSrc.vt == VT_BSTR)
    {
        return _wtoi64(vSrc.bstrVal);
    }
    else
    {
        return 0;
    }
}

void XLPlayerInfo2DataX(const XLPLAYERINFO& playerInfo, IDispatchEx* pDx)
{
    if(pDx == NULL)
        return;

    PDataX dx(pDx);

    dx[DataID_UserID] = Int64ToBSTR(playerInfo.UserID);
    dx[DataID_Username] = CComBSTR(CA2W(playerInfo.UserBasicInfo.Username.c_str(), 936));
    dx[DataID_Nickname] = CComBSTR(CA2W(playerInfo.UserBasicInfo.Nickname.c_str(), 936));
    dx[DataID_ImageIndex] = playerInfo.UserBasicInfo.ImageIndex;
    dx[DataID_UserIsVip] = playerInfo.UserBasicInfo.IsVIPUser;
    dx[DataID_UserIP] = playerInfo.UserIP.c_str();
    dx[DataID_TableID] = playerInfo.TableID;
    dx[DataID_SeatID] = playerInfo.SeatID;
    dx[DataID_UserStatus] = playerInfo.UserStatus;
    dx[DataID_UserLevel] = playerInfo.Level;
    dx[DataID_UserPoints] = playerInfo.Points;
    dx[DataID_UserWinNum] = playerInfo.WinNum;
    dx[DataID_UserLoseNum] = playerInfo.LoseNum;
    dx[DataID_UserEqualNum] = playerInfo.EqualNum;
    dx[DataID_UserEscapeNum] = playerInfo.EscapeNum;
    dx[DataID_UserOrgID] = playerInfo.OrgID;
    dx[DataID_UserOrgPos] = playerInfo.OrgPos;
    dx[DataID_UserDropNum] = playerInfo.DropNum;
    //	LOG4CPLUS_INFO(_g_logger, "playerInfo.LevelName=" << playerInfo.LevelName.c_str());
    dx[DataID_LevelName] = playerInfo.LevelName.c_str();
    dx[DataID_UserIsMale] = playerInfo.IsMale;
}

void XLPlayerInfo2DataXEx(const XLPLAYERINFOEX& playerInfo, IDispatchEx* pDx)
{
    XLPlayerInfo2DataX(playerInfo, pDx);
    PDataX dx(pDx);
    //
    dx[DataID_UserScore] = playerInfo.Score;
    dx[DataID_UserRankName] = CComBSTR(CA2W(playerInfo.RankName.c_str(), 936));
}

void DataXNet2PlayerInfo(IDataXNet* pDataXNet, XLPLAYERINFO& playerInfo)
{
    if(pDataXNet == NULL || pDataXNet == NULL)
        return;

    DxNetWrapper wrapper(pDataXNet);

    playerInfo.UserID                      = wrapper.GetInt64(DataID_UserID);
    playerInfo.UserBasicInfo.Username      = wrapper.GetUTF8String(DataID_Username);
    playerInfo.UserBasicInfo.Nickname      = wrapper.GetUTF8String(DataID_Nickname);
    playerInfo.UserBasicInfo.ImageIndex    = wrapper.GetShort(DataID_ImageIndex);
    playerInfo.UserBasicInfo.IsVIPUser     = (wrapper.GetShort(DataID_UserIsVip) ? true : false);
    //playerInfo.UserIP                    = inet_ntoa(wrapper.GetInt(DataID_UserIP);
    playerInfo.TableID                     = wrapper.GetShort(DataID_TableID);
    playerInfo.SeatID                      = (unsigned char)wrapper.GetShort(DataID_SeatID);   
    playerInfo.UserStatus                  = (unsigned char)wrapper.GetShort(DataID_UserStatus);
    playerInfo.Level     = (unsigned char)wrapper.GetShort(DataID_UserLevel);    
    playerInfo.Points    = wrapper.GetInt(DataID_UserPoints);   
    playerInfo.WinNum    = wrapper.GetInt(DataID_UserWinNum);  
    playerInfo.LoseNum   = wrapper.GetInt(DataID_UserLoseNum);   
    playerInfo.EqualNum  = wrapper.GetInt(DataID_UserEqualNum); 
    playerInfo.EscapeNum = wrapper.GetInt(DataID_UserEscapeNum);
    playerInfo.OrgID     = wrapper.GetInt(DataID_UserOrgID); 
    playerInfo.OrgPos    = wrapper.GetInt(DataID_UserOrgPos);
    playerInfo.DropNum   = wrapper.GetInt(DataID_UserDropNum);
    playerInfo.IsMale    = (wrapper.GetShort(DataID_UserIsMale) ? true : false);

    char szLevelName[256] = { 0 };
    int nBufferLen = sizeof(szLevelName);
    pDataXNet->GetBytes(DataID_LevelName, (byte*)szLevelName, nBufferLen);
    playerInfo.LevelName     = szLevelName;
}

void DataXNet2PlayerInfoEx(IDataXNet* pDataXNet, XLPLAYERINFOEX& playerInfo)
{
    DataXNet2PlayerInfo(pDataXNet, playerInfo);
    DxNetWrapper wrapper(pDataXNet);
    //
    playerInfo.Score = wrapper.GetInt(DataID_UserScore);
    playerInfo.RankName = wrapper.GetUTF8String(DataID_UserRankName);

}

void PlayerInfoDataXNet2DataX(IDataXNet* pDataXNet, IDispatchEx* pDx)
{
    if(pDx == NULL || pDataXNet == NULL)
        return;

    PDataX dx(pDx);
    DxNetWrapper wrapper(pDataXNet);

    dx[DataID_UserID]        = Int64ToBSTR(wrapper.GetInt64(DataID_UserID));
    dx[DataID_Username]      = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_Username).c_str(), 936));
    dx[DataID_Nickname]      = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_Nickname).c_str(), 936));
    dx[DataID_ImageIndex]    = wrapper.GetShort(DataID_ImageIndex);
    dx[DataID_UserIsVip]     = wrapper.GetShort(DataID_UserIsVip);
    dx[DataID_UserIP]        = wrapper.GetInt(DataID_UserIP);
    dx[DataID_TableID]       = wrapper.GetShort(DataID_TableID);
    dx[DataID_SeatID]        = wrapper.GetShort(DataID_SeatID);   
    dx[DataID_UserStatus]    = wrapper.GetShort(DataID_UserStatus);
    dx[DataID_UserLevel]     = wrapper.GetShort(DataID_UserLevel);    
    dx[DataID_UserPoints]    = wrapper.GetInt(DataID_UserPoints);   
    dx[DataID_UserWinNum]    = wrapper.GetInt(DataID_UserWinNum);  
    dx[DataID_UserLoseNum]   = wrapper.GetInt(DataID_UserLoseNum);   
    dx[DataID_UserEqualNum]  = wrapper.GetInt(DataID_UserEqualNum); 
    dx[DataID_UserEscapeNum] = wrapper.GetInt(DataID_UserEscapeNum);
    dx[DataID_UserOrgID]     = wrapper.GetInt(DataID_UserOrgID); 
    dx[DataID_UserOrgPos]    = wrapper.GetInt(DataID_UserOrgPos);
    dx[DataID_UserDropNum]   = wrapper.GetInt(DataID_UserDropNum);
    dx[DataID_UserIsMale]    = wrapper.GetShort(DataID_UserIsMale);
    dx[DataID_PingGap]       = wrapper.GetInt(DataID_PingGap, 1000);
    
    char szLevelName[256] = { 0 };
    int nBufferLen = sizeof(szLevelName);
    pDataXNet->GetBytes(DataID_LevelName, (byte*)szLevelName, nBufferLen);
    dx[DataID_LevelName]     = CComBSTR(CA2W(szLevelName, 936));

    dx[DataID_UserScore] = wrapper.GetInt(DataID_UserScore);
    dx[DataID_UserRankName]  = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_UserRankName).c_str(), 936));

    dx[DataID_Balance]  = wrapper.GetInt(DataID_Balance);
//	dx["Balance"]  = wrapper.GetInt(DataID_Balance);
    dx[DataID_AreaName] = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_AreaName).c_str(), 936));
    dx[DataID_CityName] = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_CityName).c_str(), 936));

	dx[DataID_GlobalRank]		= wrapper.GetInt(DataID_GlobalRank, -1);
	dx[DataID_GlobalRankChg]	= wrapper.GetInt(DataID_GlobalRankChg, -1);
	dx[DataID_AreaRank]			= wrapper.GetInt(DataID_AreaRank, -1);
	dx[DataID_AreaRankChg]		= wrapper.GetInt(DataID_AreaRankChg, -1);
	dx[DataID_CityRank]			= wrapper.GetInt(DataID_CityRank, -1);
	dx[DataID_CityRankChg]		= wrapper.GetInt(DataID_CityRankChg, -1);    

	LOG4CPLUS_DEBUG(g_logger, "PlayerInfoDataXNet2DataX(), DataID_UserID=" << dx[DataID_UserID]
			<<", DataID_Username=" << dx[DataID_Username]
			<<", DataID_Nickname=" << dx[DataID_Nickname]
			<<", DataID_ImageIndex=" << dx[DataID_ImageIndex]
			<<", DataID_UserIsVip=" << dx[DataID_UserIsVip]
			<<", DataID_UserIP=" << dx[DataID_UserIP]
			<<", DataID_TableID=" << dx[DataID_TableID]
			<<", DataID_SeatID=" << dx[DataID_SeatID]
			<<", DataID_UserStatus=" << dx[DataID_UserStatus]
			<<", DataID_UserLevel=" << dx[DataID_UserLevel]
			<<", DataID_LevelName=" << dx[DataID_LevelName]
			<<", DataID_UserScore=" << dx[DataID_UserScore]
			<<", DataID_UserRankName=" << dx[DataID_UserRankName]
			<<", DataID_Balance=" << dx[DataID_Balance]
			<<", DataID_PingGap=" << dx[DataID_PingGap]
			<<", DataID_AreaName=" << (BSTR)dx[DataID_AreaName]
			<<", DataID_CityName=" << (BSTR)dx[DataID_CityName]
			<<", DataID_GlobalRank=" << dx[DataID_GlobalRank]
			<<", DataID_GlobalRankChg=" << dx[DataID_GlobalRankChg]
			<<", DataID_AreaRank=" << dx[DataID_AreaRank]
			<<", DataID_AreaRankChg=" << dx[DataID_AreaRankChg]
			<<", DataID_CityRank=" << dx[DataID_CityRank]
			<<", DataID_CityRank=" << dx[DataID_CityRankChg]);
}

void PlayerInfoDataX2DataXNet(IDispatchEx* pDx, IDataXNet* pDataXNet)
{
	if(pDx == NULL || pDataXNet == NULL)
		return;

	PDataX dx(pDx);

	//dx[DataID_UserID]        = Int64ToBSTR(wrapper.GetInt64(DataID_UserID));
	//dx[DataID_Username]      = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_Username).c_str(), 936));
	//dx[DataID_Nickname]      = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_Nickname).c_str(), 936));
	//dx[DataID_ImageIndex]    = wrapper.GetShort(DataID_ImageIndex);
	//dx[DataID_UserIsVip]     = wrapper.GetShort(DataID_UserIsVip);
	//dx[DataID_UserIP]        = wrapper.GetInt(DataID_UserIP);
	//dx[DataID_TableID]       = wrapper.GetShort(DataID_TableID);
	//dx[DataID_SeatID]        = wrapper.GetShort(DataID_SeatID);   
	//dx[DataID_UserStatus]    = wrapper.GetShort(DataID_UserStatus);
	//dx[DataID_UserLevel]     = wrapper.GetShort(DataID_UserLevel);    
	//dx[DataID_UserPoints]    = wrapper.GetInt(DataID_UserPoints);   
	//dx[DataID_UserWinNum]    = wrapper.GetInt(DataID_UserWinNum);  
	//dx[DataID_UserLoseNum]   = wrapper.GetInt(DataID_UserLoseNum);   
	//dx[DataID_UserEqualNum]  = wrapper.GetInt(DataID_UserEqualNum); 
	//dx[DataID_UserEscapeNum] = wrapper.GetInt(DataID_UserEscapeNum);
	//dx[DataID_UserOrgID]     = wrapper.GetInt(DataID_UserOrgID); 
	//dx[DataID_UserOrgPos]    = wrapper.GetInt(DataID_UserOrgPos);
	//dx[DataID_UserDropNum]   = wrapper.GetInt(DataID_UserDropNum);
	//dx[DataID_UserIsMale]    = wrapper.GetShort(DataID_UserIsMale);

	//char szLevelName[256] = { 0 };
	//int nBufferLen = sizeof(szLevelName);
	//pDataXNet->GetBytes(DataID_LevelName, (byte*)szLevelName, nBufferLen);
	//dx[DataID_LevelName]     = CComBSTR(CA2W(szLevelName, 936));

	//dx[DataID_UserScore] = wrapper.GetInt(DataID_UserScore);
	//dx[DataID_UserRankName]  = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_UserRankName).c_str(), 936));

	pDataXNet->PutInt(DataID_Balance, (int)dx[DataID_Balance]);

	string strTmp;
	strTmp = CW2A((BSTR)dx[DataID_AreaName], 936);
	pDataXNet->PutUTF8String(DataID_AreaName, (const byte*)strTmp.c_str(), (int)strTmp.length()+1);
	strTmp = CW2A((BSTR)dx[DataID_CityName], 936);
	pDataXNet->PutUTF8String(DataID_CityName, (const byte*)strTmp.c_str(), (int)strTmp.length()+1);

	pDataXNet->PutInt(DataID_GlobalRank, (int)dx[DataID_GlobalRank]);
	pDataXNet->PutInt(DataID_GlobalRankChg, (int)dx[DataID_GlobalRankChg]);
	pDataXNet->PutInt(DataID_AreaRank, (int)dx[DataID_AreaRank]);
	pDataXNet->PutInt(DataID_AreaRankChg, (int)dx[DataID_AreaRankChg]);
	pDataXNet->PutInt(DataID_CityRank, (int)dx[DataID_CityRank]);
	pDataXNet->PutInt(DataID_CityRankChg, (int)dx[DataID_CityRankChg]);
    pDataXNet->PutInt(DataID_PingGap, (int)dx[DataID_PingGap]);

	LOG4CPLUS_DEBUG(g_logger, "PlayerInfoDataX2DataXNet(), DataID_UserID=" << dx[DataID_UserID]
		//<<", DataID_Username=" << dx[DataID_Username]
		//<<", DataID_Nickname=" << dx[DataID_Nickname]
		//<<", DataID_ImageIndex=" << dx[DataID_ImageIndex]
		//<<", DataID_UserIsVip=" << dx[DataID_UserIsVip]
		//<<", DataID_UserIP=" << dx[DataID_UserIP]
		//<<", DataID_TableID=" << dx[DataID_TableID]
		//<<", DataID_SeatID=" << dx[DataID_SeatID]
		//<<", DataID_UserLevel=" << dx[DataID_UserLevel]
		//<<", DataID_LevelName=" << dx[DataID_LevelName]
		//<<", DataID_UserScore=" << dx[DataID_UserScore]
		//<<", DataID_UserRankName=" << dx[DataID_UserRankName]
		<<", DataID_Balance=" << dx[DataID_Balance]
		<<", DataID_AreaName=" << (BSTR)dx[DataID_AreaName]
		<<", DataID_CityName=" << (BSTR)dx[DataID_CityName]
		<<", DataID_GlobalRank=" << dx[DataID_GlobalRank]
		<<", DataID_GlobalRankChg=" << dx[DataID_GlobalRankChg]
		<<", DataID_AreaRank=" << dx[DataID_AreaRank]
		<<", DataID_AreaRankChg=" << dx[DataID_AreaRankChg]
		<<", DataID_CityRank=" << dx[DataID_CityRank]
		<<", DataID_CityRank=" << dx[DataID_CityRankChg]);
}

void DataX2XLPlayerInfo(IDispatchEx* pDx,XLPLAYERINFO& playerInfo)
{
    if(pDx == NULL)
        return;

    PDataX dx(pDx);

    USES_CONVERSION;

    playerInfo.UserID = VariantBstrToInt64(dx[DataID_UserID]);
    playerInfo.UserBasicInfo.Username = OLE2A((BSTR)dx[DataID_Username]);
    playerInfo.UserBasicInfo.Nickname = OLE2A((BSTR)dx[DataID_Nickname]) ;
    playerInfo.UserBasicInfo.ImageIndex = (short)(dx[DataID_ImageIndex]) ;
    playerInfo.UserBasicInfo.IsVIPUser = (dx[DataID_UserIsVip] ? true : false);
    //playerInfo.UserIP= OLE2A((BSTR)dx[DataID_UserIP]);
    playerInfo.TableID = (unsigned short)dx[DataID_TableID] ;
    playerInfo.SeatID = (unsigned char)dx[DataID_SeatID] ;
    playerInfo.UserStatus = (unsigned char)dx[DataID_UserStatus] ;
    playerInfo.Level = (unsigned char)dx[DataID_UserLevel];
    playerInfo.Points = dx[DataID_UserPoints];
    playerInfo.WinNum = dx[DataID_UserWinNum] ;
    playerInfo.LoseNum = dx[DataID_UserLoseNum] ;
    playerInfo.EqualNum = dx[DataID_UserEqualNum] ;
    playerInfo.EscapeNum = dx[DataID_UserEscapeNum]; 
    playerInfo.OrgID = dx[DataID_UserOrgID];
    playerInfo.OrgPos = dx[DataID_UserOrgPos];
    playerInfo.DropNum = dx[DataID_UserDropNum];
    playerInfo.LevelName =  OLE2A((BSTR)dx[DataID_LevelName]);
    playerInfo.IsMale = (dx[DataID_UserIsMale] ? true : false);
}

void DataX2XLPlayerInfoEx(IDispatchEx* pDx,XLPLAYERINFOEX& playerInfo)
{
    if(pDx == NULL)
        return;

    PDataX dx(pDx);

    USES_CONVERSION;

    playerInfo.UserID = VariantBstrToInt64(dx[DataID_UserID]);
    playerInfo.UserBasicInfo.Username = OLE2A((BSTR)dx[DataID_Username]);
    playerInfo.UserBasicInfo.Nickname = OLE2A((BSTR)dx[DataID_Nickname]) ;
    playerInfo.UserBasicInfo.ImageIndex = (short)dx[DataID_ImageIndex] ;
    playerInfo.UserBasicInfo.IsVIPUser = (dx[DataID_UserIsVip] ? true : false);
    //playerInfo.UserIP= OLE2A((BSTR)dx[DataID_UserIP]);
    playerInfo.TableID = (unsigned short)dx[DataID_TableID] ;
    playerInfo.SeatID = (unsigned char)dx[DataID_SeatID] ;
    playerInfo.UserStatus = (unsigned char)dx[DataID_UserStatus] ;
    playerInfo.Level = (unsigned char)dx[DataID_UserLevel];
    playerInfo.Points = dx[DataID_UserPoints];
    playerInfo.WinNum = dx[DataID_UserWinNum] ;
    playerInfo.LoseNum = dx[DataID_UserLoseNum] ;
    playerInfo.EqualNum = dx[DataID_UserEqualNum] ;
    playerInfo.EscapeNum = dx[DataID_UserEscapeNum]; 
    playerInfo.OrgID = dx[DataID_UserOrgID];
    playerInfo.OrgPos = dx[DataID_UserOrgPos];
    playerInfo.DropNum = dx[DataID_UserDropNum];
    playerInfo.LevelName =  OLE2A((BSTR)dx[DataID_LevelName]);
    playerInfo.IsMale = (dx[DataID_UserIsMale] ? true : false);
    playerInfo.Score = dx[DataID_UserScore];
    playerInfo.RankName = OLE2A((BSTR)dx[DataID_UserRankName]);
}

void DataX2XLUserInfo(IDispatchEx* pDx,XLUSERINFOEX& userInfo)
{
    if(pDx == NULL)
    {
        return;
    }

    PDataX dx(pDx);

    USES_CONVERSION;

    userInfo.Username    = OLE2A((BSTR)dx[DataID_Username]);
    userInfo.Nickname    = OLE2A((BSTR)dx[DataID_Nickname]);
    userInfo.ImageIndex  = (short)dx[DataID_ImageIndex];
    userInfo.IsVIPUser   = (dx[DataID_UserIsVip] ? true : false);
    userInfo.IsMale      = (byte)(dx[DataID_UserIsMale]);
    userInfo.Score       = dx[DataID_UserScore];
    userInfo.RankName    = OLE2A((BSTR)dx[DataID_UserRankName]);
}

void UserInfoDataX2DataXNet(IDispatchEx* pDx, IDataXNet* pDataXNet, string& strPeerId, LPCTSTR szNickname)
{
    if(pDx == NULL || pDataXNet == NULL)
    {
        return;
    }
    
    PDataX dx(pDx);    

    string strTmp = CW2A((BSTR)dx[DataID_Username], 936);
    pDataXNet->PutUTF8String(DataID_Username, (byte*)strTmp.c_str(), (int)(strTmp.length() + 1));

    strTmp = CT2A(szNickname, 936);    
    pDataXNet->PutUTF8String(DataID_Nickname, (byte*)strTmp.c_str(), (int)(strTmp.length() + 1));

    pDataXNet->PutShort(DataID_ImageIndex, (short)dx[DataID_ImageIndex]);
    pDataXNet->PutShort(DataID_UserIsVip, (short)dx[DataID_UserIsVip]);
    pDataXNet->PutShort(DataID_UserIsMale, (short)dx[DataID_UserIsMale]);

    pDataXNet->PutBytes(DataID_PeerID, (byte*)strPeerId.c_str(), (int)strPeerId.length());

    pDataXNet->PutInt(DataID_UserScore, dx[DataID_UserScore]);    
    
    strTmp = CW2A((BSTR)dx[DataID_UserRankName], 936);    
    pDataXNet->PutUTF8String(DataID_UserRankName, (byte*)strTmp.c_str(), (int)(strTmp.length() + 1));

	if( (BSTR)dx[DataID_AreaName] == NULL)
	{
		dx[DataID_AreaName] = L"";
	}
    strTmp = CW2A((BSTR)dx[DataID_AreaName], 936);    
	pDataXNet->PutUTF8String(DataID_AreaName, (byte*)strTmp.c_str(), (int)(strTmp.length() + 1));

	if( (BSTR)dx[DataID_CityName] == NULL)
	{
		dx[DataID_CityName] = L"";
	}
    strTmp = CW2A((BSTR)dx[DataID_CityName], 936);    
    pDataXNet->PutUTF8String(DataID_CityName, (byte*)strTmp.c_str(), (int)(strTmp.length() + 1));

    pDataXNet->PutInt(DataID_PingGap, dx[DataID_PingGap]);
}

void MagicToolListDataXNet2Vector(IDataXNet* pDataXNet, std::vector<XLMAGICTOOL> &vecMagicTool)
{
	vecMagicTool.clear();
	int nToolNum = 0;
	bool bRet = pDataXNet->GetDataXArraySize(DataID_MagicToolIDList, nToolNum);

	if(bRet)
	{
		vecMagicTool.reserve( nToolNum);
		for(int i = 0; i < nToolNum; ++i)
		{
			IDataXNet *pDataXTool = NULL;
			bRet = pDataXNet->GetDataXArrayElement(DataID_MagicToolIDList, i, &pDataXTool);

			DxNetWrapper toolWrapper(pDataXTool);
			XLMAGICTOOL item;
			item.ToolClassID = toolWrapper.GetShort(DataID_ToolClassID, -1);
			item.ToolBatchID = toolWrapper.GetInt(DataID_ToolBatchID, -1);
			item.UsedTime = toolWrapper.GetInt(DataID_UsedTime);
			item.Duration = toolWrapper.GetInt(DataID_Duration);

			vecMagicTool.push_back(item);
		}
	}
}

void MagicToolListDataXNet2DataX(IDataXNet* pDataXNet, IDispatchEx* pDx)
{
	PDataX dx(pDx);
	dx.Clear();
	int nToolNum = 0;
	dx[DataID_Amount] = 0;
	bool bRet = pDataXNet->GetDataXArraySize(DataID_MagicToolIDList, nToolNum);

	if(bRet)
	{
		dx[DataID_Amount] = nToolNum;
		for(int i = 0; i < nToolNum; ++i)
		{
			IDataXNet *pDataXTool = NULL;
			bRet = pDataXNet->GetDataXArrayElement(DataID_MagicToolIDList, i, &pDataXTool);

			DxNetWrapper toolWrapper(pDataXTool);
			PDataX e = PDataX::CreateInstance();
			e[DataID_ToolClassID] = toolWrapper.GetShort(DataID_ToolClassID, -1);
			e[DataID_ToolBatchID] = toolWrapper.GetInt(DataID_ToolBatchID, -1);
			e[DataID_UsedTime] = toolWrapper.GetInt(DataID_UsedTime);
			e[DataID_Duration] = toolWrapper.GetInt(DataID_Duration);

			dx[i] = e;
		}
	}
}

void DataXNet2XLGameScoreExt(IDataXNet* pDataXNet, XLGAMESCOREEXT& gameScoreExt)
{
    if(pDataXNet == NULL)
    {
        return;
    }

    DxNetWrapper wrapper(pDataXNet);
    gameScoreExt.UserID = wrapper.GetInt64(DataID_UserID);
    gameScoreExt.Level = (unsigned char)wrapper.GetShort(DataID_UserLevel);

    char szLevelName[256] = { 0 };
    int nBufferLen = sizeof(szLevelName);
    pDataXNet->GetBytes(DataID_LevelName, (byte*)szLevelName, nBufferLen);
    gameScoreExt.LevelName = szLevelName;

    gameScoreExt.Points      = wrapper.GetInt(DataID_UserPoints);
    gameScoreExt.WinNum      = wrapper.GetInt(DataID_UserWinNum);
    gameScoreExt.LoseNum     = wrapper.GetInt(DataID_UserLoseNum);
    gameScoreExt.EqualNum    = wrapper.GetInt(DataID_UserEqualNum);
    gameScoreExt.EscapeNum   = wrapper.GetInt(DataID_UserEscapeNum);
    gameScoreExt.DropNum     = wrapper.GetInt(DataID_UserDropNum);
    gameScoreExt.PointsDelta = wrapper.GetInt(DataID_ChangeValue);

	MagicToolListDataXNet2Vector(pDataXNet, gameScoreExt.vecMagicTool);
}

void XLGameScoreExtDataXNet2DataX(IDataXNet* pDataXNet, IDispatchEx* pDx)
{
    if(pDataXNet == NULL || pDx == NULL)
    {
        return;
    }

    PDataX dx(pDx);
    DxNetWrapper wrapper(pDataXNet);

    dx[DataID_UserID] = Int64ToBSTR(wrapper.GetInt64(DataID_UserID));
    dx[DataID_UserLevel] = wrapper.GetShort(DataID_UserLevel);

    char szLevelName[256] = { 0 };
    int nBufferLen = sizeof(szLevelName);
    pDataXNet->GetBytes(DataID_LevelName, (byte*)szLevelName, nBufferLen);
    dx[DataID_LevelName] = CComBSTR(CA2W(szLevelName, 936));

    dx[DataID_UserPoints]      = wrapper.GetInt(DataID_UserPoints);
    dx[DataID_UserWinNum]      = wrapper.GetInt(DataID_UserWinNum);
    dx[DataID_UserLoseNum]     = wrapper.GetInt(DataID_UserLoseNum);
    dx[DataID_UserEqualNum]    = wrapper.GetInt(DataID_UserEqualNum);
    dx[DataID_UserEscapeNum]   = wrapper.GetInt(DataID_UserEscapeNum);
    dx[DataID_UserDropNum]     = wrapper.GetInt(DataID_UserDropNum);
    dx[DataID_ChangeValue]     = wrapper.GetInt(DataID_ChangeValue);
    dx[DataID_ChangeType]      = wrapper.GetInt(DataID_ChangeType);
    //dx[DataID_TableID]         = wrapper.GetInt(DataID_TableID);
}

void AutoChooseParamDataX2DataXNet(IDispatchEx* pDx, IDataXNet* pDataXNet)
{
	if(pDx == NULL || pDataXNet == NULL)
	{
		return;
	}

	PDataX dx(pDx);

	string strTmp = CW2A((BSTR)dx[DataID_DirEncode], 936);
	pDataXNet->PutUTF8String(DataID_DirEncode, (byte*)strTmp.c_str(), (int)(strTmp.length() + 1));
	pDataXNet->PutInt(DataID_GameClassID,dx[DataID_GameClassID]);
	pDataXNet->PutInt(DataID_GameID,dx[DataID_GameID]);
	pDataXNet->PutInt(DataID_UserType,dx[DataID_UserType]);
	pDataXNet->PutInt(DataID_UserScore,dx[DataID_UserScore]);
	pDataXNet->PutInt(DataID_Balance,dx[DataID_Balance]);

	PDataX dxArray = dx[CComBSTR(L"SkipRoomArray")];
	int nCount = dx[CComBSTR(L"SkipRoomCount")].lVal;
	int *pRooms = new int[nCount];
	for(int i = 0; i < nCount; i++)
	{
		pRooms[i] = dxArray[i];
	}
	pDataXNet->PutIntArray(DataID_SkipRooms,pRooms,nCount);
	delete []pRooms;
}

#endif // _DATA_STRUCT_SWITCHER_H_
