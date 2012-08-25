
#include "tea.h"
#include <cstring> //for memcpy,memset

using namespace std;

TEA::TEA(const unsigned char *key, int round /*= 32*/, bool isNetByte /*= false*/)
:_round(round)
,_isNetByte(isNetByte) {
	if (key != 0)
		memcpy(_key, key, 16);
	else
		memset(_key, 0, 16);
}

TEA::TEA(const TEA &rhs)
:_round(rhs._round)
,_isNetByte(rhs._isNetByte) {
	memcpy(_key, rhs._key, 16);
}

TEA& TEA::operator=(const TEA &rhs) {
	if (&rhs != this) {
		_round = rhs._round;
		_isNetByte = rhs._isNetByte;
		memcpy(_key, rhs._key, 16);
	}
	return *this;
}

void TEA::encrypt(const unsigned char *in, unsigned char *out) {
	encrypt((const unsigned long*)in, (unsigned long*)out);
}

void TEA::decrypt(const unsigned char *in, unsigned char *out) {
	decrypt((const unsigned long*)in, (unsigned long*)out);
}

void TEA::encrypt(const unsigned long *in, unsigned long *out) {

	unsigned long *k = (unsigned long*)_key;
	register unsigned long y = ntoh(in[0]);
	register unsigned long z = ntoh(in[1]);
	register unsigned long a = ntoh(k[0]);
	register unsigned long b = ntoh(k[1]);
	register unsigned long c = ntoh(k[2]);
	register unsigned long d = ntoh(k[3]);
	register unsigned long delta = 0x9E3779B9; /* (sqrt(5)-1)/2*2^32 */
	register int round = _round;
	register unsigned long sum = 0;

	while (round--) {	/* basic cycle start */
		sum += delta;
		y += ((z << 4) + a) ^ (z + sum) ^ ((z >> 5) + b);
		z += ((y << 4) + c) ^ (y + sum) ^ ((y >> 5) + d);
	}	/* end cycle */
	out[0] = ntoh(y);
	out[1] = ntoh(z);
}

void TEA::decrypt(const unsigned long *in, unsigned long *out) {

	unsigned long *k = (unsigned long*)_key;
	register unsigned long y = ntoh(in[0]);
	register unsigned long z = ntoh(in[1]);
	register unsigned long a = ntoh(k[0]);
	register unsigned long b = ntoh(k[1]);
	register unsigned long c = ntoh(k[2]);
	register unsigned long d = ntoh(k[3]);
	register unsigned long delta = 0x9E3779B9; /* (sqrt(5)-1)/2*2^32 */
	register int round = _round;
	register unsigned long sum = 0;

	if (round == 32)
		sum = 0xC6EF3720; /* delta << 5*/
	else if (round == 16)
		sum = 0xE3779B90; /* delta << 4*/
	else
		sum = delta * round;

	while (round--) {	/* basic cycle start */
		z -= ((y << 4) + c) ^ (y + sum) ^ ((y >> 5) + d);
		y -= ((z << 4) + a) ^ (z + sum) ^ ((z >> 5) + b);
		sum -= delta;
	}	/* end cycle */
	out[0] = ntoh(y);
	out[1] = ntoh(z);
}
