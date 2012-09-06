//
//  PinggujigouyinhangLV2ViewController.m
//  yungujia
//
//  Created by lijinxin on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PinggujigouyinhangLV2ViewController.h"

@interface PinggujigouyinhangLV2ViewController ()

@end

@implementation PinggujigouyinhangLV2ViewController

@synthesize navctrl = _navctrl;

@synthesize name = _name;
@synthesize dianhua = _dianhua;

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
    self.name = [NSMutableArray arrayWithObjects:@"张先勇",@"刘明则",@"李丽",@"金科",nil];
    self.dianhua = [NSMutableArray arrayWithObjects:@"13902332194(福田支行)",@"13902332194(龙岗支行)",@"13902332194(南山支行)",@"13902332194(福田支行)",nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.name = nil;
    self.dianhua = nil;
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
        //_yinhangctrl.title = @"入围银行";
        //[self.navigationController pushViewController:_yinhangctrl animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_name count];
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
    
    cell.left.text = [_name objectAtIndex:row];
    cell.right.text = [_dianhua objectAtIndex:row];
    cell.right.adjustsFontSizeToFitWidth = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

@end
