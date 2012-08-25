#ifndef __GAME_DIR_INFO_MANAGER_H_20090228
#define __GAME_DIR_INFO_MANAGER_H_20090228

#include <string>
#include <vector>
#include <map>
#include "common/common.h"
#include "XMLParser/tinyxml.h"
#include "common/GNInterface.h"

using std::string;
using std::vector;

class TiXmlElement;

enum enumGameType
{
    XLGT_NORMAL_MINIGAME = 0,
    XLGT_HAPPY_MINIGAME,
    XLGT_COUNT,
};

enum enumEnterType
{
	EnterType_NO_LIMIT = 0,
	EnterType_LOGIN    = 1,
	EnterType_GUEST    = 2,
	EnterType_VIP      = 3,
	EnterType_NO_CHEAT = 4,
	EnterType_MATCH    = 5,
	EnterType_IngotMATCH = 7,
};

enum XML_RESP_TYPE
{
	RESP_UNKNOWN = 0,
	RESP_GAME_DIR = 1,
	RESP_ONLINE_NUM = 2,
	RESP_SERVER_CFG = 3,
	RESP_NEW_HALL_VER = 4,
	RESP_QUERY_SUITED_ZOONS = 5,
	RESP_RECOMMEND_GAMES = 6,
	RESP_GAME_LEVEL_DIR = 7,
	RESP_ZONE_LEVEL_DIR = 8,
	RESP_ROOM_LEVEL_DIR = 9,
};

struct GameRoomDetail
{
	GAMEROOM roominfo;
	string 	 sServer;
	string   sRoomName;
	string   sZoneName;
	string   sDualIP;
	int      nPort;
};

class GameDirInfoMgr
{
	GameDirInfoMgr(void);
public:
	~GameDirInfoMgr();
	static GameDirInfoMgr* GetInstance();
	
    int 		GetXmlInfoType(const std::string& strGameInfoXml, XML_RESP_TYPE& respType, std::string& strRet);
    void 		SetQuerySuitedZoonsInfo(const std::string& strGameInfoXml);

public:
    IDataXNet*  GetSuitedZoonsDataX() { return m_dxSuitedZoonsInfo; }
    bool 		GetRoomInfo(int nGameID, int nZoneID, int nRoomID, GameRoomDetail& ret);
    bool 		GetRoomInfo(const GAMEROOM& roomInfo, GameRoomDetail& ret);

private:
    void 		FillSuitedZoonsInfo(TiXmlElement* pRootElement);

private:
    typedef std::map<GAMEROOM, GameRoomDetail> GameRoomInfoMap;
    IDataXNet* 	m_dxSuitedZoonsInfo;
    GameRoomInfoMap m_mapGameRoomInfo;
	DECL_LOGGER;
};

#endif // __GAME_DIR_INFO_MANAGER_H_20090228
