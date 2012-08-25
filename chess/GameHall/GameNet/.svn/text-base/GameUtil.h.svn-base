
#ifndef __GAME_UTILITY_H_20090219_29
#define __GAME_UTILITY_H_20090219_29

#include <string>
#include "common/GameNetInf.h"

class GameUtility : public IGameUtility
{
	// private ctor
	GameUtility() { } 
public:
	static GameUtility* GetInstance();

	static bool ANSI_to_UTF8(const char* pszSource, int nSrcLen, char* pszDest, int& nDestLen);
	static bool UTF8_to_ANSI(const char* pszSource, int nSrcLen, char* pszDest, int& nDestLen);

	virtual IGameCommand* DecodeCmd(const char* pDataBuf, int nDataLen);

	// 判断pCmd是否为nTableID对应游戏桌感兴趣的命令
	// (大厅根据此结果来决定是否需要向游戏桌转发该命令)
	virtual BOOL IsGameTableAcceptCmd(IGameCommand* pCmd, int nTableID);

	virtual IDataXNet* CreateDataX();
	virtual void DeleteDataX(IDataXNet* pDataX);

	virtual IDataXNet* DecodeDataX(const char* pDataBuf, int nDataLen);

	virtual IDataXNet* QueryCommandStatus(IGameCommand* pCmd, const char* pszQueryStr);
	virtual string GetPeerID();
	virtual IGameCommand* CreateNonSessionDataXCmd(const char* cmdName, IDataXNet* pDataX, int nCmdSrcID);
	virtual BOOL GetPeerID2(char* pszBuffer, int& nBufferLen);

public:
	void SetPeerID(const char* szPeerID);

private:
	DECL_LOGGER; //LOG4CPLUS_CLASS_DECLARE(s_logger);

	std::string m_sPeerID;
};

#endif // #ifndef __GAME_UTILITY_H_20090219_29
