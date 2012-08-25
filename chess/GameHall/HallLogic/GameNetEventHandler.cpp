
#include "GameNetEventHandler.h"
#include "GameNet/command/DataID.h"
#include "HallContext.h"
#include "common/DxNetWrapper.h"
#include "JniHelper.h"
#include "GameDirInfoMgr.h"
#include "LoginUserStat.h"

IMPL_LOGGER(CGameNetEventHandler);

///////////////////////////////////////////////////////////////////////////////
CGameNetEventHandler::CGameNetEventHandler()
{
}

CGameNetEventHandler* CGameNetEventHandler::GetInstance()
{
	static CGameNetEventHandler _instance;
	return &_instance;
}
	
void CGameNetEventHandler::OnQueryDirResp(const string& response)
{
	GameDirInfoMgr* pDirMgr = GameDirInfoMgr::GetInstance();

	string strRet;

	XML_RESP_TYPE respType = RESP_UNKNOWN;
	LOG_INFO("OnQueryDirResp() head=" << response[0] << " tail=" << response[response.length()-1]);
	if( response[0] != '<' || response[response.length()-1] != '>' )
	{
		respType = RESP_GAME_DIR;
		LOG_ERROR("OnQueryDirResp() invalid response");
		JniHelper::Notify_JniHall("OnQueryDirFailed", NULL);
		return;
	}

	int nInfoType = pDirMgr->GetXmlInfoType(response, respType, strRet);
	switch(nInfoType)
	{
	case RESP_QUERY_SUITED_ZOONS:
		{
			LOG_INFO("OnQueryDirResp: querySuitedZoons info");

			pDirMgr->SetQuerySuitedZoonsInfo(response);
			IDataXNet* pDx = pDirMgr->GetSuitedZoonsDataX();

			if(pDx)
			{
				JniHelper::Notify_JniHall("OnQuerySuitedZoneResp", pDx, false);

				INT nGameID = 0;
				pDx->GetInt(DataID_GameID, nGameID);
				LOG_DEBUG("RESP_QUERY_SUITED_ZOONS - gameid = " << nGameID);
				if(nGameID > 0)
				{
					JniHelper::Notify_JniGame(nGameID, "OnQuerySuitedZoneResp", pDx, false);
				}
			}
		}
		break;

	default:
		break;
	}

	if(0 == nInfoType)
	{
		// failed
		if(respType == RESP_QUERY_SUITED_ZOONS)
		{
			IDataXNet* pdxNotify = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
			pdxNotify->PutInt(DataID_Result, -1);
			pdxNotify->PutInt(DataID_Param1, -202);
			pdxNotify->PutInt(DataID_Param2, -1);
			JniHelper::Notify_JniGame(-1, "NetworkError", pdxNotify, true);
		}
	}
}

void CGameNetEventHandler::OnQueryUserInfoResp(int nResult, XLUSERID nUserID, const vector<XLUSERGAMEINFO>& userGamesInfo)
{
    LOG_INFO("OnQueryUserInfoResp nResult="<<nResult<<" UserID="<<nUserID<<" infosize="<<(int)userGamesInfo.size());
    if (nResult !=0 || nUserID != g_nUserID)
    {
        return;
    }
}

void CGameNetEventHandler::OnNetworkError(int nErrorCode)
{
	IDataXNet* pdxNotify = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
	pdxNotify->PutInt(DataID_Result, nErrorCode);
	JniHelper::Notify_JniGame(-1, "NetworkError", pdxNotify, true);
}

