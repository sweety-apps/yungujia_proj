// asyn_message_events.h: interface for the asyn_message_events class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ASYN_MESSAGE_EVENTS_H__B2A00F47_9C06_4B38_8CC1_312322D02E91__INCLUDED_)
#define AFX_ASYN_MESSAGE_EVENTS_H__B2A00F47_9C06_4B38_8CC1_312322D02E91__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "common/common.h"

//////////////////////////////////////////////////////////////////////
class asyn_message_events  
{
public:
	asyn_message_events();
	virtual ~asyn_message_events();

public:
	virtual void handle_message(ULONG lMessageId, ULONG lParam1, ULONG lParam2)
	{
	}
	virtual void on_delete_message(ULONG lMessageId, ULONG lParam1, ULONG lParam2) { }

private:
	friend class asyn_message_sender;
};

#endif // !defined(AFX_ASYN_MESSAGE_EVENTS_H__B2A00F47_9C06_4B38_8CC1_312322D02E91__INCLUDED_)
