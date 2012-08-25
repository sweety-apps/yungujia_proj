#include "HallContext.h"
#include "GameSessionMgr.h"

IMPL_LOGGER(GameSessionMgr);

GameSessionMgr::GameSessionMgr(void)
{
}

GameSessionMgr::~GameSessionMgr(void)
{
}

GameSessionMgr* GameSessionMgr::GetInstance()
{
	static GameSessionMgr _instance;
	return &_instance;
}

void GameSessionMgr::AddSessionConnection(short nGameID, short nZoneID, short nRoomID, ISessionConnection* pConn, ISessionCallback* pCallback)
{
	if(pConn == NULL || pCallback == NULL)
	{
		return;
	}

    GAMEROOM roomInfo;
    roomInfo.GameID = nGameID;
    roomInfo.ZoneID = nZoneID;
    roomInfo.RoomID = nRoomID;

	m_mapSessionConns[roomInfo] = std::make_pair(pConn, pCallback);
}

void GameSessionMgr::RemoveSessionConnection(short nGameID, short nZoneID, short nRoomID)
{
    GAMEROOM roomInfo;
    roomInfo.GameID = nGameID;
    roomInfo.ZoneID = nZoneID;
    roomInfo.RoomID = nRoomID;

	m_mapSessionConns.erase(roomInfo);
}

BOOL GameSessionMgr::QueryRoomInfoByConnID(int nConnID, GAMEROOM& roomInfo)
{
	bool bFound = false;
	roomInfo.GameID = roomInfo.ZoneID = roomInfo.RoomID = (unsigned short)-1;

	LOG_INFO("try to query room info by connID " << nConnID );
	for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
	{
		ISessionConnection* pConn = it->second.first;
		if(pConn->GetConnectionID() == nConnID)
		{
			GAMEROOM room = it->first;
            roomInfo = room;

			LOG_INFO("successfully query room info: GameID=" << roomInfo.GameID << ", ZoneID=" << roomInfo.ZoneID << ", RoomID=" << roomInfo.RoomID );

			bFound = true;
			break;
		}
	}

	return bFound;
}

void GameSessionMgr::RemoveSessionConnection(int nConnID)
{
	bool removed = false;
	LOG_INFO("try to remove connection(connID=" << nConnID << ", count of connections in GameSessionMgr is: " << (int)m_mapSessionConns.size());
	for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
	{
		ISessionConnection* pConn = it->second.first;
		if(pConn->GetConnectionID() == nConnID)
		{
			m_mapSessionConns.erase(it);
			LOG_INFO("Session connection removed now, count of connections in GameSessionMgr is: " << (int)m_mapSessionConns.size());
			removed = true;
			break;
		}
	}
}

ISessionConnection* GameSessionMgr::FindSessionConnection(short nGameID, short nZoneID, short nRoomID)
{
    GAMEROOM roomInfo;
    roomInfo.GameID = nGameID;
    roomInfo.ZoneID = nZoneID;
    roomInfo.RoomID = nRoomID;

	std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::iterator it = m_mapSessionConns.find(roomInfo);
	if(it != m_mapSessionConns.end())
	{
        LOG_INFO("FindSessionConnection - (GameID=" << it->first.GameID << ", ZoneID=" << it->first.ZoneID << ", RoomID=" << it->first.RoomID << ") found");
		return it->second.first;
	}
	else
	{
		return NULL;
	}
}

ISessionConnection* GameSessionMgr::FindSessionConnection(int nConnID)
{
	int i = 0;
	for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::const_iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
	{
		ISessionConnection* pConn = it->second.first;
		LOG_DEBUG("#" << i << ": ConnectionID=" << pConn->GetConnectionID());
		if(pConn->GetConnectionID() == nConnID)
		{
			return pConn;
		}
		i++;
	}

	return NULL;
}

ISessionCallback* GameSessionMgr::FindSessionCallback(int nConnID)
{
	for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::const_iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
	{
		ISessionConnection* pConn = it->second.first;
		ISessionCallback* pCallback = it->second.second;
		if(pConn->GetConnectionID() == nConnID)
		{
			return pCallback;
		}
	}

	return NULL;
}

BOOL GameSessionMgr::IsSessionConnExists(int nConnID)
{
	for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::const_iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
	{
		ISessionConnection* pConn = it->second.first;
		if(pConn->GetConnectionID() == nConnID)
		{
			return TRUE;
		}
	}

	return FALSE;
}

