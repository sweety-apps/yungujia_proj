//
//  USFCommon.c
//  base_utilities
//
//  Created by lijinxin on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include <unistd.h>
#include <sys/time.h>
#include "USFCommon.h"

long long BU_GetTimeInMicroSecond()
{
    long long time_by_ms = 0;
	struct timeval tv;
	if(gettimeofday(&tv,NULL)!=0)
		return 0;
	time_by_ms +=  ((long long)tv.tv_sec) * 1000000;
	time_by_ms += tv.tv_usec ;
    return time_by_ms;
}
 
