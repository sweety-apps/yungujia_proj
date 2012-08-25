#ifndef __GAME_COMMAND_FLEXIBILITY_FACTORY_H_20100724_19
#define __GAME_COMMAND_FLEXIBILITY_FACTORY_H_20100724_19

#include "common/GameNetInf.h"
#include "GameCmdBase.h"
#include "CmdCommon.h"

#pragma pack(push)
#pragma pack(4)

typedef struct tagGameCmdFlexNode
{
	LONG lSrcID;
	LONG lCmdReqID;
	LONG lCmdRespID;
	string strCmdReqName;
	string strCmdRespName;
}GameCmdFlexNode, *PGameCmdFlexNode;

#pragma pack(pop)

class GameCmdFlexFactory
{
	GameCmdFlexFactory();

public:
	static GameCmdFlexFactory* GetInstance();

	void AddGameCmdNode(LONG lSrcID, LONG lCmdReqID, const char* pCmdReqName, LONG lCmdRespID, const char* pCmdRespName);
	bool HasCoupleRespCmd(IGameCommand* pRespCmd);
	bool HasCoupleRespCmd(LONG lCmdRespID);
	bool HasCoupleReqCmd(LONG lCmdReqID, const char* cmdReqName);
	void AdjustRespCmd(IGameCommand* pCmd);
	CmdCommonResp* GetCoupleRespCmd(LONG lCmdRespID);
private:
	vector<GameCmdFlexNode> m_vecCmd;

	DECL_LOGGER;
};

#endif
