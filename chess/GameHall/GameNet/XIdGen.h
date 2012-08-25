
#ifndef _XID_GEN_H_20090220_37
#define _XID_GEN_H_20090220_37

#include <stdlib.h>
#include <sys/times.h>

class XIDGen
{
	enum {
		XID_MIN_LIMIT	= 10,
		XID_MAX_LIMIT = 0x7FFFFFF0
	};

	XIDGen() { }

	static int m_nNextID; // = XID_MIN_LIMIT;
	static bool m_bInited;

	static void Init()
	{
		if(!m_bInited)
		{
			tms tm;
			::srand(times(&tm));
			m_nNextID = XID_MIN_LIMIT + rand() % 101;

			m_bInited = true;
		}
	}

public:
	static int GetNextID()
	{
		Init();

		m_nNextID++;
		if(m_nNextID >= XID_MAX_LIMIT)
		{
			m_nNextID = XID_MIN_LIMIT;
		}
		return m_nNextID;
	}
};



#endif // #ifndef _XID_GEN_H_20090220_37
