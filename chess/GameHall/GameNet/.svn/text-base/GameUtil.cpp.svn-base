#include "common/GameNetTypes.h"
#include "GameUtil.h"
#include "command/GameCmdBase.h"
#include "command/GameCmdFactory.h"
#include "command/DataXImpl.h"
#include "command/DataID.h"
#include "command/CmdNonSessionDx.h"
#include "command/CmdGameSvrDx.h"

IMPL_LOGGER(GameUtility);

GameUtility* GameUtility::GetInstance()
{
	static GameUtility _instance;
	return &_instance;
}

bool GameUtility::ANSI_to_UTF8(const char* pszSource, int nSrcLen, char* pszDest, int& nDestLen)
{
	memcpy(pszDest, pszSource, nSrcLen);
	nDestLen = nSrcLen;
	//TODO: implementation

	return false;
}

bool GameUtility::UTF8_to_ANSI(const char* pszSource, int nSrcLen, char* pszDest, int& nDestLen)
{
	memcpy(pszDest, pszSource, nSrcLen);
	nDestLen = nSrcLen;
	//TODO: implementation

	return false;
}

IGameCommand* GameUtility::DecodeCmd(const char* pDataBuf, int nDataLen)
{
	unsigned short cmd_typeid = GameCmdBase::parse_cmd_type((const unsigned char*)pDataBuf);
	IGameCommand* pCmd = GameCmdFactory::create_cmd_by_typeid(cmd_typeid);
	if(pCmd != NULL)
	{
		LOG_DEBUG(  "try to decode cmd: [" << pCmd->CmdName() << "], length:" << nDataLen);
		pCmd->Decode( pDataBuf, nDataLen );
	}

	return pCmd;
}


// 判断pCmd是否为nTableID对应游戏桌感兴趣的命令
// (大厅根据此结果来决定是否需要向游戏桌转发该命令)
BOOL GameUtility::IsGameTableAcceptCmd(IGameCommand* pCmd, int nTableID)
{
	if(pCmd == NULL)
		return FALSE;

	BOOL bRet = TRUE;

	LOG_DEBUG( "IsGameTableAcceptCmd() called, nTableID=" << nTableID << ", CmdName=" << pCmd->CmdName());

	GameCmdBase* pGameCmd = NULL;
	int nCmdType = pCmd->GetCmdType();
	switch(nCmdType)
	{
	case GameCmdFactory::CMD_ID_ENTERROOM_RESP:
	case GameCmdFactory::CMD_ID_ENTERTABLE_RESP:
	case GameCmdFactory::CMD_ID_ASKSTART_RESP:
	case GameCmdFactory::CMD_ID_QUITGAME_RESP:
	case GameCmdFactory::CMD_ID_EXITROOM_RESP:
	case GameCmdFactory::CMD_ID_CHAT_RESP:
	case GameCmdFactory::CMD_ID_CHAT_NOTIFY:
	case GameCmdFactory::CMD_ID_GAMEACTION_NOTIFY:
	case GameCmdFactory::CMD_ID_USERINFO_CHG_NOTIFY:
	case GameCmdFactory::CMD_ID_USERSCORE_CHG_NOTIFY:
	case GameCmdFactory::CMD_ID_USERSTATUS_CHG_NOTIFY:	
	case GameCmdFactory::CMD_ID_GAMESVR_DATAX:
	case GameCmdFactory::CMD_ID_GAMESVR_DATAX_RESP:
		pGameCmd = (GameCmdBase*)pCmd;
		bRet = pGameCmd->IsGameTableAcceptCmd(nTableID);

		break;
	default:
		LOG_DEBUG( "Unknown command type when IsGameTableAcceptCmd() called.");
	}

	LOG_DEBUG( "IsGameTableAcceptCmd() returns " << bRet);

	return bRet;
}

IDataXNet* GameUtility::CreateDataX()
{
	IDataXNet* pDataX =  new DataXImpl();
	LOG_DEBUG("CreateDataX() called, returned IDataX ptr is: " << pDataX);
	return pDataX;
}

void GameUtility::DeleteDataX(IDataXNet* pDataX)
{	
	LOG_DEBUG("DeleteDataX() called, IDataX ptr is: " << pDataX);
	if(pDataX == NULL)
		return;

	delete pDataX;
}

IDataXNet* GameUtility::DecodeDataX(const char* pDataBuf, int nDataLen)
{
	LOG_DEBUG("DecodeDataX() called, buffer length is " << nDataLen);

	if(pDataBuf == NULL || nDataLen < 1)
		return NULL;

	int nBufferLen = nDataLen;
	IDataXNet* pDx = DataXImpl::DecodeFrom((byte*)pDataBuf, nBufferLen);
	LOG_DEBUG("DecodeDataX(): returned IDataX ptr is " << pDx);

	return pDx;
}

IDataXNet* GameUtility::QueryCommandStatus(IGameCommand* pCmd, const char* pszQueryStr)
{
	LOG_DEBUG("QueryCommandStatus() called.");
	if(pCmd == NULL || pszQueryStr == NULL)
	{
		return NULL;
	}

	LOG_DEBUG("QueryCommandStatus(): cmdName=" << pCmd->CmdName() << ", QueryString=" << pszQueryStr);

	if(strcasecmp(pszQueryStr, "EnterGameRespResult") == 0)
	{
		IDataXNet* pDxRet = NULL;
		return pDxRet;
	}
	else if(strcasecmp(pszQueryStr, "UserScoreChangeUserID") == 0)
	{
        IDataXNet* pDxRet = NULL;
        return pDxRet;
	}
	else
	{
		LOG_WARN("Unknown QueryString: " << pszQueryStr << " when QueryCommandStatus() called.");
	}

	return NULL;
}

void GameUtility::SetPeerID(const char* szPeerID)
{
	m_sPeerID = szPeerID;
	LOG_INFO("peerid = " << m_sPeerID.c_str());
}

string GameUtility::GetPeerID()
{
	return m_sPeerID;
}

IGameCommand* GameUtility::CreateNonSessionDataXCmd(const char* cmdName, IDataXNet* pDataX, int nCmdSrcID)
{
	CmdNonSessionDataX* pCmd = new CmdNonSessionDataX();
	pCmd->m_cmdName = cmdName;
	pCmd->SetDataXParam(pDataX, true);
	pCmd->m_nCmdSrcID = nCmdSrcID;

	return pCmd;
}

BOOL GameUtility::GetPeerID2(char* pszBuffer, int& nBufferLen)
{
	// TODO
	return FALSE;
}

