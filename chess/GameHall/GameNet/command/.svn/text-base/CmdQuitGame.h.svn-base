
#ifndef __GAME_COMMAND_QUIT_GAME_20090224_11
#define __GAME_COMMAND_QUIT_GAME_20090224_11

#include "GameCmdBase.h"

class CmdQuitGame : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdQuitGame();

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
};

class CmdQuitGameResp : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdQuitGameResp();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return TRUE; }

public:
	int m_result;
};

#endif // #ifndef __GAME_COMMAND_QUIT_GAME_20090224_11
