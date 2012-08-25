
#ifndef __GAME_NET_INSTANCE_H_20090218_h
#define __GAME_NET_INSTANCE_H_20090218_h

#include "common/GameNetInf.h"
#include <set>
#include <map>
#include <string>
#include "common/SDLogger.h"
#include "asynio/asyn_io_frame.h"

using std::set;
using std::string;
typedef std::map<string, int> GameNetConfigMap;

#define CONN_ID_GETDIR_RESP -2
#define CONN_ID_GETDIR_COMMON -200
#define CONN_ID_GETDIR_ONLINE_RESP -201
#define CONN_ID_GETDIR_QUERY_ROOM_RESP -202
#define CONN_ID_GETDIR_QUERY_VERSION_RESP -203
#define CONN_ID_GETUSERINFO_RESP -3
#define CONN_ID_NONSESSION_DX_RESP -4
#define CONN_ID_USERSTATUSSVR_DX_RESP -5
#define CONN_ID_BALANCESVR_DX_RESP -6
#define CONN_ID_TIMED_MATCH_DX_RESP -7
#define CONN_ID_USERGUIDESVR_DX_RESP -8
#define CONN_ID_TAB_STATUS_DX_RESP -9
#define CONN_ID_STATSVR_DX_RESP -10
#define CONN_ID_USERSVR_DX_RESP -11
#define CONN_ID_CHIPSVR_DX_RESP -12

class vdt_tcp_cmd_handler;

class CGameNetInstance : public IGameNetEx3
{
	class ServerAddr
	{
	public:
		ServerAddr(const char* server_addr, int port)
		{
			if(server_addr)
				strcpy(m_server_addr, server_addr);
			else
				m_server_addr[0] = '\0';
			m_server_port = port;
		}

		char* get_server_addr() { return m_server_addr; }
		int get_server_port() { return m_server_port; }

		bool operator == (const ServerAddr& svrAddr) const
		{
			return (0 == strcasecmp(m_server_addr, svrAddr.m_server_addr) && m_server_port == svrAddr.m_server_port);
		}
		bool operator < (const ServerAddr& svrAddr) const
		{
			int nRet = (int)strcasecmp(m_server_addr, svrAddr.m_server_addr);
			if(nRet != 0)
				return nRet < 0;
			return m_server_port < svrAddr.m_server_port;
		}

	private:
		char m_server_addr[256];
		int m_server_port;
	};

	CGameNetInstance();
public:
	static CGameNetInstance* GetInstance();

	void SetTracerEnabled(bool bEnabled = true) { m_tracer_enabled = bEnabled; }
	bool IsTracerEnabled() { return m_tracer_enabled; }

	// interface of IGameNet
	virtual BOOL InitEvent(IGameNetEvent* pCallback);
	virtual BOOL QueryDirInfo(const char* server_addr, unsigned short server_port, const string& strMethodName,const map<string, string>& mapParams);
	virtual BOOL QueryUserGameInfo(const char* server_addr, unsigned short server_port, XLUSERID nUserID);
	virtual ISessionConnection* CreateSessionConnection(const char* server_addr, unsigned short server_port, ISessionCallback* pCallback);
	virtual ISessionConnection* RegisterSessionEvent(int nConnID,ISessionCallback* pCallback);
	virtual void Close();
	virtual BOOL SubmitDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID );
	virtual BOOL SubmitUserStatusSvrDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSeqNo );
    virtual BOOL SubmitBalanceDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSeqNo );    
	virtual BOOL SubmitTimedMatchDataXReq(const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSeqNo );    
	virtual BOOL SubmitDataXReqSpec(int nSvrType, const char* server_addr, unsigned short server_port, const char* cmdName, IDataXNet* pDataX, int nCmdSrcID);
	virtual BOOL SubmitFlexDataXReq(const char* server_addr, unsigned short server_port, const LONG nCmdReqID, const char* cmdReqName, const LONG nCmdRespID, const char* cmdRespName, IDataXNet* pDataX, int nCmdSrcID);
    virtual void SetConfig(const char* key, int value);
    virtual int GetConfig(const char* key, int default_value);
    virtual int SetProxy(int type,  const char* server_addr, unsigned short server_port, const char* username, const char* pwd);

    virtual BOOL QueryDirInfoWithSkipRooms(const char* server_addr, unsigned short server_port, const string& strMethodName,IDataXNet* pParams);

	void OnRecvDirResp(int nConnID, IGameCommand* pCmd);
	void OnRecvUserInfoResp(IGameCommand* pCmd);
	void OnRecvNonSessionDxResp(IGameCommand* pCmd);
	void OnRecvUserStatusSvrDxResp(IGameCommand* pCmd);
    void OnRecvBalanceSvrDxResp(IGameCommand* pCmd);

	void OnRecvUserGuideSvrDxResp(IGameCommand* pCmd);
	void OnRecvTimedMatchDxResp(IGameCommand* pCmd);
	void OnRecvTabStatusDxResp(IGameCommand* pCmd);
	void OnRecvChipDxResp(IGameCommand* pCmd);
	void OnNetworkError(int nErrorCode);
	void OnNetworkErrorDetail(int nConnID, int nErrorCode);
	void OnRecvFlexDxResp(IGameCommand* pCmd);

	void Session_OnRecvResp(int nSessionID, IGameCommand* pCmd);
	void Session_OnNetworkError(int nSessionID,int nErrorCode);
	void Session_OnReconnectOK(int nSessionID);
	void Session_OnClose(int nSessionID);

	static void HandleSessionResponse(ISessionCallback* pCallback, IGameCommand* pCmdResp);

private:
	string BuildQueryDirRequest(string strMethodName,const map<string, string>& mapParams);
    string BuildQueryDirRequestByDataX(const string strMethodName,IDataXNet* pdatax);

	static void HandleEnterRoomResp(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleEnterTableResp(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleAskStartResp(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleQuitGameResp(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleExitRoomResp(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleChatResp(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleChatNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleGameActionNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleUserInfoChgNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleUserScoreChgNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleUserStatusChgNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleKickoutNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleDataXNotify(ISessionCallback* pCallback, IGameCommand* pCmdResp);
	static void HandleDataXResp(ISessionCallback* pCallback, IGameCommand* pCmdResp);

private:
	set<IGameNetEvent*> m_pGameEvents;
	bool m_is_querying_dir;
	bool m_is_querying_userinfo;
	vdt_tcp_cmd_handler* m_query_userinfo_handler;
	map<ServerAddr, vdt_tcp_cmd_handler*> m_common_handlers;
	map<int, std::pair<vdt_tcp_cmd_handler*, ISessionCallback*> > m_map_session_events;

	bool m_tracer_enabled;
    GameNetConfigMap m_map_configs;

    string m_proxy_server;
    unsigned short m_proxy_port;
    string m_proxy_user;
    string m_proxy_pwd;

    bool m_is_using_proxy;

private:
	DECL_LOGGER; //LOG4CPLUS_CLASS_DECLARE(s_logger);

	static CGameNetInstance* s_instance;

};

#endif // #ifndef __GAME_NET_INSTANCE_H_20090218_h
