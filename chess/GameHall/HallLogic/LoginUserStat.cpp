#include <string>
#include "HallLogic.h"
#include "LoginUserStat.h"
#include "HallContext.h"
#include "common/DxNetWrapper.h"

IMPL_LOGGER(CLoginUserStat);

BOOL CLoginUserStat::m_bNewUserReported = FALSE;

CLoginUserStat::CLoginUserStat(void)
: m_nBalance(0)
, m_nLastUserID(0)
, m_bQueryUserGameInfo(FALSE)
, m_bQueryBalance(FALSE)
{
	memset(&m_XLUserInfo, 0, sizeof(XLUSERINFOEX));
}

CLoginUserStat::~CLoginUserStat(void)
{
    Clean();
}

VOID CLoginUserStat::Clean()
{
    m_nBalance = 0;
    m_bQueryUserGameInfo = FALSE;
    m_bQueryBalance = FALSE;
    m_mapGameID2Score.clear();
	m_mapLastReport.clear();
}

VOID CLoginUserStat::OnUserChanged(XLUSERID nUserID, const XLUSERINFOEX& newUser)
{    
	if(nUserID != g_nUserID)
	{
		m_nLastUserID = g_nUserID;
		g_nUserID = nUserID;

		Clean();
		m_XLUserInfo = newUser;
	}
}

VOID CLoginUserStat::OnGameScoreChanged(INT nGameID, IDataXNet* pDxNet)
{
	if(m_mapGameID2Score.find(nGameID) == m_mapGameID2Score.end())
    {
    	XLUSERGAMEINFO newInfo;
    	memset(&newInfo, 0, sizeof(XLUSERGAMEINFO));
        m_mapGameID2Score.insert(UserScoreMap::value_type(nGameID, newInfo));
    }

    DxNetWrapper wrapper(pDxNet);
    XLUSERGAMEINFO& info = m_mapGameID2Score[nGameID];
    info.UserLevel       = wrapper.GetShort(DataID_UserLevel);
    info.LevelName       = wrapper.GetBytes(DataID_LevelName, "");
    info.Points       	 = wrapper.GetInt(DataID_UserPoints);
    info.WinNum       	 = wrapper.GetInt(DataID_UserWinNum);
    info.LoseNum      	 = wrapper.GetInt(DataID_UserLoseNum);
    info.EqualNum     	 = wrapper.GetInt(DataID_UserEqualNum);
    info.EscapeNum    	 = wrapper.GetInt(DataID_UserEscapeNum);
    info.DropNum      	 = wrapper.GetInt(DataID_UserDropNum);

    LOG_INFO("gameid=" << nGameID << ", score=" << info.Points);
}

VOID CLoginUserStat::OnBalanceChanged(INT nNewBalance)
{    
    LOG_INFO("new balance=" << nNewBalance);
    NotifyBalanceChanged(nNewBalance);
}

VOID CLoginUserStat::OnQueryGameInfoResp(const vector<XLUSERGAMEINFO>& userGamesInfo)
{
    LOG_INFO("CLoginUserStat::OnQueryGameInfoResp");

    INT nGameID = 0;
    for(int i = 0; i < (INT)userGamesInfo.size(); i++)
    {
        nGameID = userGamesInfo[i].GameID;  

        if(-1 == nGameID)
        {
            LOG_ERROR("CLoginUserStat::OnQueryGameInfoResp failed! [" << i << "], gameid=-1");
            continue;
        }

        if(m_mapGameID2Score.find(nGameID) == m_mapGameID2Score.end())
        {
        	XLUSERGAMEINFO newInfo;
        	memset(&newInfo, 0, sizeof(XLUSERGAMEINFO));
        	m_mapGameID2Score.insert(UserScoreMap::value_type(nGameID, newInfo));
        }

        XLUSERGAMEINFO& info = m_mapGameID2Score[nGameID];
		info.UserLevel       = userGamesInfo[i].UserLevel;
		info.LevelName       = userGamesInfo[i].LevelName;
		info.Points       	 = userGamesInfo[i].Points;
		info.WinNum       	 = userGamesInfo[i].WinNum;
		info.LoseNum      	 = userGamesInfo[i].LoseNum;
		info.EqualNum     	 = userGamesInfo[i].EqualNum;
		info.EscapeNum    	 = userGamesInfo[i].EscapeNum;
		info.DropNum      	 = userGamesInfo[i].DropNum;

        LOG_INFO("CLoginUserStat::OnQueryGameInfoResp - gameid=" << nGameID << ", score=" << info.Points);
    }

    if(!m_bQueryUserGameInfo)
    {
        m_bQueryUserGameInfo = TRUE;
        CheckLoginAction();

		//g_pHallLogic->ReportOnline(0);
    }
}

VOID CLoginUserStat::QueryOnFirstLogin()
{
    //g_pHallLogic->Call(CComBSTR(L"GetPlayGameScore"));
    //g_pHallLogic->Call(CComBSTR(L"QueryBalance"));
}

INT CLoginUserStat::GetUserScore(INT nGameID)
{
    if(m_mapGameID2Score.find(nGameID) == m_mapGameID2Score.end())
    {
        return 0;
    }

    return m_mapGameID2Score[nGameID].Points;
}

VOID CLoginUserStat::OnQueryBalanceResp(INT nBalance)
{
    LOG_INFO("CLoginUserStat::OnQueryBalanceResp - balance=" << nBalance);    
    NotifyBalanceChanged(nBalance);
    
    if(!m_bQueryBalance)
    {
        m_bQueryBalance = TRUE;
        CheckLoginAction();
    }
}

