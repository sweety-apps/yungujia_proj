//
//  PinggujigouViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GuJiaShiViewController.h"
#import "PinggujigouViewController.h"
#import "AppDelegate.h"

@interface PinggujigouViewController ()

@end

@implementation PinggujigouViewController

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
    Pinggujigoulv1Cell *cell = (Pinggujigoulv1Cell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        _xiangqingctrl.title = cell.xxpinggu.text;
        [[AppDelegate sharedInstance] makeTabBarHidden:YES];
        [_navctrl setDelegate:self];
        [_navctrl pushViewController:_xiangqingctrl animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString* reuseID = @"pgjglv1cell";
    
    Pinggujigoulv1Cell *cell = (Pinggujigoulv1Cell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        PinggujigouLV1CellViewController* temporaryController = [[PinggujigouLV1CellViewController alloc] initWithNibName:@"PinggujigouLV1CellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (Pinggujigoulv1Cell *)temporaryController.view;
        [temporaryController release];
    }
    
    if (row%2 == 0)
    {
        cell.xxpinggu.text = @"世联评估";
        //cell.xxpinggu.textColor = [UIColor blueColor];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.xxpinggu.text = @"同志城";
        //cell.xxpinggu.textColor = [UIColor darkGrayColor];
        //cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![viewController isKindOfClass:[PinggujigouxiangqingViewController class]])
    {
        [[AppDelegate sharedInstance] makeTabBarHidden:NO];
    }
}

@end
