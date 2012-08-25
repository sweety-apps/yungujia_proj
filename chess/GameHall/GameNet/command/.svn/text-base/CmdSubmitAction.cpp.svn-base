
#include "CmdSubmitAction.h"
#include "CmdGameActionNotify.h"

//================================================================================================
//==========================| CmdSubmitAction implementation |====================================
//================================================================================================

const char* CmdSubmitAction::GAME_CMD_NAME = "SubmitAction";

CmdSubmitAction::CmdSubmitAction()
{
	m_cmd_typeid = GameCmdFactory::CMD_ID_SUBMIT_ACTION;
}

void CmdSubmitAction::desc_parameters(std::string &str)
{
	char buffer[2048];

	snprintf(buffer, sizeof(buffer), "[GameID=%d, ZoneID=%d, RoomID=%d, DataLen=%d]",
		m_roomInfo.GameID,
		m_roomInfo.ZoneID,
		m_roomInfo.RoomID,
		m_action_data.length());

	str = buffer;
}

void CmdSubmitAction::encode_parameters(void * buff, unsigned long &buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	fixed_buffer.put_int64((_u64)m_userid);
	fixed_buffer.put_short(m_cmd_typeid);

	fixed_buffer.put_short(m_roomInfo.GameID);
	fixed_buffer.put_short(m_roomInfo.ZoneID);
	fixed_buffer.put_short(m_roomInfo.RoomID);

	fixed_buffer.put_string(m_action_data);

	buff_size = fixed_buffer.position();
}

void CmdSubmitAction::decode_parameters(const void * buff, unsigned long buff_size)
{
	FixedBuffer fixed_buffer((char*)buff, buff_size, true);

	m_userid = (__int64)fixed_buffer.get_int64();
	fixed_buffer.get_short();  // m_cmd_typeid

	m_roomInfo.GameID = fixed_buffer.get_short();
	m_roomInfo.ZoneID = fixed_buffer.get_short();
	m_roomInfo.RoomID = fixed_buffer.get_short();

	m_action_data = fixed_buffer.get_string();
}

unsigned long CmdSubmitAction::length_parameters()
{
	m_package_header.BodyLen = sizeof(__int64) + sizeof(short); // m_userid, m_cmd_typeid

	m_package_header.BodyLen += (sizeof(short) * 3); // m_roomInfo
	m_package_header.BodyLen += (sizeof(int) + m_action_data.length());

	if(m_package_header.CipherFlag)
		return (m_package_header.BodyLen + 7)/8 * 8;
	else
		return m_package_header.BodyLen;

}

bool CmdSubmitAction::SetActionData(const char* pszDataBuf, int nDataLen)
{
	if(pszDataBuf == NULL)
		return false;
	if(nDataLen <= 0 || nDataLen > MAX_ACTION_DATA_LEN)
		return false;

	string strData(pszDataBuf, nDataLen);
	m_action_data = strData;

	return true;
}

bool CmdSubmitAction::CloneBody( GameCmdBase* pResultCmd )
{
    CmdSubmitAction* pCmd = dynamic_cast<CmdSubmitAction*>(pResultCmd);
    if(!pCmd)
    {
        return false;
    }

    pCmd->m_roomInfo = m_roomInfo;
    pCmd->m_action_data = m_action_data;
    return true;
}

bool CmdSubmitAction::IsCoupleRespCmd( IGameCommand* pCmd )
{
    if(pCmd && (pCmd->GetCmdType() == GameCmdFactory::CMD_ID_GAMEACTION_NOTIFY))
    {
        CmdGameActionNotify* pActionCmd = (CmdGameActionNotify*)pCmd;
        if( (pActionCmd->m_submit_userID == -1) || (pActionCmd->m_submit_userID == m_userid) )
        {
            return true;
        }
    }

    return false;
}
