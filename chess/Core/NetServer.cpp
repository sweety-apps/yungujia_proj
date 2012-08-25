#include "NetServer.h"
#include "CnChess_define.h"
#include "CnChessLogic.h"
#include "CnChess_PlayerInfo.h"
//#include "SessionConnAgent.h"
//#include "DxNetWrapper.h"
#include <string>
//#include "DataID.h"
//#include "GameHallLogic.h"

//IMPL_LOGGER(CNetServer)

CNetServer::CNetServer()
{
	//LOG_DEBUG("[CnChess]:CNetServer()");
}

CNetServer::~CNetServer(void)
{
	//LOG_DEBUG("[CnChess]:~CNetServer()");
	//	m_pSessionConnection->Close();
}

bool CNetServer::init(int nConnID, CCnChessLogic *pClient)
{
// 	LOG_DEBUG("[CnChess]:init()");
 	m_pCnChessLogic = pClient;
// 	
// 	m_pSessionConnection = RegisterSessionEvent(nConnID, this);
// 	NSLog(@"m_pSessionConnection = %d", m_pSessionConnection);
// 	ysh_assert( m_pSessionConnection );
// 	
// 	LOG_DEBUG("[CnChess]:init() succeed");
	return true;
}


// 服务器的响应
void CNetServer::OnEnterGameResp(int nResult, const vector<XLPLAYERINFO>& tablePlayers)
{
	LOG_ERROR("[CnChess]:OnEnterGameResp(), ERROR!!! NOT purposed to be called!!!");
}
// 服务器的响应
void CNetServer::OnEnterGameResp(int nResult, const vector<PlayerInfoExt>& tablePlayers)
{
 	LOG_INFO("[CnChess]:OnEnterGameResp(), get "<<tablePlayers.size()<<" players");
 	
 	// OnSvrRespIEnterGame()里面处理旁观者的问题
 	if(nResult != 0)
 	{
 		m_pCnChessLogic->OnSvrRespEnterGameFailed(nResult);
 	}
 	else
 	{
 		m_pCnChessLogic->OnSvrRespIEnterGame(nResult, tablePlayers);
 	}
}

void CNetServer::OnEnterGameNotify(XLUSERID nEnterUserID, int nTableID, byte nSeatID, bool isLookOnUser)
{
 	LOG_ERROR("[CnChess]:OnEnterGameNotify(): "<<nEnterUserID<<", nTableID = "<<nTableID<<", nSeatID = "<<nSeatID<<", isLookOnUser = "<<isLookOnUser<<", ERROR!!!! NOT purposed to be called!!!");
 	
 	if(isLookOnUser)
 	{
 		return;
 	}
 	
 	XLPLAYERINFOEX vRec;
 	uint32_t hr = Call("GetPlayerRec", &nEnterUserID, NULL, &vRec );
 	if(!hr)
 	{
 		//PlayerInfoExt tempPlayerInfo = vRec;
 		
 		PlayerInfoExt tempPlayerInfo;
 		InitPlayerInfoExt_From_XLPLAYERINFOEX(tempPlayerInfo, vRec);
 		
 		LOG_DEBUG("[CnChess]:OnEnterGameNotify(), PlayerRec2Info() transform succ.");
 		LOG_DEBUG("[CnChess]:OnEnterGameNotify(), tempPlayerInfo.SeatID = "<<tempPlayerInfo.SeatID);
 		tempPlayerInfo.SeatID = nSeatID;
 		tempPlayerInfo.TableID = nTableID;
 		
 		m_pCnChessLogic->OnSvrRespUserEnterGame(tempPlayerInfo, isLookOnUser);
 	}
 	else
 	{
 		LOG_ERROR("[CnChess]:OnEnterGameNotify(), GetPlayerRec() from hall failed!!!");
 	}
}
//void CNetServer::OnEnterGameNotify(XLUSERID nEnterUserID, int nTableID, byte nSeatID, bool isLookOnUser, IDataXNet* pdata)
//{
//     LOG_INFO("[CnChess]:OnEnterGameNotify(): "<<nEnterUserID<<", nTableID = "<<nTableID<<", nSeatID = "<<nSeatID<<", isLookOnUser = "<<isLookOnUser);
// 	
//     if(isLookOnUser)
//     {
//         return;
//     }
// 	
//     XLPLAYERINFOEX vRec;
//     uint32_t hr = Call("GetPlayerRec", &nEnterUserID, NULL, &vRec );
//     if(!hr)
//     {
//         //PlayerInfoExt tempPlayerInfo = vRec;
// 		
// 		PlayerInfoExt tempPlayerInfo;
// 		InitPlayerInfoExt_From_XLPLAYERINFOEX(tempPlayerInfo, vRec);
// 		
//         DataXNet2PlayerInfoExt(pdata, tempPlayerInfo);
// 		
//         LOG_DEBUG("[CnChess]:OnEnterGameNotify(), PlayerRec2Info() transform succ.");
//         LOG_DEBUG("[CnChess]:OnEnterGameNotify(), tempPlayerInfo.SeatID = "<<tempPlayerInfo.SeatID);
//         tempPlayerInfo.SeatID = nSeatID;
//         tempPlayerInfo.TableID = nTableID;
// 		
//         m_pCnChessLogic->OnSvrRespUserEnterGame(tempPlayerInfo, isLookOnUser);
//     }
//     else
//     {
//         LOG_ERROR("[CnChess]:OnEnterGameNotify(), GetPlayerRec() from hall failed!!!");
//     }
//}
//

