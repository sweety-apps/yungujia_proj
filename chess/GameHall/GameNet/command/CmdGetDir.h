
#ifndef __GAME_COMMAND_GET_DIR_20090219_11
#define __GAME_COMMAND_GET_DIR_20090219_11

#include "GameCmdBase.h"

class CmdGetDir : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdGetDir();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }
    virtual bool CloneBody(GameCmdBase* pResultCmd);
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd);

public:
	string m_request;
};

class CmdGetDirResp : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdGetDirResp();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }

public:
	string m_response;
};

#endif // #ifndef __GAME_COMMAND_GET_DIR_20090219_11
