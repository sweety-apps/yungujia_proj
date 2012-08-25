#include "statisticsmgr.h"
#include "HallContext.h"
#include "common/setting.h"
#include "GameNet/command/DataID.h"
#include "common/utility.h"
#include "GameSessionMgr.h"

IMPL_LOGGER(CStatisticsMgr);

extern int g_nMajorVersion;
extern int g_nMinorVersion;
extern int g_nBuildNum;
extern int g_nRevVersion;

#define UNREFERENCED_PARAMETER(x) x

CStatisticsMgr::CStatisticsMgr(void)
: m_tLastCalcTime(0)
, m_llTotalBegin(0)
{
    InitStatMap();
    m_llTotalBegin = utility::current_time_ms();
}

CStatisticsMgr::~CStatisticsMgr(void)
{
	m_mapStat.clear();
}

/*
运行时间统计	特殊时间统计	数量统计	错误统计	邀请统计
大厅运行时间	激活时间	启动游戏次数	获取目录树失败	邀请是否弹出
大厅tab页停留时间	非激活时间	最多开启房间数	进游戏失败次数	邀请是否成功
游戏tab页停留时间	最小化时间		加载道具失败次数	
单机tab页停留时间				
*/
void CStatisticsMgr::InitStatMap()
{
    m_mapStat["RunningTime"]            = 0;
    m_mapStat["MainTabStayTime"]        = 0;
    m_mapStat["MiniGameTabStayTime"]    = 0;
    m_mapStat["PcGameTabStayTime"]      = 0;

    m_mapStat["MainWndActiveTime"]      = 0;
    m_mapStat["MainWndInActiveTime"]    = 0;
    m_mapStat["MainWndMinTime"]         = 0;

    m_mapStat["StartGameCount"]         = 0;
    m_mapStat["MaxRoomCount"]           = 0;

    m_mapStat["GetDirInfoFailed"]       = 0;
    m_mapStat["StartGameFailedCount"]   = 0;

	m_mapStat["TotalPlayGameTime"]		= 0;
	m_mapStat["DownloadGameP2spError"]	= 0;
}

void CStatisticsMgr::ReportStatistics()
{
    // time stat
    SetStatValue("RunningTime",         (INT)(utility::current_time_ms()-m_llTotalBegin));

    IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();
    
    IDataXNet* pDxParam = pGameUtil->CreateDataX();
    INT nCount = (INT)m_mapStat.size();
    IDataXNet** ppDataXArray = new IDataXNet*[nCount];

	if(!pDxParam || !ppDataXArray)
	{
		return;
	}

    //pDxParam->PutInt(DataID_Param1, nCount);
    
    INT i = 0;
    StatMap::iterator it;
    for(it = m_mapStat.begin(); it != m_mapStat.end(); i++,it++)
    {
        string strName = (it->first);
        ppDataXArray[i] = pGameUtil->CreateDataX();        
        ppDataXArray[i]->PutUTF8String(DataID_NAME, (byte*)strName.c_str(), (int)strName.size()+1);
        ppDataXArray[i]->PutInt(DataID_VALUE, it->second);   

        LOG_INFO("ReportStatistics - " << strName.c_str() << "=" << it->second);
    }

    pDxParam->PutDataXArray(DataID_Param2, ppDataXArray, nCount); // CCC
	for(i = 0; i < nCount; i++)
	{
		pGameUtil->DeleteDataX(ppDataXArray[i]);
		ppDataXArray[i] = NULL;
	}
    delete[] ppDataXArray;
    ppDataXArray = NULL; 

    string strServer = setting::get_instance()->get_string("userConfig", "stat_server", "stat.minigame.ysh.com");
    int nPort = setting::get_instance()->get_int("userConfig", "stat_port", 38088);

    IGameNet* pGameNet = CHallContext::GetInstance()->GetGameNet();
    pGameNet->SubmitDataXReqSpec(GN_CONN_STAT, strServer.c_str(), (unsigned short)nPort, "ReportLogOutStateReq", pDxParam);
}

void CStatisticsMgr::SetStatValue(LPCSTR szKey, INT nValue)
{
    if(m_mapStat.find(szKey) == m_mapStat.end()) return;
    m_mapStat[szKey] = nValue;
}

INT CStatisticsMgr::GetStatValue(LPCSTR szKey)
{
    if(m_mapStat.find(szKey) == m_mapStat.end()) return 0;
    return m_mapStat[szKey];
}

void CStatisticsMgr::IncreaseStatValue(LPCSTR szKey, INT nInc)
{
    if(m_mapStat.find(szKey) == m_mapStat.end()) return;
    m_mapStat[szKey] += nInc;
}

void CStatisticsMgr::DecreaseStatValue(LPCSTR szKey, INT nDec)
{
    if(m_mapStat.find(szKey) == m_mapStat.end()) return;
    m_mapStat[szKey] -= nDec;
}

void CStatisticsMgr::OnStartGameFailed(INT nGameID)
{
    UNREFERENCED_PARAMETER(nGameID);
    IncreaseStatValue("StartGameFailedCount");
}

