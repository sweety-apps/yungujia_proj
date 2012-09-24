//
//  YuegongViewController.m
//  yungujia
//
//  Created by lijinxin on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YuegongViewController.h"

@interface YuegongViewController ()

@end

@implementation YuegongViewController

@synthesize tableView = _tableView;

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
    
    _rowCount = 21;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (row != _rowCount - 1)
    {
        NSString* reuseID = @"YuegongCell";
        YuegongCell *cell = (YuegongCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
        if (cell == nil)
        {
            // Create a temporary UIViewController to instantiate the custom cell.
            YuegongCellViewController* temporaryController = [[YuegongCellViewController alloc] initWithNibName:@"YuegongCellViewController" bundle:nil];
            // Grab a pointer to the custom cell.
            cell = (YuegongCell *)temporaryController.view;
            [temporaryController release];
        }
        
        cell.dixxqi.text = [NSString stringWithFormat:@"第%d期",row + 1];
        
        return cell;
    }
    else
    {
        NSString* reuseID = @"YuegongGengduoCell";
        YuegongGengduoCell *cell = (YuegongGengduoCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
        if (cell == nil)
        {
            // Create a temporary UIViewController to instantiate the custom cell.
            YuegongGengduoCellViewController* temporaryController = [[YuegongGengduoCellViewController alloc] initWithNibName:@"YuegongGengduoCellViewController" bundle:nil];
            // Grab a pointer to the custom cell.
            cell = (YuegongGengduoCell *)temporaryController.view;
            cell.active.hidden = YES;
            [temporaryController release];
        }
        
        _gengduoCell = cell;
        
        return cell;
    }
    
    return nil;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (row == _rowCount - 1)
    {
        [self startNewData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (row == _rowCount - 1)
    {
        return 72.;
    }
    
    return 44.f;
}

#pragma mark - Load New Data

- (void)startNewData
{
    _gengduoCell.title.text = @"正在获取";
    _gengduoCell.active.hidden = NO;
    [_gengduoCell.active startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(finishedNewData) userInfo:nil repeats:NO];
}

- (void)finishedNewData
{
    _gengduoCell.title.text = @"获取更多……";
    _gengduoCell.active.hidden = YES;
    [_gengduoCell.active stopAnimating];
    _rowCount += 20;
    [_tableView reloadData];
}

@end
