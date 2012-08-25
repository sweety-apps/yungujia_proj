// asyn_message_sender.h: interface for the asyn_message_sender class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_ASYN_MESSAGE_SENDER_H__25EDA80D_35A4_4107_ADF3_FDA07696FB62__INCLUDED_)
#define AFX_ASYN_MESSAGE_SENDER_H__25EDA80D_35A4_4107_ADF3_FDA07696FB62__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "asyn_message_events.h"

/////////////////////////////////////////////////////////////
class asyn_message_sender
{
public:
	asyn_message_sender(asyn_message_events *events_ptr);
	virtual ~asyn_message_sender();

public:
	virtual void send_message(ULONG lMessageId, ULONG lParam1 = 0, ULONG lParam2 = 0);
	virtual void post_message(ULONG lMessageId, ULONG lParam1 = 0, ULONG lParam2 = 0);

private:
	asyn_message_events *m_events_ptr;
	DECL_LOGGER; // LOG_CLASS_DECLARE();
};

#endif // !defined(AFX_ASYN_MESSAGE_SENDER_H__25EDA80D_35A4_4107_ADF3_FDA07696FB62__INCLUDED_)