void CNetServer::OnGameReadyNotify(XLUSERID nReadyUserID)
{
	LOG_INFO("[CnChess]:OnGameReadyNotify(): "<<nReadyUserID);
	
	m_pCnChessLogic->OnSvrRespGetReady(nReadyUserID);
}

void CNetServer::OnGameStartNotify(int nTableID)
{
// 	LOG_INFO("[CnChess]:OnGameStartNotify(): "<<nTableID);
}

void CNetServer::OnEndGameNotify(int nTableID)
{
 	LOG_INFO("[CnChess]:OnEndGameNotify(): "<<nTableID);
 	m_pCnChessLogic->OnSvrRespSetGameOver();
}

void CNetServer::OnQuitGameResp(int nResult)
{
// 	LOG_INFO("[CnChess]:OnQuitGameResp(): "<<nResult);
}

//void CNetServer::OnQuitGameNotify(XLUSERID nQuitUserID)
//{
// 	LOG_INFO("[CnChess]:OnQuitGameNotify(): "<<nQuitUserID);
// 	
// 	m_pCnChessLogic->OnSvrRespUserQuitGame(nQuitUserID);
//}

//void CNetServer::OnExitRoomNotify(XLUSERID nExitUserID)
//{
// 	LOG_INFO("[CnChess]:OnExitRoomNotify(): "<<nExitUserID);
//}

void CNetServer::OnExitRoomResp(int nResult)
{
// 	LOG_INFO("[CnChess]:OnExitRoomResp(): "<<nResult);
}

void CNetServer::OnChatResp(int nChatSeqNo, int nResult)
{
// 	LOG_INFO("[CnChess]:OnChatResp(): "<<nChatSeqNo<<"result="<<nResult);
}

//void CNetServer::OnChatNotify(const GAMETABLE& tableInfo, XLUSERID nChatUserID, const string& chatMsg)
//{
// 	LOG_INFO("[CnChess]:OnChatNotify()");
//}

void CNetServer::OnGameActionResp(int nResult)
{
// 	LOG_INFO("[CnChess]:OnGameActionResp(): "<<nResult);
}

