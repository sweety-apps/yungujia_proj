
#ifndef __GAME_COMMAND_KICKOUT_20090318_15
#define __GAME_COMMAND_KICKOUT_20090318_15

#include "GameCmdBase.h"

class CmdKickoutNotify : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdKickoutNotify();


	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return true; }    

private:
	bool check_is_valid_reason(byte reason);

public:
	GAMETABLE m_tableInfo;
	byte m_reason;
	__int64 m_whoKickMe;

private:
	DECL_LOGGER; //LOG4CPLUS_CLASS_DECLARE(s_logger);
};


#endif // #ifndef __GAME_COMMAND_KICKOUT_20090318_15
