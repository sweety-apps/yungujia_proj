#ifndef TEA_H
#define TEA_H

/*
*for htonl,htonl
*do remember link "ws2_32.lib"
*/
#ifdef WIN32
#include <winsock2.h>
#else
#include <arpa/inet.h>
#endif


class TEA {
public:
	TEA(const unsigned char *key, int round = 32, bool isNetByte = false);
	TEA(const TEA &rhs);
	TEA& operator=(const TEA &rhs);
	void encrypt(const unsigned char *in, unsigned char *out);
	void decrypt(const unsigned char *in, unsigned char *out);
private:
	void encrypt(const unsigned long *in, unsigned long *out);
	void decrypt(const unsigned long *in, unsigned long *out);
	unsigned long ntoh(unsigned long netlong) { return _isNetByte ? ntohl(netlong) : netlong; }
	unsigned long hton(unsigned long hostlong) { return _isNetByte ? htonl(hostlong) : hostlong; }
private:
	int _round; //iteration round to encrypt or decrypt
	bool _isNetByte; //whether input bytes come from network
	unsigned char _key[16]; //encrypt or decrypt key
};

#endif/*TEA_H*/
