
#include "CmdGetDir.h"
#include <zlib.h>

//================================================================================================
//========================| CmdGetDir implementation |============================================
//================================================================================================

const char* CmdGetDir::GAME_CMD_NAME = "GetDir";

CmdGetDir::CmdGetDir()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_GETDIR;
}

void CmdGetDir::desc_parameters(std::string &str)
{
	str = "[request = ";
	str += m_request;
	str += "]";
}

void CmdGetDir::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);
	fixed_buffer.put_string(m_request);

	buff_size = fixed_buffer.position();
    
    if( m_request.find("<methodName>getClass</methodName>") != -1 || 
        m_request.find("<methodName>getOnlineNum</methodName>") != -1 ||
        m_request.find("<methodName>getServerConfig</methodName>") != -1)
    {
        m_package_header.CipherFlag = 2;
    }
}

void CmdGetDir::decode_parameters(const void * buff, unsigned long buff_size)
{
	ysh_assert("CmdGetDir::decode_parameters() not implemented" && false);
}

unsigned long CmdGetDir::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(int) + (unsigned int)m_request.length());

    switch(m_package_header.CipherFlag)
    {    
    case 1:
        return (m_package_header.BodyLen + 7)/8 * 8;
        break;

    case 2:
        {
            return m_package_header.BodyLen;
        }
        break;

    default:
        break;
    }

    return m_package_header.BodyLen;
}

bool CmdGetDir::CloneBody( GameCmdBase* pResultCmd )
{
    CmdGetDir* pCmd = dynamic_cast<CmdGetDir*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_request = m_request;
    return true;
}

bool CmdGetDir::IsCoupleRespCmd( IGameCommand* pCmd )
{
    return (pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_GETDIR_RESP));
}

//================================================================================================
//====================| CmdGetDirResp implementation |============================================
//================================================================================================

const char* CmdGetDirResp::GAME_CMD_NAME = "GetDirResp";

CmdGetDirResp::CmdGetDirResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_GETDIR_RESP;
}

void CmdGetDirResp::desc_parameters(std::string &str)
{
	str = "[response = ";
	str += m_response;
	str += "]";
}

void CmdGetDirResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	ysh_assert("CmdGetDirResp::encode_parameters() not implemented" && false);
}

void CmdGetDirResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_response = fixed_buffer.get_string();
}

unsigned long CmdGetDirResp::length_parameters()
{
	ysh_assert("CmdGetDirResp::length_parameters() not implemented" && false);
	return 0;
}
