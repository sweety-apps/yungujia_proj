#ifndef _SESSION_CONNECTION_MGR_H_20090302
#define _SESSION_CONNECTION_MGR_H_20090302

#include <map>
#include "common/common.h"
#include "GameSession.h"
#include "common/GameNetInf.h"

class ISessionConnection;
class ISessionCallback;

class GameSessionMgr
{
	GameSessionMgr(void);
	~GameSessionMgr(void);

public:
	static GameSessionMgr* GetInstance();

	void AddSessionConnection(short nGameID, short nZoneID, short nRoomID, ISessionConnection* pConn, ISessionCallback* pCallback);
	void RemoveSessionConnection(short nGameID, short nZoneID, short nRoomID);
	void RemoveSessionConnection(int nConnID);
	ISessionConnection* FindSessionConnection(short nGameID, short nZoneID, short nRoomID);
	ISessionConnection* FindSessionConnection(int nConnID);
	ISessionCallback* FindSessionCallback(int nConnID);
	BOOL IsSessionConnExists(int nConnID);
    BOOL IsSameGameSessionConnExist(short nGameID);
    BOOL IsSameTypeGameSessionExist(int nGameType);
    BOOL IsGameRuning(short nGameID);

    ISessionCallback* FindFirstGameRoomByGameID(short nGameID);

	BOOL QueryRoomInfoByConnID(int nConnID, GAMEROOM& roomInfo);
    ISessionCallback* GetSessionCallbackHandle();

    void ExitAllRoom();
    void NotifyEvent2Game(const char* szEvent, IDataXNet* pDx);
    void ClearAllConnection();
    void ReportUserInfo(LONG lScore, string& sRank);

    size_t GetSessionConnSize();

private:
	std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> > m_mapSessionConns;

	DECL_LOGGER;
};

#endif // #ifndef _SESSION_CONNECTION_MGR_H_20090302
