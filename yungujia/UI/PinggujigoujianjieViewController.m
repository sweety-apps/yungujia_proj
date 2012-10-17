//
//  PinggujigoujianjieViewController.m
//  yungujia
//
//  Created by Lee Justin on 12-9-6.
//
//

#import "PinggujigoujianjieViewController.h"

@interface PinggujigoujianjieViewController ()

@end

@implementation PinggujigoujianjieViewController

@synthesize contentView = _contentView;

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
    
    ((UIScrollView*)(self.view)).contentSize = _contentView.frame.size;
    
    [self.view setBackgroundColor:[UIColor clearColor]];
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
    PinggujigouyinhangCell *cell = (PinggujigouyinhangCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        //_yinhangctrl.title = @"入围银行";
        //[self.navigationController pushViewController:_yinhangctrl animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if(indexPath.row == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cell.right.text]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    
    switch (row)
    {
        case 0:
            cell.left.text = @"公司电话";
            cell.right.text = @"0755-23344323";
            break;
        case 1:
            cell.left.text = @"网站";
            cell.right.text = @"http://www.yungujia.com";
            break;
        case 2:
            cell.left.text = @"地址";
            cell.right.text = @"深圳市福田区上沙创新科技园1栋304";
            break;
        default:
            break;
    }
    
    cell.right.numberOfLines = 0;
    cell.right.adjustsFontSizeToFitWidth = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    return cell;
}

@end
