#if !defined(AFX_DEFTYPE_ANALYSER_H__EA0415E8_57B0_4DA8_A4AD_AE04F9769C2F__INCLUDED_)
#define AFX_DEFTYPE_ANALYSER_H__EA0415E8_57B0_4DA8_A4AD_AE04F9769C2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#if defined(__cplusplus)
extern "C"
{
#endif
#pragma pack(push, 1)
/*

//error code define
const int NOT_SUPPORT_PROXY_TYPE = -1;
const int TASK_ALREADY_STARTED = -2;
const int TASK_ALREADY_STOPPED = -3;
const int HAS_MORE_DATA = 1;
const int BUFFER_TOO_SMALL = -4;
const int GET_CUR_PATH_ERROR = -5;
const int SOCKET_INIT_ERROR = -6;
const int P2HUB_INIT_ERROR = -7;
const int P2P_INIT_ERROR = -8;
const int URL_NOT_LEGAL = -9;
const int SCHEMA_NOT_SUPPORT = -10;
const int PARAMETER_NOT_LEGAL = -11;
const int INVALID_TASK_ID = -12;
const int RUNTIME_ERROR = -13;
const int TEMPFILE_NOT_EXIST = -14;
const int TEMPFILE_IS_LOW_VERSION = -15;
const int QUERY_BEEN_CANCELED = -16;
const int LOGIC_ERROR = -17;
const int CANT_SEARCH_RESOURCE = -18;
const int HASNT_PART_CID = -19;
const int HASNT_PEER_ID = -20;
const int RESOLVER_CREATE_FAILURE=-21;

//buffer alloc const define
const int MAX_SERVER_NAME_LEN  = 256;
const int MAX_SCHEMA_NAME_LEN  = 256;
const int MAX_HOST_NAME_LEN    = 256;
const int MAX_USER_NAME_LEN    = 256;
const int MAX_PASSWORD_LEN     = 256;
const int MAX_FULLPATH_LEN     = 1024;
const int MAX_FILE_NAME_LEN    = 1024;
const int MAX_RESOURCE_DES_LEN = 1024;

const int MAX_DESCRIPTION_LEN  = 8192;
const int MAX_URL_LEN          = 1024;
const int MAX_PATH_LEN         = 256;
const int MAX_NAME_LEN         = 256;
const int MAX_VERSION_LEN      = 64;
*/

const int CID_SIZE = 20;
const int MD5_SIZE = 16;
const unsigned CID_PART_LENGTH = (20<<10); // 20K
const unsigned MAX_PART_SIZE = 10485760; // 10M

//define proxy type
const int NO_PROXY   = 0;
const int SOCKS5     = 1;
const int HTTP_PROXY = 2;
const int FTP_PROXY  = 3;
const int DEFAULT    = 4;

const int TCID_SAMPLE_SIZE     = 61440;
const int TCID_SAMPLE_UNITSIZE = 20480;
const int BCID_DEF_MIN_BLOCK_COUNT = 512;
const int BCID_DEF_MAX_BLOCK_SIZE  = 2097152;
const int BCID_DEF_BLOCK_SIZE	   = 262144;

//////////////////////////////////////////////////////////////////////////////////////
typedef unsigned long long U64;

typedef unsigned char byte;

typedef union tag_bit_value
{
	unsigned char ch;
	struct
	{
		long b0:1;
		long b1:1;
		long b2:1;
		long b3:1;
		long b4:1;
		long b5:1;
		long b6:1;
		long b7:1;
	};
	struct 
	{
		long l4:4;
		long h4:4;
	};
} bit_value;

#pragma pack(pop)
#if defined(__cplusplus)
}
#endif

#endif // !defined(AFX_DEFTYPE_ANALYSER_H__EA0415E8_57B0_4DA8_A4AD_AE04F9769C2F__INCLUDED_)
