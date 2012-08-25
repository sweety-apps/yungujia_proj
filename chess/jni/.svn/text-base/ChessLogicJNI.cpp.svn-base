#include "ChessLogicJNI.h"
#include "CnChessLogic.h"
#include <string.h>
//#include <time.h>
#include "CnChess_define.h"
#include <pthread.h>
#include <signal.h>


CCnChessLogic cnChessLogic;
int result;
pthread_t tid=0;


void threadKill(int t)
{
	 LOGI("AImove",": AImove thread Killed!");
	 if(cnChessLogic.isAttached)
		 cnChessLogic._vm->DetachCurrentThread();
	 cnChessLogic.isAttached=false;
     pthread_exit(0);
	
	 
}


void *AImove(void *arg)
{
   
	//signal(SIGKILL,threadKill);
	struct sigaction act;
	act.sa_handler=threadKill;
	//act.sa_flags = SA_RESETHAND | SA_NODEFER;
	sigaction(SIGHUP, &act, NULL);
	
    
	LOGI("AImove",": Thread already start!");
	cnChessLogic.Call("AIMOVE", 0, NULL);
	LOGI("AImove",": AImove finished!");
	
	

}

string   jstringTostring(JNIEnv*   env,   jstring   jstr)  
{  
   char*   rtn   =   NULL;
   static jmethodID mid=NULL;
   jclass   clsstring   =   env->FindClass("java/lang/String");   
   jstring   strencode   =   env->NewStringUTF("GB2312"); 
   //clock_t start,finish;
   //start=clock();
   if(mid==NULL)
   {
	    mid   =   env->GetMethodID(clsstring,   "getBytes",   "(Ljava/lang/String;)[B"); 
		if(mid==NULL)
			return NULL;

   }
   //finish=clock();
   //__android_log_print(ANDROID_LOG_INFO, LOG_TAG,"CODE RUN IN %d ms",(int)(finish-start));
   //LOGI("CODE RUN IN %d ms",(int)(finish-start));
    
   jbyteArray   barr=   (jbyteArray)env->CallObjectMethod(jstr,mid,strencode);  
   jsize   alen   =   env->GetArrayLength(barr);  
   jbyte*   ba   =   env->GetByteArrayElements(barr,JNI_FALSE);  
   if(alen   >   0)  
   {  
    rtn   =   (char*)malloc(alen+1);         //new   char[alen+1];  
    memcpy(rtn,ba,alen);  
    rtn[alen]=0;  
   }  
   env->ReleaseByteArrayElements(barr,ba,0);  
   string stemp(rtn);
   free(rtn);
   return stemp;  
}  

jint JNI_OnLoad(JavaVM* vm,void* reserved)
{
	JNIEnv *env;
	jclass jcls;
	cnChessLogic._vm=vm;
	vm->GetEnv((void**)&env,JNI_VERSION_1_4);
	jcls=env->FindClass("com/ysh/chess/ChessLogicJNI");
	cnChessLogic.jcls=(jclass)env->NewGlobalRef(jcls);

	return JNI_VERSION_1_4;

}


JNIEXPORT void JNICALL Java_com_ysh_chess_ChessLogicJNI_InitVM
(JNIEnv *env, jobject thiz, jobject b)
{
	/*JavaVM *vm;
	jclass jcls;
	(*env).GetJavaVM((JavaVM **) &vm);
	jcls=env->FindClass("com/ysh/chess/ChessLogicJNI");
	cnChessLogic.jcls=(jclass)env->NewGlobalRef(jcls);
	cnChessLogic._vm = vm;*/
	cnChessLogic._thiz = (*env).NewGlobalRef(b);
	
}

JNIEXPORT jint JNICALL Java_com_ysh_chess_ChessLogicJNI_Call
  (JNIEnv *env, jobject thiz,jstring method,jint param1,jintArray param2)
{
	string strMethod = jstringTostring(env,method);

	if (0 == param2)
	{
		
		
		if(strMethod=="AIMOVE")
		{
			LOGI("AImove",": Call AImove thread!");
			pthread_create(&tid,NULL,AImove,NULL);
		}
		else
		{
			/*int status = cnChessLogic._vm->GetEnv((void**) &cnChessLogic.env, JNI_VERSION_1_4);
			if (status != JNI_OK)
			{
				LOGI("AImove",": Get JNIenv failed!");
				return 0;
			}*/
		    cnChessLogic.Call(strMethod, (const void*)param1, (const void*)param2);
		}
	}
	else
	{
		jint *array = env->GetIntArrayElements(param2, 0);	
		if (!strMethod.compare("REPLYSETTIME") || !strMethod.compare("REPLYCONFIRMTIME"))
		{
			TimeStruct time;
			time.nRoundTime = (array[0]);
			time.nStepAddedTime = (array[1]);
			time.nStepTimeLimit = (array[2]);
			cnChessLogic.Call(strMethod, (const void*)param1, (const void*)&time);
		}
		else
		{
			cnChessLogic.Call(strMethod, (const void*)param1, (const void*)array[0]);
		}
	}

	
	return result;
}

