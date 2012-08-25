// range.h: interface for the range class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_RANGE_H__4736E282_CE0C_4091_BE84_2C4CB914BD63__INCLUDED_)
#define AFX_RANGE_H__4736E282_CE0C_4091_BE84_2C4CB914BD63__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "common.h"
#include <string>
#include <stdio.h>

class range  
{
public:
	static _u64 nlength;
	static range full_range()
	{
		return range( 0, nlength );
	}
	static range zero_range()
	{
		return range( 0, 0 );
	}
	range( _u64 pos = 0, _u64 length = range::nlength)
		: _pos(pos), _length(length)
	{
	}
//	virtual ~range();
	inline _u64 pos() const
	{
		return _pos;
	};
	inline void set_pos( const _u64& pos )
	{
		_pos = pos;
	}
	inline _u64 length() const
	{
		return _length;
	};
	inline void set_length( const _u64& length )
	{
		_length = length;
	}

	inline void set( const _u64& pos, const _u64& length )
	{
		_pos = pos;
		_length = length;
	}
	//只改变pos，end不变
	void dec_pos( _u64 offset )
	{
		_pos -= offset;
		_length += offset;
	}
	//只改变pos，end不变
	void inc_pos( _u64 offset )
	{
		_pos += offset;
		_length -= offset;
	}
	inline _u64 end() const
	{
		if( _length == nlength)
			return _length;
		return _pos + _length;
	}
	inline bool is_in( _u64 pos ) const
	{
		return ( (pos>=_pos) && (pos<end()) );
	}
	inline bool is_contain( const range& r ) const
	{
		return ( (r.pos()>=_pos) && (r.end()<=this->end()) );
	}
	inline bool is_full_range() const
	{
		return ( ( _pos==0 ) && ( _length==nlength ) );
	};

	bool friend operator < (const range& r1, const range& r2)
	{
		if(r1.pos() < r2.pos())
		{
			return true;
		}
		else if(r1.pos() == r2.pos())
		{
			if(r1.length() < r2.length())
				return true;
			else
				return false;
		}
		return false;
	}

	range& operator -=(const range& r)
	{
		if(_pos >= r.pos())
		{
			if(end() <= r.end())
			{
				this->set_length(0);
			}
			else
			{
				this->set_length(end() - r.end());
				this->set_pos(r.end());
			}
		}
		else
		{
			if(end() > r.pos())
			{
				if(end() > r.end())
				{
					//split two range, return half
					this->set_length(r.pos() - _pos);
				}
				else
				{
					this->set_length(r.pos() - _pos);
				}
			}
		}
		return *this;
	}

    // 计算两个 range 的交集
    static range intersection( const range & r1, const range & r2 );

	inline bool operator==( const range & r ) const
	{
		return (_pos==r.pos())&&(_length==r.length());
	}
	bool is_relevant( const range& r ) const
	{
		if( (r.end() <= _pos) || (this->end() <= r.pos() ) )
			return false;
		else
			return true;
	}
	std::string to_string() const
	{
		char buf[64];
		std::string result;
		sprintf( buf, "[%I64u, %I64u, %I64u) ", _pos, _length, this->end());
		result = buf;
		return result;
	}

private:
	_u64 _pos;
	_u64 _length;
};

#endif // !defined(AFX_RANGE_H__4736E282_CE0C_4091_BE84_2C4CB914BD63__INCLUDED_)
