// mutex.h: interface for the mutex class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MUTEX_H__E9C53005_869C_4F43_B05C_58E5596EC023__INCLUDED_)
#define AFX_MUTEX_H__E9C53005_869C_4F43_B05C_58E5596EC023__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "common.h"
#include <pthread.h>

class mutex  
{
public:
	mutex()
	{
		pthread_mutex_init(&_mutex, NULL);
	}
	~mutex()
	{
		pthread_mutex_destroy(&_mutex);
	}
	void lock()
	{
		pthread_mutex_lock(&_mutex);
	}
	void trylock()
	{
		pthread_mutex_trylock(&_mutex);
	}
	void unlock()
	{
		pthread_mutex_unlock(&_mutex);
	}
private:
	pthread_mutex_t _mutex;

};

class scoped_lock
{
public:
	scoped_lock( mutex& mutex_obj ) : _mutex_obj(mutex_obj)
	{
		_mutex_obj.lock();
	}
	~scoped_lock()
	{
		_mutex_obj.unlock();
	}
private:
	mutex& _mutex_obj;

};

#endif // !defined(AFX_MUTEX_H__E9C53005_869C_4F43_B05C_58E5596EC023__INCLUDED_)
