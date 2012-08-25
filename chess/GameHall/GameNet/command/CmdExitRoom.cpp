
#include "CmdExitRoom.h"

//================================================================================================
//==========================| CmdExitRoom implementation |========================================
//================================================================================================

const char* CmdExitRoom::GAME_CMD_NAME = "ExitRoom";

CmdExitRoom::CmdExitRoom()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_EXITROOM;
}

void CmdExitRoom::desc_parameters(std::string &str)
{
	char buffer[2048];

	snprintf(buffer, sizeof(buffer), "[GameID=%d, ZoneID=%d, RoomID=%d]",
		m_roomInfo.GameID,
		m_roomInfo.ZoneID,
		m_roomInfo.RoomID);

	str = buffer;
}

void CmdExitRoom::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_roomInfo.GameID);
	fixed_buffer.put_short(m_roomInfo.ZoneID);
	fixed_buffer.put_short(m_roomInfo.RoomID);

	buff_size = fixed_buffer.position();
}

void CmdExitRoom::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_roomInfo.GameID = fixed_buffer.get_short();
	m_roomInfo.ZoneID = fixed_buffer.get_short();
	m_roomInfo.RoomID = fixed_buffer.get_short();
}

unsigned long CmdExitRoom::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 3); // m_roomInfo

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

bool CmdExitRoom::CloneBody( GameCmdBase* pResultCmd )
{
    CmdExitRoom* pCmd = dynamic_cast<CmdExitRoom*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_roomInfo = m_roomInfo;
    return true;
}

bool CmdExitRoom::IsCoupleRespCmd( IGameCommand* pCmd )
{
    return (pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_EXITROOM_RESP));
}

//================================================================================================
//======================| CmdExitRoomResp implementation |========================================
//================================================================================================

const char* CmdExitRoomResp::GAME_CMD_NAME = "ExitRoomResp";

CmdExitRoomResp::CmdExitRoomResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_EXITROOM_RESP;
}

void CmdExitRoomResp::desc_parameters(std::string &str)
{
	char buffer[1024];

	snprintf(buffer, sizeof(buffer), "[Result=%d]",
		m_result);

	str = buffer;
}

void CmdExitRoomResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_int(m_result);

	buff_size = fixed_buffer.position();
}

void CmdExitRoomResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_result = fixed_buffer.get_int();
}

unsigned long CmdExitRoomResp::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(int)); // m_result


	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}
