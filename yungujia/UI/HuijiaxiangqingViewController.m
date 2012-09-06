//
//  HuijiaxiangqingViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HuijiaxiangqingViewController.h"

@interface HuijiaxiangqingViewController ()

@end

@implementation HuijiaxiangqingViewController

@synthesize headinfo = _headinfo;
@synthesize navctrl = _navctrl;
@synthesize xiangqingctrl = _xiangqingctrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.xiangqingctrl = [[PinggujigouxiangqingViewController alloc] initWithNibName:@"PinggujigouxiangqingViewController" bundle:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.xiangqingctrl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HuijiaxiangqingCell *cell = (HuijiaxiangqingCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        _xiangqingctrl.title = cell.xxpinggu.text;
        if (_navctrl)
        {
            [_navctrl pushViewController:_xiangqingctrl animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:_xiangqingctrl animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _headinfo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString* reuseID = @"hxqlv1cell";
    
    HuijiaxiangqingCell *cell = (HuijiaxiangqingCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        HuijiaxiangqingCellViewController* temporaryController = [[HuijiaxiangqingCellViewController alloc] initWithNibName:@"HuijiaxiangqingCellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (HuijiaxiangqingCell *)temporaryController.view;
        [temporaryController release];
    }
    
    
    return cell;
}

@end
