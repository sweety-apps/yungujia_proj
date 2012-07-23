//
//  PinggujigouxiangqingViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PinggujigouxiangqingViewController.h"

@interface PinggujigouxiangqingViewController ()

@end

@implementation PinggujigouxiangqingViewController

@synthesize logo = _logo;
@synthesize xiangqing = _xiangqing;

@synthesize navctrl = _navctrl;
@synthesize yinhangctrl = _yinhangctrl;

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
    self.yinhangctrl = [[PinggujigouyinhangViewController alloc] initWithNibName:@"PinggujigouyinhangViewController" bundle:nil];
}

- (void)viewDidUnload
{
    [self.yinhangctrl release];
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
    PinggujigouyinhangCell *cell = (PinggujigouyinhangCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        _yinhangctrl.title = @"入围银行";
        [self.navigationController pushViewController:_yinhangctrl animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString* reuseID = @"pgjgyhcell";
    
    PinggujigouyinhangCell *cell = (PinggujigouyinhangCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        PinggujigouyinhangCellViewController* temporaryController = [[PinggujigouyinhangCellViewController alloc] initWithNibName:@"PinggujigouyinhangCellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (PinggujigouyinhangCell *)temporaryController.view;
        [temporaryController release];
    }
    
    if (row == 0)
    {
        cell.left.text = @"机构资质";
        cell.right.text = @"国家土地一级,房地产一级";
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    else
    {
        cell.left.text = @"入围银行";
        cell.right.text = @"24家";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

@end

