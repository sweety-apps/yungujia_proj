//
//  GeyinhangkedaieViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GeyinhangkedaieViewController.h"

@interface GeyinhangkedaieViewController ()

@end

@implementation GeyinhangkedaieViewController

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;

@synthesize headinfo = _headinfo;
@synthesize kdectrl = _kdectrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _headinfo = @"万科金色家园XX栋XX层XXX";
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
    GeyinhangkedaieCell *cell = (GeyinhangkedaieCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        _kdectrl.title = @"中行可贷额查询";
        [self.navigationController pushViewController:_kdectrl animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _headinfo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString* reuseID = @"GeyinhangkedaieCell";
    
    GeyinhangkedaieCell *cell = (GeyinhangkedaieCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        GeyinhangkedaieCellViewController* temporaryController = [[GeyinhangkedaieCellViewController alloc] initWithNibName:@"GeyinhangkedaieCellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (GeyinhangkedaieCell *)temporaryController.view;
        [temporaryController release];
    }
    
    //cell.xxhao.text = [NSString stringWithFormat:@"50%d",row + 1];
    //cell.xxhuayuan.text = @"万科金色家园";
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
