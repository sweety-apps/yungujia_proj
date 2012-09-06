//
//  ZidonggujiaViewController.m
//  yungujia
//
//  Created by Lee Justin on 12-9-6.
//
//

#import "ZidonggujiaViewController.h"

@interface ZidonggujiaViewController ()

@end

@implementation ZidonggujiaViewController

@synthesize headinfo = _headinfo;

@synthesize navctrl = _navctrl;
@synthesize xjjgctrl = _xjjgctrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"自动估价";
        _headinfo = @"共询223次";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.xjjgctrl = [[XunjiajieguoViewController alloc] initWithNibName:@"XunjiajieguoViewController" bundle:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.xjjgctrl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZidonggujiaCell *cell = (ZidonggujiaCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        //[(AppDelegate*)[UIApplication sharedApplication].delegate makeTabBarHidden:YES];
        _xjjgctrl.title = @"询价结果";
        _xjjgctrl.hidesBottomBarWhenPushed = YES;
        _xjjgctrl.navctrl = _navctrl;
        [_navctrl pushViewController:_xjjgctrl animated:YES];
        //[_loudongctrl customBackBtn];
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _headinfo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    static NSString* reuseID = @"ZidonggujiaCell";
    
    ZidonggujiaCell *cell = (ZidonggujiaCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        // Create a temporary UIViewController to instantiate the custom cell.
        ZidonggujiaCellViewController* temporaryController = [[ZidonggujiaCellViewController alloc] initWithNibName:@"ZidonggujiaCellViewController" bundle:nil];
        // Grab a pointer to the custom cell.
        cell = (ZidonggujiaCell *)temporaryController.view;
        [temporaryController release];
    }
    
    
    //cell.xxhuayuan.text = @"万科金色家园";
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


@end
