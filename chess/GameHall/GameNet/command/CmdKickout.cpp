
#include "CmdKickout.h"

//================================================================================================
//==============================| CmdKickoutNotify implementation |===============================
//================================================================================================

//LOG4CPLUS_CLASS_IMPLEMENT(CmdKickoutNotify, s_logger, "GN.CmdKickoutNotify");
IMPL_LOGGER_EX(CmdKickoutNotify, GN);

const char* CmdKickoutNotify::GAME_CMD_NAME = "Kickout";

CmdKickoutNotify::CmdKickoutNotify()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_KICKOUT;
}

void CmdKickoutNotify::desc_parameters(std::string &str)
{
	char buffer[2048];

	snprintf(buffer, sizeof(buffer), "[GameID=%d, ZoneID=%d, RoomID=%d, TableID=%d, Reason=%d]",
		m_tableInfo.GameID,
		m_tableInfo.ZoneID,
		m_tableInfo.RoomID,
		m_tableInfo.TableID,
		(int)m_reason);

	str = buffer;
}

void CmdKickoutNotify::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_tableInfo.GameID);
	fixed_buffer.put_short(m_tableInfo.ZoneID);
	fixed_buffer.put_short(m_tableInfo.RoomID);
	fixed_buffer.put_short(m_tableInfo.TableID);
	fixed_buffer.put_byte(m_reason);
	fixed_buffer.put_int64(m_whoKickMe);

	buff_size = fixed_buffer.position();
}

void CmdKickoutNotify::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (_u64)fixed_buffer.get_int64();
	m_cmd_typeid = fixed_buffer.get_short();

	m_tableInfo.GameID = fixed_buffer.get_short();
	m_tableInfo.ZoneID = fixed_buffer.get_short();
	m_tableInfo.RoomID = fixed_buffer.get_short();
	m_tableInfo.TableID = fixed_buffer.get_short();
	m_reason = fixed_buffer.get_byte();
	if(!check_is_valid_reason(m_reason))
	{
		LOG_WARN( "!! Invalid kickout reason: " << (int)m_reason);
	}
	m_whoKickMe = fixed_buffer.get_int64();
}

bool CmdKickoutNotify::check_is_valid_reason(byte reason)
{
	if(reason == KICKOUT_BY_TABLE_OWNER ||
		reason == KICKOUT_BY_VIP ||
		reason == KICKOUT_BY_ADMIN ||
		reason == KICKOUT_MULTI_LOGIN)
	{
		return true;
	}
	else
	{
		return false;
	}
}

unsigned long CmdKickoutNotify::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 4); // m_tableInfo
	m_package_header.BodyLen += sizeof(byte); // m_reason
	m_package_header.BodyLen += sizeof(__int64); // m_whoKickMe

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}
