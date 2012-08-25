#ifndef _JNI_HELPER_H_
#define _JNI_HELPER_H_

#include <jni.h>
#include <iomanip>
#include <iostream>
#include <strstream>
#include <android/log.h>
#include <map>

using std::map;
using std::setw;
using std::ios;
using std::setiosflags;

extern jobject g_objXLGameService;
extern JavaVM* g_pVM;

#define LOG_TAG "HallLogicJNI"

#define LOG_G_TRACE(tag, b)\
{\
	std::strstream  t_obj;\
	t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
	__android_log_write(ANDROID_LOG_VERBOSE, tag, t_obj.str());\
}
#define LOG_G_DEBUG(tag, b)\
{\
	std::strstream  t_obj;\
	t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
	__android_log_write(ANDROID_LOG_DEBUG, tag, t_obj.str());\
}
#define LOG_G_INFO(tag, b)\
{\
	std::strstream  t_obj;\
	t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
	__android_log_write(ANDROID_LOG_INFO, tag, t_obj.str());\
}
#define LOG_G_WARN(tag, b)\
{\
	std::strstream  t_obj;\
	t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
	__android_log_write(ANDROID_LOG_WARN, tag, t_obj.str());\
}
#define LOG_G_ERROR(tag, b)\
{\
	std::strstream  t_obj;\
	t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
	__android_log_write(ANDROID_LOG_ERROR, tag, t_obj.str());\
}
#define LOG_G_FATAL(tag, b)\
{\
	std::strstream  t_obj;\
	t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
	__android_log_write(ANDROID_LOG_FATAL, tag, t_obj.str());\
}

struct IDataXNet;

class JniHelper
{
public:
	static bool Notify_JniHall(const char* szEvent,
			IDataXNet* pDataXNet, bool bNeedDestroyDataXNet = true);
	static bool Notify_JniGame(int nGameID, const char* szEvent,
				IDataXNet* pDataXNet, bool bNeedDestroyDataXNet = true);
};

#endif // _JNI_HELPER_H_
