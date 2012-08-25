#include "gamedirinfomgr.h"
#include "GameNet/command/DataID.h"
#include "common/setting.h"
#include "HallContext.h"
#include "HallLogic.h"
#include "GameSessionMgr.h"
#include <zlib.h>
#include "JniHelper.h"

#define DIR_RC1 0x584C4741
#define DIR_RC2 0x4D454458

IMPL_LOGGER(GameDirInfoMgr);

GameDirInfoMgr::GameDirInfoMgr(void)
{
	m_dxSuitedZoonsInfo = NULL;
}

GameDirInfoMgr::~GameDirInfoMgr()
{
	IGameUtility* pGameUtil = CHallContext::GetInstance()->GetGameUtility();
	if(m_dxSuitedZoonsInfo) pGameUtil->DeleteDataX(m_dxSuitedZoonsInfo);
}

GameDirInfoMgr* GameDirInfoMgr::GetInstance()
{
	static GameDirInfoMgr _instance;
	return &_instance;
}

int GameDirInfoMgr::GetXmlInfoType(const std::string& strGameInfoXml,
		XML_RESP_TYPE& respType, std::string& strRet)
{
	LOG_TRACE("GetXmlInfoType entrance, xml=" << strGameInfoXml);

	strRet = "";

    TiXmlDocument xmlDoc("");
    xmlDoc.Parse(strGameInfoXml.c_str(), NULL);

    if(xmlDoc.Error())
    {
        LOG_ERROR("GetXmlInfoType Parse game dir-server XML response error!");
		xmlDoc.Clear();
        return 0;
    }	

    TiXmlElement* pNodeResult = TiXmlHandle(xmlDoc.RootElement()).FirstChildElement("params").FirstChildElement("result").ToElement();
    if(pNodeResult == NULL)
    {
        LOG_ERROR("Can not find 'params\result' node in XML response!");
		xmlDoc.Clear();
        return 0;
    }

	const char* lpText = pNodeResult->GetText();
	if (lpText)
		strRet = lpText;

    TiXmlElement*  pNodeMethodName = TiXmlHandle(xmlDoc.RootElement()).FirstChildElement("methodName").ToElement();
    if(pNodeMethodName == NULL)
    {
        LOG_ERROR("GetXmlInfoType No methodName node!");
		xmlDoc.Clear();
        return 0;
    }

    string strMethodName = pNodeMethodName->GetText();
    LOG_DEBUG("GetXmlInfoType methodName=" << strMethodName);
    
    INT nRet = 1;
    if(!strRet.empty() && strRet != "0")
    {
        LOG_ERROR("Result in XML response is: " << strRet << ", not 0!");
        nRet = 0;
    }   
	
	if(strMethodName == "getClass")
	{
		respType = RESP_GAME_DIR;
	}
	else if (strMethodName == "getGames")
	{
		respType = RESP_GAME_LEVEL_DIR;
	}
	else if (strMethodName == "getZones")
	{
		respType = RESP_ZONE_LEVEL_DIR;
	}
	else if (strMethodName == "getRooms")
	{
		respType = RESP_ROOM_LEVEL_DIR;
	}
	else if(strMethodName == "getOnlineNum")
	{
		respType = RESP_ONLINE_NUM;
	}
	else if(strMethodName == "getServerConfig")
	{
		respType = RESP_SERVER_CFG;
	}
	else if(strMethodName == "queryNewHallVersion")
	{
		respType = RESP_NEW_HALL_VER;
	}
	else if(strMethodName == "querySuitedZoons")
	{
        respType = RESP_QUERY_SUITED_ZOONS;
	}
	else if(strMethodName == "getRecommendGames")
	{
		respType = RESP_RECOMMEND_GAMES;
	}
	else
	{
        respType = RESP_UNKNOWN;
		LOG_ERROR("GetXmlInfoType unknown methodName!!");
	}
	
	if(!strRet.empty() && strRet != "0")
	{
		nRet = 0;
	}
	else
	{
		nRet = respType;
	}
	LOG_DEBUG("GetXmlInfoType returns "<< nRet);
	xmlDoc.Clear();
	return nRet;
}

