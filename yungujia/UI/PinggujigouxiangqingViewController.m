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

@synthesize contentView = _contentView;

@synthesize logo = _logo;
@synthesize xiangqing = _xiangqing;

@synthesize navctrl = _navctrl;
@synthesize yinhangctrl = _yinhangctrl;
@synthesize jianjiectrl = _jianjiectrl;
@synthesize yhkdectrl = _yhkdectrl;

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
    self.jianjiectrl = [[PinggujigoujianjieViewController alloc] initWithNibName:@"PinggujigoujianjieViewController" bundle:nil];
    self.yhkdectrl = [[YinhangkedaichaxunViewController alloc] initWithNibName:@"YinhangkedaichaxunViewController" bundle:nil];
    
    ((UIScrollView*)(self.view)).contentSize = _contentView.frame.size;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.yinhangctrl = nil;
    self.jianjiectrl = nil;
    self.yhkdectrl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PinggujigouyinhangCell *cell = (PinggujigouyinhangCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (tableView.tag == 0)
    {
        if (indexPath.row == 3)
        {
            _yhkdectrl.title = @"银行可贷额查询";
            [self.navigationController pushViewController:_yhkdectrl animated:YES];
        }
    }
    else if (tableView.tag == 1)
    {
        if (indexPath.row == 1)
        {
            _yinhangctrl.title = @"入围银行";
            [self.navigationController pushViewController:_yinhangctrl animated:YES];
        }
        else if (indexPath.row == 2)
        {
            _jianjiectrl.title = @"评估机构简介";
            [self.navigationController pushViewController:_jianjiectrl animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0)
    {
        return 4;
    }
    else if (tableView.tag == 1)
    {
        return 3;
    }
    return 0;
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
    
    if (tableView.tag == 0)
    {
        if (row == 0)
        {
            cell.left.text = @"评估物业";
            cell.right.text = @"万科东海岸3期4栋12层405室";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        else if(row == 1)
        {
            cell.left.text = @"单位估价";
            cell.right.text = @"20034元";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if(row == 2)
        {
            cell.left.text = @"评估总价";
            cell.right.text = @"23万";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if(row == 3)
        {
            cell.left.text = @"银行可贷额查询";
            cell.right.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (tableView.tag == 1)
    {
        if (row == 0)
        {
            cell.left.text = @"机构资质";
            cell.right.text = @"国家土地一级,房地产一级";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        else if(row == 1)
        {
            cell.left.text = @"入围银行";
            cell.right.text = @"24家";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(row == 2)
        {
            cell.left.text = @"简介与联系方式";
            cell.right.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

@end

