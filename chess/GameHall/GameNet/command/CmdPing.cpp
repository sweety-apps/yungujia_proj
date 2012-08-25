
#include "CmdPing.h"

//================================================================================================
//==============================| CmdPing implementation |========================================
//================================================================================================

const char* CmdPing::GAME_CMD_NAME = "Ping";

CmdPing::CmdPing()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_PING;
}

void CmdPing::desc_parameters(std::string &str)
{
	char buffer[2048];

	snprintf(buffer, sizeof(buffer), "[GameID=%d, ZoneID=%d, RoomID=%d]",
		m_roomInfo.GameID,
		m_roomInfo.ZoneID,
		m_roomInfo.RoomID);

	str = buffer;
}

void CmdPing::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_roomInfo.GameID);
	fixed_buffer.put_short(m_roomInfo.ZoneID);
	fixed_buffer.put_short(m_roomInfo.RoomID);

	buff_size = fixed_buffer.position();
}

void CmdPing::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_roomInfo.GameID = fixed_buffer.get_short();
	m_roomInfo.ZoneID = fixed_buffer.get_short();
	m_roomInfo.RoomID = fixed_buffer.get_short();
}

unsigned long CmdPing::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 3); // m_roomInfo

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

bool CmdPing::CloneBody( GameCmdBase* pResultCmd )
{
    CmdPing* pCmd = dynamic_cast<CmdPing*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_roomInfo = m_roomInfo;
    return true;
}

bool CmdPing::IsCoupleRespCmd( IGameCommand* pCmd )
{
    return (pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_PING_RESP));
}

//================================================================================================
//======================| CmdPingResp implementation |========================================
//================================================================================================

const char* CmdPingResp::GAME_CMD_NAME = "PingResp";

CmdPingResp::CmdPingResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_PING_RESP;
}

void CmdPingResp::desc_parameters(std::string &str)
{
	char buffer[1024];

	snprintf(buffer, sizeof(buffer), "[NextInterval=%d]",
		m_next_interval);

	str = buffer;
}

void CmdPingResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_int(m_next_interval);

	buff_size = fixed_buffer.position();
}

void CmdPingResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_next_interval = fixed_buffer.get_int();
}

unsigned long CmdPingResp::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(int)); // m_next_interval


	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}