void CGameNetEventHandler::OnRecvDataXResp(int nResult , const char* cmdName, IDataXNet* pDataX)
{
	LOG_DEBUG("OnRecvDataXResp() called, result=" << nResult << ", cmdName=" << cmdName);

	int nCmdScrID = CMD_FROM_GAMEHALL;
	if(pDataX)
	{
		DxNetWrapper wrapper(pDataX);
		nCmdScrID = wrapper.GetInt(DataID_CmdSrcID, CMD_FROM_GAMEHALL);
	}

	if(nCmdScrID != CMD_FROM_GAMEHALL)
	{
		LOG_INFO("OnRecvDataXResp(): cmdSrcID=" << nCmdScrID << ", try to notify game client.");	


	}
	else
	{
		LOG_DEBUG("OnRecvDataXResp(): cmdSrcID=" << nCmdScrID << ", it's cmd from game hall, not game client!");	

		if(strcasecmp(cmdName, "QueryUserInfoResp") == 0)
		{
			HandlerUserInfoResp(nResult, cmdName, pDataX);
		}
        else if (strcasecmp(cmdName, "TransferGuestAllScoresResp") == 0)
        {
            HandlerTransferGuestAllScoresResp(nResult, cmdName, pDataX);
        }
        else if (strcasecmp(cmdName, "GetUserPositionResp") == 0)
        {
			OnQueryUserPositionResp(nResult, cmdName, pDataX);
        }
        else if (strcasecmp(cmdName, "QueryBalanceResp") == 0)
        {
            HandlerQueryBalanceResp(nResult, cmdName, pDataX);
        }
		else if (strcasecmp(cmdName, "ReportOnlineResp") == 0)
		{
			HandlerReportOnlineResp(nResult, cmdName, pDataX);
		}
		else if(strcasecmp(cmdName, "ReportTabStatusResp") == 0)
		{
			if(pDataX)
			{
				DxNetWrapper wrapper(pDataX);				
				LOG_DEBUG("ReportTabStatusResp result=" << wrapper.GetInt(DataID_Result, 0))
			}			
		}
	}
}

void CGameNetEventHandler::HandlerUserInfoResp(int /*nResult*/ , const char* /*cmdName*/, IDataXNet* pDataX)
{
	LOG_DEBUG("HandlerUserInfoResp() called.");

	ysh_assert(pDataX != NULL);

	DxNetWrapper wrapper(pDataX);

	XLUSERID nUserID = wrapper.GetInt64(DataID_UserID, -1);
	short nUserLevel = wrapper.GetShort(DataID_UserLevel, 0);
	int nBlockResult = wrapper.GetInt(DataID_Result, 0);
    int nDisplaySeqNo = wrapper.GetInt(DataID_Param1, 0);
    int nUseridValidDuration = wrapper.GetInt(DataID_Param2, 0);
    int nChangeType = wrapper.GetInt(DataID_ChangeType, 0);

	LOG_DEBUG("HandlerUserInfoResp(): UserID=" << nUserID << ", UserLevel=" << nUserLevel << ", BlockResult=" << nBlockResult
        << ", nDisplaySeqNo =" << nDisplaySeqNo << ", nUseridValidDuration=" << nUseridValidDuration << ", ChangeType=" << nChangeType);

	char szUsername[64] = "";
	XLUSERINFOEX info;

	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();

	if(nUserLevel <= 0)
	{
		sprintf(szUsername, "游客%.5d", nDisplaySeqNo);
		info.Username   = szUsername;
		info.Nickname   = szUsername;//pGameUtil->GetPeerID();
		info.IsVIPUser  = false;
		info.ImageIndex = 0;
		info.IsMale     = 1;
		info.Score      = 0;

		CLoginUserStat::GetInstance()->OnUserChanged(nUserID, info);
		JniHelper::Notify_JniHall("OnGuestLoginOK", pDataX, false);
		JniHelper::Notify_JniGame(-1, "ConnectOK", pDataX, false);
	}
	else
	{
		// TODO
	}

	/*
    PDataX dxUserInfo = PDataX::CreateInstance();
    CString strUserID, strDisplay;
    strUserID.Format(_T("%I64d"), nUserID);
    dxUserInfo[DataID_UserID] = (LPCTSTR)strUserID;
    dxUserInfo[DataID_UserLevel] = nUserLevel;
    dxUserInfo[DataID_Result] = nBlockResult;    

    PDataX dxParam2 = PDataX::CreateInstance();
    dxParam2[DataID_ChangeType] = nChangeType;

    if (nUserLevel <= 0)
    {
        dxUserInfo[DataID_Username] = dxUserInfo[DataID_UserID];
		CString strNickname;
		//strNickname.Format(_T("游客%.5d"), nDisplaySeqNo);
		strNickname = CA2T((g_pHallLogic->GenNickNameByPeerId()).c_str());
        dxUserInfo[DataID_Nickname]     = (LPCTSTR)strNickname;
        dxUserInfo[DataID_UserIsMale]   = TRUE;
        dxUserInfo[DataID_UserIsVip]    = VARIANT_FALSE;
        dxUserInfo[DataID_JumpKey]      = L"";
        dxUserInfo[DataID_UserScore]    = 0;
        dxUserInfo[DataID_UserRankName] = L"";
        dxUserInfo[DataID_ChangeType]   = 0;        
        dxUserInfo[DataID_AreaName]     = L"";
        dxUserInfo[DataID_CityName]     = L"";
        dxUserInfo[DataID_PingGap]      = 0;
        dxUserInfo[DataID_Balance]      = 0;
        dxUserInfo[DataID_UserIsXLVip]  = 0;
        PDataX::GetDataCenter()[DataID_LoginInfo] = dxUserInfo;

       	CHallContext::GetInstance()->SetGameNetUserInfo(nUserID, NULL);

        g_nLoginUserID = nUserID;

        CLoginUserStat::GetInstance()->OnUserChanged();
        g_pHallLogic->SaveGuestInfo(nUserID, nDisplaySeqNo, nUseridValidDuration);        
    }
    else if (g_nLoginUserID == nUserID)
    {
        PDataX::GetDataCenter()[DataID_LoginInfo][DataID_UserLevel] = nUserLevel;
        if (nUserLevel >= 10)
        {
            PDataX::GetDataCenter()[DataID_LoginInfo][DataID_UserIsVip] = TRUE;
        }
        
        CComBSTR spbstrArea = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_AreaName).c_str(), 936));
        CComBSTR spbstrCity = CComBSTR(CA2W(wrapper.GetUTF8String(DataID_CityName).c_str(), 936));
        INT64 nVipLeftTime = wrapper.GetInt64(DataID_ValidTime, -1);

        PDataX dxLoginUser = PDataX::GetDataCenter()[DataID_LoginInfo];
        dxLoginUser[DataID_AreaName] = spbstrArea;
        dxLoginUser[DataID_CityName] = spbstrCity;
        dxLoginUser[DataID_ValidTime] = Int64ToBSTR(nVipLeftTime);

		CTime t = CTime::GetCurrentTime();
		CTime t2(t.GetTime() + nVipLeftTime);

		LOG_DEBUG("HandlerUserInfoResp(): spbstrArea=" << spbstrArea << ", spbstrCity=" << spbstrCity
			<< ", ValidTime=" << t2.Format(_T("%Y-%m-%d %H:%M")));
    }
	else
	{
		BOOL bBlueDiamond = nUserLevel >= 10;
		dxUserInfo[DataID_UserIsVip] = bBlueDiamond;
		g_pHallLogic->UpdateUserBlueDiamondInfo(nUserID, bBlueDiamond);
	}

    HallLogicInstanceMgr::Fire_Notify(CComBSTR(L"OnQueryBlueDiamondInfoResp"), dxUserInfo, dxParam2);
	SessionConnMgr::GetInstance()->NotifyEvent2AllGame(CComBSTR(L"OnQueryBlueDiamondInfoResp"), dxUserInfo, dxParam2);
	*/
}

