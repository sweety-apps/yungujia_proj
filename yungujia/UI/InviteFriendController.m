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

@synthesize lblInfo;
@synthesize tableView = _tableView;
@synthesize btnSend;
@synthesize txtTelNum;

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
    [lblInfo setBackgroundColor:[UIColor clearColor]];
    
    UIImage* btn_img = nil;
    
    btn_img = [UIImage imageNamed:@"btnGray"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btnSend setBackgroundImage:btn_img forState:UIControlStateNormal];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friendlist count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString* dequeueIdentifer = @"section2";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
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
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header.
{
    UITextView *headerLabel = [[[UITextView alloc] init] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor grayColor];
    headerLabel.text = @"已经邀请的朋友";
//    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    headerLabel.shadowColor = [UIColor clearColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    return headerLabel;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
