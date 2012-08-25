/*
 *  CnChessLogic.cpp
 *  yshGameCnChess
 *
 *  Created by Tony Zhang on 10/28/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include <iostream>
#include <locale>

#include "CnChessLogic.h"
#include "CnChess_Protocol.h"
//#include "DataXImpl.h"
//#include "GameNetTypes.h"
//#include "DataID.h"
//#include "xlErr.h"
#include "CnChessAI.h"



#ifndef S_OK
#define S_OK 0
#endif

#ifndef S_FALSE
#define S_FALSE -1
#endif
	
	
#ifndef E_NOTIMPL
#define E_NOTIMPL 0x80004001
#endif

#ifndef E_POINTER
#define E_POINTER 0x80004003
#endif	

#ifndef E_FAIL
#define E_FAIL 0x80004005
#endif		

#ifndef E_INVALIDARG
#define E_INVALIDARG 0x80070057
#endif		


	
using namespace std;


vector<int> CCnChessLogic::ParseDescribeStr(char ch[256])
{
	vector<int> ivec;
	int value = 0;
	int fuhao = 1;
	int value1 = 0;
	int value2 = 0;
	char *p = ch;
	while (*p)
	{
		if ('-' == *p)
		{
			fuhao = -1;
		}
		else if (',' == *p)
		{
			value1 = value * fuhao;
			value = 0;
			fuhao = 1;
		}
		else if ('|' == *p)
		{
			value2 = value * fuhao;
			value = 0;
			fuhao = 1;
			ivec.push_back(value1);
			ivec.push_back(value2);
		}
		else if (*p >= '0' && *p <= '9')
		{
			value = value * 10 + (*p - '0');
		}
		else
		{
			
		}
		p++;
	}
	
	return ivec;
}

vector<int> CCnChessLogic::ParseDescribeStr2(char ch[256])
{
	char ch2[256];
	sprintf(ch2, "%s|",ch);
	return ParseDescribeStr(ch2);
}

jstring CCnChessLogic::stoJstring( JNIEnv* env, const char* pat )
{
	jclass strClass = env->FindClass("I");
	jmethodID ctorID = env->GetMethodID(strClass, "<init>", "([BLjava/lang/String;)V");
	jbyteArray bytes = env->NewByteArray(strlen(pat));
	env->SetByteArrayRegion(bytes, 0, strlen(pat), (jbyte*)pat);
	jstring encoding = env->NewStringUTF("utf-8");
	return (jstring)env->NewObject(strClass, ctorID, bytes, encoding);
}

uint32_t CCnChessLogic::Fire_Notify(const char *method, int param1, int param2,NOTIFYTYPE type,vector<int>* Vec)
{
	LOG_DEBUG("CCnChessLogic::Fire_Notify");
	int status;
	JNIEnv *env = NULL;	
	//jclass comPlay_class;
	jobject comPlay_object;
       jmethodID comPlay_id, function_id;
      
	//获得环境
	
    
	status = _vm->GetEnv((void**) &env, JNI_VERSION_1_4);

       if(status < 0) {

                status = _vm->AttachCurrentThread(&env, NULL);
                if(status < 0) 
		 {
                      LOGI("AImove",": get JNIEnv failed!");
                       return  0;
                }
                  isAttached = true;
       }
   

	LOGI("AImove",": env is not NULL!");
	//comPlay_class = env->FindClass("com/ysh/chess/ChessLogicJNI");
	//LOGI("AImove",": FindClass finish!");
	if(jcls==NULL)
		LOGI("AImove","comPlay_class==NULL");
	//if(comPlay_id==NULL)
	    comPlay_id = (*env).GetMethodID(jcls, "<init>", "()V");
	//if(comPlay_object==NULL)
	    comPlay_object = (*env).NewObject(jcls, comPlay_id);
	//if(function_id==NULL)
	    function_id = env->GetMethodID(jcls,"Fire_Notify","([I)V");
       LOGI("AImove",": GetMethodID finish!");
	int size = 0;
	if(Vec!=0)
	{
		size = Vec->size();
	}
	size+=3;
	jint buf[size];   
  
  for(int i = 3;i<size;i++)
  {
  		buf[i] = Vec->at(i-3);
  }
  buf[0] = int(type);
  buf[1] = param1;
  buf[2] = param2;
  jintArray iarr = env->NewIntArray(size);
  if(iarr == NULL)
  {
 		return NULL; 		
 }   
  
  env->SetIntArrayRegion(iarr,0,size,buf);
  {
  	LOGI("AImove",": Begin call Fire_Notify!");
	env->CallVoidMethod(comPlay_object,function_id,iarr);
	LOGI("AImove",": Finish calling Fire_Notify!");
  }
  if(isAttached==true)
  {
  	_vm->DetachCurrentThread();
	isAttached=false;
  }
  return 0;
}
CCnChessLogic::CCnChessLogic()//xx:m_replay(this)
{
	InitCallMap();
	
	m_bRedSide = false;
	m_bGameSarted = false;
	m_bMyTurn = false;
	m_nStepCount 	= 0;
	m_GameStatus = GAME_UNKNOWN;
	m_bInATable = false;
	m_nRecvScoreCount = 	0;
	m_bRecvGameEnd = false;
	
    m_bOpenProtectMagic = false;
 
	m_lServerMode       = 0;
    m_bUserHandleProtect = false;
	
	
 
	m_AiInterface = NULL;
    m_bJustRetractMove = false;
    m_RetractSeqCount = 	0;
    m_bUseRetractTool = false;
    m_bMyReqRetract = false;
	
	
	isNeedMainThread = false;
	isAttached=false;
	_vm = NULL;

	_thiz = 0;
}

CCnChessLogic::~CCnChessLogic()
{
	
}

void CCnChessLogic::InitCallMap()
{
	//TSAUTO();
	m_mapCall.clear();
	m_mapCall["GETLASTERRORINT"]			= &CCnChessLogic::GetLastErrorInt;
	m_mapCall["GETLASTERRORSTR"]			= &CCnChessLogic::GetLastErrorStr;
	//m_mapCall["GETVERSIONINT"]				= &CCnChessLogic::GetVersionInt;
	//m_mapCall["GETVERSIONSTR"]				= &CCnChessLogic::GetVersionStr;
	
	m_mapCall["INIT"]						= &CCnChessLogic::Init;
	m_mapCall["GETREADY"]					= &CCnChessLogic::GetReady;
	m_mapCall["REQUESTSURRENDER"]			= &CCnChessLogic::RequestSurrender;
	m_mapCall["REQUESTDRAW"]				= &CCnChessLogic::RequestDraw;
	m_mapCall["REQUESTRETRACTMOVE"]			= &CCnChessLogic::RequestRetractMove;
	m_mapCall["PRACTICERETRACTMOVE"]		= &CCnChessLogic::PracticeRetractMove;
	m_mapCall["DOUBLEPRACTICERETRACTMOVE"]	= &CCnChessLogic::DoublePracticeRetractMove;
    m_mapCall["REQUESTRETRACTBYGAMEPROP"]	= &CCnChessLogic::RequestRetractByGameProp;
	//m_mapCall["SHOWREPLAY"]					= &CCnChessLogic::ShowReplay;
	m_mapCall["GETUSERID"]					= &CCnChessLogic::GetUserID;
	m_mapCall["USERCLICK"]					= &CCnChessLogic::UserClick;
	m_mapCall["CONFIRMMOVE"]				= &CCnChessLogic::ConfirmMove;
	m_mapCall["REPLYDRAW"]					= &CCnChessLogic::ReplyDraw;
	m_mapCall["REPLYRETRACTMOVE"]			= &CCnChessLogic::ReplyRetractMove;
	m_mapCall["REPLYSETTIME"]				= &CCnChessLogic::ReplySetTime;
	m_mapCall["REPLYCONFIRMTIME"]			= &CCnChessLogic::ReplyConfirmTime;
	//m_mapCall["ISCURSORHAND"]				= &CCnChessLogic::IsCursorHand;
	//m_mapCall["LOADREPLAYFILE"]				= &CCnChessLogic::LoadReplayFile;
	//m_mapCall["SAVEREPLAYFILE"]				= &CCnChessLogic::SaveReplayFile;
	//m_mapCall["SETAUTOSAVEREPLAY"]			= &CCnChessLogic::SetAutoSaveReplay;
	m_mapCall["QUITGAME"]					= &CCnChessLogic::QuitGame;
	m_mapCall["ONCOMMBTNCLICKED"]			= &CCnChessLogic::OnCommBtnClicked;
    m_mapCall["ISPOINTSAFE"]				= &CCnChessLogic::IsPointStatusSafe;
    //m_mapCall["SETPROTECTMAGICTOO"]			= &CCnChessLogic::SetProtectMagicTool;
    m_mapCall["GETUNSAFEKINGPOS"]			= &CCnChessLogic::GetUnSafeKingPos;
    m_mapCall["STARTGAMEHAL"]				= &CCnChessLogic::StartGameHall;
    //m_mapCall["REPORTUSERACTION"]			= &CCnChessLogic::ReportCorpId;
    //m_mapCall["GETUSERINFOBYUSERID"]		= &CCnChessLogic::GetUserInfoByUserID;
    //m_mapCall["GETUSERINFOBYROLEID"]		= &CCnChessLogic::GetUserInfoByRoleID;  
    //m_mapCall["CANUSERETRACTERPROPNOW"]		= &CCnChessLogic::CanUseRetractPropNow;
    //m_mapCall["MAKEFRIEND"]					= &CCnChessLogic::MakeFriend;
    m_mapCall["ISPLAYER"]					= &CCnChessLogic::IsPlayer;
    m_mapCall["GETMYSEAT"]					= &CCnChessLogic::GetMySeat;
    //m_mapCall["GETTOTALUSERINFOBYROLEID"]	= &CCnChessLogic::GetTotalUserInfoByRoleID;
    m_mapCall["GETMYUSERID"]				= &CCnChessLogic::GetMyUserID;
    
    m_mapCall["AIMOVE"]						= &CCnChessLogic::AiMove;
}

uint32_t CCnChessLogic::Call(const string &method, const void *param1, const void *param2,void *result)
{
	m_lastHResult = S_OK;
	m_lastError = "";
	string k = method;
	//transform(k.begin(), k.end(), k.begin(), ::toupper);
	int hr = S_FALSE;
	//varRet->vt = VT_NULL; //返回错误
	if(m_mapCall.end() == m_mapCall.find(k))
	{
		//LOG4C_WARN("CallFunction Invalid function '%S'", k);
        if(HandlePracticeReq(method, param1, param2, result))
        {
            hr = S_OK;
            return hr;
        }
		hr = E_NOTIMPL;
		if(result);
			//??result->vt = VT_NULL;
	}
	else
	{
		hr = (this->*m_mapCall[k])(param1, param2, result);
	}
	m_lastHResult = hr;
	return hr;	
}

uint32_t CCnChessLogic::GetLastErrorInt(const void *param1, const void *param2, void *result)
{
	if(!result)
		return E_POINTER;
	return *(int*)result;
}

uint32_t CCnChessLogic::AiMove(const void *param1, const void *param2, void *result)
{
	if (!m_AiInterface) 
	{
		m_AiInterface = new CCnChessAI();
		m_AiInterface->init(this);
	}
	UserMoveChessRequest stRequest;
	LOG_INFO("Before AI");
	m_AiInterface->NotifyComputerMoveFunc(&stRequest);
	LOG_INFO("AFTER AI");
	LOGI("AImove",": Finish computerMoveFunc");
	OnSvrRespMovedAPiece(&stRequest);
	return 0;	
}

uint32_t CCnChessLogic::GetLastErrorStr(const void *param1, const void *param2, void *result)
{
	if(!result)
		return E_POINTER;
	return 0;
}


// CnChess与用户交互的接口
uint32_t CCnChessLogic::Init(const void* param1, const void* param2, void* result)
{
	int nConnID = (int)param1;

	bool r = m_NetServer.init(nConnID, this);	// 初始化通信模块
//	if(!r)
//	{
		//LOG_WARN("[CnChess]:m_NetServer.init() failed. nConnID="<<nConnID);
//		return S_FALSE;
//	}
	
	// 从大厅获取游戏相关信息
	unsigned short nSitStatus = GetSeatInfoFromHall();
//	
//    if(!m_bPlayer)
//    {
//		Fire_Notify("ImLookOnUser");
//    }
	
	
	// 向服务器发送进入游戏请求
	m_NetServer.EnterGame(m_MyInfo.GameSeat, GAME_USER_STATUS(nSitStatus), "", "");
	m_GameStatus = GAME_WAITING;
	m_pChosedPiece.x = -1;
	m_TempPoint.x = -1;
	
	return S_OK;
}


uint32_t CCnChessLogic::QuitGame(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:QuitGame() called new");
    
    if(m_bGameSarted)
        SaveGameRecord(true);
    
    if(m_bMiniHall)
    {
		//NSTimeInterval deltaTime = [[NSDate date] timeIntervalSinceDate:m_startTime];
		//std::string s("gameid=2*time=%d", deltaTime);
		//ReportUserAction(s);

    }
	
	m_NetServer.QuitGame(m_MyInfo.GameTable);
	
	//LOG_DEBUG("[CnChess]: call m_NetServer.QuitGame()");
	return S_OK;
}

uint32_t CCnChessLogic::GetReady(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]: call m_NetServer.GameReady()");
	if( m_bPlayer)
	{
		m_NetServer.GameReady(m_MyInfo.GameSeat);
		m_bReady = true;
	}
	return S_OK;
}

uint32_t CCnChessLogic::RequestSurrender(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:RequestSurrender(): m_bGameSarted = "<<m_bGameSarted);
	
	if( m_bGameSarted && m_bPlayer)
	{
		//submitGameAction(CMD_DLL_REQ_SURRENDER, REQUEST);
	}
	return S_OK;
}

uint32_t CCnChessLogic::RequestDraw(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:RequestDraw(): m_bGameSarted = "<<m_bGameSarted<<", req count = "<<m_nRequestTimesCount_Draw+1);
	
	if( m_bGameSarted && m_nRequestTimesCount_Draw < 3 && m_bPlayer)
	{
		//submitGameAction(CMD_DLL_REQ_DRAW, REQUEST);
	}
	else
	{
		//LOG_INFO("[CnChess]:RequestDraw(): the "<<m_nRequestTimesCount_Draw<<" times to request draw.");
	}
	++m_nRequestTimesCount_Draw;
	return S_OK;
}

uint32_t CCnChessLogic::RequestRetractMove(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:RequestRetractMove(): m_bGameSarted = "<<m_bGameSarted<<", m_nStepCount = "<<m_nStepCount);
	//BOOL bRet = FALSE;
	
    if(m_bRetractRefuseCount >= 2)
    {
		Fire_Notify("CantSendRetractMoveThisTime",0,0,NOTIFY_CantSendRetractMoveThisTime);
		//*(bool*)result = bRet;
        return S_OK;
    }
	
    if(m_RetractSeqCount >=4)
    {
		Fire_Notify("CantRetractTooMuchOnceTime",0,0,NOTIFY_CantRetractToolMuchOnceTime);
       // *(bool*)result = bRet;
        return S_OK;
    }
	
	
	if(m_bGameSarted && m_nStepCount>2 && m_nRequestTimesCount_Retract<2 && m_bPlayer)
	{
        if(m_bJustRetractMove)
        {
			Fire_Notify("CantRetractForJustUse",0,0,NOTIFY_CantRetractForJustUse);
        }
        else
        {
			m_bUseRetractTool = false;
			m_bMyReqRetract = true;
			submitGameActionEx(CMD_DLL_REQ_RETRACTMOVE, REQUEST, RETRACT_NOMAL);
			//bRet = TRUE;
        }
    }
    else if(m_bGameSarted && m_nStepCount>2 && m_nRequestTimesCount_Retract>= 2  && m_bPlayer)
    {
		Fire_Notify("CantRetractForMoreTimes",0,0,NOTIFY_CantRetractForMoreTimes);
    }
    else
	{
		int i = 0;
		i = m_nRequestTimesCount_Retract<3 ? 0 : m_nRequestTimesCount_Retract;
		//NSNumber *v = [NSNumber numberWithInt:i]; 
		Fire_Notify("RequestRetractMoveInvalid", i,0,NOTIFY_RequestRetractMoveInvalid);
	}
	
	//*(bool*)result = bRet;
	return S_OK;
}

uint32_t CCnChessLogic::PracticeRetractMove(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:PracticeRetractMove(): m_bGameSarted = "<<m_bGameSarted<<", m_nStepCount = "<<m_nStepCount);
	int n = 2;
	if(n >= 0)
	{
		retractMoves(1, n, 0);
    }
	return S_OK;
}

uint32_t CCnChessLogic::DoublePracticeRetractMove(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:PracticeRetractMove(): m_bGameSarted = "<<m_bGameSarted<<", m_nStepCount = "<<m_nStepCount);
	int n = 1;
	if(n >= 0)
	{
		SwitchFlagSide();
		m_XQGame.SwitchMySide();
		retractMoves(1, n, 0);
    }
	return S_OK;
}

uint32_t CCnChessLogic::RequestRetractByGameProp(const void *param1, const void *param2, void *result)
{
    //LOG_DEBUG("[CnChess]:RequestRetractByGameProp(): m_bGameSarted = "<<m_bGameSarted<<", m_nStepCount = "<<m_nStepCount);
    BOOL bRet = FALSE;
	
    if(m_bGameSarted && m_nStepCount > 2 && m_bPlayer && m_RetractSeqCount < 4)
    {
        m_bUseRetractTool = true;
        m_bMyReqRetract = true;
        submitGameActionEx(CMD_DLL_REQ_RETRACTMOVE, REQUEST, RETRACT_BYTOOL);
        bRet = TRUE;
    }
    else if(m_bGameSarted && m_nStepCount > 2 && m_bPlayer && m_RetractSeqCount >= 4)
    {
		Fire_Notify("CantRetractTooMuchOnceTime");
    }
    else
    {
        int i = 0;
        i = m_nRequestTimesCount_Retract<3 ? 0 : m_nRequestTimesCount_Retract;
    //    NSNumber *v = [NSNumber numberWithInt:i]; 
		Fire_Notify("RequestRetractMoveInvalid", i,0,NOTIFY_RequestRetractMoveInvalid,0);
    }
	
    *(bool*)result = bRet;
    return S_OK;
}



uint32_t CCnChessLogic::GetUserID(const void *param1, const void *param2, void *result)
{
	////LOG_DEBUG("[CnChess]:GetUserID(): "<< *(int*)param1);
	int n = *(int*)param1;
	XLUSERID xlid;
	if(n == 0)
	{
		xlid = m_PlayerInfo_Mine.UserID;
	}
	else if(n == 1)
	{
		xlid = (m_TablePlayerInfo.size() > 1) ? m_PlayerInfo_Rival.UserID : XLUSERID(0);
	}
	
	char buff[32];
	sprintf(buff, "%lld", xlid);
	string v = buff;
	//LOG_DEBUG("[CnChess]:GetUserID(): "<< v);
	*(string *)result = v;
	return 0;
}

uint32_t CCnChessLogic::UserClick(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:UserClick(): "<<*(int*)param1);
	
	int n = (int)param1;
	if(m_bGameSarted && m_bMyTurn && n >= 0 && n<=89 && m_bPlayer)
	{
		CPoint p;
		p.y = n/9;
		p.x = n - 9*p.y;
		checkClickResult(p);
	}
	
	return S_OK;
}

uint32_t CCnChessLogic::ConfirmMove(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:ConfirmMove(), m_TempPoint = ("<<m_TempPoint.x<<", "<<m_TempPoint.y<<")");
	if(m_bGameSarted && m_bMyTurn && m_TempPoint.x >= 0 && m_bPlayer)
	{
		checkClickResult(m_TempPoint, false);
		m_TempPoint.x = -1;
	}
	return S_OK;
}

uint32_t CCnChessLogic::ReplyDraw(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:ReplyDraw(): "<< *(int*)param1);
	if( m_bPlayer)
	{
		int n = (int)param1;
		int iData = (n==1) ? ANSWER_YES : ANSWER_NO;
		submitGameAction(CMD_DLL_ANSWER_DRAW, iData);
	}
	return S_OK;
}

uint32_t CCnChessLogic::ReplyRetractMove(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:ReplyRetractMove(): "<< *(int*)param1);
	
	if( m_bPlayer)
	{
		int n = (int)param1;
		int iData = (n==1) ? ANSWER_YES : ANSWER_NO;
		submitGameAction(CMD_DLL_ANSWER_RETRACTMOVE, iData);
	}
	return S_OK;
}

uint32_t CCnChessLogic::ReplySetTime(const void *param1, const void *param2, void *result)
{
	int flag = (int)param1;
	
	int r = (*(TimeStruct*)param2).nRoundTime;
	int a = (*(TimeStruct*)param2).nStepAddedTime;
	int s = (*(TimeStruct*)param2).nStepTimeLimit;
	//LOG_DEBUG("[CnChess]:ReplySetTime(): flag = "<<flag<<", RoundTime = "<<r<<", StepAddedTime = "<<a<<", StepTimeLimit"<<s);
	if(m_bRedSide && !m_bGameSarted && m_bPlayer)
	{
		if(flag < 0)
		{
			r = a = s = -1;
		}
		submitGameActionEx(CMD_DLL_REQ_SETTIMER, r*10000+a, s);
	}
	return S_OK;
}
 
uint32_t CCnChessLogic::ReplyConfirmTime(const void *param1, const void *param2, void *result)
{
	int flag = (int)param1;
	
	int r = (*(TimeStruct*)param2).nRoundTime;
	int a = (*(TimeStruct*)param2).nStepAddedTime;
	int s = (*(TimeStruct*)param2).nStepTimeLimit;
	//LOG_DEBUG("[CnChess]:ReplyConfirmTime(): flag = "<<flag<<", RoundTime = "<<r<<", StepAddedTime = "<<a<<", StepTimeLimit"<<s);
	if(!m_bRedSide && !m_bGameSarted && m_bPlayer)
	{
		if(flag < 0)
		{
			r = a = s = -1;
		}
		submitGameActionEx(CMD_DLL_REQ_CONFIRMTIMER, r*10000+a, s);
	}
	return S_OK;
}


uint32_t CCnChessLogic::IsCursorHand(const void *param1, const void *param2, void *result)
{
	CPoint p;
	p.x = *(long*)param1;
	p.y = *(long*)param2;
	//LOG_DEBUG("[CnChess]:IsCursorHand(): "<<p.x<<", "<<p.y);
	
	bool bRtn = false;
	if(m_XQGame.IsMyPiece(p))		// 此处有个我的子，选中它？
	{
		//LOG_DEBUG("[CnChess]:IsCursorHand(): is my piece");
		bRtn = true;
	}
	else if(m_pChosedPiece.x >= 0)	// 此处不是我的子，则之前必须选中了一个棋子
	{
		//LOG_DEBUG("[CnChess]:IsCursorHand(): can selected piece move here from ("<<m_pChosedPiece.x<<", "<<m_pChosedPiece.y<<")?");
		if(m_XQGame.canMove(m_pChosedPiece, p))	// 如果m_pChosedPiece处的子能否走到p处
		{
			bRtn = true;
		}
	}
	
	//LOG_DEBUG("[CnChess]:IsCursorHand(): return "<<bRtn);
	*(bool*)result = bRtn;
	return 0;
}

uint32_t CCnChessLogic::IsPointStatusSafe(const void *param1, const void *param2, void *result)
{
	
    bool bRtn = true;
	
    // 如果没有打开保护, 则认为每个地方都是安全的
    if(!m_bOpenProtectMagic)
    {
        //LOG_DEBUG("[CnChess]:IsPointStatusSafe(): return "<<bRtn);
		*(bool*)result = bRtn;
		return 0;
    }
	
    CPoint p;
	p.x = *(long*)param1;
	p.y = *(long*)param2;
    //LOG_DEBUG("[CnChess]:IsPointStatusSafe(): "<<p.x<<", "<<p.y);
    if(!m_XQGame.IsMyPiece(p) && m_pChosedPiece.x >= 0)		 
    {
        if(m_XQGame.canMove(m_pChosedPiece, p) &&  m_XQGame.ShouldShowWarning(m_pChosedPiece, p))	// 如果m_pChosedPiece处的子能否走到p处
        {
            bRtn = false;
        }
		
    }

    //LOG_DEBUG("[CnChess]:IsPointStatusSafe(): return "<<bRtn);
    *(bool*)result = bRtn;
    return 0;
}

uint32_t CCnChessLogic::StartGameHall(const void *param1, const void *param2, void *result)
{
	m_NetServer.Call("STARTHA");
	//LOG_DEBUG("[CnChess]:StartGameHall(): return ");
	*(bool*)result = TRUE;
	return 0;
}

uint32_t CCnChessLogic::GetUnSafeKingPos(const void *param1, const void *param2, void *result)
{
	
    long lRtn = -1;
	
    // 如果没有打开保护, 则认为每个地方都是安全的
    if(!m_bOpenProtectMagic)
    {
        //LOG_DEBUG("[CnChess]:GetUnSafeKingPos(): return "<<lRtn);
		*(long*)result = lRtn;
		return 0;
    }
	
    CPoint p;
	p.x = *(long*)param1;
	p.y = *(long*)param2;
    //LOG_DEBUG("[CnChess]:GetUnSafeKingPos(): "<<p.x<<", "<<p.y);
    if(!m_XQGame.IsMyPiece(p) && m_pChosedPiece.x >= 0)		 
    {
        if(m_XQGame.canMove(m_pChosedPiece, p))	// 如果m_pChosedPiece处的子能否走到p处
        {
			lRtn = m_XQGame.GetMyUnsafeKingPos(m_pChosedPiece, p);
        }
		
    }
	
    //LOG_DEBUG("[CnChess]:GetUnSafeKingPos(): return "<<lRtn);
    *(long*)result = lRtn;
    return 0;
}


uint32_t CCnChessLogic::OnCommBtnClicked(const void *param1, const void *param2, void *result)
{
	//LOG_DEBUG("[CnChess]:OnCommBtnClicked() called. param1 = "<<param1);
	m_NetServer.Call("OnCommBtnClicked", param1, param2, result);
	return S_OK;
}

// private函数
void CCnChessLogic::checkClickResult(CPoint p, bool bWarn)	// 
{
	LOG_DEBUG("[CnChess]:checkClickResult(). p = ("<<p.x<<", "<<p.y<<")");
	if(m_XQGame.IsMyPiece(p))		// 此处有个我的子，选中它？
	{
		int n = -1;
		if(m_pChosedPiece.x != p.x || m_pChosedPiece.y != p.y)
		{
			m_pChosedPiece = p;
			n = m_XQGame.GetPieceIndex(p);
			Fire_Notify("ChosedAPiece", 0, n,NOTIFY_CHOSED,0);// 通知界面
		}
		else	// 之前已经选中这颗子
		{
			m_pChosedPiece.x = -1;
			Fire_Notify("UnchoseAPiece",0,0,NOTIFY_UNCHOSED);// 通知界面
		}
		//submitGameAction(CMD_DLL_NOTIFY_CHOSE_PIECE, n);
	}
	else if(m_pChosedPiece.x >= 0)	// 此处不是我的子，则之前必须选中了一个棋子
	{
		if(m_XQGame.canMove(m_pChosedPiece, p))	// 如果m_pChosedPiece处的子能否走到p处
		{
			int code = m_XQGame.CheckViolation(m_pChosedPiece, p, bWarn);
			if(code == 0 || (code < 0 && !bWarn))
			{
				UserMoveChessRequest stRequest;
				stRequest.cType = CMD_DLL_REQ_MOVE;
				stRequest.side = char(m_bRedSide ? 0 : 1);
				stRequest.fromx = char(m_pChosedPiece.x);
				stRequest.fromy = char(m_pChosedPiece.y);
				stRequest.tox = char(p.x);
				stRequest.toy = char(p.y);
				stRequest.bCheck = char(0);
				//OnSvrRespMovedAPiece(&stRequest);
				m_NetServer.SubmitGameAction(m_MyInfo.GameRoom, (char*)&stRequest, sizeof(stRequest));
				//LOG_DEBUG("[CnChess]:m_NetServer.SubmitGameAction(): move a piece");
				
				m_pChosedPiece.x = -1;
				
                // 用户走了一步棋， 表明悔棋后有新的走子动作
                m_bJustRetractMove = false;
                m_RetractSeqCount  = 0;
                m_bRetractRefuseCount = 0;
 			}
            else if( -1 == code)
            {
                m_TempPoint = p;
                long v0 = p.x;
                long v1 = p.y;
				long px = v0 + v1 * 9;	
				Fire_Notify("NotifyWarning", px, v1,NOTIFY_WARNING);// 通知界面
            }
			else 
			{       
             	if(code < 0)
				{
					//LOG_WARN("[CnChess]: this move will cause something. Need confirm");
					m_TempPoint = p;
				}
				else
				{
					//LOG_WARN("[CnChess]: this move will Break the rules. Objection!!!");
				}
				
				int v0 = 0;
				int v1 = code;
				Fire_Notify("ViolationMoves", v0, v1,NOTIFY_VIOLATIONMOVES);// 通知界面
			}
		}
		else
		{
			Fire_Notify("Can't move", 0, 0,NOTIFY_CANNOTMOVE);// 通知界面
		}
	}
	else	//既没有我的子，也没有别人的子
	{
		Fire_Notify("NOTIFY_NOCHOSED",0,0,NOTIFY_NOCHOSED);
	}
}

void CCnChessLogic::checkPracticeClickResult(CPoint p, bool needAi, bool bWarn)	// 
{
	//LOG_DEBUG("[CnChess]:checkPracticeClickResult(). p = ("<<p.x<<", "<<p.y<<")");
	//if (needAi && m_AiInterface->GetIsAiInThinking()) {
	//	return;
	//}
	if(m_XQGame.IsMyPiece(p))		// 此处有个我的子，选中它？
	{
		int n = -1;
		if(m_pChosedPiece.x != p.x || m_pChosedPiece.y != p.y)
		{
			//LOG_DEBUG("[CnChess]:this is my piece, chose it");
			m_pChosedPiece = p;
			n = m_XQGame.GetPieceIndex(p);
			//NSNumber* v0 = [NSNumber numberWithInt:0];
			//NSNumber* v1 = [NSNumber numberWithInt:n];
			//Fire_Notify("ChosedAPiece", v0, v1);// 通知界面
			Fire_Notify("ChosedAPiece", 0, n,NOTIFY_CHOSED,0);// 通知界面
		}
		else	// 之前已经选中这颗子
		{
			//LOG_DEBUG("[CnChess]:chosen this piece before, unchose it");
			m_pChosedPiece.x = -1;
			Fire_Notify("UnchoseAPiece",0,0,NOTIFY_UNCHOSED);// 通知界面
		}
	}
	else if(m_pChosedPiece.x >= 0)	// 此处不是我的子，则之前必须选中了一个棋子
	{
		if(m_XQGame.canMove(m_pChosedPiece, p))	// 如果m_pChosedPiece处的子能否走到p处
		{
			int code = m_XQGame.CheckViolation(m_pChosedPiece, p, bWarn);
			//LOG_DEBUG("[CnChess]:m_XQGame.CheckViolation() = "<<code);
			if(code == 0 || (code < 0 && !bWarn))
			{
				m_bNeedAi = needAi;
				UserMoveChessRequest stRequest;
				stRequest.cType = CMD_DLL_REQ_MOVE;
				stRequest.side = char(m_bRedSide ? 0 : 1);
				stRequest.fromx = char(m_pChosedPiece.x);
				stRequest.fromy = char(m_pChosedPiece.y);
				stRequest.tox = char(p.x);
				stRequest.toy = char(p.y);
				stRequest.bCheck = char(0);
				//m_NetServer.SubmitGameAction(m_MyInfo.GameRoom, (char*)&stRequest, sizeof(stRequest));
				////LOG_DEBUG("[CnChess]:m_NetServer.SubmitGameAction(): move a piece");
				OnSvrRespMovedAPiece(&stRequest);
				m_pChosedPiece.x = -1;
				
                // 用户走了一步棋， 表明悔棋后有新的走子动作
                m_bJustRetractMove = false;
                m_RetractSeqCount  = 0;
                m_bRetractRefuseCount = 0;
				

				//if (m_bNeedAi) {
				//	m_AiInterface->NotifyComputerMove();
				//}
				//else {
				//	m_XQGame.SwitchMySide();
				//	SwitchFlagSide();
				//}

 			}
            else if( -1 == code)
            {
                m_TempPoint = p;
                long v0 = p.x;
                long v1 = p.y;
				long px = v0 + v1 * 9;	
				Fire_Notify("NotifyWarning", px, v1,NOTIFY_WARNING);// 通知界面
            }
			else 
			{       
             	if(code < 0)
				{
					//LOG_WARN("[CnChess]: this move will cause something. Need confirm");
					m_TempPoint = p;
				}
				else
				{
					//LOG_WARN("[CnChess]: this move will Break the rules. Objection!!!");
				}
				
				int v0 = 0;
				int v1 = code;
				Fire_Notify("ViolationMoves", v0, v1,NOTIFY_VIOLATIONMOVES);// 通知界面
			}
		}
		else
		{
			Fire_Notify("Can't move", 0, 0,NOTIFY_CANNOTMOVE);// 通知界面
		}
	}
	else	//既没有我的子，也没有别人的子
	{
		Fire_Notify("NOTIFY_NOCHOSED",0,0,NOTIFY_NOCHOSED);
	}
}


void CCnChessLogic::retractMoves(bool bMyReq, int n, int iTime)
{
	if(m_XQGame.RetractMoves(n))
	{
		int nOff = m_bRedSide ? 1 : 0;
		m_nStepCount = (m_XQGame.GetStepCount() + nOff)/2;
		m_bMyTurn = bMyReq;
		
		int v0 = (bMyReq ? int(0) : int(1));	// 谁请求的，即现在该谁
		char buff[512];
		sprintf(buff, "%d,%d,%d|%s", m_nStepCount, m_nRequestTimesCount_Retract, iTime, m_XQGame.GetDescribeStr());
		//LOG_INFO("[CnChess]:m_XQGame.GetDescribeStr(): "<<buff);
		string v1 = buff;
		//NSNumber *_v0 = [NSNumber numberWithInt:v0];
		//NSMutableArray *_v1 = [NSMutableArray array];
		//[_v1 addObject:[NSNumber numberWithInt:m_nStepCount]];
		//[_v1 addObject:[NSNumber numberWithInt:m_nRequestTimesCount_Retract]];
		//[_v1 addObject:[NSNumber numberWithInt:iTime]];
		vector<int> describeVec = ParseDescribeStr2(m_XQGame.GetDescribeStr());
		//for (vector<int>::iterator it = describeVec.begin(); it != describeVec.end(); it++) {
		//	[_v1 addObject:[NSNumber numberWithInt:*it]];
		//}
	    Fire_Notify("RetractMoves", 0, 0,NOTIFY_RETRACTMOVES,&describeVec);// 通知界面
        NotifyWillBeKilledChesses();
	}
	else
	{
		//LOG_ERROR("[CnChess]:m_XQGame.RetractMoves("<<n<<") failed!!");
	}
}

void CCnChessLogic::submitGameAction(unsigned char cType, int iData)
{
	UserInformRequest stRequest;
	stRequest.cType = cType;
	stRequest.iData = htonl(iData);
	m_NetServer.SubmitGameAction(m_MyInfo.GameRoom, (char*)&stRequest, sizeof(stRequest));
}

void CCnChessLogic::submitGameActionEx(unsigned char cType, int iData, int iDataEx)
{
	UserInformRequestEx stRequest;
	stRequest.cType = cType;
	stRequest.iData = htonl(iData);
	stRequest.iDataEx = htonl(iDataEx);
	m_NetServer.SubmitGameAction(m_MyInfo.GameRoom, (char*)&stRequest, sizeof(stRequest));
}

unsigned short CCnChessLogic::GetSeatInfoFromHall()
{
	// 从大厅获取游戏相关信息
	//unsigned short v;
	//__int64 v1;
	//m_NetServer.Call(string("GetGameID"), NULL,  NULL, &v);		
	//m_MyInfo.GameID  = v;
	//m_NetServer.Call(string("GetZoneID"), NULL,  NULL, &v);		
	//m_MyInfo.ZoneID  = v;
	//m_NetServer.Call(string("GetRoomID"), NULL,  NULL, &v);		
	//m_MyInfo.RoomID  = v;
	//m_NetServer.Call(string("GetTableID"), NULL, NULL, &v);		
	//m_MyInfo.TableID = v;
	//m_NetServer.Call(string("GetSeatID"), NULL,  NULL, &v);		
	//m_MyInfo.SeatID  = v;
	//m_NetServer.Call(string("GetUserID"), NULL,  NULL, &v1);		
	//m_MyInfo.UserID  = v1;
	//
	//unsigned short nSitStatus;
	//m_NetServer.Call(string("GetSitStatus"), NULL,  NULL, &v1);	
	//
	//nSitStatus  = v1;
	//m_bPlayer = false;//(GAME_USER_STATUS(nSitStatus) != LOOKON);
	//
	////LOG_INFO("[CnChess]:GetSeatInfoFromHall():my userId = "<<m_MyInfo.UserID<<", sitStatus = "<<nSitStatus);
	//return nSitStatus;

	int status;
	JNIEnv *env = NULL;	
	jclass comPlay_class;
	jobject comPlay_object;
	jmethodID comPlay_id, function_id;

	//获得环境
	status = (*_vm).GetEnv((void**) &env, JNI_VERSION_1_4);
	if (status != JNI_OK)
		return 0;

	comPlay_class = env->FindClass("com/ysh/chess/NetServer");
	comPlay_id = env->GetMethodID(comPlay_class , "<init>", "()V");
	comPlay_object = env->NewObject(comPlay_class, comPlay_id);
	function_id = env->GetMethodID(comPlay_class,"getnCmdID","()[S");
	//jshortArray iarr = env->NewShortArray(7);
	jshortArray iarr = (jshortArray)env->CallObjectMethod(comPlay_object,function_id);
	//jfieldID ival = (env)->GetFieldID(comPlay_class,"mSeatInfo","[S");
	//env->SetObjectField(comPlay_object,ival,iarr);
	int size = env->GetArrayLength(iarr);
	jshort *body = env->GetShortArrayElements( iarr, 0);

	m_MyInfo.GameID = body[0];
	m_MyInfo.ZoneID = body[1];
	m_MyInfo.RoomID= body[2];
	m_MyInfo.TableID = body[3];
	m_MyInfo.SeatID = body[4];
	m_MyInfo.UserID = body[5];
	m_bPlayer = (GAME_USER_STATUS(body[6]) != LOOKON);
	return body[6];


	
}

void CCnChessLogic::notifyUserInfo(int p, const PlayerInfoExt &info)
{
	////LOG_DEBUG("[CnChess]:notifyUserInfo(), p = "<<p<<", userID = "<<info.UserID<<", nickName = "<<info.UserBasicInfo.Nickname);
	
	//NSNumber *_p = [NSNumber numberWithInt:p];
	
	PlayerInfoExt *tmp = new PlayerInfoExt;
	*tmp = info;
	
	//NSData *dx = [NSData dataWithBytes:&tmp length:sizeof(PlayerInfoExt*)];
	
	//if (tmp) {
	//	delete tmp;
	//	tmp = NULL;
	//}
	
	//Fire_Notify("UserInfo", _p, dx);// 通知界面
	
	
}


void CCnChessLogic::SaveGameRecord(bool isMeEsc)
{

}


void CCnChessLogic::checkGameScore()
{

}


int CCnChessLogic::reportXlScore(bool bWin, XLUSERID userID)
{
	////LOG_DEBUG("[CnChess]:reportXlScore(), userID = "<<userID<<", bWin = "<<bWin);
	
	int rtn = 0;
	if(bWin)
	{
		int v;
		m_NetServer.Call(string("ReportScore"), &userID, NULL, &v);
		rtn = v;
		//LOG_DEBUG("[CnChess]:reportXlScore(), ReportScore() = "<<rtn);
	}
	return rtn;
}

// 对服务器传回的消息的响应
void CCnChessLogic::OnSvrRespIEnterGame(int nResult, const vector<PlayerInfoExt>& tablePlayers)
{
//	//LOG_INFO("[CnChess]:OnSvrRespIEnterGame(): result = "<<nResult<<", get "<<tablePlayers.size()<<" players");
	if(m_bInATable)	// 已经在一个桌子上了，这次应该是换桌子
	{
		// 从大厅获取游戏相关信息
		GetSeatInfoFromHall();
		m_bGameSarted = false;
		m_bReady = false;
		m_bMyTurn = false;
	//	NSNumber *v0 = [NSNumber numberWithInt:m_bPlayer ? 0 : -1];
	//	Fire_Notify("IChangedATable", v0);
	}
	
	m_bInATable = true;
	m_TablePlayerInfo.reserve(2);
	m_TablePlayerInfo.clear();
	
	int n = 1;
	for(vector<PlayerInfoExt>::const_iterator it = tablePlayers.begin(); it != tablePlayers.end(); it++)
	{
		////LOG_DEBUG("[CnChess]:OnSvrRespIEnterGame(): id = "<<it->UserID<<", seatID = "<<int(it->.SeatID)<<", status = "<<int(it->.UserStatus));
		if(false)//GAME_USER_STATUS(it->UserStatus) == LOOKON
			continue;
		
		m_TablePlayerInfo.push_back(*it);
		if(it->SeatID == m_MyInfo.SeatID)
		{
			n = m_bPlayer ? 0 : -1;
			m_PlayerInfo_Mine = *it;
			notifyUserInfo(n, m_PlayerInfo_Mine);
		}
		else if(it->SeatID == 1 - m_MyInfo.SeatID)
		{
			n = 1;
			m_PlayerInfo_Rival = *it;
			notifyUserInfo(n, m_PlayerInfo_Rival);
		}
		
	}
	
	////LOG_DEBUG("[CnChess]:OnSvrRespIEnterGame(): my status = "<<int(m_PlayerInfo_Mine.UserStatus)<<", is LookOn = "<<!m_bPlayer);
	if(m_bPlayer && false)//GAME_USER_STATUS(m_PlayerInfo_Mine.UserStatus) == IS_PLAYING
	{
		//LOG_INFO("[CnChess]:OnSvrRespIEnterGame(): client reload? Call Replay()");
		m_NetServer.Replay(m_MyInfo.GameSeat);
	}
	
	m_bRecvGameEnd = false;
	m_nRecvScoreCount = 0;
	//LOG_DEBUG("[CnChess]:OnSvrRespIEnterGame(): return");
}

void CCnChessLogic::OnSvrRespUserEnterGame(const PlayerInfoExt &PlayerInfo, bool isLookOnUser)
{
	////LOG_DEBUG("[CnChess]:OnSvrRespUserEnterGame(): user status = "<<PlayerInfo.UserStatus);
	
	//tony add this
	if (PlayerInfo.TableID != m_MyInfo.TableID) {
		return;
	}
	
	if(!isLookOnUser)
	{
		if(PlayerInfo.SeatID == m_MyInfo.SeatID)
		{
			m_PlayerInfo_Mine = PlayerInfo;
			notifyUserInfo(1, m_PlayerInfo_Mine);
			////LOG_ERROR("[CnChess]:OnSvrRespUserEnterGame(): (PlayerInfo.SeatID == m_MyInfo.SeatID) = "<<m_MyInfo.SeatID);
		}
		else if(PlayerInfo.SeatID == 1 - m_MyInfo.SeatID)
		{
			m_PlayerInfo_Rival = PlayerInfo;
			notifyUserInfo(1, m_PlayerInfo_Rival);
		}
		else
		{
			//LOG_ERROR("[CnChess]:OnSvrRespUserEnterGame(): (PlayerInfo.SeatID == m_MyInfo.SeatID) = "<<m_MyInfo.SeatID);
		}
		m_TablePlayerInfo.push_back( PlayerInfo);
		
		//notifyUserInfo(1, PlayerInfo);
	}
}

void CCnChessLogic::OnSvrRespGetReady(XLUSERID nReadyUserID)
{
	//LOG_DEBUG("[CnChess]:OnSvrRespGetReady(): game started:"<<m_bGameSarted);
	
	if(!m_bGameSarted)
	{
		int i = (nReadyUserID == m_PlayerInfo_Mine.UserID)? 0: 1;
		//NSNumber* v = [NSNumber numberWithInt:i];
		//Fire_Notify("GetReady", v);
	}
}

void CCnChessLogic::OnSvrRespSideFlag(int iRedSide)
{
	////LOG_DEBUG("[CnChess]:OnSvrRespSideFlag(): m_bGameSarted = "<<m_bGameSarted<<", red side = "<<iRedSide);
	if(!m_bGameSarted)		// 设置双方的颜色
	{
		m_bRedSide = (m_MyInfo.SeatID == iRedSide);
		////LOG_DEBUG("[CnChess]:OnSvrRespSideFlag(): m_bRedSide = "<<m_bRedSide);
	}
}

void CCnChessLogic::OnSvrRespGameStart(int nTime, int nTimeEx)
{
//	//LOG_DEBUG("[CnChess]:OnSvrRespGameStart(): nTime = "<<nTime<<", nTimeEx = "<<nTimeEx);
	
	m_bGameSarted = true;
	m_bPracticeStart = false;
	m_bMyTurn = m_bRedSide;
	
	int n = m_bRedSide ? 0 : 1;
	m_XQGame.InitGame(n);
	m_nRequestTimesCount_Draw = 0;
	m_nRequestTimesCount_Retract = 0;
	m_GameEndCode = 0;
	m_nStepCount = 0;
	
	m_GameStatus = GAME_STARTED;
	m_pChosedPiece.x = -1;
	m_nRecvScoreCount = 0;
	m_bRecvGameEnd = false;
	//--m_replay.RecordStartTime();
	
	//NSNumber *v0 = [NSNumber numberWithInt:n];
	//NSArray *v1 = [NSArray arrayWithObjects:[
	//				NSNumber numberWithFloat:nTime/10000],
	//			   [NSNumber numberWithFloat:nTime%10000], 
	//			   [NSNumber numberWithFloat:nTimeEx], 
	//				nil];
	vector<int> describeVec;
	describeVec.push_back(nTime/10000);
	describeVec.push_back(nTime%10000);
	describeVec.push_back(nTimeEx);
	describeVec.push_back(0);
	Fire_Notify("GameStarted", n, 0,NOTIFY_GAMESTARTED,&describeVec);
}

void CCnChessLogic::NotifyWillBeKilledChesses()
{ 
	
    if(!m_bGameSarted || !m_bPlayer)
    {
        return;
    }
	
    // 如果没有打开保护, 则认为每个地方都是安全的
    if(!m_bOpenProtectMagic)
    {
        return;
    }
	
    std::vector<CPoint> AllpointVec = m_XQGame.GetAllPointsWillbeKill();
    std::vector<CPoint> NewestpointVec = m_XQGame.GetNewestPointsWillbeKill(m_bMyTurn);
    std::vector<CPoint> OldpointVec;
    {
		int i, j;
        for(i = 0; i < AllpointVec.size(); i++)
        {
            for(j = 0; j < NewestpointVec.size(); j++)
            {
                if(AllpointVec[i].x == NewestpointVec[j].x && AllpointVec[i].y == NewestpointVec[j].y)
                    break;
            }
			
            // 没有在最新的里面找到， 则是老的被威胁的子
            if(j == NewestpointVec.size())
            {
                OldpointVec.push_back(AllpointVec[i]);
            }
        }
    }
	
    //NSMutableDictionary *px = [NSMutableDictionary dictionary];
    //for(int i=0; i<OldpointVec.size(); i++)
    //{
	//	NSString *key = [NSString stringWithFormat:"%d", i];
	//	[px setObject:[NSNumber numberWithInt:OldpointVec[i].x + OldpointVec[i].y * 9] forKey:key];
    //}
	//Fire_Notify("NotifyWillBeKilledChesses", px);
	
	//NSMutableDictionary *dx = [NSMutableDictionary dictionary];
    //for(int i=0; i<NewestpointVec.size(); i++)
    //{
	//	NSString *key = [NSString stringWithFormat:"%d", i];
	//	[dx setObject:[NSNumber numberWithInt:NewestpointVec[i].x + NewestpointVec[i].y * 9] forKey:key];
    //}
	//Fire_Notify("NotifyNewestWillBeKilledChesses", dx);
}

const GAMEDATA& CCnChessLogic::GetGameSeatInfo()
{
    //LOG_DEBUG("[CnChess]:GetGameSeatInfo() called");
    return m_MyInfo;
}

void CCnChessLogic::OnSvrRespMovedAPiece(UserMoveChessRequest* pstMove)
{
	//LOG_DEBUG("[CnChess]:OnSvrRespMovedAPiece(): ");
	
	bool bRedPiece = (int(pstMove->side) == 0);
	CPoint from;
	from.x = pstMove->fromx;
	from.y = pstMove->fromy;
	CPoint to;
	to.x = pstMove->tox;
	to.y = pstMove->toy;
	
	int moveType = 0;
	int ret = m_XQGame.GetPieceIndex(to);
	if (!m_bPracticeStart)
	{
		if(int(pstMove->bCheck) == 1)
		{
			moveType = 2;
		}
		else if(ret >= 0)
		{
			moveType = 1;
		}
	}
	
	//LOG_DEBUG("[CnChess]:side:"<<int(pstMove->side)<<"("<<from.x<<","<<from.y<<") -> ("<<to.x<<","<<to.y<<"). moveType="<<moveType);
	
	int v0 = 0; 
	if(bRedPiece == m_bRedSide)
	{
		v0 = 0;
		++m_nStepCount;
	}
	else
	{
		v0 = 1;
	}
	m_MoveResult = m_XQGame.MovedAPiece_Client(from, to, pstMove->side, pstMove->bCheck);

	if (m_bPracticeStart)
	{
		if (m_XQGame.canKillRivalKing())
		{
			moveType = 2;
		}
		else if(ret >= 0)
		{
			moveType = 1;
		}		
	}

	//m_bPracticeStart = true;
	if (m_bPracticeStart) {
		//NSLog("m_bPracticeStart == true");
		if (GAME_OVER == m_XQGame.GetGameState()) {
			practicehandleresult();
			m_bNeedAi = false;
			return;
		}
	}
	
	if(m_MoveResult < 0)
	{
		//LOG_ERROR("[CnChess]:MovedAChess(): error!!!! rtn = "<<m_MoveResult);
	}
	else if(m_MoveResult == 0)
	{
		char buff[256];
		sprintf(buff, "%s|%d,%d", m_XQGame.GetDescribeStr(), int(pstMove->nLeftTime), moveType);
		//LOG_DEBUG("[CnChess]:MovedAChess(): "<<buff<<". rtn = "<<m_MoveResult);
		
		vector<int> describeVec = ParseDescribeStr(buff);
		
		int size = describeVec.size();
		//NSMutableArray *describeArray = [NSMutableArray array];
		//for (vector<int>::iterator it = describeVec.begin(); it != describeVec.end(); it++) {
			//[describeArray addObject:[NSNumber numberWithInt:*it]];
			//int a = *it;
		//}
		
		//[describeArray addObject:[NSNumber numberWithInt:int(pstMove->nLeftTime)]];
		//[describeArray addObject:[NSNumber numberWithInt:moveType]];
		
		//NSNumber* _v0 = [NSNumber numberWithInt:v0];
		//NSString* _v1 = [NSString stringWithCString:v1.c_str()];
		//Fire_Notify("MovedAPiece", _v0, describeArray);

		if (2 != moveType || ret == -1)
		{
			describeVec.push_back(moveType);
		}
		describeVec.push_back(int(pstMove->nLeftTime));

		Fire_Notify("MovedAPiece",v0,moveType,NOTIFY_MOVEAPIECE,&describeVec);
		m_bMyTurn = !m_bMyTurn;

        NotifyWillBeKilledChesses();
        if(m_XQGame.ShouldDraw())
        {
            //LOG_TRACE("[CCnChessLogic::OnSvrRespMovedAPiece] m_XQGame.ShouldDraw()");
            //submitGameAction(CMD_NOTIFY_SHOULD_DRAW, 0);
        }
		
        
		 //// 如果是对方下的棋 ， 那么根据是否有道具来提示哪些棋有被吃掉的危险
		 ////if(m_XQGame.GetMySide() != pstMove->side)
		 //{
		 ////std::vector<CPoint> pointVec = m_XQGame.GetPointsWillbeKill(to);
		 //std::vector<CPoint> pointVec = m_XQGame.GetAllPointsWillbeKill();
		 //PDataX px = PDataX::CreateInstance();
		 //for(int i=0; i<pointVec.size(); i++)
		 //{
		 //px[i] = pointVec[i].x + pointVec[i].y * 9;
		 //}
		 //Fire_Notify(("NotifyWillBeKilledChesses"), px);
		 //}
		 //// else
		 //{   
		 ////如果是自己下了一步棋， 则清理图片
		 //// Fire_Notify(("NotifyCleanImages"));
		 //}
		
	}
	else
	{
		//LOG_INFO("[CnChess]:MovedAChess(): game over? rtn = "<<m_MoveResult);
	}
}

void CCnChessLogic::OnSvrRespReqDraw(XLUSERID nUserID, int iData)
{
	//LOG_DEBUG("[CnChess]:OnSvrRespReqDraw(): "<<iData<<", request times = "<<m_nRequestTimesCount_Draw);
	
	if(iData == REQUEST)
	{
		int n = (nUserID == m_PlayerInfo_Mine.UserID) ? 0 : 1;
		//NSNumber *v = [NSNumber numberWithInt:n];
		Fire_Notify("RequestDraw", n,0,NOTIFY_RequestDraw,NULL);
	}
	else
	{
		//LOG_WARN("[CnChess]:OnSvrRespReqDraw(): error code");
	}
}

void CCnChessLogic::OnSvrRespAnswerDraw(XLUSERID nUserID, int iData)
{
//	//LOG_DEBUG("[CnChess]:OnSvrRespAnswerDraw(): "<<iData<<", request times = "<<m_nRequestTimesCount_Draw);
	
	if(iData == ANSWER_NO)
	{
		int n = (nUserID == m_PlayerInfo_Mine.UserID) ? 0 : 1;
		//NSNumber *v0 = [NSNumber numberWithInt:n];
		//int i = m_nRequestTimesCount_Draw<3 ? 0 : m_nRequestTimesCount_Draw;
		//NSNumber *v1 = [NSNumber numberWithInt:i];
		//Fire_Notify("RequestDrawRefused", v0, v1);
	}
	else
	{
		//LOG_WARN("[CnChess]:OnSvrRespAnswerDraw(): error code");
	}
}

void CCnChessLogic::OnSvrRespReqRetractMove(XLUSERID nUserID, int iData, int mode)
{
	//LOG_DEBUG("[CnChess]:OnSvrRespRetractMove(): "<<iData);
	//确认
	if(iData == REQUEST)
	{
		int n = (nUserID == m_PlayerInfo_Mine.UserID) ? 0 : 1;
		//NSNumber *v = [NSNumber numberWithInt:n];
		//NSNumber *_mode = [NSNumber numberWithInt:mode];
		Fire_Notify("RequestRetractMove", 0,0,NOTIFY_RequestRetractMove,NULL);
	}
	else
	{
		//LOG_WARN("[CnChess]:OnSvrRespReqDraw(): error code");
	}
}

void CCnChessLogic::OnSvrRespAnswerRetractMove(XLUSERID nUserID, int iData, int iTime)
{
//	//LOG_INFO("[CnChess]:OnSvrRespAnswerRetractMove(): back to step "<<iData<<", cur step = "<<m_XQGame.GetStepCount()<<", iTime = "<<iTime<<", bMyTurn = "<<m_bMyTurn);
	bool bmyretract = m_bMyReqRetract;
    m_bMyReqRetract = false;
	
	if(iData == ANSWER_NO)
	{
		int n = (nUserID == m_PlayerInfo_Mine.UserID) ? 0 : 1;
	//	NSNumber *v0 = [NSNumber numberWithInt:n];
	//	NSNumber *v1 = [NSNumber numberWithBool:m_bUseRetractTool];
		Fire_Notify("RequestRetractMoveRefused", n, m_bUseRetractTool,NOTIFY_RequestRetractMoveRefused,0);
        m_bRetractRefuseCount++;
	}
	else
	{
		int n = m_XQGame.GetStepCount() - iData;
		bool bMyReq = (m_bMyTurn && n == 2) || (!m_bMyTurn && n == 1);
		// 重置悔棋前的状态
		retractMoves(bMyReq, n, iTime);
		
        if(bmyretract)
        {
            m_bJustRetractMove = true;
            m_RetractSeqCount++;
            m_nRequestTimesCount_Retract++;
        }
		
       // if(m_bUseRetractTool && bmyretract)
        //{
        //    Fire_Notify("ShouldPayPropToolNow");
        //}
	}
}

void CCnChessLogic::OnSvrRespGameEndCode(unsigned char nEndCode, int nCodeEx)
{
	//LOG_DEBUG("[CnChess]:OnSvrRespGameEndCode(): ");
	if(m_bGameSarted || m_bReady || !m_bPlayer)
	{
		m_GameEndCode = int(nEndCode);
		m_GameEndCodeEx = nCodeEx;
	}
}

void CCnChessLogic::OnSvrRespSetGameOver()
{
	//LOG_DEBUG("[CnChess]:OnSvrRespSetGameOver(): ");
	
	// 自动保存棋谱文件
	//--
	//if(m_bGameSarted)
	//{
	//	const char *pRedUserName = m_PlayerInfo_Mine.UserBasicInfo.Username.c_str();
	//	const char *pRedNickName = m_PlayerInfo_Mine.UserBasicInfo.Nickname.c_str();
	//	const char *pBlackUserName = m_PlayerInfo_Rival.UserBasicInfo.Username.c_str();
	//	const char *pBlackNickName = m_PlayerInfo_Rival.UserBasicInfo.Nickname.c_str();
	//	int nSide = 0;
	//	if(!m_bRedSide)
	//	{
	//		const char *temp = pRedUserName;
	//		pRedUserName = pBlackUserName;
	//		pBlackUserName = temp;
	//		
	//		temp = pRedNickName;
	//		pRedNickName = pBlackNickName;
	//		pBlackNickName = temp;
	//		nSide = 1;
	//	}
	//	m_replay.SaveHistoryRecord(pRedUserName, pRedNickName, pBlackUserName, pBlackNickName, nSide, m_XQGame.GetChessStepRecordLength(), m_XQGame.GetChessStepRecord(), m_GameEndCode, m_GameEndCodeEx, m_bPlayer);
	//}
	//--
	
	// 通知界面
	if(m_bGameSarted || m_bReady || !m_bPlayer)
	{
		m_bGameSarted = false;
		m_bReady = false;
		m_bRecvGameEnd = true;
		//bool bWin[2]   = {false, false};

		int nCode = m_GameEndCodeEx;
		if( (m_GameEndCode == CMD_DLL_NOTIFY_GAMEEND_BYSURRENDER) && 
			((m_GameEndCodeEx == 1 && m_bRedSide) || (m_GameEndCodeEx == 2 && !m_bRedSide)))
		{
			nCode = 5;	// 对方认输
		}
		else if( m_GameEndCode == CMD_DLL_NOTIFY_GAMEEND_BYTIMEOUT)
		{
			if(m_GameEndCodeEx == 1)
			{
				nCode = 7;	// 黑方超时
			}
			else if(m_GameEndCodeEx == 2)
			{
				nCode = 6;	// 红方超时
			}
		}
		else if( m_GameEndCode == CMD_DLL_NOTIFY_GAMEEND_BYABORT)
		{
			nCode = 0;	// 协商时间失败
		}
		Fire_Notify("GameOver", m_GameEndCode, nCode,NOTIFY_GAMEOVER,NULL);
		m_GameStatus = GAME_OVER;

		SaveGameRecord(false);
	}
	checkGameScore();
}

void CCnChessLogic::OnSvrRespUserQuitGame(XLUSERID nQuitUserID)
{
	////LOG_DEBUG("[CnChess]:OnSvrRespUserQuitGame(): "<<nQuitUserID);
	
	for(int i=0; i<m_TablePlayerInfo.size(); ++i)
	{
		if(nQuitUserID == m_TablePlayerInfo[i].UserID)
		{
			int n = (m_TablePlayerInfo[i].SeatID == m_MyInfo.SeatID) ? 0 : 1;
			int m = 0;
			if(n==0 && m_TablePlayerInfo[i].UserID != m_MyInfo.UserID)
			{
				m = 1;
				m_NetServer.QuitGame(m_MyInfo.GameTable);
				//LOG_DEBUG("[CnChess]:OnSvrRespUserQuitGame(): LOOKON player quit? call QuitGame() now.");
				m_GameStatus = GAME_EXIT;
			}
			vector<PlayerInfoExt>::iterator it = m_TablePlayerInfo.begin() + i;
			m_TablePlayerInfo.erase(it);
			
			//NSNumber *v0 = [NSNumber numberWithInt:n];
			//NSNumber *v1 = [NSNumber numberWithInt:m];
			Fire_Notify("UserQuitGame", n, m,NOTIFY_USERQUITGAME,NULL);
		}
	}
}

void CCnChessLogic::OnSvrRespUserScoreChanged(const std::vector<XLGAMESCOREEXT>& scoreInfoArr)
{
	//LOG_DEBUG("[CnChess]:OnSvrRespUserScoreChanged() called");
	
	for(int i=0; i<scoreInfoArr.size(); ++i)
	{
		const XLGAMESCOREEXT& scoreInfo = scoreInfoArr[i];
		
		////LOG_DEBUG("[CnChess]:OnSvrRespUserScoreChanged(), i = "<<i<<", userID = "<<scoreInfo.UserID<<", score = "<<scoreInfo.PointsDelta<<", xlScore = "<<scoreInfo.Score);
		int seatId = -1;
		
        ////LOG_TRACE("m_PlayerInfo_Mine.UserID = " << m_PlayerInfo_Mine.UserID);
        ////LOG_TRACE("m_PlayerInfo_Rival.UserID = " << (*m_pPlayerInfo_Rival).UserID);
		XLUSERID scoreInfoid = scoreInfo.UserID;
		if(scoreInfoid == m_PlayerInfo_Mine.UserID)
		{
			seatId = m_PlayerInfo_Mine.SeatID;
			m_PlayerInfo_Mine.LevelName = scoreInfo.LevelName;
		}
		else if(scoreInfoid == m_PlayerInfo_Rival.UserID)
		{
			seatId = 1-m_PlayerInfo_Mine.SeatID; //m_PlayerInfo_Rival.SeatID;
			m_PlayerInfo_Rival.LevelName = scoreInfo.LevelName;
		}
		
        ////LOG_TRACE("SeatID = " << seatId);
		if(seatId >= 0 && seatId <2)
		{
			m_nUserScore[seatId] = scoreInfo;
			++m_nRecvScoreCount;
		}
	}
	checkGameScore();
}

void CCnChessLogic::OnSvrRespSetTime(int iRedSide)
{
//	//LOG_DEBUG("[CnChess]:OnSvrRespSetTime(): m_bGameSarted = "<<m_bGameSarted<<", red side = "<<iRedSide);
	if(!m_bGameSarted)		// 设置双方的颜色
	{
		m_bRedSide = (m_MyInfo.SeatID == iRedSide);
		
		int n = m_bRedSide? 0 : 1;
		//LOG_DEBUG("[CnChess]:n = "<<n<<", m_bRedSide = "<<m_bRedSide<<", m_bPlayer = "<<m_bPlayer);
		
		if(m_bPlayer)
		{
		//	NSNumber *v0 = [NSNumber numberWithInt:n];// 我，还是对方来设置时间
		//	NSNumber *v1 = [NSNumber numberWithInt:n];// 我是红方，还是黑方
		//	Fire_Notify("SetTime", v0, v1);
			Fire_Notify("SetTime",n, n,NOTIFY_SETTIME,0);
		}
		m_GameStatus = GAME_SETTING;
	}
	else
	{
		//LOG_ERROR("[CnChess]: game already start!!!");
	}
}


void CCnChessLogic::OnSvrRespConfirmTime(int iTime, int nTimeEx)
{
//	//LOG_DEBUG("[CnChess]:OnSvrRespConfirmTime(): m_bGameSarted = "<<m_bGameSarted<<", iTime = "<<iTime<<", nTimeEx = "<<nTimeEx);
	
	if(!m_bGameSarted)
	{
	//	NSNumber *v0 = [NSNumber numberWithInt:0];
	//	NSArray *v1 = [NSArray arrayWithObjects:
	//				   [NSNumber numberWithFloat:iTime/10000],
	//				   [NSNumber numberWithFloat:iTime%10000], 
	//				   [NSNumber numberWithFloat:nTimeEx], 
	//					nil];
		vector<int> describeVec;
		describeVec.push_back(iTime/10000);
		describeVec.push_back(iTime%10000);
		describeVec.push_back(nTimeEx);
		describeVec.push_back(0);
		Fire_Notify("RequestConfirmTime", 0, 0,NOTIFY_CONFIRMTIME,&describeVec);
	}
	else
	{
		//LOG_ERROR("[CnChess]: game already start!!!");
	}
}


void CCnChessLogic::OnSvrRespUserChoseAPiece(XLUSERID nSubmitUserID, int iData)
{
//	//LOG_DEBUG("[CnChess]:OnSvrRespUserChoseAPiece(): userID = "<<nSubmitUserID<<", iData = "<<iData);
	if(m_bGameSarted && (nSubmitUserID != m_PlayerInfo_Mine.UserID || !m_bPlayer))
	{
		if(iData >= 0)
		{
	//		NSNumber *v0 = [NSNumber numberWithInt:1];
	//		NSNumber *v1 = [NSNumber numberWithInt:iData];
	//		Fire_Notify("ChosedAPiece", v0, v1);		// 通知界面
		}
		else	// 取消选中这颗子
		{
			Fire_Notify("UnchoseAPiece");		// 通知界面
		}
	}
}

void CCnChessLogic::OnSvrRespEnterGameFailed(int nResult)
{
	//LOG_ERROR("[CnChess]:OnSvrRespEnterGameFailed(): nResult = "<<nResult);
	Fire_Notify("EnterGameFailed");
}

void CCnChessLogic::OnSvrRespReloadGameData(ResumeGameData *pGameData)
{
	//LOG_INFO("[CnChess]:OnSvrRespReloadGameData().");
	
	m_bGameSarted = true;
	m_bReady = false;
	m_bRedSide = (m_MyInfo.SeatID == pGameData->nRedChair);
	m_bMyTurn = (m_MyInfo.SeatID == pGameData->nTurnChair);
	int n = m_bRedSide? 0 : 1;
	m_XQGame.InitGame(n);
	m_GameEndCode = 0;
	m_nStepCount = (pGameData->nStepCount+1-n)/2;
	//LOG_DEBUG("[CnChess]:m_bRedSide = "<<m_bRedSide<<", my step count = "<<m_nStepCount);
	
	m_XQGame.SetGameData(pGameData->nPiecePosArr, pGameData->ChessStepArr, pGameData->nStepCount);
	
	char buff[512];
	int nWhoTurn = m_bMyTurn? 0 : 1;
	
	int nTimeCount = pGameData->nTimeCount;
	//int nRoundTime = pGameData->nRoundTime;
	int nStepTime = pGameData->nStepTime;
	int nStepTimeLimit = pGameData->nStepTimeLimit;
	int nCurStepTimeElapsed = pGameData->nCurStepTimeElapsed;
	int nLeftTime_mine = pGameData->nLeftRoundTime[m_MyInfo.SeatID];
	int nLeftTime_rival = pGameData->nLeftRoundTime[1-m_MyInfo.SeatID];
	m_nRequestTimesCount_Draw = pGameData->nReqDrawCount[m_MyInfo.SeatID];
	m_nRequestTimesCount_Retract = pGameData->nReqRetractCount[m_MyInfo.SeatID];
	sprintf(buff, "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d|%s", n, nWhoTurn, m_nStepCount, nTimeCount, nLeftTime_mine, nLeftTime_rival, nStepTime, nStepTimeLimit, nCurStepTimeElapsed, m_nRequestTimesCount_Draw, m_nRequestTimesCount_Retract, m_XQGame.GetCompleteDescribeOfCurPos());
	//LOG_INFO("[CnChess]:OnSvrRespReloadGameData(). buff = "<<buff);	
	//--m_replay.RecordStartTime(nTimeCount);
	
	//NSNumber *v0 = [NSNumber numberWithInt:m_bPlayer ? int(0) : int(-1)];
	//string str = buff;
	//NSString *v1 = [NSString stringWithFormat:"%s",str.c_str()];
	//Fire_Notify("ReloadGameGata", v0, v1);
    NotifyWillBeKilledChesses();
	
	// 如果处于请求状态
	if(GAMESTATE(pGameData->nGameStatus) == GAME_REQUEST && m_bPlayer)
	{
		if(((unsigned short)pGameData->nReqChair) == m_MyInfo.SeatID)
		{
			//v0 = [NSNumber numberWithInt:0];
			//Fire_Notify("ReloadReqStatus", v0);
		}
		else
		{
			//v0 = [NSNumber numberWithInt:1];
			if(pGameData->nCurReqCode == CMD_DLL_REQ_DRAW)
			{
			//	Fire_Notify("RequestDraw", v0);
			}
			else if(pGameData->nCurReqCode == CMD_DLL_REQ_RETRACTMOVE)
			{
			//	NSNumber *v = [NSNumber numberWithInt:m_ReplayRetractMode];
			//	Fire_Notify("RequestRetractMove", v0, v);
			}
		}
	}
}


// 通知服务器端模式
void CCnChessLogic::OnSvrSetServerMode(long srvmode)
{
    m_lServerMode = srvmode;
   // //LOG_TRACE("CCnChessLogic::OnSvrSetServerMode  srvmode = "<<m_lServerMode);
	
}


void CCnChessLogic::OnSvrRespPlayerStatusChanged(XLUSERID nPlayerID, PLAYER_STATUS_ACTION_ENUM nStatusAction)
{
//	//LOG_DEBUG("[CnChess]:OnSvrRespPlayerStatusChanged(): ");
	
	int n = -1;
	if(nPlayerID == m_PlayerInfo_Mine.UserID)
	{
		n = 0;
	}
	else if(nPlayerID == m_PlayerInfo_Rival.UserID)
	{
		n = 1;
	}
	else {
		return;
	}

	
	//NSNumber *v0 = [NSNumber numberWithInt:n];
	//NSNumber *v1 = [NSNumber numberWithInt:nStatusAction];
	//Fire_Notify("UserStatusChanged", v0, v1);
}

void CCnChessLogic::ondrawAchess(int srcindex, int destindex, CPoint from, CPoint to)
{
    
    //LOG_TRACE("CCnChessLogic::ondrawAchess from, to");
	
	//NSMutableDictionary *px = [NSMutableDictionary dictionary];
	//[px setObject:[NSNumber numberWithInt:srcindex] forKey:[NSString stringWithFormat:"srcindex"]];
    //[px setObject:[NSNumber numberWithInt:destindex] forKey:[NSString stringWithFormat:"destindex"]];
	//[px setObject:[NSNumber numberWithInt:to.x] forKey:[NSString stringWithFormat:"x"]];
	//[px setObject:[NSNumber numberWithInt:to.y] forKey:[NSString stringWithFormat:"y"]];
	//[px setObject:[NSNumber numberWithInt:from.x] forKey:[NSString stringWithFormat:"srcx"]];
	//[px setObject:[NSNumber numberWithInt:from.y] forKey:[NSString stringWithFormat:"srcy"]];
	//[px setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:"role"]];
	
	//Fire_Notify("PracticeMoveAPiece", px);
    //int whowin = m_AiInterface->whowin();
    practicehandleresult();
}

void CCnChessLogic::onretractmove(int srcindex, int destindex, CPoint from, CPoint to)
{	
//	NSMutableDictionary *px = [NSMutableDictionary dictionary];
//	[px setObject:[NSNumber numberWithInt:srcindex] forKey:[NSString stringWithFormat:"srcindex"]];
//   [px setObject:[NSNumber numberWithInt:destindex] forKey:[NSString stringWithFormat:"destindex"]];
//	[px setObject:[NSNumber numberWithInt:from.x] forKey:[NSString stringWithFormat:"srcx"]];
//	[px setObject:[NSNumber numberWithInt:from.y] forKey:[NSString stringWithFormat:"srcy"]];
//	[px setObject:[NSNumber numberWithInt:to.x] forKey:[NSString stringWithFormat:"destx"]];
//	[px setObject:[NSNumber numberWithInt:to.y] forKey:[NSString stringWithFormat:"desty"]];
//	
//	Fire_Notify("PracticeRetractMove", px);
}

void CCnChessLogic::practicehandleresult()
{
    ////LOG_TRACE("[CCnChessLogic::practicehandleresult] enter result = "<<result);
	//NSNumber *v = [NSNumber numberWithInt:result];
    Fire_Notify("PracticeHandleResult",0,0,NOTIFY_PRACTICEHANDLERESULT,NULL);
}

uint32_t CCnChessLogic::HandlePracticeReq(const string &method, const void *param1, const void *param2, void *result)
{
    bool v = false;
    bool bRet = true;
	
    //LOG_TRACE("CCnChessLogic HandlePracticeReq entry");
    
    if(strcasecmp(method.c_str(), "StartPractice") == 0)
    {
        if(!m_bGameSarted)
        {
			
			if (!m_AiInterface) {
				m_AiInterface = new CCnChessAI();
				m_AiInterface->init(this);
			}
            
            if(!m_AiInterface)
            {
                //LOG_DEBUG("CCnchessLogic m_AiInterface == NU");
                goto Exit;
            }
			m_XQGame.InitGame(0);
            if(m_AiInterface->restart())
            {
                m_bPracticeStart = true;
                m_pChosedPiece.x = -1;
                v = true;
				m_bRedSide = true;
            }
        }
		
    }
    else if(strcasecmp(method.c_str(), "PracticeClick") == 0)
    {
		//LOG_DEBUG("[CnChess]:UserClick(): "<<*(int*)param1);
		//NSLog("turn : %d, stepcount : %d", *(int*)param2, m_XQGame.GetStepCount());
		
		if(m_bGameSarted || !m_bPracticeStart)
        {
            goto Exit;
        }
		
		int n = int(param1);
		CPoint p;
		p.y = n/9;
		p.x = n - 9*p.y;
		checkPracticeClickResult(p, (bool)param2);
    }
    else
    {
        bRet = false;
    }
	
Exit:
	result = (void*)&v;
    return bRet;
	
}

void CCnChessLogic::HandleUserLevelChanged(IDataXNet* pDataX)
{

}




uint32_t CCnChessLogic::IsPlayer(const void *param1, const void *param2, void *result)
{
    //LOG_TRACE("[CCnChessLogic::GetUserInfoByUserID] Enter");
    bool ret = true;

    __int64 UserId = 0;
    string bstrUserID;
    if(NULL == result)
    {
        *(bool *)result = ret;
		return S_OK;
    }
	
    UserId = *(__int64 *)param1;
    
    if(m_PlayerInfo_Mine.UserID == UserId || m_PlayerInfo_Rival.UserID == UserId)
    {
        ret = true;
    }
    else 
    {
        ret = false;
    }
	
    if(result == NULL)
    {
        return E_FAIL;
    }

    *(bool *)result = ret;
    return S_OK;
}

uint32_t CCnChessLogic::GetMySeat(const void *param1, const void *param2, void *result)
{
    //LOG_TRACE("[ CCnChessLogic::GetMySeat] enter");
    LONG v = (LONG)m_MyInfo.SeatID;
    if(NULL == result)
        return E_FAIL;
    *(LONG*)result = v;
    return S_OK; 
}

uint32_t CCnChessLogic::GetTotalUserInfoByRoleID(const void *param1, const void *param2, void *result)
{
    //LOG_TRACE("[CCnChessLogic::GetTotalUserInfoByRoleID] enter");
    if(NULL == result)
    {
        return E_FAIL;
    }
	
	
    LONG role = *(LONG*)param1;
    if(role != 0 && role != 1)
    {
        return E_INVALIDARG;
    }
	
    PlayerInfoExt* playerInfo = NULL;
    if(role == 0)
    {
        playerInfo = &m_PlayerInfo_Mine;
    }
    else
    {
        playerInfo = &m_PlayerInfo_Rival;
    }
	memcpy(result, playerInfo, sizeof(PlayerInfoExt));
    return S_OK;
}


uint32_t CCnChessLogic::GetMyUserID(const void *param1, const void *param2, void *result)
{
    //LOG_TRACE("[CCnChessLogic::GetMyUserID] enter");
    char buff[32];
    sprintf(buff, "%lld", m_MyInfo.UserID);
    string v = buff;
    //LOG_DEBUG("[CnChess]:GetMyUserID(): "<<v);
    *(string*)result = v;
    return S_OK;
}

void CCnChessLogic::NotifyGameEndTime(void* data)
{
    if(NULL == data)
    {
        return;
    }

	
    GameEndTime* pEndTime = (GameEndTime*)data;     
    if(pEndTime->cType != CMD_NOTIFY_GAMEEND_TIME)
        return;
	
	//NSNumber *px = [NSNumber numberWithLong:pEndTime->sec];
	
    ////LOG_TRACE("[CCnChessLogic::NotifyGameEndTime] year = " << pEndTime->sec);
    Fire_Notify("NotifyGameEndTime", pEndTime->sec);
}

void CCnChessLogic::ShowAlert(string type)
{
	//if (!strcasecmp(type.c_str(), "KickPlayerNotifyReq")) {
	//	NSString *str = [[[NSString alloc] initWithString:"非常抱歉，您被蓝宝石用户请出了游戏!"] autorelease];
	//	Fire_Notify("ShowAlert", str);
	//}
}

