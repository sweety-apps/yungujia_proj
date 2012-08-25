// Utility.h: interface for the Utility class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_UTILITY_H__07772489_D647_42B2_8F6B_63F97692C9ED__INCLUDED_)
#define AFX_UTILITY_H__07772489_D647_42B2_8F6B_63F97692C9ED__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#pragma warning(disable:4786)
#pragma warning(disable:4290)

#include <string>
#include "deftype.h"
#include "common.h"
#include "range_queue.h"

#define DCACHE_DATA_DEFAULT_KEY 11

using namespace std;

class utility  
{
public:
	static string   ch2str( unsigned char * cid, unsigned size );
	static char		str2char( const string & );
	static short	str2short( const string & );
	static long		str2long( const string & );
	static __int64	str2longlong( const string & );
	static string   char2str( char );
	static string   short2str( short );
	static string   long2str( long );
	static string   longlong2str( __int64 );

	static bool set_fd_block(int fd, bool block_mode);
	static int recv_nonblock_data(int sock_fd, char * buffer, int & recv_len);
	static int send_nonblock_data(int sock_fd, const char * buffer, int bytes_tosend);

	static bool set_socket_send_timeout(int fd, int timeout_sec);
	static bool set_socket_recv_timeout(int fd, int timeout_sec);

	static _u64 current_time_ms();

	static string get_first_ip_from_domainname(const char *domainname);

private:
	DECL_LOGGER;
};


#endif // !defined(AFX_UTILITY_H__07772489_D647_42B2_8F6B_63F97692C9ED__INCLUDED_)
