
#include "CmdGameActionNotify.h"
#include "common/utility.h"

//================================================================================================
//==========================| CmdGameActionNotify implementation |================================
//================================================================================================

const char* CmdGameActionNotify::GAME_CMD_NAME = "GameActionNotify";

//LOG4CPLUS_CLASS_IMPLEMENT(CmdGameActionNotify, s_logger, "GN.CmdGameActionNotify");
IMPL_LOGGER_EX(CmdGameActionNotify, GN);

CmdGameActionNotify::CmdGameActionNotify()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_GAMEACTION_NOTIFY;
}

void CmdGameActionNotify::desc_parameters(std::string &str)
{
	char buffer[2048];
	memset(buffer, 0, 2048);

	int nLen = m_action_data.length();
	if(nLen > 40)
		nLen = 40;
	string strData = utility::ch2str((unsigned char*)m_action_data.c_str(), nLen);
	sprintf(buffer, "[SubmitUserID=%lld, DataLen=%d, Data=%s]",
		m_submit_userID,
		m_action_data.length(),
		strData.c_str());

	str = buffer;
}

void CmdGameActionNotify::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_roomInfo.GameID);
	fixed_buffer.put_short(m_roomInfo.ZoneID);
	fixed_buffer.put_short(m_roomInfo.RoomID);

	fixed_buffer.put_int64(m_submit_userID);
	fixed_buffer.put_string(m_action_data);

	buff_size = fixed_buffer.position();
}

void CmdGameActionNotify::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	LOG_DEBUG( "buffer length: " << buff_size);

	m_userid = (_u64)fixed_buffer.get_int64();
	LOG_DEBUG( "m_userid=" << m_userid);
	m_cmd_typeid = fixed_buffer.get_short();
	LOG_DEBUG( "m_cmd_typeid=" << m_cmd_typeid);

	m_roomInfo.GameID = fixed_buffer.get_short();
	LOG_DEBUG( "GameID=" << m_roomInfo.GameID);
	m_roomInfo.ZoneID = fixed_buffer.get_short();
	LOG_DEBUG( "ZoneID=" << m_roomInfo.ZoneID);
	m_roomInfo.RoomID = fixed_buffer.get_short();
	LOG_DEBUG( "RoomID=" << m_roomInfo.RoomID);

	m_submit_userID = fixed_buffer.get_int64();
	LOG_DEBUG( "m_submit_userID=" << m_submit_userID);

	int str_len = fixed_buffer.get_int();
	LOG_DEBUG( "buffer remain length: " << fixed_buffer.remain_len() << ", str_len=" << str_len);
	fixed_buffer.skip(-4);

	m_action_data = fixed_buffer.get_string();
	LOG_DEBUG( "m_action_data length: " << m_action_data.length());
}

unsigned long CmdGameActionNotify::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 3); // m_roomInfo
	m_package_header.BodyLen += sizeof(__int64);
	m_package_header.BodyLen += (sizeof(int) + m_action_data.length()); // m_action_data

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}

