//
//  Config.m
//  yungujia
//
//  Created by 波 徐 on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Config.h"
#import "PublicHeader.h"

@implementation Config

+(NSString*) getUsername
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* username = [defaults objectForKey:KEYFORUSERNAME];
    
    return username;
}

+(void) saveUserName:(NSString*)username
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:username forKey:KEYFORUSERNAME];
}
@end