void CNetServer::OnGameActionNotify(XLUSERID nSubmitUserID, const char* szGameDataBuf, int nDataLen)
{
 	//LOG_INFO("[CnChess]:OnGameActionNotify(), userID="<<nSubmitUserID<<", nDataLen="<<nDataLen);
 	
 	UserInformRequest* pstNotify = (UserInformRequest*)szGameDataBuf;
 	//LOG_DEBUG("[CnChess]:pstNotify->cType = "<<int(pstNotify->cType)<<", iData = "<<ntohl(pstNotify->iData));
 	
 	switch( pstNotify->cType )
 	{
 		case CMD_DLL_NOTIFY_SIDE_FLAG:	// 通知游戏双方颜色
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstNotify->iData);
  			m_pCnChessLogic->OnSvrRespSideFlag(pstNotify->iData);
 			break;
 			
 		case CMD_DLL_NOTIFY_GAME_BEGIN:	// 通知游戏开始
 		{
  			UserInformRequestEx* pstInfo = (UserInformRequestEx*)szGameDataBuf;
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstInfo->iData);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstInfo->iDataEx);
  			m_pCnChessLogic->OnSvrRespGameStart(pstInfo->iData, pstInfo->iDataEx);
 		}
 			break;
 			
 			// 以下是通知游戏结束
 		case CMD_DLL_NOTIFY_GAMEEND_BYWIN:			// 杀死对方
 		case CMD_DLL_NOTIFY_GAMEEND_BYSURRENDER:	// 认输
 		case CMD_DLL_NOTIFY_GAMEEND_BYTIMEOUT:		// 超时
 		case CMD_DLL_NOTIFY_GAMEEND_BYDRAW:			// 和棋
 		case CMD_DLL_NOTIFY_GAMEEND_BYESC:			// 逃跑
 		case CMD_DLL_NOTIFY_GAMEEND_BYABORT:		// 流局
 			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstNotify->iData);
 			m_pCnChessLogic->OnSvrRespGameEndCode(pstNotify->cType, pstNotify->iData);
 			break;
 			
 		case CMD_DLL_REQ_MOVE:	// 走棋（我，或对手）
 		{
 			UserMoveChessRequest* pstMove = (UserMoveChessRequest*)szGameDataBuf;
 			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstMove->nLeftTime);
 			if(pstMove->nLeftTime < 0)
 				pstMove->nLeftTime = 0;
 			m_pCnChessLogic->OnSvrRespMovedAPiece(pstMove);
 		}
 			break;
 			
 		case CMD_DLL_REQ_RETRACTMOVE:	// 悔棋
         {
              UserInformRequestEx* pReq = (UserInformRequestEx*)szGameDataBuf;
              CONVERT_SELF_TO_HOST_BYTE_ORDER(pReq->iData);
              CONVERT_SELF_TO_HOST_BYTE_ORDER(pReq->iDataEx);
              m_pCnChessLogic->OnSvrRespReqRetractMove(nSubmitUserID, pReq->iData, pReq->iDataEx);
         }
 			
 			break;
 		case CMD_DLL_ANSWER_RETRACTMOVE:	// 悔棋的答复
 		{
  			UserInformRequestEx* pstAnswar = (UserInformRequestEx*)szGameDataBuf;
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstAnswar->iData);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstAnswar->iDataEx);
  			m_pCnChessLogic->OnSvrRespAnswerRetractMove(nSubmitUserID, pstAnswar->iData, pstAnswar->iDataEx);
 		}
 			break;
 			
 		case CMD_DLL_REQ_DRAW:	// 和棋
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstNotify->iData);
  			m_pCnChessLogic->OnSvrRespReqDraw(nSubmitUserID, pstNotify->iData);
 			break;
 		case CMD_DLL_ANSWER_DRAW:	// 和棋的答复
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstNotify->iData);
  			m_pCnChessLogic->OnSvrRespAnswerDraw(nSubmitUserID, pstNotify->iData);
 			break;
 			
 		case CMD_DLL_NOTIFY_SET_TIMER:	// 设置时间

  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstNotify->iData);
  			m_pCnChessLogic->OnSvrRespSetTime(pstNotify->iData);
 			break;
 		case CMD_DLL_REQ_CONFIRMTIMER:	// 确认时间
 		{
  			UserInformRequestEx* pstInfo = (UserInformRequestEx*)szGameDataBuf;
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstInfo->iData);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstInfo->iDataEx);
  			m_pCnChessLogic->OnSvrRespConfirmTime(pstInfo->iData, pstInfo->iDataEx);
 		}
 			break;
 			
 		case CMD_DLL_NOTIFY_CHOSE_PIECE:	// 对方选中/取消选中一颗棋子
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pstNotify->iData);
  			m_pCnChessLogic->OnSvrRespUserChoseAPiece(nSubmitUserID, pstNotify->iData);
 			break;
 			
 		case CMD_DLL_NOTIFY_RESUME_GAME:	// 由服务器来重置数据
 		{
  			ResumeGameData *pGameData = (ResumeGameData *)szGameDataBuf;
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pGameData->nTimeCount);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pGameData->nRoundTime);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pGameData->nStepTime);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pGameData->nStepTimeLimit);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pGameData->nCurStepTimeElapsed);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pGameData->nLeftRoundTime[0]);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pGameData->nLeftRoundTime[1]);
  			CONVERT_SELF_TO_HOST_BYTE_ORDER(pGameData->nStepCount);
  			pGameData->ChessStepArr = (ChessStep*)(szGameDataBuf + sizeof(ResumeGameData));
  			
  			m_pCnChessLogic->OnSvrRespReloadGameData(pGameData);
 		}
 			break;
 		case CMD_DLL_NOTIFY_SERVERMODE:
         {
              m_pCnChessLogic->OnSvrSetServerMode(ntohl(pstNotify->iData));
             break;
         }
 		case CMD_BALANCE_NOT_ENOUGH:
         {
             // 不够雷豆支付
              m_pCnChessLogic->Fire_Notify("NotEnoughBalanceRetract");
         }
 			break;
 		case CMD_NOTIFY_RETRACT_MODE:
         {
 			 m_pCnChessLogic->m_ReplayRetractMode = ntohl(pstNotify->iData);
//              LOG_TRACE("[CNetServer::OnGameActionNotify] m_ReplayRetractMode=" << m_pCnChessLogic->m_ReplayRetractMode );
         }
 			break;
 		/*case CMD_NOTIFY_RETRACTBYTOOL_SUCCESS:
         {
             LONG Chair = ntohl(pstNotify->iData);
             LOG_TRACE("[CNetServer::OnGameActionNotify] chair = " << Chair);
             m_pCnChessLogic->NotifyUseRetractToolSuccess(Chair);
         }*/
 			break;
 		case CMD_NOTIFY_LEIDOU_STAT:
         {
             //m_pCnChessLogic->NotifyLeidouStat(pstNotify);
         }
 			break;
 		case CMD_NOTIFY_SHOULD_DRAW:
         {
              m_pCnChessLogic->Fire_Notify("ShouldDraw");
         }
 			break;
 		case CMD_NOTIFY_GAMEEND_TIME:
         {
              m_pCnChessLogic->NotifyGameEndTime(pstNotify);
         }
 			break;
 		default:
 			//LOG_WARN("[CnChess]:unknown cmdType. cType = "<<int(pstNotify->cType)<<", iData = "<<ntohl(pstNotify->iData));
 			break;
 	}
}

