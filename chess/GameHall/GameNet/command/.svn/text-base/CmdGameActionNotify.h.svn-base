
#ifndef __GAME_COMMAND_GAME_ACTION_NOTIFY_20090224_11
#define __GAME_COMMAND_GAME_ACTION_NOTIFY_20090224_11

#include "GameCmdBase.h"

class CmdGameActionNotify : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdGameActionNotify();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	
	// 服务端只转发给同桌的玩家，故不用过滤
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return TRUE; }

public:
	GAMEROOM m_roomInfo;
	__int64 m_submit_userID;
	string m_action_data;

private:
    DECL_LOGGER; // LOG4CPLUS_CLASS_DECLARE(s_logger);
};


#endif // #ifndef __GAME_COMMAND_SUBMIT_ACTION_20090224_11
