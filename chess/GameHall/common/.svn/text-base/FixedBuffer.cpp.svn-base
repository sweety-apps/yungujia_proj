//============================================================
// FixedBuffer.h : interface of class FixedBuffer
//                          
// Author: JeffLuo
// Created: 2006-11-08
//============================================================

#include "FixedBuffer.h"

const string FixedBuffer::EMPTY_STRING = string("");

FixedBuffer::FixedBuffer(char * buffer, int buffer_size, bool reverse_byteorder)
{
	m_buffer = buffer;
	m_buffer_size = buffer_size;
	m_offset = 0;
	m_reverse_byteorder = reverse_byteorder;

	m_limit = 0;
}

bool FixedBuffer::put_byte(byte x)
{
	if(remain_len() < (int)sizeof(byte))
	{
		return false;
	}

	*(m_buffer + m_offset) = x;
	m_offset += sizeof(byte);
	if(m_limit < m_offset)
		m_limit = m_offset;

	return true;
}

bool FixedBuffer::put_int(int x)
{
	if(remain_len() < (int)sizeof(int))
	{
		return false;
	}

	copy_bytes((byte*)(m_buffer + m_offset), (byte*)&x, sizeof(int));
	m_offset += sizeof(int);
	if(m_limit < m_offset)
		m_limit = m_offset;	

	return true;
}

bool FixedBuffer::put_int64(_u64 x)
{
	if(remain_len() < (int)sizeof(_u64))
	{
		return false;
	}

	copy_bytes((byte*)(m_buffer+m_offset), (byte*)&x, sizeof(_u64));
	m_offset += sizeof(_u64);
	if(m_limit < m_offset)
		m_limit = m_offset;

	return true;
}

bool FixedBuffer::put_short(short x)
{
	if(remain_len() < (int)sizeof(short))
	{
		return false;
	}

	copy_bytes((byte*)(m_buffer+m_offset), (byte*)&x, sizeof(short));
	m_offset += sizeof(short);
	if(m_limit < m_offset)
		m_limit = m_offset;

	return true;
}

bool FixedBuffer::put_string(const char * str, int str_len)
{
	int len = str_len;
	if(len == -1)
		len = (str != NULL ? strlen(str) : 0);

	if(remain_len() < (int)sizeof(int) + len)
	{
		return false;
	}

	copy_bytes((byte*)(m_buffer+m_offset), (byte*)&len, sizeof(int));
	m_offset += sizeof(int);
	if(len > 0)
		memcpy(m_buffer + m_offset, str, len);
	m_offset += len;

	if(m_limit < m_offset)
		m_limit = m_offset;

	return true;
}

bool FixedBuffer::put_string(const string & str)
{
	int len = str.length();

	if(remain_len() < (int)sizeof(int) + len)
	{
		return false;
	}

	copy_bytes((byte*)(m_buffer+m_offset), (byte*)&len, sizeof(int));
	m_offset += sizeof(int);
	if(len > 0)
		memcpy(m_buffer + m_offset, str.c_str(), len);
	m_offset +=  len;

	if(m_limit < m_offset)
		m_limit = m_offset;

	return true;
}

bool FixedBuffer::put_bytes(const byte* data, int data_len)
{
	if(data_len < 0)
		return false;
	if(data_len == 0)
		return true;

	if(remain_len() < data_len)
	{
		return false;
	}

	memcpy(m_buffer + m_offset, data, data_len);
	m_offset +=  data_len;

	if(m_limit < m_offset)
		m_limit = m_offset;

	return true;
}

bool FixedBuffer::skip(int offset)
{
	int new_pos = m_offset + offset;
	if(new_pos > -1 && new_pos <= m_buffer_size)
	{
		m_offset += offset;
		if(m_limit < m_offset)
			m_limit = m_offset;
		
		return true;
	}
	else
	{
		return false;
	}
}

byte FixedBuffer::get_byte()
{
	if(remain_len() < (int)sizeof(byte))
	{
		return 0;
	}   
	byte b = *(m_buffer + m_offset);
	m_offset += sizeof(byte);

	if(m_limit < m_offset)
		m_limit = m_offset;

	return b;
}

int FixedBuffer::get_int()
{
	int x;
	if(remain_len() < (int)sizeof(int))
	{
		return 0;
	}   

	copy_bytes((byte*)&x, (byte*)(m_buffer+m_offset), sizeof(int));
	m_offset += sizeof(int);

	if(m_limit < m_offset)
		m_limit = m_offset;

	return x;
}

_u64 FixedBuffer::get_int64()
{
	_u64 x;
	if(remain_len() < (int)sizeof(_u64))
	{
		return 0;
	}   

	copy_bytes((byte*)&x, (byte*)(m_buffer+m_offset), sizeof(_u64));
	m_offset += sizeof(_u64);

	if(m_limit < m_offset)
		m_limit = m_offset;

	return x;
}


short FixedBuffer::get_short()
{
	short x;
	if(remain_len() < (int)sizeof(short))
	{
		return 0;
	}   

	copy_bytes((byte*)&x, (byte*)(m_buffer+m_offset), sizeof(short));
	m_offset += sizeof(short);

	if(m_limit < m_offset)
		m_limit = m_offset;

	return x;
}


string FixedBuffer::get_string()
{
	int str_len = get_int();
	if(str_len < 0)
	{
		return "";
	}   
	else if(str_len == 0)
		return EMPTY_STRING;
    
	if(remain_len() < str_len)
	{
		return "";
	}   

	string str(str_len, 0);
	memcpy(&str[0], m_buffer + m_offset, str_len);
	m_offset += str_len;

	if(m_limit < m_offset)
		m_limit = m_offset;

	return str;
}

// NOTICE: get_bytes do not read prefix length, but get_string() DO
bool FixedBuffer::get_bytes(byte * buf, int len)
{
	if(len < 0 || remain_len() < len)
	{
		return false;
	}   

	memcpy(buf, m_buffer + m_offset, len);
	m_offset += len;

	if(m_limit < m_offset)
		m_limit = m_offset;

	return true;
}

