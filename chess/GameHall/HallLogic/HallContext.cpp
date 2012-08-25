#include "HallContext.h"
#include "GameNet/command/DataID.h"
#include "GameNet/GameNetInstance.h"
#include "GameNet/GameUtil.h"
#include "GameNetEventHandler.h"

XLUSERID g_nUserID = -1;

IMPL_LOGGER(CHallContext);

CHallContext::CHallContext()
{
	m_pGameNet = NULL;
	m_pGameUtil = NULL;
}

CHallContext* CHallContext::GetInstance()
{
	static CHallContext _instance;
	return &_instance;
}

XLUSERID CHallContext::GetLoginUserID()
{
	return g_nUserID;
}

IGameNetEx2* CHallContext::GetGameNet()
{
	LOG_TRACE("GetGameNet - gamenet ptr=" << m_pGameNet);
	if(m_pGameNet != NULL)
		return m_pGameNet;

	if(LoadGameNet())
		return m_pGameNet;
	else
		return NULL;
}

BOOL CHallContext::LoadGameNet()
{
	if(m_pGameNet != NULL)
	{
		LOG_DEBUG("LoadGameNet - gamenet already loaded!");
		return TRUE;
	}

	m_pGameNet = static_cast<IGameNetEx2*>(CGameNetInstance::GetInstance());

	if(m_pGameNet == NULL)
	{
		LOG_ERROR("GetGameNetInstance() return NULL!");
		return FALSE;
	}

	LOG_DEBUG("InitEvent, pointer=" << CGameNetEventHandler::GetInstance());

	m_pGameNet->InitEvent(CGameNetEventHandler::GetInstance());
	return TRUE;
}

IGameUtility* CHallContext::GetGameUtility()
{
	if(m_pGameUtil != NULL)
	{
		return m_pGameUtil;
	}

	m_pGameUtil = GameUtility::GetInstance();
	if(m_pGameUtil == NULL)
	{
		LOG_ERROR("GetGameNetInstance() return NULL!");
		return NULL;
	}

	return m_pGameUtil;
}

void CHallContext::SetGameNetUserInfo(__int64 nUserID, const char* pszUsername)
{
	g_nUserID = nUserID;
}
