//
//  LoudongTableViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoudongTableViewController.h"

@interface LoudongTableViewController ()

@end

@implementation LoudongTableViewController

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;

@synthesize headinfo = _headinfo;
@synthesize loucengctrl = _loucengctrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"选择楼栋";
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoudongCell *cell = (LoudongCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        _loucengctrl.title = @"选择楼层";
        _loucengctrl.headinfo = [NSString stringWithFormat:@"%@>%@",_headinfo,cell.xxdong.text];
        [self.navigationController pushViewController:_loucengctrl animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _headinfo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString* reuseID = @"LoudongCell";
    
    LoudongCell *cell = (LoudongCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        LoudongCellViewController* temporaryController = [[LoudongCellViewController alloc] initWithNibName:@"LoudongCellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (LoudongCell *)temporaryController.view;
        [temporaryController release];
    }
    
    cell.xxdong.text = [NSString stringWithFormat:@"%d栋",row + 1];
    //cell.xxhuayuan.text = @"万科金色家园";
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)popSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customBackBtn
{
    UINavigationBar* navbar = _navctrl.navigationBar;
    UINavigationItem* bi = self.navigationItem;
    
    UIImage* btnImage = [UIImage imageNamed:@"returnBtn_normal"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, btnImage.size.width, btnImage.size.height);
    
    UILabel* lbl = [[[UILabel alloc] initWithFrame:btn.frame] autorelease];
    lbl.text = @"返回";
    lbl.font = [UIFont boldSystemFontOfSize:15];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.textColor = [UIColor whiteColor];
    lbl.shadowOffset = CGSizeMake(1, 1);
    lbl.shadowColor = [UIColor colorWithWhite:0.f alpha:0.7];
    lbl.backgroundColor = [UIColor clearColor];
    //lbl.shadowColor = [UI]
    
    UIBarButtonItem* bbi = [[[UIBarButtonItem alloc] initWithCustomView:btn]autorelease];
    //bi.backBarButtonItem = bbi;
    [btn setImage:btnImage forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"returnBtn_pushed"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    [btn addSubview:lbl];
    bi.leftBarButtonItem = bbi;
}

@end
