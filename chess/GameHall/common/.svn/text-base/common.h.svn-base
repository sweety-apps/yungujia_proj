#ifndef _COMMON_H
#define _COMMON_H

#include <assert.h>
#include "SDLogger.h"

typedef long long __int64;
typedef unsigned long long _u64;
typedef unsigned char byte;
typedef unsigned char BYTE;
typedef long BOOL;
typedef unsigned short UINT16;
typedef long LONG;
typedef unsigned long ULONG;
typedef unsigned long DWORD;
typedef unsigned short USHORT;
typedef __int64 XLUSERID;
typedef short SHORT;
typedef void VOID;
typedef int INT;

#ifndef _MAC
typedef wchar_t WCHAR;    // wc,   16-bit UNICODE character
#else
// some Macintosh compilers don't define wchar_t in a convenient location, or define it as a char
typedef unsigned short WCHAR;    // wc,   16-bit UNICODE character
#endif

typedef WCHAR *PWCHAR;
typedef WCHAR *LPWCH, *PWCH;
typedef const WCHAR *LPCWCH, *PCWCH;
typedef WCHAR *NWPSTR;
typedef WCHAR *LPWSTR, *PWSTR;

typedef const WCHAR *LPCWSTR, *PCWSTR;

#define FALSE   0
#define TRUE    1

#define ysh_assert assert

#define max(a,b)    (((a) > (b)) ? (a) : (b))
#define min(a,b)    (((a) < (b)) ? (a) : (b))

#ifndef MINI_VERSION
#define HASH_MAP
#endif

#ifndef BYTE_PER_MB
#define BYTE_PER_MB 1048576
#endif

#endif



