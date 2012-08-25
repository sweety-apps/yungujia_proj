
#include "CmdGetUserGameInfo.h"

//================================================================================================
//========================| CmdGetUserGameInfo implementation |===================================
//================================================================================================

const char* CmdGetUserGameInfo::GAME_CMD_NAME = "GetUserGameInfo";

CmdGetUserGameInfo::CmdGetUserGameInfo()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_GETUSERGAMEINFO;
}

void CmdGetUserGameInfo::desc_parameters(std::string &str)
{
	char buffer[1024];

	sprintf(buffer, "[gameID=%d]", (int)m_gameID);

	str = buffer;
}

void CmdGetUserGameInfo::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);
	fixed_buffer.put_short(m_gameID);

	buff_size = fixed_buffer.position();
}

void CmdGetUserGameInfo::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_gameID = fixed_buffer.get_short();
}

unsigned long CmdGetUserGameInfo::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += sizeof(short);  // m_gameID

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

bool CmdGetUserGameInfo::CloneBody( GameCmdBase* pResultCmd )
{
    CmdGetUserGameInfo* pCmd = dynamic_cast<CmdGetUserGameInfo*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_gameID = m_gameID;
    return true;
}

bool CmdGetUserGameInfo::IsCoupleRespCmd( IGameCommand* pCmd )
{
    return (pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_GETUSERGAMEINFO_RESP));
}

//================================================================================================
//==================| CmdGetUserGameInfoResp implementation |=====================================
//================================================================================================

//LOG4CPLUS_CLASS_IMPLEMENT(CmdGetUserGameInfoResp, s_logger, "GN.CmdGetUserGameInfoResp");
IMPL_LOGGER_EX(CmdGetUserGameInfoResp, GN);

const char* CmdGetUserGameInfoResp::GAME_CMD_NAME = "GetUserGameInfoResp";

CmdGetUserGameInfoResp::CmdGetUserGameInfoResp()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_GETUSERGAMEINFO_RESP;
}

void CmdGetUserGameInfoResp::desc_parameters(std::string &str)
{
	char buffer[2048];
	char* buf_ptr = buffer;

	int game_types = (int)m_userGamesInfo.size();
	buf_ptr += sprintf(buf_ptr, "[result=%d, gameTypes=%d, ", m_result, game_types);
	for(int i = 0; i < game_types && i < 8; i++)
	{
		XLUSERGAMEINFO& userGameInfo = m_userGamesInfo[i];
		buf_ptr += sprintf(buf_ptr, "(Points=%d, Win=%d, Lose=%d, Equal=%d)",
			userGameInfo.Points,
			userGameInfo.WinNum, 
			userGameInfo.LoseNum, 
			userGameInfo.EqualNum);
	}
	buf_ptr += sprintf(buf_ptr, "]");

	str = buffer;
}

void CmdGetUserGameInfoResp::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_int(m_result);

	if(m_result == RESULT_OK)
	{
		int game_types = (int)m_userGamesInfo.size();
		fixed_buffer.put_int(game_types);
		for(int i = 0; i < game_types; i++)
		{
			encode_xlusergameinfo(fixed_buffer, m_userGamesInfo[i]);
		}
	}

	buff_size = fixed_buffer.position();
}

void CmdGetUserGameInfoResp::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_result = fixed_buffer.get_int();
	if(m_result != RESULT_OK)
	{
		LOG_WARN("received m_result <> 0 !! (" << m_result << ", userID=" << m_userid << ")");
		return;
	}

	int game_types = fixed_buffer.get_int();
	m_userGamesInfo.clear();
	if(game_types > 0)
		m_userGamesInfo.reserve(game_types);

	LOG_DEBUG("count of game types: " << game_types);
	for(int i = 0; i < game_types; i++)
	{
		XLUSERGAMEINFO userGameInfo;
		decode_xlusergameinfo(fixed_buffer, userGameInfo);
		m_userGamesInfo.push_back(userGameInfo);
	}	
}

unsigned long CmdGetUserGameInfoResp::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += sizeof(int);  // m_result

	if(m_result == RESULT_OK)
	{
		m_package_header.BodyLen += sizeof(int);  // count of game types
		int game_types = (int)m_userGamesInfo.size();
		for(int i = 0; i < game_types; i++)
		{
			m_package_header.BodyLen += sizeof(int);  // struct len
			m_package_header.BodyLen += calc_xlusergameinfo_length(m_userGamesInfo[i]);
		}
	}

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;
}

void CmdGetUserGameInfoResp::encode_xlusergameinfo(FixedBuffer& fixed_buffer, const XLUSERGAMEINFO& userGameInfo)
{
	int struct_len = sizeof(XLUSERGAMEINFO);
	fixed_buffer.put_int(struct_len);

	fixed_buffer.put_short(userGameInfo.GameID);
	fixed_buffer.put_int(userGameInfo.Points);
	fixed_buffer.put_int(userGameInfo.WinNum);
	fixed_buffer.put_int(userGameInfo.LoseNum);
	fixed_buffer.put_int(userGameInfo.EqualNum);
	fixed_buffer.put_int(userGameInfo.EscapeNum);
	fixed_buffer.put_int(userGameInfo.OrgID);
	fixed_buffer.put_int(userGameInfo.OrgPos);
	fixed_buffer.put_int(userGameInfo.DropNum);
}

void CmdGetUserGameInfoResp::decode_xlusergameinfo(FixedBuffer& fixed_buffer, XLUSERGAMEINFO& userGameInfo)
{
	int struct_len = fixed_buffer.get_int();
	if(fixed_buffer.remain_len() < struct_len)
	{
		LOG_WARN("buffer remain length is " << fixed_buffer.remain_len() << ", but struct length is " << struct_len);
	}
	ysh_assert(fixed_buffer.remain_len() >= struct_len);

	int start_pos = fixed_buffer.position();

	userGameInfo.GameID = fixed_buffer.get_short();
	userGameInfo.Points = fixed_buffer.get_int();
	userGameInfo.WinNum = fixed_buffer.get_int();
	userGameInfo.LoseNum = fixed_buffer.get_int();
	userGameInfo.EqualNum = fixed_buffer.get_int();
	userGameInfo.EscapeNum = fixed_buffer.get_int();
	userGameInfo.OrgID = fixed_buffer.get_int();
	userGameInfo.OrgPos = fixed_buffer.get_int();
	if(struct_len >= sizeof(XLUSERGAMEINFO))
	{
		userGameInfo.DropNum = fixed_buffer.get_int();
	}
	else
	{
		LOG_WARN("'DropNum' not found in XLUSERGAMEINFO struct when decode_xlusergameinfo() called!");
		userGameInfo.DropNum = 0;
	}

	int end_pos = fixed_buffer.position();
	int real_struct_len = end_pos - start_pos;

	ysh_assert(struct_len >= real_struct_len);
	if(struct_len > real_struct_len)
	{
		fixed_buffer.skip(struct_len - real_struct_len);
	}
	
}

unsigned int CmdGetUserGameInfoResp::calc_xlusergameinfo_length(const XLUSERGAMEINFO& userGameInfo)
{
	return sizeof(XLUSERGAMEINFO);
}
