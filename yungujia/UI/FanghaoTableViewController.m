//
//  FanghaoTableViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FanghaoTableViewController.h"
#import "Utils.h"

@interface FanghaoTableViewController ()

@end

@implementation FanghaoTableViewController

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;

@synthesize headinfo = _headinfo;
@synthesize kaishixunjiactrl = _kaishixunjiactrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"选择房号";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _kaishixunjiactrl.fanghaoCtrl = self;
    fhctrl = self;
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
    FanghaoCell *cell = (FanghaoCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        _kaishixunjiactrl.title = @"开始询价";
        _kaishixunjiactrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:_kaishixunjiactrl animated:YES];
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
    
    static NSString* reuseID = @"FanghaoCell";
    
    FanghaoCell *cell = (FanghaoCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        FanghaoCellViewController* temporaryController = [[FanghaoCellViewController alloc] initWithNibName:@"FanghaoCellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (FanghaoCell *)temporaryController.view;
        [temporaryController release];
    }
    
    cell.xxhao.text = [NSString stringWithFormat:@"50%d",row + 1];
    //cell.xxhuayuan.text = @"万科金色家园";
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}



@end
