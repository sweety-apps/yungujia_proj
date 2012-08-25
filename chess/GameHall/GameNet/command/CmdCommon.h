#ifndef  __GAME_COMMAND_COMMON_20100724_20
#define __GAME_COMMAND_COMMON_20100724_20

#include "GameCmdBase.h"

class IDataXNet;

class CmdCommon: public GameCmdBase
{
public:
	CmdCommon();
	~CmdCommon();

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

	void SetCmdReqID(LONG lCmdReqID);
public:
	int m_nCmdSrcID;
	std::string m_cmdName;

private:
	IDataXNet* m_pDataX;

private:
	DECL_LOGGER;
};

class CmdCommonResp : public GameCmdBase
{
public:
	CmdCommonResp();
	~CmdCommonResp();

	virtual const char* CmdName();

	virtual void desc_parameters(std::string &str);
	virtual void encode_parameters(void * buff, unsigned long &buff_size);
	virtual void decode_parameters(const void * buff, unsigned long buff_size);
	virtual unsigned long length_parameters();
	virtual BOOL IsGameTableAcceptCmd(int nTableID);

	void SetDataXParam(IDataXNet* pDataX, bool bGiveupOwnership = false);
	IDataXNet* GetDataXParam(bool bNeedClone = false);
	IDataXNet* DetachDataXParam();

    void SetCmdRespID(LONG lCmdRespID);
public:
	int m_nCmdSrcID;
	std::string m_cmdName;
	int m_nResult;

private:
	IDataXNet* m_pDataX;

	DECL_LOGGER;
};


#endif