//void CNetServer::OnUserScoreChanged(XLUSERID nChangeUserID, const XLGAMESCORE& scoreInfo)
//{
// 	LOG_INFO("[CnChess]:OnUserScoreChanged(): "<<nChangeUserID<<", score = "<<scoreInfo.PointsDelta);
	//	m_pCnChessLogic->OnSvrRespUserScoreChanged(nChangeUserID, scoreInfo);
//}

//void CNetServer::OnCmdSimpeleResp(SIMPLE_RESP_CMD_ID nRespCmdID, int nResult)
//{
// 	LOG_INFO("[CnChess]:OnCmdSimpeleResp(): "<<nRespCmdID<<", "<<nResult);
//}

//void CNetServer::OnPlayerStatusChanged(XLUSERID nPlayerID, PLAYER_STATUS_ACTION_ENUM nStatusAction)
//{
// 	LOG_INFO("[CnChess]:OnPlayerStatusChanged(): "<<nPlayerID<<", status = "<<int(nStatusAction));
// 	m_pCnChessLogic->OnSvrRespPlayerStatusChanged(nPlayerID, nStatusAction);
//}

void CNetServer::OnNetworkError(int iErrorCode)
{
// 	LOG_ERROR("[CnChess]:OnNetworkError(): error code = "<<iErrorCode);
// 	NSNumber *v0 = [NSNumber numberWithInt:iErrorCode];
// 	m_pCnChessLogic->Fire_Notify(@"OnGameQuit", v0);
}

/*

uint32_t CNetServer::OnNotify(const string &event, const void * param1, const void * param2)
{
	LOG_INFO("[CnChess]:OnNotify(): event = "<<event);
	if(event == _T("GameHallBroken"))
	{
		//		m_pCnChessLogic->Fire_Notify(CComBSTR(L"OnGameQuit"), CComVariant(_T("游戏大厅出现异常！")));
	}
	else if(event == _T("STARTTIMEOUT"))
	{
		//		m_pCnChessLogic->Fire_Notify(CComBSTR(L"OnGameQuit"), CComVariant(_T("游戏长时间未开始，将自动退出！")));
	}
	else if(event == _T("MUSICBOXNOTIFY"))
	{
		//m_pCnChessLogic->Fire_Notify(@"OnMusicBoxStatus", param1, param2);
	}
    else if(event == _T("CMDTOGAME"))
    {
        IDataXNet *dx = (IDataXNet *)(param2);
		string strParam = dx->GetString(DataID_Param2, event2);
        LOG_TRACE("[CnChess]:OnNotify()] "<<strParam);
        int pos = strParam.Find('$');
        if(pos == -1)
        {
            m_pCnChessLogic->Fire_Notify(strParam);
        }
        else
        {
            int count = 0;
			vector<string> strArray;
            count = utility::split_string(strParam, "$", strArray);
            if( count < 2)
            {
				LOG_TRACE("[CNetServer::OnNotify] splitstring error");
				return S_OK; 
            }
            else
            {
                string &event2 = strArray[0];
                string &param = strArray[1];
                if(NULL != event2  &&  NULL != param)
                {
                    LOG_TRACE("[CnChess]:OnNotify()] event"<<event2);
                    LOG_TRACE("[CnChess]:OnNotify()] event"<<param);
                    m_pCnChessLogic->Fire_Notify(event2, CComVariant(param));
                }
                if(NULL != event2)
                {
                    LOG_TRACE("[CnChess]:OnNotify()] event"<<event2);
                }
                if(NULL != param)
                {
                    LOG_TRACE("[CnChess]:OnNotify()] event"<<param);
                }
            }
        }
        LOG_TRACE("Data value11222333==="<<strParam);
		
    }
	else if(event == _T("KICKOUTCOUNTDOWNNOTIFY"))
	{
		m_pCnChessLogic->Fire_Notify(@"KickOutCountDownNotify", param1, param2);
	}
    
	 //else if(event == _T("NEEDREPLAY"))
	// {
	 //Replay( m_pCnChessLogic->GetGameSeatInfo().GameSeat);
	 //}
	
	return S_OK;
}
*/

