#pragma once

#include <map>
#include "common/common.h"
#include "GameNet/command/DataID.h"

class CLoginUserStat
{
private:
    CLoginUserStat(void);
    CLoginUserStat(const CLoginUserStat&);
    CLoginUserStat& operator = (const CLoginUserStat&);

public:
    ~CLoginUserStat(void);

    static CLoginUserStat* GetInstance()
    {
        static CLoginUserStat _instance;
        return &_instance;
    }

public:
    XLUSERINFO 		GetLoginUser() { return m_XLUserInfo; }
    VOID            OnUserChanged(XLUSERID nUserID, const XLUSERINFOEX& newUser);
    VOID            OnGameScoreChanged(INT nGameID, IDataXNet* pDxNet);
    VOID            OnBalanceChanged(INT nNewBalance);
    VOID            OnQueryGameInfoResp(const vector<XLUSERGAMEINFO>& userGamesInfo);
    VOID            OnQueryBalanceResp(INT nBalance);

    VOID            QueryOnFirstLogin();
    INT             GetUserScore(INT nGameID);
    INT             GetUserBalance() const { return m_nBalance; }
    VOID            SetUserBalance(XLUSERID nUserID, INT nNew);
    XLUSERGAMEINFO  GetGameScore(INT nGameID);

	BOOL			IsGuest();
	VOID			GameScoresToDataXNet(IDataXNet* pDxNet);
	BOOL			IsNewUser();

	VOID 			UserInfo2DataXNet(IDataXNet* pDataXNet);

private:
    VOID            Clean();
    VOID            CheckLoginAction();
    VOID            NotifyBalanceChanged(INT nBalance);

private:
    typedef std::map<INT, XLUSERGAMEINFO> UserScoreMap;
	typedef std::map<INT, INT> ReportScoreMap;

    UserScoreMap    m_mapGameID2Score;
	ReportScoreMap	m_mapLastReport;
    INT             m_nBalance;
    XLUSERID        m_nLastUserID;
    BOOL            m_bQueryUserGameInfo;
    BOOL            m_bQueryBalance;
    XLUSERINFOEX	m_XLUserInfo;

	static BOOL		m_bNewUserReported;

    DECL_LOGGER;
};
