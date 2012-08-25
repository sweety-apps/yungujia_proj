
#ifndef __GAME_COMMAND_BALANCE_IDATAX_20101030_11
#define __GAME_COMMAND_BALANCE_IDATAX_20101030_11

#include "GameCmdBase.h"

class IDataXNet;

class CmdBalanceSvrDataX : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdBalanceSvrDataX();
	~CmdBalanceSvrDataX();

	virtual const char* CmdName();

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
    virtual unsigned long length_parameters();
    virtual bool CloneBody(GameCmdBase* pResultCmd);
    virtual bool IsCoupleRespCmd(IGameCommand* pCmd);

	virtual BOOL IsGameTableAcceptCmd(int nTableID);

	void SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership = false);
	IDataXNet* GetDataXParam(bool bNeedClone = false);
    IDataXNet* DetachDataXParam();

public:
	int m_nCmdSrcID;
	std::string m_cmdName;

private:
	IDataXNet* m_pDataX;

private:
	DECL_LOGGER;
};

class CmdBalanceSvrDataXResp : public GameCmdBase
{
	static const char* GAME_CMD_NAME;
public:
	CmdBalanceSvrDataXResp();
	~CmdBalanceSvrDataXResp();

	virtual const char* CmdName();

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID);

	void SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership = false);
	IDataXNet* GetDataXParam(bool bNeedClone = false);
	IDataXNet* DetachDataXParam();

public:
	int m_nCmdSrcID;
	std::string m_cmdName;
	int m_nResult;

private:
	IDataXNet* m_pDataX;

	DECL_LOGGER;
};


#endif // #ifndef __GAME_COMMAND_BALANCE_IDATAX_20101030_11