void CGameNetEventHandler::HandlerTransferGuestAllScoresResp(int /*nResult*/, const char* /*cmdName*/, IDataXNet* pDataX)
{
    LOG_DEBUG("HandlerTransferGuestAllScoresResp()  called.");
}

/*
void CGameNetEventHandler::NotifyGameClientDataXResp(CHallInterface* pHallInf, int nResult , const char* cmdName, IDataXNet* pDataX)
{
	if(pHallInf == NULL)
		return;

	LOG_DEBUG("NotifyGameClientDataXResp() called.");

	IDataXNet* pDxParam = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
	pDxParam->PutInt(DataID_RespResult, nResult);
	pDxParam->PutBytes(DataID_CmdName, (byte*)cmdName, (int)strlen(cmdName) + 1);

	CComVariant v1, v2;
	CHallContext::GetInstance()->GetGameUtility()->DataXToVariant(pDxParam, v1);
	CHallContext::GetInstance()->GetGameUtility()->DeleteDataX(pDxParam);


//	LOG_DEBUG("NotifyGameClientDataXResp(): 001");
	CHallContext::GetInstance()->GetGameUtility()->DataXToVariant(pDataX, v2);
//	LOG_DEBUG("NotifyGameClientDataXResp(): 002");

	pHallInf->Fire_Notify(CComBSTR(L"NonSessionDataXResp"), v1, v2);

	LOG_DEBUG("NotifyGameClientDataXResp() finished.");
}
*/

