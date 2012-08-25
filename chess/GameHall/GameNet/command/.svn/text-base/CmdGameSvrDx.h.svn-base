
#ifndef __GAME_COMMAND_GAMESVR_IDATAX_20090417_11
#define __GAME_COMMAND_GAMESVR_IDATAX_20090417_11

#include "GameCmdBase.h"

class IDataXNet;

class CmdGameSvrDataX : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdGameSvrDataX();
	~CmdGameSvrDataX();

	virtual const char* CmdName();

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
    virtual bool CloneBody(GameCmdBase* pResultCmd);
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd);

	virtual BOOL IsGameTableAcceptCmd(int nTableID);

	void SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership = false);
	IDataXNet* GetDataXParam(bool bCopy = true);
	IDataXNet* DetachDataXParam();

public:
	GAMEROOM m_roomInfo;
	std::string m_cmdName;

public:
	IDataXNet* m_pDataX;

private:
	DECL_LOGGER; //LOG4CPLUS_CLASS_DECLARE(s_logger);
};

class CmdGameSvrDataXResp : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdGameSvrDataXResp();
	~CmdGameSvrDataXResp();

	virtual const char* CmdName();

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID);

	void SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership = false);
	IDataXNet* GetDataXParam(bool bCopy = true);
	IDataXNet* DetachDataXParam();

public:
	std::string m_cmdName;
	int m_nResult;

private:
	IDataXNet* m_pDataX;

private:
    DECL_LOGGER;
};


#endif // #ifndef __GAME_COMMAND_GAMESVR_IDATAX_20090417_11
