/********************************************************************
*
*   FileName    :   SDLogger.h
*   Author      :   (zhongcun_yao) 
*   Create      :   2008-11-15
*   LastChange  :   
*   History     :	copy from: 
*                          created:		16:8:2005   21:07, lifeng
*								
*   Description :   
*
********************************************************************/



#ifndef SANDAI_C_LOGGER_H_200508162107
#define SANDAI_C_LOGGER_H_200508162107

//#define LOGGER

#ifdef LOGGER

	#include <iomanip>
	#include <iostream>
	#include <strstream>
	#include <pthread.h>
	#include <android/log.h>

	using std::setw;
	using std::ios;
	using std::setiosflags;

	#if  defined(_UNICODE) || defined(UNICODE)
		#undef	_UNICODE
		#undef UNICODE
		#define  __SD_LOGGER_UNICODE_FLAG__
	#endif

	#define INIT_LOGGER(conf_file)
	#define DECL_LOGGER static const char s_logger_tag_name[64];
	#define IMPL_LOGGER(classname) const char classname::s_logger_tag_name[] = #classname;
	#define IMPL_LOGGER_EX(classname, parent) const char classname::s_logger_tag_name[] = #parent"."#classname;
	#define IMPL_LOGGER_GLOBAL(logger, name)
	
	#define LOG_TRACE(b)\
	{\
		std::strstream  t_obj;\
		t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
		__android_log_write(ANDROID_LOG_VERBOSE, s_logger_tag_name, t_obj.str());\
	}
	#define LOG_DEBUG(b)\
	{\
		std::strstream  t_obj;\
		t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
		__android_log_write(ANDROID_LOG_DEBUG, s_logger_tag_name, t_obj.str());\
	}
	#define LOG_INFO(b)\
	{\
		std::strstream  t_obj;\
		t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
		__android_log_write(ANDROID_LOG_INFO, s_logger_tag_name, t_obj.str());\
	}
	#define LOG_WARN(b)\
	{\
		std::strstream  t_obj;\
		t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
		__android_log_write(ANDROID_LOG_WARN, s_logger_tag_name, t_obj.str());\
	}
	#define LOG_ERROR(b)\
	{\
		std::strstream  t_obj;\
		t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
		__android_log_write(ANDROID_LOG_ERROR, s_logger_tag_name, t_obj.str());\
	}
	#define LOG_FATAL(b)\
	{\
		std::strstream  t_obj;\
		t_obj<<"[L"<<setw(4)<<setiosflags(ios::left)<<__LINE__<<"] "<<setw(24)<<setiosflags(ios::right)<<__FUNCTION__<<"  "<<b<<'\0';\
		__android_log_write(ANDROID_LOG_FATAL, s_logger_tag_name, t_obj.str());\
	}

	#ifdef __SD_LOGGER_UNICODE_FLAG__
		#define _UNICODE
		#define  UNICODE
	#endif

#else  // #ifdef LOGGER
	#define INIT_LOGGER(conf_file) 
	#define DECL_LOGGER
	#define IMPL_LOGGER(classname)
	#define IMPL_LOGGER_EX(classname, parent) 
	#define IMPL_LOGGER_GLOBAL(logger, name)	

	#define LOG_TRACE(b)
	#define LOG_DEBUG(b)
	#define LOG_INFO(b)
	#define LOG_WARN(b)
	#define LOG_ERROR(b)
	#define LOG_FATAL(b)

	#define _LOG4CPLUS_LOGGING_MACROS_HEADER_
	#define LOG4CPLUS_TRACE(a,b)
	#define LOG4CPLUS_DEBUG(a,b)
	#define LOG4CPLUS_INFO(a,b)
	#define LOG4CPLUS_WARN(a,b)
	#define LOG4CPLUS_ERROR(a,b)
	#define LOG4CPLUS_FATAL(a,b)
#endif

#endif
