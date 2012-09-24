//
//  PinggujigouyinhangViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PinggujigouyinhangViewController.h"

@interface PinggujigouyinhangViewController ()

@end

@implementation PinggujigouyinhangViewController

@synthesize navctrl = _navctrl;
@synthesize lv2ctrl = _lv2ctrl;

@synthesize yinhang = _yinhang;
@synthesize kehujingli = _kehujingli;

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
    //self.yinhangctrl = [[PinggujigouyinhangViewController alloc] initWithNibName:@"PinggujigouyinhangViewController" bundle:nil];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
    self.lv2ctrl = [[[PinggujigouyinhangLV2ViewController alloc] initWithNibName:@"PinggujigouyinhangLV2ViewController" bundle:nil] autorelease];
    self.yinhang = [NSMutableArray arrayWithObjects:@"中国银行",@"农业银行",@"工商银行",@"建设银行",nil];
    self.kehujingli = [NSMutableArray arrayWithObjects:@"3位客户经理",@"4位客户经理",@"3位客户经理",@"2位客户经理",nil];
}

- (void)viewDidUnload
{
    //[self.yinhangctrl release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.lv2ctrl = nil;
    self.yinhang = nil;
    self.kehujingli = nil;
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
        _lv2ctrl.title = [_yinhang objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:_lv2ctrl animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_yinhang count];
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
    
    cell.left.text = [_yinhang objectAtIndex:row];
    cell.right.text = [_kehujingli objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

@end