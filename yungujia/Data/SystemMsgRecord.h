//
//  SystemMsgRecord.h
//  yungujia
//
//  Created by 波 徐 on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMsgRecord : NSObject 
{
    NSString* text;
    BOOL isRead;
    NSString* time;
    NSString* msgid;
    NSString* title;
}
@property (nonatomic,retain) NSString* time;
@property (retain,nonatomic) NSString* text;
@property (assign,nonatomic) BOOL isRead;
@property (retain,nonatomic) NSString* msgid;
@property (retain,nonatomic) NSString* title;
@end