JNIEXPORT void JNICALL Java_com_ysh_chess_ChessLogicJNI_SetPracticeGameOver
(JNIEnv *env,jobject thiz)
{
	
	if(tid!=0)
	{
        LOGI("AImove",": Call kill AImove thread!");
	    pthread_kill(tid,SIGHUP);
	}

}

JNIEXPORT jboolean JNICALL Java_com_ysh_chess_ChessLogicJNI_GetIsGameStarted
  (JNIEnv *env, jobject thiz)
{
		return cnChessLogic.GetIsGameStarted();
}

JNIEXPORT jboolean JNICALL Java_com_ysh_chess_ChessLogicJNI_GetFlagSide
  (JNIEnv *env, jobject thiz)
{
		return cnChessLogic.GetFlagSide();
}

JNIEXPORT jboolean JNICALL Java_com_ysh_chess_ChessLogicJNI_GetIsMyTurn
(JNIEnv *env, jobject thiz)
{
	return cnChessLogic.GetIsMyTurn();
}


JNIEXPORT jint JNICALL Java_com_ysh_chess_ChessLogicJNI_GetGameStatus
(JNIEnv *env, jobject thiz)
{
	return cnChessLogic.GetGameStatus();
}

JNIEXPORT jboolean JNICALL Java_com_ysh_chess_ChessLogicJNI_GetStepCount
(JNIEnv *env, jobject thiz)
{
	return cnChessLogic.m_XQGame.GetStepCount();
}

JNIEXPORT void JNICALL Java_com_ysh_chess_ChessLogicJNI_OnSvrRespSetGameOver
  (JNIEnv *env, jobject thiz)
{
		return cnChessLogic.OnSvrRespSetGameOver();
}

CPoint ValueToPosition(int value,int column)
{
	CPoint pos;
	pos.y = value/column;
	pos.x = value - pos.y * column;
	return pos;
}

JNIEXPORT jint JNICALL Java_com_ysh_chess_ChessLogicJNI_GetPieceIndex 
  (JNIEnv *env, jobject thiz,jint index,jint column)
{
	CPoint pos = ValueToPosition(index,column);
 	return cnChessLogic.m_XQGame.GetPieceIndex(pos); 	
}

JNIEXPORT jobjectArray JNICALL Java_com_ysh_chess_ChessLogicJNI_GetChessMap
	(JNIEnv* env,jobject thiz) 
{
	int row = 10,column = 9;
	jobjectArray result;
	int i;
	jclass intArrCls = env->FindClass( "[I");
	if (intArrCls == NULL) 
	{
		return NULL;
	}
	result = env->NewObjectArray(row, intArrCls,NULL);
	if (result == NULL) 
	{
		return NULL;
	}
	for (i = 0; i < row; i++) 
	{
		jint tmp[256];
		int j;
		jintArray iarr = env->NewIntArray(column);
		if (iarr == NULL) 
		{
			return NULL;
		}
		for (j = 0; j < column; j++) 
		{
			tmp[j] = cnChessLogic.m_XQGame.m_chessmap[i][j];
		}
		env->SetIntArrayRegion(iarr, 0, column, tmp);
		env->SetObjectArrayElement(result, i, iarr);
		env->DeleteLocalRef(iarr);
	}
	return result;
}

JNIEXPORT void JNICALL Java_com_ysh_chess_NetServer_OnGameActionNotify
(JNIEnv *env, jobject thiz,jlong UserID,jbyteArray szGameDataBuf)
{
	int size = env->GetArrayLength(szGameDataBuf);
	jbyte *body = env->GetByteArrayElements( szGameDataBuf, 0);
	cnChessLogic.m_NetServer.OnGameActionNotify(UserID,(const char*)(body),size);
}

JNIEXPORT void JNICALL Java_com_ysh_chess_NetServer_OnEndGameNotify
(JNIEnv *env,jobject thiz,jint TableID)
{
	cnChessLogic.m_NetServer.OnEndGameNotify(TableID);
	
}
