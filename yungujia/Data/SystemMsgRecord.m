//
//  SystemMsgRecord.m
//  yungujia
//
//  Created by 波 徐 on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SystemMsgRecord.h"

@implementation SystemMsgRecord
@synthesize time;
@synthesize text;
@synthesize isRead;
@synthesize msgid;
@synthesize title;
-(void)dealloc
{
    [time release];
    [text release];
    [msgid release];
    [title release];
    [super dealloc];
}
@end
