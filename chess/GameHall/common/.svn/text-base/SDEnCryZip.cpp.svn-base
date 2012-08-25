#include "SDEnCryZip.h"

#define UNZIP_CHUNK 32*1024

int SDZip::inflate_read(char *source, int len, char **dest, bool gzip, int& out_size) 
{ 
    int ret; 
    unsigned have; 
    z_stream strm; 
    unsigned char out[UNZIP_CHUNK]; 
    int totalsize = 0; 

    /* allocate inflate state */ 
    strm.zalloc   = Z_NULL; 
    strm.zfree    = Z_NULL; 
    strm.opaque   = Z_NULL; 
    strm.avail_in = 0; 
    strm.next_in  = Z_NULL; 

    if(gzip) 
        ret = inflateInit2(&strm, 47); 
    else 
        ret = inflateInit(&strm); 

    if (ret != Z_OK) 
        return ret; 

    strm.avail_in = len; 
    strm.next_in = (Bytef*)source; 

    /* run inflate() on input until output buffer not full */ 
    do 
    { 
        strm.avail_out = UNZIP_CHUNK; 
        strm.next_out = out; 
        ret = inflate(&strm, Z_NO_FLUSH); 
        if(ret == Z_STREAM_ERROR) return ret; /* state not clobbered */ 

        switch (ret) 
        { 
        case Z_NEED_DICT:
            ret = Z_DATA_ERROR; 
            /* and fall through */
        case Z_DATA_ERROR: 
        case Z_MEM_ERROR:
            inflateEnd(&strm);
            return ret; 
        } 

        have = UNZIP_CHUNK - strm.avail_out; 
        totalsize += have; 
        *dest = (char*)realloc(*dest, totalsize); 
        memcpy(*dest + totalsize - have, out, have); 
    } while(strm.avail_out == 0); 

    /* clean up and return */ 
    (void)inflateEnd(&strm); 
    out_size = totalsize;

    return ret == Z_STREAM_END ? Z_OK : Z_DATA_ERROR; 
} 

int SDZip::inflate_read_part(char *source, int len, bool gzip, char *dest, int max_size)
{
    int ret;     
    z_stream strm;     

    /* allocate inflate state */ 
    strm.zalloc   = Z_NULL; 
    strm.zfree    = Z_NULL; 
    strm.opaque   = Z_NULL; 
    strm.avail_in = 0; 
    strm.next_in  = Z_NULL; 

    if(gzip) 
        ret = inflateInit2(&strm, 47); 
    else 
        ret = inflateInit(&strm);          

    if (ret != Z_OK) 
        return ret; 

    strm.avail_in  = len; 
    strm.next_in   = (Bytef*)source;     
    strm.avail_out = max_size; 
    strm.next_out  = (Bytef*)dest; 

    ret = inflate(&strm, Z_NO_FLUSH); 
    if(ret == Z_STREAM_ERROR) return ret; /* state not clobbered */ 

    switch (ret) 
    { 
    case Z_NEED_DICT:
        ret = Z_DATA_ERROR; 
        /* and fall through */
    case Z_DATA_ERROR: 
    case Z_MEM_ERROR:
        inflateEnd(&strm);
        return ret; 
    }

    /* clean up and return */ 
    (void)inflateEnd(&strm);     

    return Z_OK; 
}
