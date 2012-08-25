#pragma once

#include <map>
#include <string>
#include "common/common.h"

using std::string;

typedef std::map<string, string> ReportStringMap;
typedef std::map<string, ReportStringMap> TimeReportMap;

typedef const char* LPCSTR;

class CStatisticsMgr
{
private:
    CStatisticsMgr(void);
    CStatisticsMgr(const CStatisticsMgr&);
    CStatisticsMgr& operator = (const CStatisticsMgr&);

public:
    ~CStatisticsMgr(void);

    static CStatisticsMgr* GetInstance()
    {
    	static CStatisticsMgr _instance;
    	return &_instance;
    }

    typedef std::map<string, int> StatMap;

public:
	void				Init();
	void				Uninit();
    void                SetStatValue(LPCSTR szKey, INT nValue);
    INT                 GetStatValue(LPCSTR szKey);

    void                IncreaseStatValue(LPCSTR szKey, INT nInc = 1);
    void                DecreaseStatValue(LPCSTR szKey, INT nDec = 1);

    void                ReportStatistics();
    void 				ReportLogin();
public:
	void				Report(const char* szName, BOOL bSucceeded, ReportStringMap* pMapString = NULL, _u64 tBegin = 0, _u64 tEnd = 0 );
	void				ReportBegin(LPCSTR szUserKey);
	void				ReportEnd(LPCSTR szUserKey, const char* szName, BOOL bSucceeded, ReportStringMap* pMapString = NULL );

public:
    //void              OnStartGame(INT nGameID);
	//void				OnEndGame(INT nGameID);
    void                OnStartGameFailed(INT nGameID);
    void                OnQueryDirInfoFailed();
    void                OnEnterRoomResp();

private:
    void                InitStatMap();	
	void				InitReportMap(ReportStringMap &repMap);
	string				GetPeerId();
	INT					GetCPUUsage();
	string				GetLocalIP();

private:
    StatMap             m_mapStat;
	TimeReportMap		m_mapTimeReport;

    DWORD               m_dwTotalBegin;
	_u64				m_tLastCalcTime;
	_u64 				m_llTotalBegin;

	string				m_sPeerId;
	static CStatisticsMgr *m_pInstance;
    DECL_LOGGER;
};