void CNetServer::OnKickout(KICKOUT_REASON_ENUM kickReason, XLUSERID nWhoKickMe)
{
 	//LOG_INFO("[CnChess]:OnKickout(): kickReason = "<<kickReason<<", by user: "<<nWhoKickMe);
	//m_pCnChessLogic->Fire_Notify(CComBSTR(L"OnGameQuit"), CComVariant(_T("您已被踢出游戏！")));
}

//void CNetServer::OnGenericResp(const string& cmdName, int nResult, IDataXNet* pDataX)
//{
// 	LOG_DEBUG("[CnChess]:OnGenericResp() called, cmdName='" << cmdName << ", result=" << nResult);
// 	
// 	if(strcasecmp(cmdName.c_str(), "TryEnterTableResp") == 0)
// 	{
// 		HandleTryEnterTableResp(nResult, pDataX);
// 	}
// 	else if(strcasecmp(cmdName.c_str(), "EnterTableResp") == 0)
// 	{
// 		HandleTryEnterTableResp(nResult, pDataX);
// 	}
//	//if(strcmp(cmdName.c_str(), "GetUserConfigResp") == 0)
//	//{
//	//	HandleUserConfigResp(nResult, pDataX);   // 游戏不必处理这个命令
//	//}
//	//else if(strcmp(cmdName.c_str(), "ChatResp") == 0)
//	//{
//	//	HandleGenericChatResp(nResult, pDataX); // 游戏不必处理这个命令; GameCom已处理
//	//}
//	//else if(strcmp(cmdName.c_str(), "KickPlayerResp") == 0)
//	//{
//	//	HandleKickPlayerResp(nResult, pDataX); // 游戏要处理
//	//}
// 	else
// 	{
// 		LOG_WARN("OnGenericResp(): Unknown cmdName: " << cmdName);
// 	}
//}
//
//void CNetServer::OnGenericNotify(const string& cmdName, const GAMEROOM& roomInfo, IDataXNet* pDataX)
//{
// 	LOG_DEBUG("[CnChess]:OnGenericNotify() called, cmdName='" << cmdName << "'");
// 	
// 	if(strcmp(cmdName.c_str(), "ChatNotifyReq") == 0)
// 	{
// 		//	HandleChatNotify(roomInfo, pDataX);  // 游戏不必处理这个命令; GameCom已处理
// 	}
// 	else if(strcmp(cmdName.c_str(), "KickPlayerNotifyReq") == 0)
// 	{
// 		m_pCnChessLogic->ShowAlert("KickPlayerNotifyReq");
// 		//	HandleKickPlayerNotify(roomInfo, pDataX);  // 游戏不必处理这个命令; GameCom已处理
// 	}
// 	else if(strcmp(cmdName.c_str(), "NotifyUserStatusReq") == 0) 
// 	{
// 		HandleUserStatusNotify(roomInfo, pDataX);  // 用户状态变化
// 	}
// 	else if(strcmp(cmdName.c_str(), "NotifyUserScoreChangeReq") == 0) 
// 	{
// 		HandleUserScoreChangedNotify(roomInfo, pDataX);  // 用户积分变化
// 	}
// 	else if(strcmp(cmdName.c_str(), "NotifyMagicToolChangeReq") == 0)
// 	{
// 		//HandleMagicToolChanged(roomInfo, pDataX);	// 用户道具信息
// 	}
//     else if(strcmp(cmdName.c_str(), "NotifyUserInfoReq") == 0)
//     {
//         //HandleNotifyUserInfoReq(pDataX);
//     }
// 	else
// 	{
// 		LOG_WARN("[CnChess]:OnGenericNotify(): Unknown cmdName: " << cmdName);
// 	}
//}

