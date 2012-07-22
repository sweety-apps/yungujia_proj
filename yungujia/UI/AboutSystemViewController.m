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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于";
        
        _arrayvalues = [[NSMutableArray alloc] initWithObjects:@"1.0",@"深圳房讯通信息技术有限公司",@"云估价专注于房地产价格数据研究与应用。目前已为众多专业房地产评估机构与商业银行提供服务。",@"http://www.yungujia.com",nil];
        _arraykeys = [[NSMutableArray alloc] initWithObjects:@"版本",@"公司",@"简介",@"官网",nil];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString* dequeueIdentifer = @"logocell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] init]autorelease];
            UIImageView* imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
            [imgLogo setFrame:CGRectMake(70, 0, 182, 71)];
            [cell addSubview:imgLogo];
            [cell setBackgroundColor:[UIColor clearColor]];
            [imgLogo release];
            
        }
        else {
            
        }
        return cell;
    }
    else {
        static NSString* dequeueIdentifer = @"introcell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            NSLog(@"%d",indexPath.row);
            cell = [[[UITableViewCell alloc] init]autorelease];
            UILabel* lblkey = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 35)];
            lblkey.text = [_arraykeys objectAtIndex:indexPath.row];
            [cell addSubview:lblkey];
//            [lblkey setBackgroundColor:[UIColor redColor]];
            lblkey.textAlignment = UITextAlignmentLeft;
            [lblkey release];
            
            UILabel* lblvalue = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220, indexPath.row == 2?129:35)];
            lblvalue.text = [_arrayvalues objectAtIndex:indexPath.row];
            lblvalue.textAlignment = UITextAlignmentRight;
            lblvalue.textColor =[UIColor blueColor];
//            [lblvalue setBackgroundColor:[UIColor blackColor]];
            [cell addSubview:lblvalue];
            [lblvalue setFont:[UIFont systemFontOfSize:14]];
            lblvalue.numberOfLines = 8;
            [lblvalue release];
        }
        else {
            
        }
        return cell;
    }
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 62;
    }
    else {
        if (indexPath.row == 2) {
            return 144;
        }
        else {
            return 44;
        }
    }
}

@end
