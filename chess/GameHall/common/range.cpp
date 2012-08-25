// range.cpp: implementation of the range class.
//
//////////////////////////////////////////////////////////////////////

#include <cassert>
#include "common.h"
#include "range.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
_u64 range::nlength = 0XFFFFFFFFFFFFFFFF;
/*
range::range( _u64 pos, _u64 length )
	: _pos(pos), _length(length)
{

}


range::~range()
{

}
*/

range range::intersection( const range & r1, const range & r2 )
{
    range ret(0,0);

    if ( r2.end() <= r1.pos() || r2.pos() >= r1.end() )
    {
        // ≤ªœ‡Ωª
        return ret;
    }
    
    range r_min, r_max;
    if ( r1.pos() < r2.pos() )
    {
        r_min = r1;
        r_max = r2;
    }
    else
    {
        r_min = r2;
        r_max = r1;
    }
    
    assert( r_min.length() > (r_max.pos()-r_min.pos()) );
    ret.set_pos( r_max.pos() );
    ret.set_length( min((r_min.length()-(r_max.pos()-r_min.pos())), r_max.length()) );
    
    return ret;
}

