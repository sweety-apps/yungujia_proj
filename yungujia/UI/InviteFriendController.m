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
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else {
        return [friendlist count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 3;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) 
    {
        static NSString* dequeueIdentifer = @"section0";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] init] autorelease];
            cell.textLabel.text = @"手机号码";
            UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
            text.delegate = self;
            text.placeholder = @"输入受邀人手机号码";
            [cell addSubview:text];
            [text release];
        }
        else {
            
        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString* dequeueIdentifer = @"section1";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] init] autorelease];
            UIButton* btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btnSend setFrame:CGRectMake(20, 0, 280, 50)];
            [btnSend setTitle:@"发邀请给该手机号码" forState:UIControlStateNormal];
            [cell addSubview:btnSend];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        else {
            
        }
        return cell;

    }
    else 
    {
        static NSString* dequeueIdentifer = @"section2";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] init]autorelease];
            UILabel* lblTel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 160, 30)];
            lblTel.text = ((FriendInfo*)[friendlist objectAtIndex:indexPath.row]).tel;
            lblTel.textAlignment = UITextAlignmentLeft;
            [cell addSubview:lblTel];
            [lblTel release];
            
            UILabel* lblIsRegisted = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 60, 30)];
            lblIsRegisted.text = ((FriendInfo*)[friendlist objectAtIndex:indexPath.row]).isRegisted?@"已注册":@"未注册";
            lblIsRegisted.textColor = ((FriendInfo*)[friendlist objectAtIndex:indexPath.row]).isRegisted?[UIColor blackColor]:[UIColor grayColor];
            [lblIsRegisted setTextAlignment:UITextAlignmentRight];
            [cell addSubview:lblIsRegisted];
            [lblIsRegisted release];
        }
        else {
            
        }
        return cell;
    }
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
    if (indexPath.section == 2) {
        return 30;
    }
    else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 20;
    }
    else {
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header.
{
    if(section == 2)
    {
        UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = [UIColor grayColor];
        headerLabel.text = @"已经邀请的好友";
        headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        headerLabel.shadowColor = [UIColor clearColor];
        return headerLabel;	
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