void CGameNetEventHandler::HandlerUserPositionResp( int nResult , const char* /*cmdName*/, IDataXNet* pDataX )
{
    LOG_DEBUG("HandlerUserPositionResp() called. result=" << nResult);
    if(nResult != 0)
    {
        LOG_WARN("HandlerUserPositionResp - can not find user position.");
        return;
    }

    ysh_assert(pDataX != NULL);

//     DataID_GameID	20090701	Short	
//     DataID_ZoneID	20090701	Short	
//     DataID_RoomID	20090701	Short	
//     DataID_UserID	20090701	Int64	userID
//     DataID_PeerID	20090701	Bytes	userPeerID
//     DataID_UserIP	20090701	Int	
//     DataID_GameSvrIP	20090701	Int	
//     DataID_GameSvrPort	20090701	Int	

    int nDataXArraySize = 0;
    bool bRet = pDataX->GetDataXArraySize(DataID_Param1, nDataXArraySize);
    if(!bRet)
    {
        LOG_ERROR("HandlerUserPositionResp - can't get tableplayer count!");
        return;
    }

    if(nDataXArraySize <= 0)
    {
        LOG_WARN("HandlerUserPositionResp - no position");
        return;
    }

    for(int i = 0; i < nDataXArraySize; i++)
    {
        IDataXNet *pDataXNet = NULL;
        bRet = pDataX->GetDataXArrayElement(DataID_Param1, i, &pDataXNet);

        if(!bRet)
        {
            LOG_WARN("HandlerUserPositionResp - can not get user position info (" << i << ")");
            continue;
        }
    }

    //HallLogicInstanceMgr::Fire_Notify(CComBSTR(L"OnTransferGuestAllScoresResp"), dxTransferRet);
}

void CGameNetEventHandler::OnQueryUserPositionResp(int nResult, const char* /*cmdName*/, IDataXNet* pDataX)
{
	LOG_DEBUG("OnQueryUserPositionResp() called. result=" << nResult);
	if (nResult != 0)
	{
		LOG_WARN("OnQueryUserPositionResp() - Can Not find User Position!");
		return;
	}

	if (pDataX == NULL)
	{
		LOG_WARN("OnQueryUserPositionResp() : pDataX is NULL!");
		return;
	}

	int nDataXArraySize = 0;
	bool bRet = pDataX->GetDataXArraySize(DataID_Param1, nDataXArraySize);
	if (!bRet)
	{
		LOG_ERROR("OnQueryUserPositionResp(): GetDataXArraySize() return false!");
		return;
	}

	LOG_DEBUG("OnQueryUserPositionResp(): nDataXArraySize=" << nDataXArraySize);
	if (nDataXArraySize > 0)
	{

	}

}

void CGameNetEventHandler::HandlerQueryBalanceResp(int nResult , const char* /*cmdName*/, IDataXNet* pDataX)
{
    LOG_DEBUG("HandlerQueryBalanceResp() called. result=" << nResult);
    if (nResult != 0)
    {
        LOG_WARN("HandlerQueryBalanceResp() - Can not find user balance!");
        return;
    }

    if (pDataX == NULL)
    {
        LOG_WARN("HandlerQueryBalanceResp() : pDataX is NULL!");
        return;
    }

    DxNetWrapper wrapper(pDataX);
    //CLoginUserStat::GetInstance()->OnQueryBalanceResp(wrapper.GetInt(DataID_Balance));
}

void CGameNetEventHandler::HandleDirInfoResp()
{

}

void CGameNetEventHandler::HandlerReportOnlineResp( int nResult , const char* cmdName, IDataXNet* pDataX )
{
	LOG_DEBUG("HandlerReportOnlineResp() called. result=" << nResult);
	if (nResult != 0)
	{
		LOG_WARN("HandlerReportOnlineResp() - failed!");
		return;
	}

	if (pDataX == NULL)
	{
		LOG_WARN("HandlerReportOnlineResp() : pDataX is NULL!");
		return;
	}

	DxNetWrapper wrapper(pDataX);
	int nDuration = wrapper.GetInt(DataID_Duration);
	LOG_INFO("HandlerReportOnlineResp() - report interval = " << nDuration);

	//g_pHallLogic->SetReportUserInterval(nDuration);
}

void CGameNetEventHandler::OnNetworkErrorWithConnID( int nConnID, int nErrorCode, int nExtraCode )
{
	IDataXNet* pdxNotify = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
	pdxNotify->PutInt(DataID_Result, nErrorCode);
	pdxNotify->PutInt(DataID_Param1, nConnID);
	pdxNotify->PutInt(DataID_Param2, nExtraCode);
	JniHelper::Notify_JniGame(-1, "NetworkError", pdxNotify, true);
}
