//
//  Utils.m
//  yungujia
//
//  Created by 波 徐 on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

#define REQUESTPLISTNAME @"RequestUrl"

@implementation Utils
+(NSString*)getRequestUrlByRequestName:(NSString*)requestName
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:REQUESTPLISTNAME ofType:@"plist"];
    NSDictionary *urlList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return [urlList objectForKey:requestName];
}

@end
