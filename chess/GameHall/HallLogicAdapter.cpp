#include "com_android_ysh_YSHGame_HallLogicJni.h"
#include "JniHelper.h"
#include "GameNet/command/DataXImpl.h"
#include "HallLogic/HallLogic.h"
#include "common/setting.h"

// com.android.ysh.XLGame

jobject g_objXLGameService = NULL;
JavaVM* g_pVM = NULL;

int g_nMajorVersion = 220;
int g_nMinorVersion = 0;
int g_nBuildNum = 1;
int g_nRevVersion = 0;

void Java_com_android_ysh_XLGame_HallLogicJni_Init
	(JNIEnv *env, jobject obj, jstring iemi, jobject callback)
{
	LOG_G_DEBUG(LOG_TAG, "Java_com_android_ysh_XLGame_HallLogicJni_Init");

	DataXImpl::InitDataIDMap();

	const char* szEmi = env->GetStringUTFChars(iemi, NULL);
	if(szEmi == NULL)
	{
		return;
	}

	LOG_G_DEBUG(LOG_TAG, "emi = " << szEmi);

	g_pHallLogic->Init(szEmi);
	env->ReleaseStringUTFChars(iemi, szEmi);

	g_objXLGameService = env->NewGlobalRef(callback);
	env->GetJavaVM(&g_pVM);
}

void Java_com_android_ysh_XLGame_HallLogicJni_Uninit
  (JNIEnv *env, jobject)
{
	if(g_objXLGameService)
	{
		env->DeleteGlobalRef(g_objXLGameService);
	}
}

void Java_com_android_ysh_XLGame_HallLogicJni_LoginAsGuest
  (JNIEnv *env, jobject obj)
{
	g_pHallLogic->LoginAsGuest();
}

jboolean Java_com_android_ysh_XLGame_HallLogicJni_GetDirInfo
  (JNIEnv *, jobject, jint, jint, jint)
{
	return false;
}

void Java_com_android_ysh_XLGame_HallLogicJni_QuerySuitRoom
  (JNIEnv *env, jobject, jint nGameClassID, jint nGameID)
{
	g_pHallLogic->AutoChooseRoom(nGameClassID, nGameID);
}

void Java_com_android_ysh_XLGame_HallLogicJni_EnterRoom
  (JNIEnv *env, jobject, jint nGameID, jint nZoneID, jint nRoomID)
{
	g_pHallLogic->TryEnterRoom(nGameID, nZoneID, nRoomID);
}

void Java_com_android_ysh_XLGame_HallLogicJni_AutoEnterGame
  (JNIEnv *env, jobject, jint nGameID)
{
	g_pHallLogic->AutoEnterGame(nGameID);
}

void Java_com_android_ysh_XLGame_HallLogicJni_QuitGame
  (JNIEnv *env, jobject, jint nGameID, jint nTableID)
{
	g_pHallLogic->QuitGame(nGameID, nTableID);
}

void Java_com_android_ysh_XLGame_HallLogicJni_ExitRoom
  (JNIEnv *env, jobject, jint nGameID)
{
	g_pHallLogic->ExitRoom(nGameID);
}

void Java_com_android_ysh_XLGame_HallLogicJni_GameReady
  (JNIEnv *env, jobject, jint nGameID, jint nTableID, jint nSeatID)
{
	g_pHallLogic->GameReady(nGameID, nTableID, nSeatID);
}

void Java_com_android_ysh_XLGame_HallLogicJni_SubmitGameAction
  (JNIEnv *env, jobject, jint nGameID, jbyteArray arr, jint nLen)
{
	jbyte *pBuffer;
	pBuffer = env->GetByteArrayElements(arr, false);
	if(pBuffer == NULL) {
		return; /* exception occurred */
	}
	g_pHallLogic->SubmitGameAction(nGameID, (const char*)pBuffer, nLen);
	env->ReleaseByteArrayElements(arr, pBuffer, 0);
}

void Java_com_android_ysh_XLGame_HallLogicJni_SetConfig
  (JNIEnv *env, jobject, jstring sSection, jstring sKey, jstring sValue)
{
	const char* szSection = env->GetStringUTFChars(sSection, NULL);
	const char* szKey = env->GetStringUTFChars(sKey, NULL);
	const char* szValue = env->GetStringUTFChars(sValue, NULL);
	if(szKey == NULL || szValue == NULL)
	{
		return;
	}

	LOG_G_DEBUG(LOG_TAG, "szKey = " << szKey << ", szValue=" << szValue);

	setting::get_instance()->set_string(szSection, szKey, szValue);
	env->ReleaseStringUTFChars(sSection, szSection);
	env->ReleaseStringUTFChars(sKey, szKey);
	env->ReleaseStringUTFChars(sValue, szValue);
}

void Java_com_android_ysh_XLGame_HallLogicJni_Replay
  (JNIEnv *, jobject, jint nGameID)
{
	g_pHallLogic->Replay(nGameID);
}

