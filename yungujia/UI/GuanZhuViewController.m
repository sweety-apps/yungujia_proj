//
//  GuanZhuViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GuanZhuViewController.h"

@interface GuanZhuViewController ()

@end

@implementation GuanZhuViewController

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关注";
        //self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:_navctrl.view];
    _navctrl.topViewController.title = @"关注";
}

- (void)viewDidUnload
{
    [_navctrl.view removeFromSuperview];
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
    GuanzhuLV1Cell *cell = (GuanzhuLV1Cell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        //[_navctrl pushViewController:_xiangqingctrl animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"您关注了%d个房子",12];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString* reuseID = @"gzlv1cell";
    
    GuanzhuLV1Cell *cell = (GuanzhuLV1Cell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        GuanzhuLV1CellViewController* temporaryController = [[GuanzhuLV1CellViewController alloc] initWithNibName:@"GuanzhuLV1CellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (GuanzhuLV1Cell *)temporaryController.view;
        [temporaryController release];
    }
    
    
    cell.xxhuayuan.text = @"万科金色家园";
    cell.xxdongxxcengxx.text = @"5层6栋605";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//swap to delete

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete) {  
        NSLog(@"Deleted row %d",  row);  
        
        /* 添上代码,将单元格从你的数据中删除 */  
        
        /* 从表格中删除单元格 */  
        
        /*NSMutableArray *array = [ [ NSMutableArray alloc ] init ];  
        [ array addObject: indexPath ];  
        [ self.tableView deleteRowsAtIndexPaths: array  
                               withRowAnimation: UITableViewRowAnimationFade  
         ];*/  
    } 
}

@end