VOID CLoginUserStat::CheckLoginAction()
{
    if(m_bQueryBalance && m_bQueryUserGameInfo)
    {      
        //g_pHallLogic->Fire_Notify(CComBSTR(L"OnQueryBalanceInfoFinished"));
    }
}

VOID CLoginUserStat::SetUserBalance(XLUSERID nUserID, INT nNew)
{
    LOG_INFO("CLoginUserStat::SetUserBalance - userid=" << nUserID << ", oldbalance=" << m_nBalance << ", newbalance=" << nNew);
    if(nUserID != m_nLastUserID)
    {
        LOG_WARN("CLoginUserStat::SetUserBalance - userid not right, current userid=" << m_nLastUserID);
        return;
    }
    NotifyBalanceChanged(nNew);
}

XLUSERGAMEINFO CLoginUserStat::GetGameScore(INT nGameID)
{
    if(m_mapGameID2Score.find(nGameID) == m_mapGameID2Score.end())
    {
    	XLUSERGAMEINFO newInfo;
    	memset(&newInfo, 0, sizeof(XLUSERGAMEINFO));
        return newInfo;
    }

    return m_mapGameID2Score[nGameID];
}

VOID CLoginUserStat::NotifyBalanceChanged(INT nBalance)
{
    if(m_nBalance != nBalance)
    {
        LOG_DEBUG("NotifyBalanceChanged");
        m_nBalance = nBalance;
    }
}

BOOL CLoginUserStat::IsGuest()
{
    return (g_nUserID > 1000000000);
}

VOID CLoginUserStat::GameScoresToDataXNet( IDataXNet* pDxNet )
{
	if(!pDxNet || m_mapGameID2Score.empty())
	{
		return;
	}

	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();
	IDataXNet** ppDataXArray = new IDataXNet*[(int)m_mapGameID2Score.size()];	

	if(!ppDataXArray)
	{
		return;
	}
	
	int i = 0;
	INT nGameID;
	UserScoreMap::iterator it;
	ReportScoreMap::iterator itLast;
	for(it = m_mapGameID2Score.begin(); it != m_mapGameID2Score.end(); it++)
	{
		XLUSERGAMEINFO& info = it->second;

		nGameID = it->first;
		itLast = m_mapLastReport.find(nGameID);
		if(itLast != m_mapLastReport.end() && itLast->second == info.Points)
		{
			continue;
		}

		ppDataXArray[i] = pGameUtil->CreateDataX();

		ppDataXArray[i]->PutInt(DataID_GameID, it->first);
		ppDataXArray[i]->PutShort(DataID_UserLevel, (short)info.UserLevel);
		ppDataXArray[i]->PutInt(DataID_UserPoints, info.Points);
		ppDataXArray[i]->PutInt(DataID_UserWinNum, info.WinNum);
		ppDataXArray[i]->PutInt(DataID_UserLoseNum, info.LoseNum);
		ppDataXArray[i]->PutInt(DataID_UserEqualNum, info.EqualNum);
		ppDataXArray[i]->PutInt(DataID_UserEscapeNum, info.EscapeNum);
		ppDataXArray[i]->PutInt(DataID_UserDropNum, info.DropNum);

		i++;
		
		m_mapLastReport[nGameID] = info.Points;
	}

	pDxNet->PutDataXArray(DataID_Param1, ppDataXArray, i); // CCC

	for(int k = 0; k < i; k++)
	{
		pGameUtil->DeleteDataX(ppDataXArray[k]);
		ppDataXArray[k] = NULL;
	}
	delete[] ppDataXArray;
	ppDataXArray = NULL; 
}

BOOL CLoginUserStat::IsNewUser()
{
	BOOL bRet = (m_mapGameID2Score.empty() ? TRUE : FALSE);
	if(bRet && !m_bNewUserReported)
	{
		m_bNewUserReported = TRUE;
		return TRUE;
	}

	return FALSE;
}

VOID CLoginUserStat::UserInfo2DataXNet(IDataXNet* pDataXNet)
{
	if(pDataXNet == NULL)
	{
		return;
	}

	pDataXNet->PutUTF8String(DataID_Username,
			(byte*)m_XLUserInfo.Username.c_str(), (int)(m_XLUserInfo.Username.length() + 1));
	pDataXNet->PutUTF8String(DataID_Nickname,
			(byte*)m_XLUserInfo.Nickname.c_str(), (int)(m_XLUserInfo.Nickname.length() + 1));

	pDataXNet->PutShort(DataID_ImageIndex, (short)m_XLUserInfo.ImageIndex);
	pDataXNet->PutShort(DataID_UserIsVip, (short)m_XLUserInfo.IsVIPUser);
	pDataXNet->PutShort(DataID_UserIsMale, (short)m_XLUserInfo.IsMale);

	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();
	string strPeerId = pGameUtil->GetPeerID();
	pDataXNet->PutBytes(DataID_PeerID, (byte*)strPeerId.c_str(), (int)strPeerId.length());

	pDataXNet->PutInt(DataID_UserScore, m_XLUserInfo.Score);

	pDataXNet->PutUTF8String(DataID_UserRankName,
			(byte*)m_XLUserInfo.RankName.c_str(), (int)(m_XLUserInfo.RankName.length() + 1));

	pDataXNet->PutInt(DataID_PingGap, 0);
}
