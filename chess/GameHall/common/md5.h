/******************************************************************************
 *  Copyright (C) 2000 by Robert Hubley.                                      *
 *  All rights reserved.                                                      *
 *                                                                            *
 *  This software is provided ``AS IS'' and any express or implied            *
 *  warranties, including, but not limited to, the implied warranties of      *
 *  merchantability and fitness for a particular purpose, are disclaimed.     *
 *  In no event shall the authors be liable for any direct, indirect,         *
 *  incidental, special, exemplary, or consequential damages (including, but  *
 *  not limited to, procurement of substitute goods or services; loss of use, *
 *  data, or profits; or business interruption) however caused and on any     *
 *  theory of liability, whether in contract, strict liability, or tort       *
 *  (including negligence or otherwise) arising in any way out of the use of  *
 *  this software, even if advised of the possibility of such damage.         *
 *                                                                            *
 ******************************************************************************
 MD5.H - header file for MD5C.C
 
   Port to Win32 DLL by Robert Hubley 1/5/2000

   Original Copyright:

		Copyright (C) 1991-2, RSA Data Security, Inc. Created 1991. All
		rights reserved.

		License to copy and use this software is granted provided that it
		is identified as the "RSA Data Security, Inc. MD5 Message-Digest
		Algorithm" in all material mentioning or referencing this software
		or this function.

		License is also granted to make and use derivative works provided
		that such works are identified as "derived from the RSA Data
		Security, Inc. MD5 Message-Digest Algorithm" in all material
		mentioning or referencing the derived work.
		
		RSA Data Security, Inc. makes no representations concerning either
		the merchantability of this software or the suitability of this
		software for any particular purpose. It is provided "as is"
		without express or implied warranty of any kind.

		These notices must be retained in any copies of any part of this
		documentation and/or software.
 *****************************************************************************/

/******************************************************************************
 *  Copyright (C) 2000 by Robert Hubley.                                      *
 *  All rights reserved.                                                      *
 *                                                                            *
 *  This software is provided ``AS IS'' and any express or implied            *
 *  warranties, including, but not limited to, the implied warranties of      *
 *  merchantability and fitness for a particular purpose, are disclaimed.     *
 *  In no event shall the authors be liable for any direct, indirect,         *
 *  incidental, special, exemplary, or consequential damages (including, but  *
 *  not limited to, procurement of substitute goods or services; loss of use, *
 *  data, or profits; or business interruption) however caused and on any     *
 *  theory of liability, whether in contract, strict liability, or tort       *
 *  (including negligence or otherwise) arising in any way out of the use of  *
 *  this software, even if advised of the possibility of such damage.         *
 *                                                                            *
 *****************************************************************************/

#ifndef _MD5_H
#define _MD5_H

#include <memory.h>
#include <stdio.h>

class ctx_md5 
{
public:
	ctx_md5();

public:
	void update(const unsigned char *pdata, unsigned long count);
	void finish(unsigned char cid[16]);

protected:
	void initialize(void);
	void handle(unsigned long *state, const unsigned char block[64]);

protected:	
	void encode(unsigned char *output, const unsigned long *input, unsigned long len);
	void decode(unsigned long *output, const unsigned char *input, unsigned long len);

protected:
	unsigned long _state[4];		/* state (ABCD) */
	unsigned long _count[2];		/* number of bits, modulo 2^64 (lsb first) */
	unsigned char _inner_data[64];  /* input buffer */
};

/******************************************************************************
 *  unsigned char cid[16]; 
 *  ctx_md5 hash;

 *  hash.update((unsigned char *)("a"), 1);
 *  hash.update((unsigned char *)("b"), 1);
 *  hash.finish(cid);
 *****************************************************************************/
#endif