//void CNetServer::HandleKickPlayerResp(int nResult, IDataXNet* pDataX)
//{
// 	if(nResult != 0)
// 	{
// 		LOG_WARN("[CnChess]:HandleKickPlayerResp(): result=" << nResult);
// 	}
// 	m_pCnChessLogic->Fire_Notify("OnKickPlayerResp", nResult);
//}
//
//void CNetServer::HandleTryEnterTableResp( int nResult, IDataXNet* pDataX )
//{
// 	LOG_INFO("HandleTryEnterTableResp(), nResult = "<<nResult);
// 	
// 	int nDataXArraySize = 0;
// 	bool bRet = pDataX->GetDataXArraySize(DataID_Param1, nDataXArraySize);
// 	vector<PlayerInfoExt> tablePlayers;
// 	if(!bRet)
// 	{
// 		LOG_ERROR("HandleTryEnterTableResp(), get tableplayer count error!");
// 		nResult = -100;
// 	}
// 	else
// 	{
// 		LOG_DEBUG("HandleTryEnterTableResp(), get tableplayer count = "<<nDataXArraySize);
// 		
// 		if( nDataXArraySize >= 1)
// 		{
// 			//tablePlayers.reserve(nDataXArraySize);
// 			
// 			IDataXNet *pDataXNet = NULL;
// 			PlayerInfoExt onePlayer;
// 			for(int i=0; i<nDataXArraySize; ++i)
// 			{
// 				bRet = pDataX->GetDataXArrayElement(DataID_Param1, i, &pDataXNet);
// 				if(!bRet)
// 				{
// 					LOG_ERROR("HandleTryEnterTableResp(), get tableplayer info error! i = "<<i);
// 					nResult = -101;
// 					break;
// 				}
// 				DataXNet2PlayerInfoExt(pDataXNet, onePlayer);
// 				if (pDataXNet) {
// 					delete pDataXNet;
// 					pDataXNet = NULL;
// 				}
// 
// 				pDataXNet = NULL;
// 				tablePlayers.push_back(onePlayer);
// 			}
// 		}
// 		LOG_INFO("HandleTryEnterTableResp(), get tableplayer info succeed!");
// 	}
// 	OnEnterGameResp(nResult, tablePlayers);
// 	
// 	// 获取道具信息
// 	IDataXNet *pDataXNet = NULL;
// 	for(int i=0; i<nDataXArraySize; ++i)
// 	{
// 		bRet = pDataX->GetDataXArrayElement(DataID_Param1, i, &pDataXNet);
// 		if(bRet && GAME_USER_STATUS(tablePlayers[i].UserStatus) != LOOKON)
// 		{
// 			LOG_DEBUG("HandleTryEnterTableResp(), call HandleMagicToolChanged(). i = "<<i);
// 			//GAMEROOM x;
// 			//HandleMagicToolChanged(x, pDataXNet);
// 		}
// 		if (pDataXNet) {
// 			delete pDataXNet;
// 			pDataXNet = NULL;
// 		}
// 	}
//}
//
//void CNetServer::HandleKickPlayerNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
//{
// 	LOG_DEBUG("[CnChess]:HandleKickPlayerNotify() called.");
// 	
// 	if(pDataX == NULL)
// 	{
// 		LOG_WARN("[CnChess]:HandleKickPlayerNotify(): pDataX param is NULL!");
// 		return;
// 	}
// 	
// 	DxNetWrapper wrapper(pDataX);
// 	//unsigned short nTableID = (unsigned short)wrapper.GetShort(DataID_TableID);
// 	short nReason = wrapper.GetShort(DataID_KickReason);
// 	__int64 nKickUserID = wrapper.GetInt64(DataID_UserID);
// 	
// 	//LOG_DEBUG("[CnChess]:HandleKickPlayerNotify(): tableID=" << nTableID << ", kickReason=" << nReason << ", kickUserID=" << nKickUserID);
// 	
// 	OnQuitGameResp(0);
// 	
// 	OnKickout((KICKOUT_REASON_ENUM)nReason, nKickUserID);
//}
//
//void CNetServer::HandleUserStatusNotify(const GAMEROOM& roomInfo, IDataXNet* pDataX)
//{
// 	LOG_DEBUG("[CnChess]:HandleUserStatusNotify() called.");
// 	
// 	if(pDataX == NULL)
// 	{
// 		LOG_ERROR("[CnChess]:HandleUserStatusNotify(): pDataX param is NULL!");
// 		return;
// 	}
// 	
// 	DxNetWrapper wrapper(pDataX);
// 	XLUSERID nUserID = wrapper.GetInt64(DataID_UserID, -1);
// 	short nTableID = wrapper.GetShort(DataID_TableID, -1);
// 	short nSeatID = wrapper.GetShort(DataID_SeatID, -1);
// 	int nChangeType = wrapper.GetShort(DataID_ChangeType, -1);
// 	LOG_DEBUG("HandleUserStatusNotify(): nUserID=" << nUserID << ", TableID=" << nTableID << ", SeatID=" << nSeatID << ", ChangeType=" << nChangeType);
// 	
// 	if(nChangeType == ENTER_TABLE_PLAY)
// 	{
// 		LOG_INFO( "[CnChess]:HandleUserStatusNotify(): " << nChangeType << " => EnterGame(sitdown) ");
// 		OnEnterGameNotify(nUserID,nTableID, nSeatID, false, pDataX);
// 	}
// 	else if(nChangeType == ENTER_TABLE_LOOKON)
// 	{
// 		LOG_INFO( "[CnChess]:HandleUserStatusNotify(): " << nChangeType << " => EnterGame(lookon) ");
// 		OnEnterGameNotify(nUserID, nTableID, nSeatID, true, pDataX);
// 	}
// 	else if(nChangeType == USER_READY)
// 	{
// 		LOG_INFO( "[CnChess]:HandleUserStatusNotify(): " << nChangeType << " => GameReady ");
// 		OnGameReadyNotify(nUserID);
// 		OnPlayerStatusChanged(nUserID, PLAYER_IS_READY);
// 	}
// 	else if(nChangeType == GAME_START)
// 	{
// 		LOG_INFO( "[CnChess]:HandleUserStatusNotify(): " << nChangeType << " => GameStart ");
// 		OnGameStartNotify(nTableID);
// 	}
// 	else if(nChangeType == EXIT_TABLE)
// 	{
// 		LOG_INFO( "[CnChess]:HandleUserStatusNotify(): " << nChangeType << " => QuitGame ");
// 		OnQuitGameNotify(nUserID);
// 		OnPlayerStatusChanged(nUserID, PLAYER_EXIT_TABLE);
// 	}
// 	else if(nChangeType == EXIT_ROOM)
// 	{
// 		LOG_INFO( "[CnChess]:HandleUserStatusNotify(): " << nChangeType << " => ExitRoom ");
// 		OnExitRoomNotify(nUserID);
// 		OnPlayerStatusChanged(nUserID, PLAYER_EXIT_ROOM);
// 	}
// 	else if(nChangeType == GAME_END)
// 	{
// 		LOG_INFO( "[CnChess]:HandleUserStatusNotify(): " << nChangeType << " => GameEnd ");
// 		OnEndGameNotify(nTableID);
// 	}
// 	else if(nChangeType == USER_DROPOUT)
// 	{
// 		LOG_INFO( "[CnChess]:HandleUserStatusNotify(): " << nChangeType << " => Dropout ");
// 		OnPlayerStatusChanged(nUserID, PLAYER_DROPOUT);
// 	}
// 	else if(nChangeType == USER_DROP_RESUME)
// 	{
// 		LOG_INFO( "[CnChess]:HandleUserStatusNotify(): " << nChangeType << " => DropResume ");
// 		OnPlayerStatusChanged(nUserID, PLAYER_DROP_RESUME);
// 	}
// 	else
// 	{
// 		LOG_WARN( "[CnChess]:Unknown change type( " << nChangeType << ") in HandleUserStatusNotify()!");
// 	}
//	
//}
//
//
//void CNetServer::HandleUserScoreChangedNotify(const GAMEROOM& room, IDataXNet* pDataX )
//{
// 	LOG_DEBUG("[CnChess]:HandleUserScoreChangedNotify() called.");
// 	
// 	int nPlayers = 0;
// 	bool bRet = pDataX->GetDataXArraySize(DataID_Param1, nPlayers);
// 	if(!bRet)
// 	{
// 		LOG_ERROR("[CnChess]:HandleUserScoreChangedNotify(), get table players count ERROR!");
// 		return;
// 	}
// 	
// 	LOG_DEBUG("[CnChess]:HandleUserScoreChangedNotify(), get table players count = "<<nPlayers);
// 	
// 	std::vector<XLGAMESCOREEXT> scoreInfo(nPlayers);
// 	for(int i=0; i<nPlayers; ++i)
// 	{
// 		IDataXNet *pDataXNet = NULL;
// 		bRet = pDataX->GetDataXArrayElement(DataID_Param1, i, &pDataXNet);
// 		
// 		if(!bRet)
// 		{
// 			LOG_WARN("[CnChess]:HandleUserScoreChangedNotify(), can NOT get playerinfo [" << i << "]");
// 			continue;
// 		}
// 		
//         m_pCnChessLogic->HandleUserLevelChanged(pDataXNet);
// 		
// 		DataXNet2XLGameScoreExt(pDataXNet, scoreInfo[i]);
//         LOG_TRACE("[CNetServer::HandleUserScoreChangedNotify] scoredelta=" << scoreInfo[i].PointsDelta);
// 		
// 		LOG_DEBUG("[CnChess]:HandleUserScoreChangedNotify(), userid=" << scoreInfo[i].UserID << ", xlScore=" << scoreInfo[i].Score);
// 	}
// 	m_pCnChessLogic->OnSvrRespUserScoreChanged(scoreInfo);
//	
//}
//
//
//void CNetServer::HandleNotifyUserInfoReq(IDataXNet* pDataX)
//{
//    LOG_DEBUG("HandleUserInfoChanged () called.");
//    /*
//	
//	DxNetWrapper wrapper(pDataX);
//	
//    short nChangeType = wrapper.GetShort(DataID_ChangeType, 0);
//    LOG_DEBUG("HandleUserInfoChanged - changetype=" << nChangeType);
//    if(0 == nChangeType)
//    {
//        return;
//    }
//	
//    XLUSERID userid = wrapper.GetInt64(DataID_UserID, 0);
//	
//    if (nChangeType == 2) // 用户信息变化
//    {
//        PlayerInfoExt* playerInfo = NULL;
//        if(m_pCnChessLogic->m_PlayerInfo_Mine.UserID == userid)
//        {
//            playerInfo = &m_pCnChessLogic->m_PlayerInfo_Mine;
//        }
//        else if(m_pCnChessLogic->m_PlayerInfo_Rival.UserID == userid)
//        {
//            playerInfo = &m_pCnChessLogic->m_PlayerInfo_Rival;
//        }
//		
//        if(NULL == playerInfo)
//        {
//            return;
//        }
//        
//        unsigned char level = playerInfo->Level;
//		
//        DataXNet2PlayerInfoExt(pDataX, *playerInfo);
//        if(playerInfo->Level > level)
//        {
//            char role =  (playerInfo == &m_pCnChessLogic->m_PlayerInfo_Mine) ? 0 : 1;
//			NSString *v = [NSString stringWithCharacters:&role length:1];
//            m_pCnChessLogic->Fire_Notify(@"ImproveLevel", v);
//        }
//		
//        PlayerInfoExt* outPlayer = new PlayerInfoExt(*playerInfo);
//        PlayerInfoExt2DataX(*playerInfo, dxPlayer);
//        m_pCnChessLogic->Fire_Notify(CComBSTR(L"OnUserInfoChanged"), playerInfo);
//    }
//	*/
//}

