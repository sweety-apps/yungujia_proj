//
//  LoginManager.m
//  yungujia
//
//  Created by 波 徐 on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginManager.h"
#import "Utils.h"
#import "PublicHeader.h"

@implementation LoginManager
static LoginManager* g_Manager = nil;

+ (id)shareInstance
{
    if (nil == g_Manager)
    {
        g_Manager = [[LoginManager alloc] init];
    }
    return g_Manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(BOOL)login:(NSString *)username password:(NSString *)password
{
    ASIHTTPRequest* request = nil;
    NSURL *url = [NSURL URLWithString:[Utils getRequestUrlByRequestName:KEYFORLOGINREQUEST]];
//    if ([requestMethod rangeOfString:@"POST"].length != 0) {
//        //POST
//        request = [ASIFormDataRequest requestWithURL:url];
//    }
//    else
//    {
    request = [ASIHTTPRequest requestWithURL:url];
    [request setUseCookiePersistence:YES];
    [request setDelegate:self];
//    [request startAsynchronous];
    [self requestFinished:nil];
    return true;
}

#pragma mark -ASIHTTPREQUESTDELEGATE
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary* argsDict = nil;
    argsDict = [NSDictionary dictionaryWithObject:NSLocalizedString(@"str_password_error",@"您輸入的賬戶或密碼不正確，請重新嘗試。") forKey:@"msg"];
    [self sendUserInfo2UI:argsDict];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary* argsDict = nil;
    argsDict = [NSDictionary dictionaryWithObject:@"登陆失败" forKey:@"msg"];
    [self sendFaildInfo2UI:argsDict];
}

#pragma mark -发消息通知UI
-(void)sendFaildInfo2UI:(NSDictionary*)datadict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginFailed object:datadict];
}

-(void)sendUserInfo2UI:(NSDictionary*)datadict
{
    [[NSNotificationCenter defaultCenter] postNotificationName: NotificationLoginSuccess object:datadict];
}

@end
