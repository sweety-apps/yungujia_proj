
#include "CmdGameSvrDx.h"
#include "common/GameNetInf.h"
#include "DataXImpl.h"
#include "common/DxNetWrapper.h"
#include "DataID.h"

//================================================================================================
//========================| CmdGameSvrDataX implementation |========================================
//================================================================================================

IMPL_LOGGER(CmdGameSvrDataX);

const char* CmdGameSvrDataX::GAME_CMD_NAME = "GameSvrDataX";

CmdGameSvrDataX::CmdGameSvrDataX()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_GAMESVR_DATAX;
    m_package_header.ProtocolVer = 12;

	m_pDataX = NULL;
}

CmdGameSvrDataX::~CmdGameSvrDataX()
{
	if(m_pDataX)
	{
		delete m_pDataX;
	}
}

const char* CmdGameSvrDataX::CmdName()
{
	if(m_cmdName.empty())
		return GAME_CMD_NAME;
	else
		return (char*)m_cmdName.c_str();
}


void CmdGameSvrDataX::SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership)
{
	if(pDataX == NULL)
		return;

	if(bGiveupOwnership)
		m_pDataX = pDataX;
	else
		m_pDataX = pDataX->Clone();
}

IDataXNet* CmdGameSvrDataX::GetDataXParam(bool bCopy)
{
	if(m_pDataX == NULL)
		return NULL;
	else
		return bCopy ? m_pDataX->Clone() : m_pDataX;
}

IDataXNet* CmdGameSvrDataX::DetachDataXParam()
{
	IDataXNet* pDx = m_pDataX;
	m_pDataX = NULL;
	return pDx;
}

void CmdGameSvrDataX::desc_parameters(std::string &str)
{
	char buffer[2048];

	snprintf(buffer, sizeof(buffer), "[CmdName=%s, GameID=%d, ZoneID=%d, RoomID=%d, Params=%s]",
		m_cmdName.c_str(),
		m_roomInfo.GameID,
		m_roomInfo.ZoneID,
		m_roomInfo.RoomID,
		m_pDataX == NULL ? "NULL" : m_pDataX->ToString().c_str());

	str = buffer;
}

void CmdGameSvrDataX::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_roomInfo.GameID);
	fixed_buffer.put_short(m_roomInfo.ZoneID);
	fixed_buffer.put_short(m_roomInfo.RoomID);
	fixed_buffer.put_string(m_cmdName);

	int nCurPos = fixed_buffer.position();
	byte* pBuf = (byte*)buff + nCurPos;
	int nBuffSize = fixed_buffer.remain_len();
	if(m_pDataX)
		m_pDataX->Encode(pBuf,nBuffSize);
	else
		nBuffSize = 0;

	buff_size = nCurPos + nBuffSize; // fixed_buffer.position();
}

void CmdGameSvrDataX::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

//	LOG_DEBUG("decode_parameters(): buff_size=" << buff_size);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

//	LOG_DEBUG("decode_parameters(): m_userid=" << m_userid);

	m_roomInfo.GameID = fixed_buffer.get_short();
	m_roomInfo.ZoneID = fixed_buffer.get_short();
	m_roomInfo.RoomID = fixed_buffer.get_short();
	m_cmdName = fixed_buffer.get_string();

	int nCurPos = fixed_buffer.position();
	byte * pBuf = (byte*)buff + nCurPos;
	int nDxBufferLen = fixed_buffer.remain_len();
	IDataXNet* pDataX = DataXImpl::DecodeFrom(pBuf, nDxBufferLen);
	if(pDataX == NULL)
	{
		LOG_WARN("pDataX is NULL in decode_parameters().");
	}
	if(m_pDataX)
	{
		delete m_pDataX;
		m_pDataX = NULL;
	}
	m_pDataX = pDataX;
}

unsigned long CmdGameSvrDataX::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 3); // m_roomInfo
	m_package_header.BodyLen += (sizeof(int) + m_cmdName.length()); // m_cmdName
	if(m_pDataX)
		m_package_header.BodyLen += m_pDataX->EncodedLength();

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

