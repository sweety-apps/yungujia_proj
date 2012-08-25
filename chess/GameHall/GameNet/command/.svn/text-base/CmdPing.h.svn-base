
#ifndef __GAME_COMMAND_PING_20090317_11
#define __GAME_COMMAND_PING_20090317_11

#include "GameCmdBase.h"

class CmdPing : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdPing();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }
    virtual bool CloneBody(GameCmdBase* pResultCmd);
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd);

public:
	GAMEROOM m_roomInfo;
};

class CmdPingResp : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdPingResp();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }

public:
	int m_next_interval;
};

#endif // #ifndef __GAME_COMMAND_PING_20090317_11