void CStatisticsMgr::OnQueryDirInfoFailed()
{
    IncreaseStatValue("GetDirInfoFailed");
}

void CStatisticsMgr::OnEnterRoomResp()
{
    INT nSize = GetStatValue("MaxRoomCount");
    nSize = max(nSize, (INT)GameSessionMgr::GetInstance()->GetSessionConnSize());
    SetStatValue("MaxRoomCount", nSize);
}

string CStatisticsMgr::GetPeerId()
{
	if(m_sPeerId.length() <= 0)
	{
		IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();
		m_sPeerId = pGameUtil->GetPeerID();
	}

	return m_sPeerId;
}

INT CStatisticsMgr::GetCPUUsage()
{
    return 0;
}

void CStatisticsMgr::Report(const char* szName, BOOL bSucceeded,
		ReportStringMap* pMapString, _u64 tBegin, _u64 tEnd)
{
	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();
	
	_u64 tNow = utility::current_time_ms();
	char szUserID[100] = "";

	sprintf(szUserID, "%lld", g_nUserID);

	ReportStringMap reportMap;	
	reportMap["PeerID"]		= GetPeerId();
	reportMap["UserID"]		= szUserID;
	reportMap["BeginTime"]	= "0";
	reportMap["CostTime"]	= "0";
	reportMap["Success"]	= (bSucceeded ? "1" : "0");
	reportMap["ysh"]	= "0";
	reportMap["Kankan"]		= "0";
	reportMap["IP"]			= GetLocalIP();
	char strVersion[64] = "";
	sprintf(strVersion, "%d.%d.%d.%d", g_nMajorVersion,
			g_nMinorVersion, g_nRevVersion, g_nBuildNum);
	reportMap["HallVersion"] = strVersion;

	LOG_INFO("Report - userid=" << g_nUserID << ", szUserID" << szUserID << ", ip=" << reportMap["IP"].c_str() << " version=" << strVersion);

	ReportStringMap::iterator it;
	if(pMapString)
	{
		for(it = pMapString->begin(); it != pMapString->end(); it++)
		{
			reportMap[it->first] = it->second;
		}
	}	

	IDataXNet* pDxParam = pGameUtil->CreateDataX();
	INT nCount = (INT)reportMap.size();
	IDataXNet** ppDataXArray = new IDataXNet*[nCount];

	if(!pDxParam || !ppDataXArray)
	{
		return;
	}

	INT i = 0;	
	for(it = reportMap.begin(); it != reportMap.end(); i++,it++)
	{		
		string strName = it->first;
		string strValue = it->second;

		ppDataXArray[i] = pGameUtil->CreateDataX();        
		ppDataXArray[i]->PutUTF8String(DataID_NAME, (byte*)strName.c_str(), (int)strName.length()+1);
		ppDataXArray[i]->PutUTF8String(DataID_VALUE, (byte*)strValue.c_str(), (int)strValue.length()+1); 

		LOG_INFO("Report - " << strName.c_str() << "=" << strValue.c_str());
	}

	pDxParam->PutDataXArray(DataID_STAT, ppDataXArray, nCount); // CCC
	for(i = 0; i < nCount; i++)
	{
		pGameUtil->DeleteDataX(ppDataXArray[i]);
		ppDataXArray[i] = NULL;
	}
	delete[] ppDataXArray;
	ppDataXArray = NULL;

	pDxParam->PutBytes(DataID_Param1, (byte*)szName, (int)strlen(szName)+1);

	string strServer = setting::get_instance()->get_string("userConfig", "stat_server", "stat.minigame.ysh.com");
	int nPort = setting::get_instance()->get_int("userConfig", "stat_port", 38088);

	IGameNet* pGameNet = CHallContext::GetInstance()->GetGameNet();
	pGameNet->SubmitDataXReq(strServer.c_str(), (unsigned short)nPort, "GenStatCmdReq", pDxParam);
}

string CStatisticsMgr::GetLocalIP()
{
	/*
	char host_name[255] = "";
	 
	if(gethostname(host_name, sizeof(host_name)) == SOCKET_ERROR) 
	{ 
		return ""; 
	}
	
	struct hostent *phe = gethostbyname(host_name); 
	if(NULL == phe) 
	{ 
		return ""; 
	} 

	struct in_addr addr; 
	memcpy(&addr, phe->h_addr_list[0], sizeof(struct in_addr)); 
	
	string sRet = inet_ntoa(addr);
	return sRet;
	*/
	return "";
}

