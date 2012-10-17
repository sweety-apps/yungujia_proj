//
//  GengDuoViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GengDuoViewController.h"
#import "AppDelegate.h"
#import "InviteFriendController.h"
#import "ModifyPwdViewController.h"
#import "GongshiController.h"
#import "AboutSystemViewController.h"
#import "SystemMsgViewController.h"
#import "XunJiaHisViewController.h"
#import "FeedBackViewController.h"
#import "PersonIdentifyViewController.h"
#import "Config.h"

@interface GengDuoViewController ()
-(void)buildDataSource;
@end

@implementation GengDuoViewController

@synthesize scrollView = _scrollView;
@synthesize navbar = _navbar;
@synthesize contentView = _contentView;
@synthesize datasource;
@synthesize imagearray;
@synthesize labelName = _labelName;
@synthesize btn = _btn;
@synthesize navctrl = _navctrl;

//@synthesize navigation;
-(void)buildDataSource
{
    self.datasource = [[NSMutableArray alloc] initWithObjects:/*@"我的询价记录",*/@"修改密码",@"个人认证",@"邀请好友",@"意见反馈",@"关于",@"系统消息",@"检查新版本",@"银行可贷额计算公式与说明",nil];
    self.imagearray = [[NSMutableArray alloc] initWithObjects:/*@"icon_wodexunjiajilu",*/@"icon_xiugaimima",@"icon_gerenrenzheng",@"icon_yaoqinghaoyou",@"icon_yijianfankui",@"icon_guanyu",@"icon_xitongxiaoxi",@"icon_jianchaxinbanben",@"icon_yinhangkedaiejisuangongshi",nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"更多";
        //self.tabBarItem.image = [UIImage imageNamed:@"second"];
        [self buildDataSource];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ((UIScrollView*)(self.scrollView)).contentSize = CGSizeMake(320, 680);
    
    self.labelName.text = [Config getUsername];
    
    //[self.view addSubview:_navctrl.view];
    
    UIImage* navBgImg = [UIImage imageNamed:@"naviBarBg.png"];
    navBgImg = [navBgImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [Utils setAtNavigationBar:self.navbar withBgImage:navBgImg];
    
    UIImage* btn_img = nil;
    
    btn_img = [UIImage imageNamed:@"btnRed"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btn setBackgroundImage:btn_img forState:UIControlStateNormal];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.navctrl.title = @"更多";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.datasource = nil;
    self.imagearray = nil;
    [super dealloc];
}

#pragma mark -tabledatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UILabel* lbltext = [[[UILabel alloc] initWithFrame:CGRectMake(50, 15, 320-70, 20)] autorelease];
    [lbltext setBackgroundColor:[UIColor clearColor]];
    lbltext.text = [self.datasource objectAtIndex:indexPath.row];
    lbltext.font = [UIFont boldSystemFontOfSize:17.0];
    [cell addSubview:lbltext];
    
    UIImageView* imgicon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.imagearray objectAtIndex:indexPath.row]]] autorelease];
    [imgicon setFrame:CGRectMake(20, 15, 20, 20)];
    [cell addSubview:imgicon];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}

#pragma mark - tabledelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 20:
            [self showXunjiaHis];
            break;
        case 0:
            [self showModifyPwd];
            break;
        case 1:
            [self showPersonIdentify];
            break;
        case 2:
            [self showInvite];
            break;
        case 3:
            [self showfeedback];
            break;
        case 4:
            [self showAbout];
            break;
        case 5:
            [self showSystemMsg];
            break;
        case 6:
            [self showActionSheet];
            break;
        case 7:
            [self showGongshi];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(IBAction)actionLogout:(id)sender
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] ShowLoginView]; 
}

-(void)showInvite
{
//    self.navigation push
    InviteFriendController* controller = [[InviteFriendController alloc] initWithNibName:@"InviteFriendController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [((UINavigationController*)self.navctrl) pushViewController:controller animated:YES];
    [controller release];
}

-(void)showXunjiaHis
{
    XunJiaHisViewController* controller = [[XunJiaHisViewController alloc] initWithNibName:@"XunJiaHisViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [((UINavigationController*)self.navctrl) pushViewController:controller animated:YES];
    [controller release];
}

-(void)showModifyPwd
{
    ModifyPwdViewController* controller = [[ModifyPwdViewController alloc] initWithNibName:@"ModifyPwdViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [((UINavigationController*)self.navctrl) pushViewController:controller animated:YES];
    [controller release];
}

-(void)showPersonIdentify
{
    PersonIdentifyViewController* controller = [[PersonIdentifyViewController alloc] initWithNibName:@"PersonIdentifyViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [((UINavigationController*)self.navctrl) pushViewController:controller animated:YES];
    [controller release];
}
-(void)showfeedback
{
    FeedBackViewController* controller = [[FeedBackViewController alloc] initWithNibName:@"FeedBackViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [((UINavigationController*)self.navctrl) pushViewController:controller animated:YES];
    [controller release];
}
-(void)showAbout
{
    AboutSystemViewController* controller = [[AboutSystemViewController alloc] initWithNibName:@"AboutSystemViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [((UINavigationController*)self.navctrl) pushViewController:controller animated:YES];
    [controller release];
}
-(void)showSystemMsg
{
    SystemMsgViewController* controller = [[SystemMsgViewController alloc] initWithNibName:@"SystemMsgViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [((UINavigationController*)self.navctrl) pushViewController:controller animated:YES];
    [controller release];
}

-(void)showGongshi
{
    GongshiController* controller = [[GongshiController alloc] initWithNibName:@"GongshiController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [((UINavigationController*)self.navctrl) pushViewController:controller animated:YES];
    [controller release];
}

-(void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"检测到新的版本，是否要进行升级?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	if(actionSheet!=nil)
	{
		[actionSheet addButtonWithTitle:@"暂不升级"];
        [actionSheet addButtonWithTitle:@"立即升级"];			
        actionSheet.cancelButtonIndex = 0;
		
		[actionSheet showInView:((AppDelegate*)[[UIApplication sharedApplication] delegate]).rootTabBarController.view];
		//[actionSheet showInView:self.view];
		[actionSheet release];
	}

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
