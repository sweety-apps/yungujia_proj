//============================================================
// FixedBuffer.h : interface of class FixedBuffer
//                          
// Author: JeffLuo
// Created: 2006-11-08
//============================================================

#ifndef __FIXED_BUFFER_H_20061108_26
#define  __FIXED_BUFFER_H_20061108_26

#include "common.h"
#include <string>

using std::string;

class FixedBuffer
{
	const static string EMPTY_STRING;
public:
	FixedBuffer(char* buffer, int buffer_size, bool reverse_byteorder = false);

	int AttachBuffer(char* buffer, int buffer_size);
	char* get_realbuffer() { return m_buffer; }
	int capacity() const { return m_buffer_size; }
	int remain_len() const { return m_buffer_size - m_offset; }
	int position() const { return m_offset; }
	bool set_position(int new_pos)
	{
		if(new_pos > -1 && new_pos < m_buffer_size)
		{
			m_offset = new_pos;
			return true;
		}
		else
			return false;
	}
	int get_limit() const { return m_limit; }
	void flip()
	{
		m_limit = m_offset;
		m_offset = 0;
	}

	bool put_int(int x);
	bool put_int64(_u64 x);
	bool put_short(short x);
	bool put_byte(byte x);
	bool put_string(const string& str);
	bool put_string(const char* str, int str_len = -1);
	bool put_bytes(const byte* data, int data_len);
	bool skip(int offset);

	int get_int();
	_u64 get_int64();
	short get_short();
	byte get_byte();
	string get_string();
	bool get_bytes(byte* buf, int len);

private:
	void copy_bytes(byte* dest, const byte * src, int len)
	{
		if(!m_reverse_byteorder)
		{
			memcpy(dest, src, len);
		}
		else
		{
			for(int i = 0; i < len; i++)
			{
				*(dest + i) = *(src + len -i - 1);
			}
		}
	}

private:
	char* m_buffer;
	int m_buffer_size;
	int m_offset;
	bool m_reverse_byteorder;

	int m_limit;
};

#endif // __FIXED_BUFFER_H_20061108_26

