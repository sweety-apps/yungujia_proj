
#include "CmdNonSessionDx.h"
#include "common/GameNetInf.h"
#include "DataXImpl.h"
#include "DataID.h"

//================================================================================================
//======================| CmdNonSessionDataX implementation |=====================================
//================================================================================================

IMPL_LOGGER(CmdNonSessionDataX);

const char* CmdNonSessionDataX::GAME_CMD_NAME = "NonSessionDataX";

CmdNonSessionDataX::CmdNonSessionDataX()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_NONSESSION_DATAX;

	m_pDataX = NULL;
}

CmdNonSessionDataX::~CmdNonSessionDataX()
{
	LOG_DEBUG("CmdNonSessionDataX dtor() called.");
	if(m_pDataX)
	{
		LOG_DEBUG("CmdNonSessionDataX dtor(): m_pDataX be deleted.");
		delete m_pDataX;
	}
}

const char* CmdNonSessionDataX::CmdName()
{
	if(m_cmdName.empty())
		return GAME_CMD_NAME;
	else
		return (char*)m_cmdName.c_str();
}


void CmdNonSessionDataX::SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership)
{
	if(pDataX == NULL)
		return;

	if(bGiveupOwnership)
		m_pDataX = pDataX;
	else
		m_pDataX = pDataX->Clone();
}

IDataXNet* CmdNonSessionDataX::GetDataXParam(bool bNeedClone)
{
	if(m_pDataX == NULL)
		return NULL;
	else
		return bNeedClone ? m_pDataX->Clone() : m_pDataX;
}

IDataXNet* CmdNonSessionDataX::DetachDataXParam()
{
	IDataXNet* pDx = m_pDataX;
	m_pDataX = NULL;
	return pDx;
}

void CmdNonSessionDataX::desc_parameters(std::string &str)
{
	char buffer[4096];

//	LOG_DEBUG("enter desc_parameters().");

	snprintf(buffer, sizeof(buffer), "[CmdName=%s, cmdSrcID=%d,  Params=%s]",
		m_cmdName.c_str(),
		m_nCmdSrcID,
		m_pDataX == NULL ? "" : m_pDataX->ToString().c_str());

//	LOG_DEBUG("exit desc_parameters().");

	str = buffer;
}

void CmdNonSessionDataX::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);
	
	fixed_buffer.put_int(m_nCmdSrcID);
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

void CmdNonSessionDataX::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_nCmdSrcID = fixed_buffer.get_int();
	m_cmdName = fixed_buffer.get_string();

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

unsigned long CmdNonSessionDataX::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(int)); // m_nCmdSrcID
	m_package_header.BodyLen += (sizeof(int) + m_cmdName.length()); // m_cmdName
	if(m_pDataX)
		m_package_header.BodyLen += m_pDataX->EncodedLength();

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

BOOL CmdNonSessionDataX::IsGameTableAcceptCmd(int nTableID)
{

	return TRUE;
}

bool CmdNonSessionDataX::CloneBody( GameCmdBase* pResultCmd )
{
    CmdNonSessionDataX* pCmd = dynamic_cast<CmdNonSessionDataX*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_nCmdSrcID = m_nCmdSrcID;
    pCmd->m_cmdName   = m_cmdName;
    pCmd->m_pDataX    = m_pDataX->Clone();

    return true;
}

bool CmdNonSessionDataX::IsCoupleRespCmd( IGameCommand* pCmd )
{
    return (pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_NONSESSION_DATAX_RESP) && 
        strncasecmp(m_cmdName.c_str(), pCmd->CmdName(), max(0, m_cmdName.length()-3)) == 0 );
}

//================================================================================================
//===================| CmdNonSessionDataXResp implementation |====================================
//================================================================================================

IMPL_LOGGER(CmdNonSessionDataXResp);

const char* CmdNonSessionDataXResp::GAME_CMD_NAME = "NonSessionDataXResp";

CmdNonSessionDataXResp::CmdNonSessionDataXResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_NONSESSION_DATAX_RESP;

	m_pDataX = NULL;
}

CmdNonSessionDataXResp::~CmdNonSessionDataXResp()
{
	LOG_DEBUG("CmdNonSessionDataXResp dtor() called.");

	if(m_pDataX)
	{
		LOG_DEBUG("CmdNonSessionDataXResp dtor(): m_pDataX be deleted.");
		delete m_pDataX;
		m_pDataX = NULL;
	}
}

const char* CmdNonSessionDataXResp::CmdName()
{
	if(m_cmdName.empty())
		return GAME_CMD_NAME;
	else
		return (char*)m_cmdName.c_str();
}

void CmdNonSessionDataXResp::SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership)
{
	if(pDataX == NULL)
		return;

	if(bGiveupOwnership)
		m_pDataX = pDataX;
	else
		m_pDataX = pDataX->Clone();
}

IDataXNet* CmdNonSessionDataXResp::GetDataXParam(bool bNeedClone)
{
	if(m_pDataX == NULL)
		return NULL;
	else
		return bNeedClone ? m_pDataX->Clone() : m_pDataX;
}

IDataXNet* CmdNonSessionDataXResp::DetachDataXParam()
{
	LOG_DEBUG("DetachDataXParam() called.");

	IDataXNet* pDx = m_pDataX;
	m_pDataX = NULL;
	return pDx;
}

void CmdNonSessionDataXResp::desc_parameters(std::string &str)
{
	char buffer[2048];

	LOG_DEBUG("desc_parameters() called.");

	char* char_ptr = buffer;
	char_ptr += sprintf(char_ptr,  "[CmdName=%s, cmdSrcID=%d,  Result=%d, Params=]",
		m_cmdName.c_str(),
		m_nCmdSrcID,
		m_nResult); 
//		m_pDataX == NULL ? "" : m_pDataX->ToString().c_str());

	//std::stringstream sStream;
	//sStream << buffer;
	//if(m_pDataX != NULL)
	//	sStream << m_pDataX->ToString();

	//str = sStream.str();
	str = buffer;
}

void CmdNonSessionDataXResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_int(m_nCmdSrcID);
	fixed_buffer.put_string(m_cmdName);
	fixed_buffer.put_int(m_nResult);

	int nCurPos = fixed_buffer.position();
	int nBuffSize = 0;
	if(m_nResult == 0)
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

void CmdNonSessionDataXResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_nCmdSrcID = fixed_buffer.get_int();
	m_cmdName = fixed_buffer.get_string();
	m_nResult = fixed_buffer.get_int();

	if(m_nResult != 0)
	{
		return;
	}

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

	if(m_pDataX)
	{
		m_pDataX->PutInt(DataID_CmdSrcID, m_nCmdSrcID);
	}

	LOG_DEBUG("decode_parameters(): m_pDataX is NULL ? " << (m_pDataX == NULL ? "true":"false"));
}

unsigned long CmdNonSessionDataXResp::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(int)); // m_nCmdSrcID
	m_package_header.BodyLen += (sizeof(int) + m_cmdName.length()); // m_cmdName
	m_package_header.BodyLen += (sizeof(int)); // m_nResult
	if(m_pDataX)
		m_package_header.BodyLen += m_pDataX->EncodedLength();

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}

BOOL CmdNonSessionDataXResp::IsGameTableAcceptCmd(int nTableID)
{

	return TRUE;
}
