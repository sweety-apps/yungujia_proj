
#include "GameCmdFlexFactory.h"

IMPL_LOGGER_EX(GameCmdFlexFactory, GN);

GameCmdFlexFactory::GameCmdFlexFactory()
{

}

GameCmdFlexFactory* GameCmdFlexFactory::GetInstance()
{
	static GameCmdFlexFactory _instance;
	return &_instance;
}

void GameCmdFlexFactory::AddGameCmdNode(LONG lSrcID, LONG lCmdReqID, const char* pCmdReqName, LONG lCmdRespID, const char* pCmdRespName)
{
	if (HasCoupleReqCmd(lCmdReqID, pCmdReqName))
		return;
	
	GameCmdFlexNode node = {0};
	node.lSrcID = lSrcID;
	node.lCmdReqID = lCmdReqID;
	node.lCmdRespID = lCmdRespID;
	node.strCmdReqName = string(pCmdReqName);
	node.strCmdRespName = string(pCmdRespName);

	m_vecCmd.push_back(node);
}

bool GameCmdFlexFactory::HasCoupleRespCmd(IGameCommand* pRespCmd)
{
	if (!pRespCmd) return false;
	for(vector<GameCmdFlexNode>::iterator it = m_vecCmd.begin(); it != m_vecCmd.end(); it++)
	{
		GameCmdFlexNode node = GameCmdFlexNode(*it);
		if(pRespCmd->GetCmdType() == node.lCmdRespID)
		{
			return true;
		}
	}
	LOG_WARN("HasCoupleRespCmd() " << pRespCmd->GetCmdType() << " false");
	return false;
}

bool GameCmdFlexFactory::HasCoupleRespCmd(LONG lCmdRespID)
{
	for(vector<GameCmdFlexNode>::iterator it = m_vecCmd.begin(); it != m_vecCmd.end(); it++)
	{
		GameCmdFlexNode node = GameCmdFlexNode(*it);
		if(lCmdRespID == node.lCmdRespID)
		{
			return true;
		}
	}
	LOG_WARN("HasCoupleRespCmd() " << lCmdRespID << " false");
	return false;
}

bool GameCmdFlexFactory::HasCoupleReqCmd(LONG lCmdReqID, const char* cmdReqName)
{
	for(vector<GameCmdFlexNode>::iterator it = m_vecCmd.begin(); it != m_vecCmd.end(); it++)
	{
		GameCmdFlexNode node = GameCmdFlexNode(*it);
		if(node.lCmdReqID == lCmdReqID 
			&& strncasecmp(node.strCmdReqName.c_str(), cmdReqName, max(0, node.strCmdReqName.length()-3)) == 0)
		{
			return true;
		}
	}
	return false;
}

void GameCmdFlexFactory::AdjustRespCmd(IGameCommand* pRespCmd)
{
	if (!pRespCmd) return;
	for(vector<GameCmdFlexNode>::iterator it = m_vecCmd.begin(); it != m_vecCmd.end(); it++)
	{
		GameCmdFlexNode node = GameCmdFlexNode(*it);
		if(pRespCmd->GetCmdType() == node.lCmdReqID)
		{
			CmdCommonResp *cmdResp = (CmdCommonResp*)pRespCmd;
			cmdResp->m_nCmdSrcID = node.lSrcID;
			cmdResp->m_cmdName = node.strCmdRespName;
			return;
		}
	}

	LOG_WARN("can't find couple common response command");
}

CmdCommonResp* GameCmdFlexFactory::GetCoupleRespCmd(LONG lCmdRespID)
{
	for(vector<GameCmdFlexNode>::iterator it = m_vecCmd.begin(); it != m_vecCmd.end(); it++)
	{
		GameCmdFlexNode node = GameCmdFlexNode(*it);
		if(lCmdRespID == node.lCmdRespID)
		{
			LOG_DEBUG("create common response");
			CmdCommonResp* cmd = new CmdCommonResp();
			cmd->SetCmdRespID(lCmdRespID);
			cmd->m_cmdName = node.strCmdRespName;
			cmd->m_nCmdSrcID = node.lSrcID;
			return cmd;
		}
	}
	return NULL;
}
