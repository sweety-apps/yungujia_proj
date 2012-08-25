/******************************************************************
* CHallContext: 全局上下文信息管理，类似于MFC工程的CxxxApp类
*
*
********************************************************************/


#ifndef __GAME_HALL_CONTEXT_H_20090408
#define __GAME_HALL_CONTEXT_H_20090408

#include "common/GameNetInf.h"

extern XLUSERID g_nUserID;

class CHallContext
{
	CHallContext();

public:
	static CHallContext* GetInstance();

	IGameUtility* GetGameUtility();
	IGameNetEx2* GetGameNet();
	XLUSERID GetLoginUserID();

	void SetGameNetUserInfo(__int64 nUserID, const char* pszUsername);

private:
	BOOL LoadGameNet();

private:
	IGameNetEx2* m_pGameNet;
	IGameUtility* m_pGameUtil;

private:
	DECL_LOGGER;
};

#endif // #ifndef __GAME_HALL_CONTEXT_H_20090408
