
#ifndef __GAME_COMMAND_CHAT_NOTIFY_20090224_17
#define __GAME_COMMAND_CHAT_NOTIFY_20090224_17

#include "GameCmdBase.h"

class CmdChatNotify : public GameCmdBase
{
	const static char* GAME_CMD_NAME;
public:
	CmdChatNotify();


	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return nTableID == m_tableInfo.TableID; }


public:
	GAMETABLE m_tableInfo;
	__int64 m_sender_userID;
	string m_chat_msg;
	int m_seq_no;
};


#endif // #ifndef __GAME_COMMAND_CHAT_NOTIFY_20090224_17
