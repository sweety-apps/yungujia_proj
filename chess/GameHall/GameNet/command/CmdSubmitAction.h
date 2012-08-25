
#ifndef __GAME_COMMAND_SUBMIT_ACTION_20090224_11
#define __GAME_COMMAND_SUBMIT_ACTION_20090224_11

#include "GameCmdBase.h"

class CmdSubmitAction : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdSubmitAction();

	enum { MAX_ACTION_DATA_LEN = 65536 };

	virtual const char* CmdName() { return GAME_CMD_NAME;}

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID) { return FALSE; }
    virtual bool CloneBody(GameCmdBase* pResultCmd);
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd);

	bool SetActionData(const char* pszDataBuf, int nDataLen);

public:
	GAMEROOM m_roomInfo;

private:
	string m_action_data;
};


#endif // #ifndef __GAME_COMMAND_SUBMIT_ACTION_20090224_11
