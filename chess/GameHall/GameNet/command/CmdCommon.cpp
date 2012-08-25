#include "CmdCommon.h"
#include "common/GameNetInf.h"
#include "DataXImpl.h"
#include <string.h>
#include "DataID.h"

IMPL_LOGGER(CmdCommon);

CmdCommon::CmdCommon()
{
	m_cmd_typeid = 0;
	m_nCmdSrcID = 0;
	m_cmdName = "";
	m_pDataX = NULL;
}

CmdCommon::~CmdCommon()
{
	LOG_DEBUG("CmdCommon dtor() called.");
	if(m_pDataX)
	{
		LOG_DEBUG("CmdCommon dtor(): m_pDataX be deleted.");
		delete m_pDataX;
	}
}

void CmdCommon::SetCmdReqID(LONG lCmdReqID)
{
	m_cmd_typeid = (USHORT)lCmdReqID;
}

const char* CmdCommon::CmdName()
{
	return (char*)m_cmdName.c_str();
}


void CmdCommon::SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership)
{
	if(pDataX == NULL)
		return;

	if(bGiveupOwnership)
		m_pDataX = pDataX;
	else
		m_pDataX = pDataX->Clone();
}

IDataXNet* CmdCommon::GetDataXParam(bool bNeedClone)
{
	if(m_pDataX == NULL)
		return NULL;
	else
		return bNeedClone ? m_pDataX->Clone() : m_pDataX;
}

IDataXNet* CmdCommon::DetachDataXParam()
{
	IDataXNet* pDx = m_pDataX;
	m_pDataX = NULL;
	return pDx;
}

void CmdCommon::desc_parameters(std::string &str)
{
	char buffer[4096];

	snprintf(buffer, sizeof(buffer), "[CmdName=%s, cmdSrcID=%d,  Params=%s]",
		m_cmdName.c_str(),
		m_nCmdSrcID,
		m_pDataX == NULL ? "" : m_pDataX->ToString().c_str());

	str = buffer;
}

void CmdCommon::encode_parameters(void * buff, unsigned long &buff_size)
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

void CmdCommon::decode_parameters(const void * buff, unsigned long buff_size)
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

unsigned long CmdCommon::length_parameters()
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

BOOL CmdCommon::IsGameTableAcceptCmd(int nTableID)
{
	return TRUE;
}

bool CmdCommon::CloneBody( GameCmdBase* pResultCmd )
{
	CmdCommon* pCmd = dynamic_cast<CmdCommon*>(pResultCmd);
	if(!pCmd)
	{
		return false;
	}

	pCmd->m_nCmdSrcID = m_nCmdSrcID;
	pCmd->m_cmdName   = m_cmdName;
	pCmd->m_pDataX    = m_pDataX->Clone();

	return true;
}

bool CmdCommon::IsCoupleRespCmd( IGameCommand* pCmd )
{
	return (pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_TIMED_MATCH_DATAX_RESP) && 
		strncasecmp(m_cmdName.c_str(), pCmd->CmdName(), max(0, m_cmdName.length()-3)) == 0 );
}

//================================================================================================
//===================| CmdCommonResp implementation |====================================
//================================================================================================

IMPL_LOGGER(CmdCommonResp);

CmdCommonResp::CmdCommonResp()
{
	m_cmd_typeid = 0;
	m_nCmdSrcID = 0;
	m_cmdName = "";

	m_pDataX = NULL;
}

CmdCommonResp::~CmdCommonResp()
{
	LOG_DEBUG("CmdCommonResp dtor() called.");

	if(m_pDataX)
	{
		LOG_DEBUG("CmdCommonResp dtor(): m_pDataX be deleted.");
		delete m_pDataX;
		m_pDataX = NULL;
	}
}

void CmdCommonResp::SetCmdRespID(LONG lCmdRespID)
{
	m_cmd_typeid = (USHORT)lCmdRespID;
}

const char* CmdCommonResp::CmdName()
{
	return (char*)m_cmdName.c_str();
}

void CmdCommonResp::SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership)
{
	if(pDataX == NULL)
		return;

	if(bGiveupOwnership)
		m_pDataX = pDataX;
	else
		m_pDataX = pDataX->Clone();
}

IDataXNet* CmdCommonResp::GetDataXParam(bool bNeedClone)
{
	if(m_pDataX == NULL)
		return NULL;
	else
		return bNeedClone ? m_pDataX->Clone() : m_pDataX;
}

IDataXNet* CmdCommonResp::DetachDataXParam()
{
	LOG_DEBUG("DetachDataXParam() called.");

	IDataXNet* pDx = m_pDataX;
	m_pDataX = NULL;
	return pDx;
}

void CmdCommonResp::desc_parameters(std::string &str)
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

void CmdCommonResp::encode_parameters(void * buff, unsigned long &buff_size)
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

void CmdCommonResp::decode_parameters(const void * buff, unsigned long buff_size)
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

unsigned long CmdCommonResp::length_parameters()
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

BOOL CmdCommonResp::IsGameTableAcceptCmd(int nTableID)
{
	return TRUE;
}
