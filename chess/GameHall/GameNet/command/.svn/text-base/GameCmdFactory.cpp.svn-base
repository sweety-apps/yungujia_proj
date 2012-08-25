
#include "GameCmdFactory.h"

#include "CmdGetDir.h"
#include "CmdAskStart.h"
#include "CmdQuitGame.h"
#include "CmdExitRoom.h"
#include "CmdSubmitAction.h"
#include "CmdChat.h"
#include "CmdChatNotify.h"
#include "CmdGameActionNotify.h"
#include "CmdPing.h"
#include "CmdKickout.h"
#include "CmdReplay.h"
#include "CmdGameSvrDx.h"
#include "CmdNonSessionDx.h"
#include "CmdBalanceSvrDx.h"
#include "GameCmdFlexFactory.h"
#include "CmdGetUserGameInfo.h"

IMPL_LOGGER_EX(GameCmdFactory, GN);

IGameCommand* GameCmdFactory::create_cmd_by_typeid(short cmd_typeid)
{
	IGameCommand* cmd = NULL;
	switch(cmd_typeid)
	{
	case CMD_ID_GETDIR:
		cmd = new CmdGetDir();
		break;
	case CMD_ID_GETDIR_RESP:
		cmd = new CmdGetDirResp();
		break;
	case CMD_ID_ENTERROOM:
		//cmd = new CmdEnterRoom();
		break;
	case CMD_ID_ENTERROOM_RESP:
		//cmd = new CmdEnterRoomResp();
		break;
	case CMD_ID_ENTERTABLE:
		//cmd = new CmdEnterTable();
		break;
	case CMD_ID_ENTERTABLE_RESP:
		//cmd = new CmdEnterTableResp();
		break;
	case CMD_ID_ASKSTART:
		cmd = new CmdAskStart();
		break;
	case CMD_ID_ASKSTART_RESP:
		cmd = new CmdAskStartResp();
		break;
	case CMD_ID_QUITGAME:
		cmd = new CmdQuitGame();
		break;
	case CMD_ID_QUITGAME_RESP:
		cmd = new CmdQuitGameResp();
		break;
	case CMD_ID_EXITROOM:
		cmd = new CmdExitRoom();
		break;
	case CMD_ID_EXITROOM_RESP:
		cmd = new CmdExitRoomResp();
		break;
	case CMD_ID_SUBMIT_ACTION:
		cmd = new CmdSubmitAction();
		break;
	case CMD_ID_CHAT:
		cmd = new CmdChat();
		break;
	case CMD_ID_CHAT_RESP:
		cmd = new CmdChatResp();
		break;
	case CMD_ID_USERINFO_CHG_NOTIFY:
		//cmd = new CmdUserInfoChgNotify();
		break;
	case CMD_ID_USERSCORE_CHG_NOTIFY:
		//cmd = new CmdUserScoreChgNotify();
		break;
	case CMD_ID_USERSTATUS_CHG_NOTIFY:
		//cmd = new CmdUserStatusChgNotify();
		break;
	case CMD_ID_CHAT_NOTIFY:
		cmd = new CmdChatNotify();
		break;
	case CMD_ID_GAMEACTION_NOTIFY:
		cmd = new CmdGameActionNotify();
		break;
	case CMD_ID_PING:
		cmd = new CmdPing();
		break;
	case CMD_ID_PING_RESP:
		cmd = new CmdPingResp();
		break;
	case CMD_ID_KICKOUT:
		cmd = new CmdKickoutNotify();
		break;
	case CMD_ID_GETUSERGAMEINFO:
		cmd = new CmdGetUserGameInfo();
		break;
	case CMD_ID_GETUSERGAMEINFO_RESP:
		cmd = new CmdGetUserGameInfoResp();
		break;
	case CMD_ID_REPLAY:
		cmd = new CmdReplay();
		break;
	case CMD_ID_REPLAY_RESP:
		cmd = new CmdReplayResp();
		break;
	case CMD_ID_GAMESVR_DATAX:
		cmd = new CmdGameSvrDataX();
		break;
	case CMD_ID_GAMESVR_DATAX_RESP:
		cmd = new CmdGameSvrDataXResp();
		break;
	case CMD_ID_NONSESSION_DATAX:
		cmd = new CmdNonSessionDataX();
		break;
	case CMD_ID_NONSESSION_DATAX_RESP:
		cmd = new CmdNonSessionDataXResp();
		break;
	case CMD_ID_USERSTATUSSVR_DATAX:
		//cmd = new CmdUserStatusSvrDataX();
		break;
	case CMD_ID_USERSTATUSSVR_DATAX_RESP:
		//cmd = new CmdUserStatusSvrDataXResp();
		break;
    case CMD_ID_BALANCE_SVR_DATAX:
        cmd = new CmdBalanceSvrDataX();
        break;
    case CMD_ID_BALANCE_SVR_DATAX_RESP:
        cmd = new CmdBalanceSvrDataXResp();
        break;
	case CMD_ID_TIMED_MATCH_DATAX:
		//cmd = new CmdTimedMatchDataX();
		break;
	case CMD_ID_TIMED_MATCH_DATAX_RESP:
		//cmd = new CmdTimedMatchDataXResp();
		break;
	case CMD_ID_USERGUIDE_SVR_DATAX:
		//cmd = new CmdUserGuideSvrDataX();
		break;
	case CMD_ID_USERGUIDE_SVR_DATAX_RESP:
		//cmd = new CmdUserGuideSvrDataXResp();
		break;
	case CMD_ID_CHIP_SVR_DATAX:
		//cmd = new CmdChipSvrDataX();
		break;
	case CMD_ID_CHIP_SVR_DATAX_RESP:
		//cmd = new CmdChipSvrDataXResp();
		break;
	case CMD_ID_TABSTATUS_SVR_DATAX_RESP:
		//cmd = new CmdTabStatusSvrDataXResp();
		break;
	default:
		if (GameCmdFlexFactory::GetInstance()->HasCoupleRespCmd(LONG(cmd_typeid)))
		{
			cmd = GameCmdFlexFactory::GetInstance()->GetCoupleRespCmd(cmd_typeid);
		}
		else
			LOG_WARN( "!! Unknown command id: " << cmd_typeid);
	}

	return cmd;
}
