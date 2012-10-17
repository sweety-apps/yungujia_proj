//
//  AboutSystemViewController.m
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutSystemViewController.h"

@interface AboutSystemViewController ()

@end

@implementation AboutSystemViewController
@synthesize tableview = _tableview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于";
        
        _arrayvalues = [[NSMutableArray alloc] initWithObjects:@"1.0",@"深圳房讯通信息技术有限公司",@"http://www.yungujia.com",@"云估价专注于房地产价格数据研究与应用。目前已为众多专业房地产评估机构与商业银行提供服务。",nil];
        _arraykeys = [[NSMutableArray alloc] initWithObjects:@"版本",@"公司",@"官网",@"简介",nil];
   }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ((UIScrollView*)(self.view)).contentSize = CGSizeMake(320, 570);
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    [imgLogo setFrame:CGRectMake(70, 10, 182, 71)];
    [self.view addSubview:imgLogo];
    [imgLogo release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [_arrayvalues release];
    [_arraykeys release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        static NSString* dequeueIdentifer = @"introcellwithlogo";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            NSLog(@"%d",indexPath.row);
            cell = [[[UITableViewCell alloc] init]autorelease];
            UILabel* lblkey = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 35)];
            lblkey.text = [_arraykeys objectAtIndex:indexPath.row];
            [cell addSubview:lblkey];
            [lblkey setBackgroundColor:[UIColor clearColor]];
            lblkey.textAlignment = UITextAlignmentLeft;
            lblkey.font = [UIFont boldSystemFontOfSize:17.0];
            [lblkey release];
            
            UILabel* lblvalue = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220, 70)];
            lblvalue.text = [_arrayvalues objectAtIndex:indexPath.row];
            lblvalue.textAlignment = UITextAlignmentLeft;
            lblvalue.textColor =[UIColor colorWithRed:82.0/255.0 green:105.0/255.0 blue:155.0/255.0 alpha:1.0];
            [lblvalue setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:lblvalue];
            [lblvalue setFont:[UIFont systemFontOfSize:14]];
            lblvalue.numberOfLines = 8;
            [lblvalue release];
            
            UIImage* imagehezuologo = [UIImage imageNamed:@"hezuologo"];
            UIImageView* imageview = [[[UIImageView alloc] initWithImage:imagehezuologo] autorelease];
            [imageview setFrame:CGRectMake(80, 90, 220, 175)];
            [cell addSubview:imageview];
        }
        else {
            
        }
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
        
    }
    else
    {
        static NSString* dequeueIdentifer = @"introcell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            NSLog(@"%d",indexPath.row);
            cell = [[[UITableViewCell alloc] init]autorelease];
            UILabel* lblkey = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 35)];
            lblkey.text = [_arraykeys objectAtIndex:indexPath.row];
            [cell addSubview:lblkey];
            [lblkey setBackgroundColor:[UIColor clearColor]];
            lblkey.textAlignment = UITextAlignmentLeft;
            lblkey.font = [UIFont boldSystemFontOfSize:17.0];
            [lblkey release];
            
            UILabel* lblvalue = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220,35)];
            lblvalue.text = [_arrayvalues objectAtIndex:indexPath.row];
            lblvalue.textAlignment = UITextAlignmentRight;
            lblvalue.textColor =[UIColor colorWithRed:82.0/255.0 green:105.0/255.0 blue:155.0/255.0 alpha:1.0];
            [lblvalue setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:lblvalue];
            [lblvalue setFont:[UIFont systemFontOfSize:14]];
            lblvalue.numberOfLines = 8;
            [lblvalue release];
        }
        else {
            
        }
        [cell setBackgroundColor:[UIColor whiteColor]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 280;
    }
    else {
        return 44;
    }
}

@end
