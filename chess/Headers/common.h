#ifndef _COMMON_H_201010180948
#define _COMMON_H_201010180948

// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the COMMON_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// COMMON_API functions as being imported from a DLL, wheras this DLL sees symbols
// defined with this macro as being exported.
#include <sstream>
//#include "xlerr.h"
#include <netinet/in.h>
using namespace std;

typedef long long int __int64;
typedef long long int LONGLONG;
typedef int __int32;
typedef short __int16;
typedef char __int8;
typedef unsigned long long int _u64;
typedef unsigned long long int U64;
typedef unsigned int _u32;
typedef unsigned short _u16;
typedef unsigned char _u8;
typedef unsigned char byte;
#ifndef BYTE
typedef unsigned char BYTE;
#endif
typedef const wchar_t *LPCWSTR;
typedef wchar_t *LPWSTR;
#ifndef BOOL
typedef signed char		BOOL; 
#endif
typedef wchar_t WCHAR;
typedef unsigned int DWORD;
typedef unsigned int UINT;
typedef int LONG;

#ifndef FALSE
#define FALSE false
#endif
#ifndef TRUE
#define TRUE true
#endif
#define CID_SIZE 20

#ifdef assert
#define ysh_assert assert
#else
#define ysh_assert
#endif


// for log4cpp
#ifdef _DEBUG
#define LOG
#endif

#ifdef LOG
extern void _my_log(const ostringstream &os);
#define MyLog(a...) \
do{ \
ostringstream os; \
os << a; \
_my_log(os); \
}while(0)
#else
#define MyLog(a...) 
#endif

#define DECL_LOGGER
#define IMPL_LOGGER(a...)
#define IMPL_LOGGER_EX(a...)

#define LOG_FATAL(a...) MyLog(a)
#define LOG_ERROR(a...) MyLog(a)
#define LOG_WARN(a...) MyLog(a)
#define LOG_INFO(a...) MyLog(a)
#define LOG_DEBUG(a...) MyLog(a)
#define LOG_TRACE(a...) MyLog(a)

#define LOG4CPLUS_THIS_FATAL(logger,a...) MyLog(a)
#define LOG4CPLUS_THIS_ERROR(logger,a...) MyLog(a)
#define LOG4CPLUS_THIS_WARN(logger,a...) MyLog(a)
#define LOG4CPLUS_THIS_INFO(logger,a...) MyLog(a)
#define LOG4CPLUS_THIS_DEBUG(logger,a...) MyLog(a)
#define LOG4CPLUS_THIS_TRACE(logger,a...) MyLog(a)

//for COM
#define _T(a) a
#define T(a) a
#define CComBSTR(a) string(a)
#define CComVariant(a) ((void *)&a)
#define VARIANT_OPTIONAL NULL
#define VARIANT_EMPTY NULL
typedef void *VARIANT;

#define CONVERT_SELF_TO_HOST_BYTE_ORDER(x) x=ntohl(x)
#define CONVERT_SELF_TO_NET_BYTE_ORDER(x) x=htonl(x)

#ifndef MINI_VERSION
#define HASH_MAP
#endif

#ifndef BYTE_PER_MB
#define BYTE_PER_MB 1048576
#endif
#ifndef MAX_PATH
#define MAX_PATH 1024
#endif


#define SUCCEEDED(hr) ((hr) == 0)
#define FAILED(hr) ((hr) != 0)
#define UNREFERENCED_PARAMETER \
 (void)

#define CPP_2_C_CALLBACK(pcppFunc, pcFunc) \
do{ \
typeof(pcppFunc) cppFp = (pcppFunc); \
void *tmp = (void *)&cppFp; \
typeof(pcFunc) *ppcFunc = (typeof(pcFunc) *)tmp; \
pcFunc=*ppcFunc; \
}while(0)

#endif	//_COMMON_H_201010180948
