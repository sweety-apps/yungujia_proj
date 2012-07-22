//
//  SystemMsgViewController.m
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SystemMsgViewController.h"
#import "SystemMsgDetailViewController.h"
#import "SystemMsgRecord.h"

@interface SystemMsgViewController ()

@end

@implementation SystemMsgViewController

-(NSString*)buildtimestr
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date=[formater dateFromString:@"2011-04-22 11:03:38"];
//    NSLog(@"%@",date);
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里去掉 具体时间 保留日期    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSString * curTime = [formater stringFromDate:curDate];
    NSLog(@"%@",curTime);
    [formater release];
    return curTime;
    
    
}
-(void)buildmsglist
{
    for (int i = 0; i<10; i++) 
    {
        SystemMsgRecord* msg = [[SystemMsgRecord alloc] init];
        msg.title = [NSString stringWithFormat:@"您的朋友%d在您的邀请下已经注册了云估价",i];
        msg.time = [self buildtimestr];
        msg.isRead = i%2?YES:NO;
        msg.text = @"正文正文";
        msg.msgid = [NSString stringWithFormat:@"%d",i];
        [_msgList addObject:msg];
        [msg release];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"系统消息";
        _msgList = [[NSMutableArray alloc] init];
        [self buildmsglist];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [_msgList release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_msgList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* dequeueIdentifer = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] init]autorelease];
        SystemMsgRecord* msg = (SystemMsgRecord*)[_msgList objectAtIndex:indexPath.row];
        UILabel* lblText = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, 290, 40)];
        lblText.text = msg.title;
        [cell addSubview:lblText];
//        [lblText setBackgroundColor:[UIColor redColor]];
        lblText.numberOfLines = 2;
        [lblText release];
        
        UILabel* lblTime = [[UILabel alloc] initWithFrame:CGRectMake(17, 48, 290, 10)];
        lblTime.text = msg.time;
        lblTime.textColor =[UIColor grayColor];
//        [lblTime setBackgroundColor:[UIColor blueColor]];
        [cell addSubview:lblTime];
        [lblTime setFont:[UIFont systemFontOfSize:14]];
        [lblTime release];
        
        if (msg.isRead) {
            UIImageView* imgIsRead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"isRead"]];
            [imgIsRead setFrame:CGRectMake(0, 22, 15, 15)];
            [cell addSubview:imgIsRead];
            [imgIsRead release];
        }

        UIImageView* imgDetail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail"]];
        [imgDetail setFrame:CGRectMake(300, 20, 11, 18)];
        [cell addSubview:imgDetail];
        [imgDetail release];
        
    }
    else {
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    SystemMsgRecord* msg = (SystemMsgRecord*)[_msgList objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SystemMsgDetailViewController* controller = [[SystemMsgDetailViewController alloc] initWithNibName:@"SystemMsgDetailViewController" bundle:nil msgid:msg.msgid];
    [((UINavigationController*)self.parentViewController) pushViewController:controller animated:YES];
    [controller release];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}


@end
