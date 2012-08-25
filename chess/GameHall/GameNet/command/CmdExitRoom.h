
#ifndef __GAME_COMMAND_EXIT_ROOM_20090224_11
#define __GAME_COMMAND_EXIT_ROOM_20090224_11

#include "GameCmdBase.h"

class CmdExitRoom : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdExitRoom();

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

class CmdExitRoomResp : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdExitRoomResp();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }

public:
	int m_result;
};

#endif // #ifndef __GAME_COMMAND_EXIT_ROOM_20090224_11
