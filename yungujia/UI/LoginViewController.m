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
@synthesize tablebackground;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"登陆手机云估价";
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
-(void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(actionRegist:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = item;
    [item release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];   
}

-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [super viewDidUnload];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    self.view.center=CGPointMake(self.view.center.x,80);
}

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

#pragma mark -table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
#pragma mark -table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* dequeueIdentifer = @"UITableViewCell";
    UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeueIdentifer] autorelease];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"手机号码";
        }
        else {
            cell.textLabel.text = @"密码";
        }
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    }
    return cell;
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    if ([[textField text] length] != 0) {
        
    }
    
    [textField resignFirstResponder];
    self.view.center=CGPointMake(160,208); 
    return YES;
}
@end
