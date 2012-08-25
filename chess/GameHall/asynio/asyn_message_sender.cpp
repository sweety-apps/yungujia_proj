// asyn_message_sender.cpp: implementation of the asyn_message_sender class.
//
//////////////////////////////////////////////////////////////////////
#include "asyn_io_frame.h"
#include "asyn_message_sender.h"

//////////////////////////////////////////////////////////////////////

//LOG_CLASS_IMPLEMENT(asyn_message_sender,"vdt_asyn_message_sender");
IMPL_LOGGER_EX(asyn_message_sender, GN);

asyn_message_sender::asyn_message_sender(asyn_message_events *events_ptr)
	: m_events_ptr(events_ptr)
{

}

asyn_message_sender::~asyn_message_sender()
{

}

//////////////////////////////////////////////////////////////////////
void asyn_message_sender::send_message(ULONG lMessageId, ULONG lParam1, ULONG lParam2)
{
	if(m_events_ptr)
	{
		m_events_ptr->handle_message(lMessageId, lParam1, lParam2);
	}
}

void asyn_message_sender::post_message(ULONG lMessageId, ULONG lParam1, ULONG lParam2)
{
	if(m_events_ptr)
	{
		m_events_ptr->handle_message(lMessageId, lParam1, lParam2);
	}
}
