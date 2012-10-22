//
//  LoggerUnitTest.m
//  base_utilities
//
//  Created by Justin Lee on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoggerUnitTest.h"
#import "Logger.h"

#ifdef DEBUG

@implementation LoggerUnitTest

+ (void)doTest
{
    LOGWC("!========>Start Log Test<=========!\n");
    
    LOGA(@"TTTT,%@%04d\n",@"CCC",500);
    LOGW(@"TTTT,%@%04d\n",@"CCC",500);
    LOGE(@"TTTT,%@%04d\n",@"CCC",500);
    
    BU_Log_Init(LOG_TG_FILE, LOG_LV_ERROR, nil);
    
    LOGWC("!========>Start File Log Test<=========!\n");
    
    LOGA(@"TTTT,%@%04d\n",@"CCC",500);
    LOGW(@"TTTT,%@%04d\n",@"CCC",500);
    LOGE(@"TTTT,%@%04d\n",@"CCC",500);
    
    LOGE(@"Log path = %@\tYeah!\n",BU_Log_getLogFileDirectory());
    LOGEC("Log path = %s\tYeah!\n",BU_Log_getLogFileDirectory_C());
    
    BU_Log_Init(LOG_TG_CONCOLE, LOG_LV_WARNING, nil);
    
    
    LOGWC("!========>End Log Test<=========!\n");
}

+ (void)doViewTest
{
    BU_Log_PrintViewTree(LOG_LV_WARNING, [[[UIApplication sharedApplication] delegate] window]);
}

@end

#endif