BOOL CmdGameSvrDataX::IsGameTableAcceptCmd(int nTableID)
{
	BOOL bAccepted = TRUE;
	LOG_DEBUG("IsGameTableAcceptCmd() called.");
	if(strcasecmp(m_cmdName.c_str(),"NotifyUserStatusReq") == 0)
	{
		DxNetWrapper wrapper(m_pDataX);

		unsigned short nNotifyTableID = (unsigned short)wrapper.GetShort(DataID_TableID, -1);
		LOG_DEBUG("IsGameTableAcceptCmd('NotifyUserStatusReq'): tableID1=" << nTableID << ", tableID2=" << nNotifyTableID);

		bAccepted = (nNotifyTableID == nTableID);
	}
	else if(strcasecmp(m_cmdName.c_str(),"ChatNotifyReq") == 0)
	{
		DxNetWrapper wrapper(m_pDataX);

		unsigned short nNotifyTableID = (unsigned short)wrapper.GetShort(DataID_TableID, -1);
		LOG_DEBUG("IsGameTableAcceptCmd('ChatNotifyReq'): tableID1=" << nTableID << ", tableID2=" << nNotifyTableID << ", (unsigned short)-1=" << (unsigned short)-1);

		bAccepted = (nNotifyTableID == nTableID || nNotifyTableID == (unsigned short)-1 || nTableID == (unsigned short)-1);
	}    
    else if(strcasecmp(m_cmdName.c_str(), "NotifyUserInfoReq") == 0)
    { 
		XLUSERID userid = 0;
		m_pDataX->GetInt64(DataID_UserID, userid);
		if(userid == g_nUserID && g_nUserID != -1)
		{
			bAccepted = TRUE;
		}
		else
		{
			DxNetWrapper wrapper(m_pDataX);
			unsigned short nNotifyTableID = (unsigned short)wrapper.GetShort(DataID_TableID, -1);
			LOG_DEBUG("IsGameTableAcceptCmd('NotifyUserInfoReq'): tableID1=" << nTableID << ", tableID2=" << nNotifyTableID << ", (unsigned short)-1=" << (unsigned short)-1);

			bAccepted = (nNotifyTableID == nTableID);
		}
    }
    else if(strcasecmp(m_cmdName.c_str(), "NotifyUserScoreChangeReq") == 0)
    {
        bAccepted = FALSE;

        int nPlayers = 0;
        bool bRet = m_pDataX->GetDataXArraySize(DataID_Param1, nPlayers);
        if(!bRet)
        {
            LOG_ERROR("CmdGameSvrDataX::IsGameTableAcceptCmd: can't get tableplayer count!");
            return FALSE;
        }

        for(int i = 0; i < nPlayers; i++)
        {
            IDataXNet* pDataXNet = NULL;
            bRet = m_pDataX->GetDataXArrayElement(DataID_Param1, i, &pDataXNet);

            if(!bRet)
            {
                LOG_WARN("IsGameTableAcceptCmd - can not get playerinfo (" << i << ")");
                continue;
            }

            short nNotifyTableID = -1;
            pDataXNet->GetShort(DataID_TableID, nNotifyTableID);

			XLUSERID userid = 0;
			pDataXNet->GetInt64(DataID_UserID, userid);

            LOG_DEBUG("IsGameTableAcceptCmd - NotifyUserScoreChangeReq - my table id=" << nTableID << ", notify table id=" << nNotifyTableID
				<< ", userid=" << userid);

            if(nTableID == nNotifyTableID)
            {
                bAccepted = TRUE;
                break;
            }
			else if(userid == g_nUserID && g_nUserID != -1)
			{
				bAccepted = TRUE;
				break;
			}
        }
    } 
	else if(strcasecmp(m_cmdName.c_str(), "NotifyMagicToolChangeReq") == 0)
	{
		XLUSERID userid = 0;
		m_pDataX->GetInt64(DataID_UserID, userid);
		if(userid == g_nUserID && g_nUserID != -1)
		{
			bAccepted = TRUE;
		}
	}
	
    LOG_DEBUG("IsGameTableAcceptCmd cmd name=" << m_cmdName.c_str() << " bAccepted=" << bAccepted);

	return bAccepted;
}

bool CmdGameSvrDataX::CloneBody( GameCmdBase* pResultCmd )
{
    CmdGameSvrDataX* pCmd = dynamic_cast<CmdGameSvrDataX*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_roomInfo = m_roomInfo;
    pCmd->m_cmdName = m_cmdName;
    pCmd->m_pDataX = m_pDataX->Clone();

    return true;
}