/*
void CNetServer::HandleMagicToolChanged(const GAMEROOM& roomInfo, IDataXNet* pDataX)
{
	DxNetWrapper wrapper(pDataX);
	XLUSERID userID = wrapper.GetInt64(DataID_UserID, 0);
	LOG_DEBUG("[CnChess]:HandleMagicToolChanged() called, userID = "<<userID);

    // 调用象棋专用道具处理过程
    m_pCnChessLogic->OnNotifyMyCnChessMagicToolsInfo(userID, pDataX);


	PDataX dx = PDataX::CreateInstance();
	MagicToolListDataXNet2DataX(pDataX, dx.p);
	LOG_DEBUG("[CnChess]:HandleMagicToolChanged(), dx[DataID_Amount] = "<<dx[DataID_Amount]);
	m_pCnChessLogic->OnSvrRespMagicToolInfo(userID, dx);
}*/

void CNetServer::SubmitGameAction(const GAMEROOM& roomInfo, const char* pszGameData, int nDataLen)
{
	int status;
	JNIEnv *env = NULL;	
	jclass comPlay_class;
	jobject comPlay_object;
	jmethodID comPlay_id, function_id;

	//获得环境
	status = (*m_pCnChessLogic->_vm).GetEnv((void**) &env, JNI_VERSION_1_4);
	if (status != JNI_OK)
		return;

	comPlay_class = env->FindClass("com/ysh/chess/NetServer");
	comPlay_id = (*env).GetMethodID(comPlay_class , "<init>", "()V");
	comPlay_object = (*env).NewObject(comPlay_class, comPlay_id);
	function_id = env->GetMethodID(comPlay_class,"submitGameAction","([B)V");

	jbyteArray iarr = env->NewByteArray(nDataLen);
	if(iarr == NULL)
	{
		return; 		
	}   
	env->SetByteArrayRegion(iarr,0,nDataLen,(const jbyte*)pszGameData);
	env->CallVoidMethod(comPlay_object,function_id,iarr);
}

void CNetServer::EnterGame(const GAMESEAT& seatInfo, GAME_USER_STATUS userStatus, const string& initialTableKey, const string& followPasswd)
{
	//m_pCnChessLogic->OnSvrRespGameStart(0,0);
}