//
//  InviteFriendController.m
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InviteFriendController.h"

@interface FriendInfo : NSObject 
{
    NSString* tel;
    BOOL isRegisted;
}
@property (nonatomic,retain) NSString* tel;
@property (assign,nonatomic) BOOL isRegisted;
@end

@implementation FriendInfo
@synthesize tel;
@synthesize isRegisted;
-(void)dealloc
{
    [tel release];
    [super dealloc];
}
@end

@interface InviteFriendController ()

@end

@implementation InviteFriendController

//@synthesize lblInfo;
@synthesize tableView = _tableView;
//@synthesize btnSend;
//@synthesize txtTelNum;

-(void)buildfriendlist
{
    for (int i = 0; i < 10; i++) {
        FriendInfo* fri = [[FriendInfo alloc] init];
        fri.tel = [NSString stringWithFormat:@"13760340767+%d",i];
        fri.isRegisted = i%2 == 0;
        [friendlist addObject:fri];
        [fri release];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"邀请朋友";
        friendlist = [[NSMutableArray alloc] init];
        [self buildfriendlist];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
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
    [friendlist release];
    [super dealloc];
}

//- (NSInteger)numberOfSections
//{
//    return 4;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 3) {
        return [friendlist count];
//    }
//    else {
//        return 1;
//    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* dequeueIdentifer = @"";
    UITableViewCell* cell = nil;
//    int section = indexPath.section;
//    switch (section) {
//        case 0:
//            dequeueIdentifer = @"section0";
//            cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
//            if(cell == nil)
//            {
//                cell = [[[UITableViewCell alloc] init]autorelease];
//                [cell addSubview:lblInfo];
//            }
//            break;
//        case 1:
//            dequeueIdentifer = @"section1";
//            cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
//            if(cell == nil)
//            {
//                cell = [[[UITableViewCell alloc] init]autorelease];
//            }
//            break;
//        case 2:
//            dequeueIdentifer = @"section2";
//            cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
//            if(cell == nil)
//            {
//                cell = [[[UITableViewCell alloc] init]autorelease];
//            }
//            break;
//        case 3:
            dequeueIdentifer = @"section3";
            cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
            if(cell == nil)
            {
                cell = [[[UITableViewCell alloc] init]autorelease];
                UILabel* lblTel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 160, 30)];
                lblTel.text = ((FriendInfo*)[friendlist objectAtIndex:indexPath.row]).tel;
                lblTel.textAlignment = UITextAlignmentLeft;
                lblTel.backgroundColor = [UIColor clearColor];
                [cell addSubview:lblTel];
                [lblTel release];
                
                UILabel* lblIsRegisted = [[UILabel alloc] initWithFrame:CGRectMake(240, 10, 60, 30)];
                lblIsRegisted.text = ((FriendInfo*)[friendlist objectAtIndex:indexPath.row]).isRegisted?@"已注册":@"未注册";
                lblIsRegisted.textColor = ((FriendInfo*)[friendlist objectAtIndex:indexPath.row]).isRegisted?[UIColor colorWithRed:90/255 green:98/255 blue:121/255 alpha:1.0]:[UIColor grayColor];
                [lblIsRegisted setTextAlignment:UITextAlignmentRight];
                lblIsRegisted.backgroundColor = [UIColor clearColor];
                [cell addSubview:lblIsRegisted];
                [lblIsRegisted release];
            }
            else {
                
            }
//            break;
//        default:
//            dequeueIdentifer = @"default";
//            cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
//            if(cell == nil)
//            {
//                cell = [[[UITableViewCell alloc] init]autorelease];
//            }
//            break;
//    }
    return cell;
}


#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    if ([[textField text] length] != 0) {

    }
    
    [textField resignFirstResponder];
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 184;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header.
{
    UIView* headerview = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 184)] autorelease];
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 155, 310, 30)] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor grayColor];
    headerLabel.text = @"已经邀请的朋友";
    headerLabel.font = [UIFont systemFontOfSize:14];
    [headerview addSubview:headerLabel];
    
    UILabel* lblInfo = [[[UILabel alloc] initWithFrame:CGRectMake(0, 4, 320, 45)] autorelease];
    [lblInfo setBackgroundColor:[UIColor clearColor]];
    [lblInfo setText:@"您还有5个邀请名额"];
    [lblInfo setFont:[UIFont boldSystemFontOfSize:20]];
    [lblInfo setTextColor:[UIColor colorWithRed:111/255.0f green:129/255.0f blue:153/255.0f alpha:1.0f]];
    [lblInfo setTextAlignment:UITextAlignmentCenter];
    [headerview addSubview:lblInfo];

    UIButton* btnTelNumbkg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnTelNumbkg setFrame:CGRectMake(10, 50, 300, 50)];
    [btnTelNumbkg.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btnTelNumbkg setTitle:@"手机号码" forState:UIControlStateNormal];
    [btnTelNumbkg setTitleEdgeInsets:UIEdgeInsetsMake(12, -203, 11, 0)];
    [btnTelNumbkg setUserInteractionEnabled:NO];
    [btnTelNumbkg setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerview addSubview:btnTelNumbkg];
    
    UITextField* txtTelNum = [[UITextField alloc] initWithFrame:CGRectMake(109, 65, 191, 31)];
    [txtTelNum setPlaceholder:@"输入受邀人手机号码"];
    [txtTelNum setDelegate:self];
    [txtTelNum setClearButtonMode:UITextFieldViewModeWhileEditing];
    [headerview addSubview:txtTelNum];
    
    
    UIButton* btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* btn_img = nil;
    btn_img = [UIImage imageNamed:@"btnGray"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [btnSend addTarget:self action:@selector(OnClickSend:) forControlEvents:UIControlEventTouchUpInside];
    [btnSend setBackgroundImage:btn_img forState:UIControlStateNormal];
    [btnSend setFrame:CGRectMake(20, 108, 280, 47)];
    [btnSend setTitle:@"发邀请给该手机号码" forState:UIControlStateNormal];
    [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerview addSubview:btnSend];
    [btnSend.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    return headerview;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)OnClickSend:(id)sender
{
    
}

@end
