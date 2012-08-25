
#ifndef __GAME_COMMAND_GET_USER_GAMEINFO_20090318_11
#define __GAME_COMMAND_GET_USER_GAMEINFO_20090318_11

#include "GameCmdBase.h"

class CmdGetUserGameInfo : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdGetUserGameInfo();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }
    virtual bool CloneBody(GameCmdBase* pResultCmd);
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd);

public:
	short m_gameID;
};

class CmdGetUserGameInfoResp : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdGetUserGameInfoResp();

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }

	static void encode_xlusergameinfo(FixedBuffer& fixed_buffer, const XLUSERGAMEINFO& userGameInfo);
	static void decode_xlusergameinfo(FixedBuffer& fixed_buffer, XLUSERGAMEINFO& userGameInfo);
	static unsigned int calc_xlusergameinfo_length(const XLUSERGAMEINFO& userGameInfo);

public:
	int m_result;
	vector<XLUSERGAMEINFO> m_userGamesInfo;

private:
	DECL_LOGGER; //LOG4CPLUS_CLASS_DECLARE(s_logger);
};

#endif // #ifndef __GAME_COMMAND_GET_USER_GAMEINFO_20090318_11
