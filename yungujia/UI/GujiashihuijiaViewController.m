//
//  GujiashihuijiaViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GujiashihuijiaViewController.h"

@interface GujiashihuijiaViewController ()

@end

@implementation GujiashihuijiaViewController

@synthesize xiangqingctrl = _xiangqingctrl;
@synthesize navctrl = _navctrl;

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
    self.xiangqingctrl = [[HuijiaxiangqingViewController alloc] initWithNibName:@"HuijiaxiangqingViewController" bundle:nil];
}

- (void)viewDidUnload
{
    [self.xiangqingctrl release];
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
    HuijiaLV1Cell *cell = (HuijiaLV1Cell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        _xiangqingctrl.title = [NSString stringWithFormat:@"回价详情 (%d)",12];
        _xiangqingctrl.headinfo = [NSString stringWithFormat:@"%@%@",cell.xxhuayuan.text,cell.xdongxcengxxx.text];
        [_navctrl pushViewController:_xiangqingctrl animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString* reuseID = @"hlv1cell";
    
    HuijiaLV1Cell *cell = (HuijiaLV1Cell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        HuijiaLV1CellViewController* temporaryController = [[HuijiaLV1CellViewController alloc] initWithNibName:@"HuijiaLV1CellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (HuijiaLV1Cell *)temporaryController.view;
        [temporaryController release];
    }
    
    if (row%2 == 0)
    {
        cell.result.text = @"6人回价";
        cell.result.textColor = [UIColor blueColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.result.text = @"等待回价";
        cell.result.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

@end
