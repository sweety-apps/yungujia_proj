
#ifndef __GAME_COMMAND_CHAT_20090224_11
#define __GAME_COMMAND_CHAT_20090224_11

#include "GameCmdBase.h"

class CmdChat : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdChat();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }
    virtual bool CloneBody(GameCmdBase* pResultCmd);
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd);

public:
	GAMETABLE m_tableInfo;
	string m_chat_msg;
	int m_seq_no;
};

class CmdChatResp : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdChatResp();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return TRUE; }

public:
	int m_seq_no;
	int m_result;
};

#endif // #ifndef __GAME_COMMAND_CHAT_20090224_11
