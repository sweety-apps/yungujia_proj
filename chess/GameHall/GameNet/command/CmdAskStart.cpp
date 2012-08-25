#include "CmdAskStart.h"

//================================================================================================
//==========================| CmdAskStart implementation |========================================
//================================================================================================

const char* CmdAskStart::GAME_CMD_NAME = "AskStart";

CmdAskStart::CmdAskStart()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_ASKSTART;
}

void CmdAskStart::desc_parameters(std::string &str)
{
	char buffer[2048];

	snprintf(buffer, sizeof(buffer), "[GameID=%d, ZoneID=%d, RoomID=%d, TableID=%d, SeatID=%d]",
		m_seatInfo.GameID,
		m_seatInfo.ZoneID,
		m_seatInfo.RoomID,
		m_seatInfo.TableID,
		(int)m_seatInfo.SeatID);


	str = buffer;
}

void CmdAskStart::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_seatInfo.GameID);
	fixed_buffer.put_short(m_seatInfo.ZoneID);
	fixed_buffer.put_short(m_seatInfo.RoomID);
	fixed_buffer.put_short(m_seatInfo.TableID);
	fixed_buffer.put_byte((byte)m_seatInfo.SeatID);

	buff_size = fixed_buffer.position();
}

void CmdAskStart::decode_parameters(const void * buff, unsigned long buff_size)
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

unsigned long CmdAskStart::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 4 + sizeof(byte)); // m_seatInfo

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

bool CmdAskStart::CloneBody( GameCmdBase* pResultCmd )
{
    CmdAskStart* pCmd = dynamic_cast<CmdAskStart*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_seatInfo = m_seatInfo;
    return true;
}

bool CmdAskStart::IsCoupleRespCmd( IGameCommand* pCmd )
{
    return (pCmd && (pCmd->GetCmdType() ==  GameCmdFactory::CMD_ID_ASKSTART_RESP));
}

//================================================================================================
//======================| CmdAskStartResp implementation |========================================
//================================================================================================

const char* CmdAskStartResp::GAME_CMD_NAME = "AskStartResp";

CmdAskStartResp::CmdAskStartResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_ASKSTART_RESP;
}

void CmdAskStartResp::desc_parameters(std::string &str)
{
	char buffer[1024];

	snprintf(buffer, sizeof(buffer), "[Result=%d]",	m_result);

	str = buffer;
}

void CmdAskStartResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_int(m_result);

	buff_size = fixed_buffer.position();
}

void CmdAskStartResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_result = fixed_buffer.get_int();
}

unsigned long CmdAskStartResp::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(int)); // m_result


	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}
