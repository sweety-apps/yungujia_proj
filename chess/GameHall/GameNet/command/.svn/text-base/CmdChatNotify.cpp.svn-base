
#include "CmdChatNotify.h"

//================================================================================================
//============================| CmdChatNotify implementation |====================================
//================================================================================================

const char* CmdChatNotify::GAME_CMD_NAME = "ChatNotify";

CmdChatNotify::CmdChatNotify()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_CHAT_NOTIFY;
}

void CmdChatNotify::desc_parameters(std::string &str)
{
	char buffer[2048];

	snprintf(buffer, sizeof(buffer), "[ChatUserID=%I64d, Msg=%s, SeqNo=%d]",
		m_sender_userID,
		m_chat_msg.c_str(),
		m_seq_no);

	str = buffer;
}

void CmdChatNotify::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_tableInfo.GameID);
	fixed_buffer.put_short(m_tableInfo.ZoneID);
	fixed_buffer.put_short(m_tableInfo.RoomID);
	fixed_buffer.put_short(m_tableInfo.TableID);
	
	fixed_buffer.put_int64(m_sender_userID);
	fixed_buffer.put_string(m_chat_msg);
	fixed_buffer.put_int(m_seq_no);

	buff_size = fixed_buffer.position();
}

void CmdChatNotify::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (_u64)fixed_buffer.get_int64();
	m_cmd_typeid = fixed_buffer.get_short();

	m_tableInfo.GameID = fixed_buffer.get_short();
	m_tableInfo.ZoneID = fixed_buffer.get_short();
	m_tableInfo.RoomID = fixed_buffer.get_short();
	m_tableInfo.TableID = fixed_buffer.get_short();

	m_sender_userID = fixed_buffer.get_int64();
	m_chat_msg = fixed_buffer.get_string();
	m_seq_no = fixed_buffer.get_int();
}

unsigned long CmdChatNotify::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 4); // m_tableInfo
	m_package_header.BodyLen += sizeof(__int64); // m_sender_userID
	m_package_header.BodyLen += (sizeof(int) + m_chat_msg.length());
	m_package_header.BodyLen += sizeof(int); // m_seq_no

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

