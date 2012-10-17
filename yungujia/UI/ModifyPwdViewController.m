//
//  ModifyPwdViewController.m
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModifyPwdViewController.h"

@interface ModifyPwdViewController ()

@end

@implementation ModifyPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"修改密码";
        UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc] init];
        rightbtn.title = @"确定";
        self.navigationItem.rightBarButtonItem = rightbtn;
        [rightbtn release];
        
        _arraykeys = [[NSMutableArray alloc] initWithObjects:@"旧密码:",@"新密码:",@"重复新密码:", nil];
        _arrayPlaceHolder = [[NSMutableArray alloc] initWithObjects:@"请输入正在使用的密码",@"请输入新密码",@"请重复输入新密码", nil];
        
    }
    return self;
}

-(void)rightclick
{
    NSLog(@"onClickOK");
    [(UINavigationController*)self.parentViewController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [_arraykeys release];
    [_arrayPlaceHolder release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString* dequeueIdentifer = @"cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] init]autorelease];
            cell.textLabel.text = [_arraykeys objectAtIndex:indexPath.row];
            UITextField* edittext = [[UITextField alloc] initWithFrame:CGRectMake(115, 20, 190, 24)];
            edittext.placeholder = [_arrayPlaceHolder objectAtIndex:indexPath.row];
            edittext.delegate = self;
//            [edittext setBackgroundColor:[UIColor redColor]];
            [cell addSubview:edittext];
            [edittext release];
        }
        else {
            
        }
        return cell;
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}
@end