BOOL GameSessionMgr::IsSameGameSessionConnExist(short nGameID)
{
    GAMEROOM roomInfo;
    for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::const_iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
    {
        GameSession* pHandler = (GameSession*)it->second.second;
        if(pHandler)
        {
            pHandler->GetRoomInfo(roomInfo);

            if((short)(roomInfo.GameID) == nGameID)
            {
                return TRUE;
            }
        }
    }

    return FALSE;
}

ISessionCallback* GameSessionMgr::FindFirstGameRoomByGameID(short nGameID)
{
    GAMEROOM roomInfo;
    for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::const_iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
    {
        GameSession* pHandler = (GameSession*)it->second.second;
        if(pHandler)
        {
            pHandler->GetRoomInfo(roomInfo);

            if((short)(roomInfo.GameID) == nGameID)
            {
                return pHandler;
            }
        }
    }

    return NULL;
}

BOOL GameSessionMgr::IsGameRuning(short nGameID)
{
	/*
    if(nGameID == -1)
    {
        return (m_mapSessionConns.empty() ? FALSE : TRUE);
    }

    GAMEROOM roomInfo;
    BOOL bFound = FALSE;
    for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::const_iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
    {
        GameSession* pHandler = (GameSession*)it->second.second;
        if(pHandler)
        {
            pHandler->GetRoomInfo(roomInfo);
            PDataX dxMyInfo = PDataX::GetDataCenter()[DataID_LoginInfo];

            bFound = pHandler->GetPlayerInfo(g_nLoginUserID, &dxMyInfo);

            if( bFound &&
                (short)(roomInfo.GameID) == nGameID &&
                dxMyInfo[DataID_UserStatus] != STANDUP )
            {
                return TRUE;
            }
        }
    }
    */

    return FALSE;
}

ISessionCallback* GameSessionMgr::GetSessionCallbackHandle()
{
    for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::const_iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
    {
        ISessionCallback* pHandler = (it->second.second);
        return pHandler;
    }

    return NULL;
}

void GameSessionMgr::ExitAllRoom()
{
    for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::const_iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
    {
        GameSession* pHandler = (GameSession*)(it->second.second);
        if(pHandler != NULL)
        {
            GAMEROOM roomInfo;
            pHandler->GetRoomInfo(roomInfo);
            ISessionConnectionEx* pConnEx = static_cast<ISessionConnectionEx*>(it->second.first);
            pConnEx->ExitRoom(roomInfo);
        }
    }
}

void GameSessionMgr::NotifyEvent2Game(const char* szEvent, IDataXNet* pDx)
{
    for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::const_iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
    {
        GameSession* pHandler = (GameSession*)(it->second.second);
        if(pHandler != NULL)
        {
            pHandler->NotifyEvent2Game(szEvent, pDx);
        }
    }
}

void GameSessionMgr::ClearAllConnection()
{
    ISessionConnection* pConn = NULL;
    ISessionCallback* pCallback = NULL;

    for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
    {
        pConn = it->second.first;
        if(pConn)
        {
            pConn->Close();
        }

        pCallback = it->second.second;
        if(pCallback != NULL)
        {
            delete pCallback;
            pCallback = NULL;
        }
    }

    m_mapSessionConns.clear();
}

void GameSessionMgr::ReportUserInfo( LONG lScore, string& sRank )
{
    if(m_mapSessionConns.empty())
    {
        return;
    }

    ISessionConnection* pConn = NULL;
    GameSession* pHandler = NULL;
    GAMEROOM roomInfo;

    for(std::map<GAMEROOM, std::pair<ISessionConnection*, ISessionCallback*> >::iterator it = m_mapSessionConns.begin(); it != m_mapSessionConns.end(); it++)
    {
        pConn = it->second.first;
        if(!pConn)
        {
            continue;
        }

        pHandler = (GameSession*)(it->second.second);
        pHandler->GetRoomInfo(roomInfo);

        IDataXNet* pDataXNet = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
        pDataXNet->PutInt(DataID_UserScore, lScore);
        pDataXNet->PutUTF8String(DataID_UserRankName, (byte*)sRank.c_str(), ((int)sRank.length()+1));
        pConn->SendGenericCmd("ReportUserInfoReq", roomInfo, pDataXNet);
    }
}

size_t GameSessionMgr::GetSessionConnSize()
{
    return m_mapSessionConns.size();
}
