//
//  LoucengTableViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoucengTableViewController.h"
#import "Utils.h"

@interface LoucengTableViewController ()

@end

@implementation LoucengTableViewController

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;

@synthesize headinfo = _headinfo;
@synthesize fanghaoctrl = _fanghaoctrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"选择楼层";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _fanghaoctrl.kaishixunjiactrl.loucengCtrl = self;
    lcctrl = self;
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
    LoucengCell *cell = (LoucengCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        _fanghaoctrl.title = @"选择房号";
        _fanghaoctrl.headinfo = [NSString stringWithFormat:@"%@>%@",_headinfo,cell.xxceng.text];
        [self.navigationController pushViewController:_fanghaoctrl animated:YES];
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
    
    static NSString* reuseID = @"LoucengCell";
    
    LoucengCell *cell = (LoucengCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        LoucengCellViewController* temporaryController = [[LoucengCellViewController alloc] initWithNibName:@"LoucengCellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (LoucengCell *)temporaryController.view;
        [temporaryController release];
    }
    
    cell.xxceng.text = [NSString stringWithFormat:@"%d层",row + 1];
    //cell.xxhuayuan.text = @"万科金色家园";
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


@end
