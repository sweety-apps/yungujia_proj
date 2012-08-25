
#include "CmdReplay.h"

//================================================================================================
//============================| CmdReplay implementation |========================================
//================================================================================================

const char* CmdReplay::GAME_CMD_NAME = "Replay";

CmdReplay::CmdReplay()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_REPLAY;
}

void CmdReplay::desc_parameters(std::string &str)
{
	char buffer[4096];

	snprintf(buffer, sizeof(buffer), "[GameID=%d, ZoneID=%d, RoomID=%d, TableID=%d]",
		m_seatInfo.GameID,
		m_seatInfo.ZoneID,
		m_seatInfo.RoomID,
		m_seatInfo.TableID);

	str = buffer;
}

void CmdReplay::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_seatInfo.GameID);
	fixed_buffer.put_short(m_seatInfo.ZoneID);
	fixed_buffer.put_short(m_seatInfo.RoomID);
	fixed_buffer.put_short(m_seatInfo.TableID);
	fixed_buffer.put_byte(m_seatInfo.SeatID);

	buff_size = fixed_buffer.position();
}

void CmdReplay::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_seatInfo.GameID = fixed_buffer.get_short();
	m_seatInfo.ZoneID = fixed_buffer.get_short();
	m_seatInfo.RoomID = fixed_buffer.get_short();
	m_seatInfo.TableID = fixed_buffer.get_short();
	m_seatInfo.SeatID = fixed_buffer.get_byte();

}

unsigned long CmdReplay::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 4 + sizeof(byte)); // m_seatInfo

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

bool CmdReplay::CloneBody( GameCmdBase* pResultCmd )
{
    CmdReplay* pCmd = dynamic_cast<CmdReplay*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_seatInfo = m_seatInfo;
    return true;
}

bool CmdReplay::IsCoupleRespCmd( IGameCommand* pCmd )
{
    return (pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_GAMEACTION_NOTIFY));
}

//================================================================================================
//======================| CmdReplayResp implementation |==========================================
//================================================================================================

const char* CmdReplayResp::GAME_CMD_NAME = "ReplayResp";

CmdReplayResp::CmdReplayResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_REPLAY_RESP;
}

void CmdReplayResp::desc_parameters(std::string &str)
{
	char buffer[1024];

	snprintf(buffer, sizeof(buffer), "[]");

	str = buffer;
}

void CmdReplayResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);



	buff_size = fixed_buffer.position();
}

void CmdReplayResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid


}

unsigned long CmdReplayResp::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}
