
#ifndef __GAME_COMMAND_REPLAY_20090408_11
#define __GAME_COMMAND_REPLAY_20090408_11

#include "GameCmdBase.h"

class CmdReplay : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdReplay();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
    virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }
    virtual bool CloneBody(GameCmdBase* pResultCmd);
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd);

public:
	GAMESEAT m_seatInfo;
};

class CmdReplayResp : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdReplayResp();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }

public:

};

#endif // #ifndef __GAME_COMMAND_REPLAY_20090408_11
