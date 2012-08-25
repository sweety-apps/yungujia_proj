
#include "CmdChat.h"

//================================================================================================
//============================| CmdChat implementation |==========================================
//================================================================================================

const char* CmdChat::GAME_CMD_NAME = "Chat";

CmdChat::CmdChat()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_CHAT;
}

void CmdChat::desc_parameters(std::string &str)
{
	char buffer[4096];

	snprintf(buffer, sizeof(buffer), "[GameID=%d, ZoneID=%d, RoomID=%d, TableID=%d, Msg=%s]",
		m_tableInfo.GameID,
		m_tableInfo.ZoneID,
		m_tableInfo.RoomID,
		m_tableInfo.TableID,
		m_chat_msg.c_str());

	str = buffer;
}

void CmdChat::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_tableInfo.GameID);
	fixed_buffer.put_short(m_tableInfo.ZoneID);
	fixed_buffer.put_short(m_tableInfo.RoomID);
	fixed_buffer.put_short(m_tableInfo.TableID);
	fixed_buffer.put_string(m_chat_msg);
	fixed_buffer.put_int(m_seq_no);

	buff_size = fixed_buffer.position();
}

void CmdChat::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_tableInfo.GameID = fixed_buffer.get_short();
	m_tableInfo.ZoneID = fixed_buffer.get_short();
	m_tableInfo.RoomID = fixed_buffer.get_short();
	m_tableInfo.TableID = fixed_buffer.get_short();
	
	m_chat_msg = fixed_buffer.get_string();
	m_seq_no = fixed_buffer.get_int();

}

unsigned long CmdChat::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 4); // m_tableInfo
	m_package_header.BodyLen += (sizeof(int) + m_chat_msg.length());
	m_package_header.BodyLen += sizeof(int); // m_seq_no

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

bool CmdChat::CloneBody( GameCmdBase* pResultCmd )
{
    CmdChat* pCmd = dynamic_cast<CmdChat*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_seq_no    = m_seq_no;
    pCmd->m_tableInfo = m_tableInfo;
    pCmd->m_chat_msg  = m_chat_msg;

    return true;
}

bool CmdChat::IsCoupleRespCmd( IGameCommand* pCmd )
{
    return (pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_CHAT_RESP));
}

//================================================================================================
//======================| CmdChatResp implementation |============================================
//================================================================================================

const char* CmdChatResp::GAME_CMD_NAME = "ChatResp";

CmdChatResp::CmdChatResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_CHAT_RESP;
}

void CmdChatResp::desc_parameters(std::string &str)
{
	char buffer[1024];

	snprintf(buffer, sizeof(buffer), "[Result=%d, SeqNo=%d]",
		m_result,
		m_seq_no);

	str = buffer;
}

void CmdChatResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_int(m_seq_no);
	fixed_buffer.put_int(m_result);

	buff_size = fixed_buffer.position();
}

void CmdChatResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_seq_no = fixed_buffer.get_int();
	m_result = fixed_buffer.get_int();
}

unsigned long CmdChatResp::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(int) * 2); // m_seq_no, m_result


	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}
