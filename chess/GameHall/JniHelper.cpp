#include "JniHelper.h"
#include "common/GNInterface.h"

bool JniHelper::Notify_JniHall(const char* szEvent, IDataXNet* pDataXNet,
		bool bNeedDestroyDataXNet)
{
	if(!szEvent)
	{
		LOG_G_WARN(LOG_TAG, "szEvent == NULL");
		return false;
	}

	JNIEnv *env;
	g_pVM->AttachCurrentThread(&env, NULL);
	{
		jclass cls = env->GetObjectClass(g_objXLGameService);
		jmethodID midHall = env->GetMethodID(cls, "OnJniToHallCallback", "(Ljava/lang/String;Landroid/os/Bundle;)V");
		if(midHall == NULL)
		{
			LOG_G_ERROR(LOG_TAG, "get OnJniToHallCallback method failed!");
			return false;
		}

		jobject objData = NULL;
		if(pDataXNet)
		{
			objData = pDataXNet->EncodeToBundle(env);
		}
		LOG_G_DEBUG(LOG_TAG, "data=" << objData);
		env->CallVoidMethod(g_objXLGameService, midHall, env->NewStringUTF(szEvent), objData);
	}
	g_pVM->DetachCurrentThread();
	if(bNeedDestroyDataXNet && pDataXNet)
	{
		delete pDataXNet;
	}
	return true;
}

bool JniHelper::Notify_JniGame(int nGameID, const char* szEvent,
		IDataXNet* pDataXNet, bool bNeedDestroyDataXNet)
{
	if(!szEvent)
	{
		LOG_G_WARN(LOG_TAG, "szEvent == NULL");
		return false;
	}

	int status;
	JNIEnv *env;
	bool isAttached = false;
	status = g_pVM->GetEnv((void **) &env, JNI_VERSION_1_4);
	if(status < 0)
	{
		LOG_G_WARN(LOG_TAG, "GetEnv failed!");
		status = g_pVM->AttachCurrentThread(&env, NULL);
		if(status < 0)
		{
			LOG_G_ERROR(LOG_TAG, "AttachCurrentThread failed!");
			return false;
		}
		isAttached = true;
	}

	jclass cls = env->GetObjectClass(g_objXLGameService);
	jmethodID midGame = env->GetMethodID(cls, "OnJniToGameCallback", "(ILjava/lang/String;Landroid/os/Bundle;)V");
	if(midGame == NULL)
	{
		LOG_G_ERROR(LOG_TAG, "get OnJniToHallCallback method failed!");
		return false;
	}

	jobject objData = NULL;
	if(pDataXNet)
	{
		objData = pDataXNet->EncodeToBundle(env);
	}
	LOG_G_DEBUG(LOG_TAG, "data=" << objData);
	env->CallVoidMethod(g_objXLGameService, midGame, nGameID, env->NewStringUTF(szEvent), objData);

	if(isAttached)
	{
		g_pVM->DetachCurrentThread();
	}

	if(bNeedDestroyDataXNet && pDataXNet)
	{
		delete pDataXNet;
	}
	return true;
}

