//
//  GeyinhangkedaieViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GeyinhangkedaieViewController.h"
#import "AppDelegate.h"

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
    UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc] init];
    rightbtn.title = @"声明";
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];

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

-(void)rightclick
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"本软件中所涉及“银行可贷额”的数据由系统通过公式计算自动生成，并非出自银行口径或承诺，请谨慎参考。 \r\r\n云估价根据国家金融政策以及各商业银行业务模式变动，及时更新计算公式，以达到相对准确的参考价值。" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//    for (int i =0; i<[[actionSheet subviews] count]; i++) {
//        UIView* view = [[actionSheet subviews] objectAtIndex:i];
//        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+30, view.frame.size.width, view.frame.size.height);
//    }
    
//    UILabel* lbltitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
//    lbltitle.text = @"关于“银行可贷额”的声明";
//    lbltitle.font = [UIFont boldSystemFontOfSize:15];
//    lbltitle.textAlignment = UITextAlignmentCenter;
//    lbltitle.backgroundColor = [UIColor clearColor];
//    lbltitle.textColor = [UIColor whiteColor];
//    [actionSheet addSubview:lbltitle];
//    [lbltitle release];
    
    ((UILabel*)[actionSheet.subviews objectAtIndex:0]).textAlignment = UITextAlignmentLeft;
    ((UILabel*)[actionSheet.subviews objectAtIndex:0]).textColor = [UIColor whiteColor];
	
    if(actionSheet!=nil)
	{
		[actionSheet addButtonWithTitle:@"确定"];		
        actionSheet.cancelButtonIndex = 0;
		
		[actionSheet showInView:((AppDelegate*)[[UIApplication sharedApplication] delegate]).rootTabBarController.view];
		[actionSheet release];
	}
    
}
@end
