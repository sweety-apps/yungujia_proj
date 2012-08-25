#pragma once

#include "common.h"
#include <zlib.h>
#include <stdlib.h>

typedef _u64 uint64_t;

class SDZip
{
public:	
	const static int MAX_ZIP_LEN = 8 * 1024;
	
	static bool compress(char * buf, _u64 * buf_len)
	{
		char tmp_buf[MAX_ZIP_LEN];
		_u64 tmp_buf_len = MAX_ZIP_LEN;
        
		if (!SDZip::compress_buffer(tmp_buf, &tmp_buf_len, buf, *buf_len))
		{
			return false;
		}
        
		memcpy(buf, tmp_buf, tmp_buf_len);
		*buf_len = tmp_buf_len;
		return true;
	}

	static bool uncompress(char * buf, _u64 * buf_len)
	{
		char tmp_buf[MAX_ZIP_LEN];
		_u64 tmp_buf_len = MAX_ZIP_LEN;
		if (!SDZip::uncompress_buffer(tmp_buf, &tmp_buf_len, buf, *buf_len))
		{
			return false;
		}
		memcpy(buf, tmp_buf, tmp_buf_len);
		*buf_len = tmp_buf_len;
	
		return true;
	}

    static int inflate_read(char *source, int len, char **dest, bool gzip, int& out_size);
    static int inflate_read_part(char *source, int len, bool gzip, char *dest, int max_size);
    //static int deflate_write(char *source, int len, char **dest, bool gzip, int& out_size);
	
public:
    static bool compress_buffer(char* dest, uint64_t* dest_len, const char* source, uint64_t source_len)
    {
        return (Z_OK == 
            ::compress2((Bytef*)dest, (uLongf*)dest_len, (const Bytef*)source, (uLongf)source_len, Z_DEFAULT_COMPRESSION));
    }
    static bool uncompress_buffer(char *dest, uint64_t* dest_len, const char* source, uint64_t source_len)
    {
        return (Z_OK ==
            ::uncompress((Bytef*)dest, (uLongf*)dest_len, (const Bytef*)source, (uLongf)source_len));
    }
	
};
