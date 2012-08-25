
#ifndef __MYTEA_H_20080220__
#define __MYTEA_H_20080220__
#include "tea.h"
#include "SDLogger.h"

class mytea
{
public:
	mytea(const unsigned char *key, int round = 32, bool isNetByte = false);
	~mytea();
	
	int encrypt_buf(const unsigned char *src,int src_len,unsigned char *enc,int enc_len);
	int decrypt_buf(const unsigned char *enc,int enc_len,unsigned char *dec,int dec_len);
private:
	TEA m_tea;

private:
    DECL_LOGGER; 

};

#endif //__MYTEA_H_20080220__
