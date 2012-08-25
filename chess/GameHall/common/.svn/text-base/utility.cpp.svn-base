// Utility.cpp: implementation of the Utility class.
//
//////////////////////////////////////////////////////////////////////

#pragma warning(disable: 4267)
#pragma warning(disable: 4244)

#include "common.h"
#include "utility.h"

#include <stdexcept>
//#include "parse_asf.h"

#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <sstream>
#include <sys/socket.h>
#include <sys/epoll.h>
#include <time.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>
#include <asm-generic/errno.h>
#include <errno.h>

#define MAX_ENCRYPT_BLOCK_SIZE	(65536) // 64K

using namespace std;

IMPL_LOGGER(utility);
//LOG4CPLUS_CLASS_IMPLEMENT(utility, _logger, "utility");

//////////////////////////////////////////////////////////////////////

string utility::ch2str( unsigned char * cid, unsigned size )
{
	char hex[16] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
	char * out = new char [size *2 + 1];
	unsigned i = 0;
	for ( i=0; i<size; i++ )
	{
		out[i*2] = hex[cid[i]/16];
		out[i*2+1] = hex[cid[i]%16];
	}
	out[i*2] = '\0';
	
	std::string s = out;
	delete []out;
	return s;
}

/*parse value from string*/
char utility::str2char( const string & s )
{
	return (char)str2long( s );
}

short utility::str2short( const string & s )
{
	return (short)str2long( s );
}

long utility::str2long( const string & s )
{
	return atol( s.c_str() );
}

__int64	utility::str2longlong( const string & s )
{
	return atoll( s.c_str() );
}

string utility::char2str( char i )
{
	return long2str( (long)i );
}

string utility::short2str( short i )
{
	return long2str( (long)i );
}

string utility::long2str( long i )
{
	char out[16];
	sprintf(out, "%d", i);
	return out;
}

string utility::longlong2str( __int64 i )
{
	char out[32];
	sprintf(out, "%lld", i);
	return out;
}

bool utility::set_fd_block(int fd, bool block_mode)
{
	int flag = fcntl(fd, F_GETFL);
	if(flag == -1)
	{
		return false;
	}

	if(block_mode)
		flag &= (~O_NONBLOCK);
	else
		flag |= O_NONBLOCK;

	if(fcntl(fd, F_SETFL, flag) == -1)
	{
		return false;
	}

	return true;
}

int utility::recv_nonblock_data(int sock_fd, char * buffer, int & recv_len)
{
	int recv_bytes = 0;
	while(recv_bytes < recv_len)
	{
		int ret = recv(sock_fd, buffer + recv_bytes, recv_len - recv_bytes, 0);
		if(ret < 0)
		{
			int err = errno;
			if(err == EAGAIN)
			{
				//recv_len = recv_bytes;
				//return -1;
				//LOG_WARN("EAGAIN");
				continue;
			}
			else if(err == EINTR)
			{
				continue;
			}
			else
			{
				recv_len = recv_bytes;
				return -2;
			}
		}
		else if(ret == 0)
		{
			// eof (possibly connection reset by peer)
			recv_len = recv_bytes;
			return 0;
		}

		recv_bytes += ret;
	}

	return recv_bytes;
}

int utility::send_nonblock_data(int sock_fd, const char * buffer, int  bytes_tosend)
{
	int bytes_sent = 0;
	while(bytes_sent < bytes_tosend)
	{
		int ret = send(sock_fd, buffer + bytes_sent, bytes_tosend - bytes_sent, 0);
		if(ret < 0)
		{
			int err = errno;
			if(err == EAGAIN)
			{
				return bytes_sent;
			}
			else if(err == EINTR)
			{
				continue;
			}
			else
			{
				return -1;
			}
		}

		bytes_sent += ret;
	}

	return bytes_sent;
}

_u64 utility::current_time_ms()
{
	struct timeval now;
	gettimeofday(&now, NULL);
	return (_u64)now.tv_sec * 1000 + now.tv_usec / 1000;
}

string utility::get_first_ip_from_domainname(const char *domainname)
{
	struct in_addr in;
	struct hostent *ht = gethostbyname(domainname);
	if(ht == NULL)
	{
		return "";
	}

	srand((unsigned int)time(NULL));

	int ip_count = 0;
	char **pptrbk = NULL;
	char *ip = NULL;
	for(pptrbk = ht->h_addr_list; (pptrbk) && (*pptrbk); pptrbk++)
	{
		ip = inet_ntoa(*(struct in_addr *)*pptrbk);
		ip_count++;
		LOG_DEBUG("host=[" << domainname << "], ip=[" << ip << "]");
	}

	if(0 == ip_count)
	{
		return domainname;
	}

	int select_index = rand() % ip_count;
	int index = 0;
	for(pptrbk = ht->h_addr_list; (pptrbk) && (*pptrbk); pptrbk++)
	{
		if(index == select_index)
		{
			(void)memcpy(&in.s_addr, *pptrbk, sizeof(in.s_addr));
			return inet_ntoa(in);
		}
		index++;
	}

	char **q = ht->h_addr_list;
	(void)memcpy(&in.s_addr, *q, sizeof(in.s_addr));
	return inet_ntoa(in);
}

bool utility::set_socket_send_timeout(int fd, int timeout_sec)
{
	struct timeval time;
	time.tv_sec = timeout_sec;
	time.tv_usec = 0;

	bool succ = (0 == setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &time, sizeof(time)));
	return succ;
}

bool utility::set_socket_recv_timeout(int fd, int timeout_sec)
{
	struct timeval time;
	time.tv_sec = timeout_sec;
	time.tv_usec = 0;

	bool succ = (0 == setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &time, sizeof(time)));
	return succ;
}
