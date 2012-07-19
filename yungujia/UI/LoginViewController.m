//
//  LoginView.m
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"

@implementation LoginViewController
@synthesize inputpassword;
@synthesize inputusername;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"登陆";
        //self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)actionNormalLogin:(id)sender
{
    [self startNormalLogin];
}

-(void)startNormalLogin
{
    if([self checkNormalLoginInput]!=true)
    {
        return;
    }
    NSString* msg = NSLocalizedString(@"str_logining",@"登陸中");
//    [self ShowLoadingView:msg];
    
    NSString* username = inputusername.text;
    NSString* password = inputpassword.text;
    [inputusername resignFirstResponder];
    [inputpassword resignFirstResponder];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] ShowMainView:@"NickName" weiboaccount:username];
}


-(BOOL)checkNormalLoginInput
{
    NSString* username = inputusername.text;
    NSString* password = inputpassword.text;
    if ([username length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"str_remind_msg_title",@"提示") message:NSLocalizedString(@"str_empty_username_info", @"请输入账号")delegate:nil cancelButtonTitle:NSLocalizedString(@"str_ok",@"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return false;
    }
    if ([password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"str_remind_msg_title",@"提示") message:NSLocalizedString(@"str_input_password",@"请输入密码") delegate:nil cancelButtonTitle:NSLocalizedString(@"str_ok",@"确定") otherButtonTitles:nil];
        [alert show];
        [alert release];
        return false;
    }
    return true;
}

-(void)actionRegist:(id)sender
{
    RegisterViewController* regist = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:regist animated:YES];
    [regist release];
}

@end