void GameDirInfoMgr::SetQuerySuitedZoonsInfo(const std::string& strGameInfoXml)
{
    LOG_INFO("SetQuerySuitedZoonsInfo xml="<<strGameInfoXml);
    TiXmlDocument xmlDoc("");
	xmlDoc.Parse(strGameInfoXml.c_str(), NULL);
	if(xmlDoc.Error())
	{
		LOG_ERROR("SetQuerySuitedZoonsInfo() parse XML failed");
		xmlDoc.Clear();
		return;
	}

    FillSuitedZoonsInfo(xmlDoc.RootElement());
	xmlDoc.Clear();
}

void GameDirInfoMgr::FillSuitedZoonsInfo(TiXmlElement* pRootElement)
{
    if(pRootElement == NULL)
        return;

    TiXmlElement* pGameRooms = TiXmlHandle(pRootElement).FirstChildElement("params").FirstChildElement("gameRooms").ToElement();
    if(pGameRooms == NULL)
    {
        LOG_ERROR("Can not find 'params\\gameRooms' node in XML response!");
        return;
    }

    TiXmlElement* pParams = TiXmlHandle(pRootElement).FirstChildElement("params").ToElement();

    if(!m_dxSuitedZoonsInfo)
    {
    	m_dxSuitedZoonsInfo = CHallContext::GetInstance()->GetGameUtility()->CreateDataX();
    }

    m_dxSuitedZoonsInfo->Clear();
    TiXmlElement* pNodeItem = pGameRooms->FirstChildElement();

    GameRoomDetail detail;

    TiXmlElement* pGameID = pParams->FirstChildElement("gameId");
	if(pGameID)
	{
		detail.roominfo.GameID = atol(pGameID->GetText());
		m_dxSuitedZoonsInfo->PutInt(DataID_GameID, detail.roominfo.GameID);
	}

	TiXmlElement* pResult = pParams->FirstChildElement("result");
	if(pResult)
	{
		m_dxSuitedZoonsInfo->PutInt(DataID_Result, atol(pResult->GetText()));
	}

    TiXmlElement* pRoomID = pNodeItem->FirstChildElement("roomId");
    if(pRoomID)
    {
    	detail.roominfo.RoomID = atol(pRoomID->GetText());
    	m_dxSuitedZoonsInfo->PutInt(DataID_RoomID, detail.roominfo.RoomID);
    }

    TiXmlElement* pZoneID = pNodeItem->FirstChildElement("zoneId");
    if(pZoneID)
    {
    	detail.roominfo.ZoneID = atol(pZoneID->GetText());
    	m_dxSuitedZoonsInfo->PutInt(DataID_ZoneID, detail.roominfo.ZoneID);
    }

    TiXmlElement* pNodeServer = pNodeItem->FirstChildElement("server");
    if(pNodeServer )
    {
    	detail.sServer = pNodeServer->Attribute("ip");
    	m_dxSuitedZoonsInfo->PutUTF8String(DataID_RoomServer, (const byte*)detail.sServer.c_str(), detail.sServer.length()+1);

    	detail.nPort = atol(pNodeServer->Attribute("port"));
    	m_dxSuitedZoonsInfo->PutInt(DataID_RoomPort, detail.nPort);
    }

    TiXmlElement* pRoomName = pNodeItem->FirstChildElement("roomName");
    if(pRoomName)
    {
    	detail.sRoomName = pRoomName->GetText();
    	m_dxSuitedZoonsInfo->PutUTF8String(DataID_RoomName, (const byte*)detail.sRoomName.c_str(), detail.sRoomName.length()+1);
    }

    GameRoomInfoMap::iterator it = m_mapGameRoomInfo.find(detail.roominfo);
	if(it == m_mapGameRoomInfo.end())
	{
		m_mapGameRoomInfo.insert(GameRoomInfoMap::value_type(detail.roominfo, detail));
	}
}

bool GameDirInfoMgr::GetRoomInfo(int nGameID, int nZoneID, int nRoomID, GameRoomDetail& ret)
{
	GAMEROOM roomInfo;
	roomInfo.GameID = nGameID;
	roomInfo.ZoneID = nZoneID;
	roomInfo.RoomID = nRoomID;

	return GetRoomInfo(roomInfo, ret);
}
bool GameDirInfoMgr::GetRoomInfo(const GAMEROOM& roomInfo, GameRoomDetail& ret)
{
	GameRoomInfoMap::iterator it = m_mapGameRoomInfo.find(roomInfo);
	if(it == m_mapGameRoomInfo.end())
	{
		return false;
	}

	ret = it->second;
	return true;
}
