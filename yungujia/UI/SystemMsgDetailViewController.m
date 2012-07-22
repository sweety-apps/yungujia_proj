//
//  SystemMsgDetailViewController.m
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SystemMsgDetailViewController.h"

@interface SystemMsgDetailViewController ()

@end

@implementation SystemMsgDetailViewController

-(void)buildmsg:(NSString*)msgid
{
    //根据msgid查询得到msg数据结构
    _msgRecord = [[SystemMsgRecord alloc]init];
    _msgRecord.title = @"您的朋友123在您的邀请下已经在云股价注册";
    _msgRecord.text = @"这里是该系统消息的正文，应该支持显示图片和这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文，这里是该系统消息的正文";
    _msgRecord.time = @"2012-12-12 23:23:23";
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil msgid:(NSString*)msgid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"系统消息";
        [self buildmsg:msgid];
    }
    return self;
}

- (void)setCustomNavButtonItemExpand:(NSString*)title imagePath:(NSString*)imagePath imagePathHover:(NSString*)imagePathHover target:(id)target action:(SEL)action 
{
    UIButton *normalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    normalButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    UIImage* originalImage = [UIImage imageNamed:imagePath];
    UIImage* buttonImage;
    if ([originalImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        //这个裁减范围和传入的图片有关。
        buttonImage = [originalImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 24, 0, 16)];
    }
    else {
        buttonImage = [originalImage stretchableImageWithLeftCapWidth:24 topCapHeight:0];
    }
    
    UIImage* hoveroriginalImage = [UIImage imageNamed:imagePathHover];
    UIImage* hoverbuttonImage;
    if ([hoveroriginalImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        //这个裁减范围和传入的图片有关。
        hoverbuttonImage = [hoveroriginalImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 24, 0, 16)];
    }
    else {
        hoverbuttonImage = [hoveroriginalImage stretchableImageWithLeftCapWidth:24 topCapHeight:0];
    }
    
    
	[normalButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [normalButton setBackgroundImage:hoverbuttonImage forState:UIControlStateHighlighted];
    [normalButton setBackgroundImage:hoverbuttonImage forState:UIControlStateSelected];
    [normalButton setTitle:title forState:UIControlStateNormal];
	[normalButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	CGSize labelSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:6]];
    normalButton.titleLabel.shadowColor = [UIColor grayColor];
    normalButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    normalButton.frame = CGRectMake(0, 0, labelSize.width + buttonImage.size.width, buttonImage.size.height);
    
	UIBarButtonItem *settingButtomItem = [[UIBarButtonItem alloc] initWithCustomView:normalButton];
	self.navigationItem.leftBarButtonItem = settingButtomItem;
	[settingButtomItem release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavButtonItemExpand:NSLocalizedString(@"str_back", @"返回") imagePath:@"topbar_button_back" imagePathHover:@"topbar_button_back_hover" target:self action:@selector(onClickBack:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [_msgRecord release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) 
    {
        static NSString* dequeueIdentifer = @"titlecell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] init]autorelease];
            UILabel* lblText = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 310, 40)];
            lblText.text = _msgRecord.title;
            [cell addSubview:lblText];
            //        [lblText setBackgroundColor:[UIColor redColor]];
            lblText.numberOfLines = 2;
            [lblText release];
            
            UILabel* lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 48, 310, 10)];
            lblTime.text = _msgRecord.time;
            lblTime.textColor =[UIColor grayColor];
            //        [lblTime setBackgroundColor:[UIColor blueColor]];
            [cell addSubview:lblTime];
            [lblTime setFont:[UIFont systemFontOfSize:14]];
            [lblTime release];
        }
        else {
            
        }
        return cell;

    }
    else
    {
        static NSString* dequeueIdentifer = @"textcell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] init]autorelease];
            cell.backgroundColor = [UIColor redColor];
            cell.textLabel.numberOfLines = 20;
            cell.textLabel.text = _msgRecord.text;
            [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        }
        else {
            
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) 
    {
        return 62;
    }
    else {
        return 354;
    }
}

-(void)onClickBack:(id)sender
{
    [(UINavigationController*)self.parentViewController popViewControllerAnimated:YES];
}

@end