bool CmdGameSvrDataX::IsCoupleRespCmd( IGameCommand* pCmd )
{ 
    if( pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_GAMESVR_DATAX_RESP) &&
        strncasecmp(m_cmdName.c_str(), pCmd->CmdName(), max(0, m_cmdName.length()-3)) == 0 )
    {
        return true;
    }

    return false;
}

//================================================================================================
//===================| CmdGameSvrDataXResp implementation |=======================================
//================================================================================================

IMPL_LOGGER(CmdGameSvrDataXResp);

const char* CmdGameSvrDataXResp::GAME_CMD_NAME = "GameSvrDataXResp";

CmdGameSvrDataXResp::CmdGameSvrDataXResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_GAMESVR_DATAX_RESP;
    m_package_header.ProtocolVer = 12;

	m_pDataX = NULL;
}

CmdGameSvrDataXResp::~CmdGameSvrDataXResp()
{
	if(m_pDataX)
	{
		delete m_pDataX;
		m_pDataX = NULL;
	}
}

const char* CmdGameSvrDataXResp::CmdName()
{
	if(m_cmdName.empty())
		return GAME_CMD_NAME;
	else
		return (char*)m_cmdName.c_str();
}

void CmdGameSvrDataXResp::SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership)
{
	if(pDataX == NULL)
		return;

	if(bGiveupOwnership)
		m_pDataX = pDataX;
	else
		m_pDataX = pDataX->Clone();
}

IDataXNet* CmdGameSvrDataXResp::GetDataXParam(bool bCopy)
{
	if(m_pDataX == NULL)
		return NULL;
	else
		return bCopy ? m_pDataX->Clone() : m_pDataX;
}

IDataXNet* CmdGameSvrDataXResp::DetachDataXParam()
{
	IDataXNet* pDx = m_pDataX;
	m_pDataX = NULL;
	return pDx;
}

void CmdGameSvrDataXResp::desc_parameters(std::string &str)
{
	char buffer[2048];

    snprintf(buffer, sizeof(buffer), "[CmdName=%s, Result=%d, Params=%s]",
        m_cmdName.c_str(),
        m_nResult,
        m_pDataX == NULL ? "" : m_pDataX->ToString().c_str());

	str = buffer;
}

void CmdGameSvrDataXResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_string(m_cmdName);
	fixed_buffer.put_int(m_nResult);

	int nCurPos = fixed_buffer.position();
	int nBuffSize = 0;
	//if(m_nResult == 0)
	{
		byte* pBuf = (byte*)buff + nCurPos;
		nBuffSize = fixed_buffer.remain_len();
		if(m_pDataX)
			m_pDataX->Encode(pBuf,nBuffSize);
		else
			nBuffSize = 0;
	}

	buff_size = nCurPos + nBuffSize; // fixed_buffer.position();
}

void CmdGameSvrDataXResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid
    
	m_cmdName = fixed_buffer.get_string();
	m_nResult = fixed_buffer.get_int();

	//if(m_nResult != 0)
	//{
	//	return;
	//}

	int nCurPos = fixed_buffer.position();
	byte * pBuf = (byte*)buff + nCurPos;
	int nDxBufferLen = fixed_buffer.remain_len();

	IDataXNet* pDataX = DataXImpl::DecodeFrom(pBuf, nDxBufferLen);
	if(m_pDataX)
	{
		delete m_pDataX;
		m_pDataX = NULL;
	}
	m_pDataX = pDataX;
}

unsigned long CmdGameSvrDataXResp::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(int) + m_cmdName.length()); // m_cmdName
	m_package_header.BodyLen += (sizeof(int)); // m_nResult
	if(m_pDataX)
		m_package_header.BodyLen += m_pDataX->EncodedLength();

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}

BOOL CmdGameSvrDataXResp::IsGameTableAcceptCmd(int nTableID)
{
	BOOL bAccepted = TRUE;
	if(strcasecmp(m_cmdName.c_str(),"TryEnterTableResp") == 0)
	{
		if(m_nResult != 0)
			bAccepted = FALSE;
		else
		{
			DxNetWrapper wrapper(m_pDataX);

			short nActionType = wrapper.GetShort(DataID_ActionType, -1);
			short nNotifyTableID = (unsigned short)wrapper.GetShort(DataID_TableID, -1);

			bAccepted = (nActionType == 2);
		}

	}

	return bAccepted;
}