void CStatisticsMgr::ReportBegin( LPCSTR szUserKey)
{
	LOG_DEBUG("ReportBegin - key=" << szUserKey);

	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();

	_u64 tNow = utility::current_time_ms();
	char szUserID[64] = "";
	char szTime[128] = "";

	sprintf(szUserID, "%lld", g_nUserID);
	sprintf(szTime, "%lld", tNow);

	ReportStringMap reportMap;
	reportMap["PeerID"]		= GetPeerId();
	reportMap["UserID"]		= szUserID;
	reportMap["BeginTime"]	= szTime;
	reportMap["ysh"]	= "0";
	reportMap["Kankan"]		= "0";
	reportMap["IP"]			= GetLocalIP();
	reportMap["CostTime"]	= "0";
	char strVersion[64] = "";
	sprintf(strVersion, "%d.%d.%d.%d", g_nMajorVersion,
				g_nMinorVersion, g_nRevVersion, g_nBuildNum);
	reportMap["HallVersion"] = strVersion;

	m_mapTimeReport.insert(TimeReportMap::value_type(szUserKey, reportMap));

	LOG_INFO("ReportBegin - userid=" << g_nUserID
			<< ", szUserID" << szUserID << ", ip="
			<< reportMap["IP"].c_str() << " version=" << strVersion);
}

void CStatisticsMgr::ReportEnd( LPCSTR szUserKey, const char* szName, BOOL bSucceeded, ReportStringMap* pMapString /*= NULL */ )
{
	LOG_DEBUG("ReportEnd - key=" << szUserKey);

	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();

	TimeReportMap::iterator itTime = m_mapTimeReport.find(szUserKey);
	if(itTime == m_mapTimeReport.end())
	{
		return;
	}

	ReportStringMap reportMap = itTime->second;
	m_mapTimeReport.erase(itTime);

	ReportStringMap::iterator it;
	if(pMapString)
	{
		for(it = pMapString->begin(); it != pMapString->end(); it++)
		{
			reportMap[it->first] = it->second;
		}
	}

	_u64 tNow = utility::current_time_ms();

	char szTime[128] = "";
	sprintf(szTime, "%lld", tNow);

	reportMap["EndTime"]	= szTime;
	reportMap["Success"]	= (bSucceeded ? "1" : "0");

	IDataXNet* pDxParam = pGameUtil->CreateDataX();
	INT nCount = (INT)reportMap.size();
	IDataXNet** ppDataXArray = new IDataXNet*[nCount];

	if(!pDxParam || !ppDataXArray)
	{
		return;
	}

	INT i = 0;
	for(it = reportMap.begin(); it != reportMap.end(); i++,it++)
	{
		string strName = it->first;
		string strValue = it->second;

		ppDataXArray[i] = pGameUtil->CreateDataX();
		ppDataXArray[i]->PutUTF8String(DataID_NAME, (byte*)strName.c_str(), (int)strName.length()+1);
		ppDataXArray[i]->PutUTF8String(DataID_VALUE, (byte*)strValue.c_str(), (int)strValue.length()+1);

		LOG_INFO("Report - " << strName.c_str() << "=" << strValue.c_str());
	}

	pDxParam->PutDataXArray(DataID_STAT, ppDataXArray, nCount); // CCC
	for(i = 0; i < nCount; i++)
	{
		pGameUtil->DeleteDataX(ppDataXArray[i]);
		ppDataXArray[i] = NULL;
	}
	delete[] ppDataXArray;
	ppDataXArray = NULL;

	pDxParam->PutBytes(DataID_Param1, (byte*)szName, (int)strlen(szName)+1);

	string strServer = setting::get_instance()->get_string("userConfig", "stat_server", "stat.minigame.ysh.com");
	int nPort = setting::get_instance()->get_int("userConfig", "stat_port", 38088);

	IGameNet* pGameNet = CHallContext::GetInstance()->GetGameNet();
	pGameNet->SubmitDataXReq(strServer.c_str(), (unsigned short)nPort, "GenStatCmdReq", pDxParam);
}

void CStatisticsMgr::ReportLogin()
{
	LOG_DEBUG("ReportLogin() called.");

	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();

	// peerid
	string strPeerId = pGameUtil->GetPeerID();

	// version
	char strVersion[64] = "";
	sprintf(strVersion, "%d.%d.%d.%d", g_nMajorVersion,
					g_nMinorVersion, g_nRevVersion, g_nBuildNum);

	// corpid
	INT nCorpID = 0;

	// starttype
	INT nStartType = 0;

	IDataXNet* pDxParam = pGameUtil->CreateDataX();
	pDxParam->PutBytes(DataID_PeerID, (byte*)strPeerId.c_str(), (int)strPeerId.length());
	pDxParam->PutUTF8String(DataID_Param1, (byte*)strVersion, (int)strlen(strVersion)+1);
	pDxParam->PutInt(DataID_CorpId, nCorpID);
	pDxParam->PutInt(DataID_StartType, nStartType);

	string strServer = setting::get_instance()->get_string("userConfig", "stat_server", "stat.minigame.ysh.com");
	int nPort = setting::get_instance()->get_int("userConfig", "stat_port", 38088);
	LOG_DEBUG("ReportLogin(): server=" << strServer << ", port=" << nPort
		<< ", PeerID=" << strPeerId
		<< ", Version=" << strVersion
		<< ", Corpid=" << nCorpID
		<< ", StartType=" << nStartType);

	IGameNet* pGameNet = CHallContext::GetInstance()->GetGameNet();
	pGameNet->SubmitDataXReqSpec(GN_CONN_STAT, strServer.c_str(), (unsigned short)nPort, "ReportLogInStateReq", pDxParam);
}
