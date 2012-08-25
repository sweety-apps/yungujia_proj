
#include "CmdQuitGame.h"

//================================================================================================
//==========================| CmdQuitGame implementation |========================================
//================================================================================================

const char* CmdQuitGame::GAME_CMD_NAME = "QuitGame";

CmdQuitGame::CmdQuitGame()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_QUITGAME;
}

void CmdQuitGame::desc_parameters(std::string &str)
{
	char buffer[2048];

	snprintf(buffer, sizeof(buffer), "[GameID=%d, ZoneID=%d, RoomID=%d, TableID=%d]",
		m_tableInfo.GameID,
		m_tableInfo.ZoneID,
		m_tableInfo.RoomID,
		m_tableInfo.TableID);

	str = buffer;
}

void CmdQuitGame::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_tableInfo.GameID);
	fixed_buffer.put_short(m_tableInfo.ZoneID);
	fixed_buffer.put_short(m_tableInfo.RoomID);
	fixed_buffer.put_short(m_tableInfo.TableID);

	buff_size = fixed_buffer.position();
}

void CmdQuitGame::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_tableInfo.GameID = fixed_buffer.get_short();
	m_tableInfo.ZoneID = fixed_buffer.get_short();
	m_tableInfo.RoomID = fixed_buffer.get_short();
	m_tableInfo.TableID = fixed_buffer.get_short();
}

unsigned long CmdQuitGame::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 4); // m_seatInfo

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

bool CmdQuitGame::CloneBody( GameCmdBase* pResultCmd )
{
    CmdQuitGame* pCmd = dynamic_cast<CmdQuitGame*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_tableInfo = m_tableInfo;
    return true;
}

bool CmdQuitGame::IsCoupleRespCmd( IGameCommand* pCmd )
{
    return (pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_QUITGAME_RESP));
}

//================================================================================================
//======================| CmdQuitGameResp implementation |========================================
//================================================================================================

const char* CmdQuitGameResp::GAME_CMD_NAME = "QuitGameResp";

CmdQuitGameResp::CmdQuitGameResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_QUITGAME_RESP;
}

void CmdQuitGameResp::desc_parameters(std::string &str)
{
	char buffer[1024];

	snprintf(buffer, sizeof(buffer), "[Result=%d]",
		m_result);

	str = buffer;
}

void CmdQuitGameResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_int(m_result);

	buff_size = fixed_buffer.position();
}

void CmdQuitGameResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_result = fixed_buffer.get_int();
}

unsigned long CmdQuitGameResp::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(int)); // m_result


	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}
