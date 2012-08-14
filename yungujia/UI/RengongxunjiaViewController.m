//
//  RengongxunjiaViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RengongxunjiaViewController.h"
#import "PinggujigouViewController.h"
#import "YinhangkedaichaxunViewController.h"
@interface RengongxunjiaViewController ()

@end

@implementation RengongxunjiaViewController

@synthesize contentView = _contentView;
@synthesize btn = _btn;
@synthesize btnPinggujigou = _btnPinggujigou;

@synthesize chakanpinggujigou = _chakanpinggujigou;
@synthesize chakanCell = _chakanCell;
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
    
    UIImage* btn_img = nil;
    
    btn_img = [UIImage imageNamed:@"buttonn"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btn setBackgroundImage:btn_img forState:UIControlStateNormal];
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

-(void)moveviewsup:(int)distance
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    for (int i = 0; i<[self.view.subviews count]; i++) {
        UIView* view = [self.view.subviews objectAtIndex:i];
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + distance, view.frame.size.width, view.frame.size.height);
    }
    [UIView commitAnimations];
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    [self moveviewsup:-100];
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    [self moveviewsup:100];
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    //    self.view.center=CGPointMake(160,208); 
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryNone)
    {
        //[self.navigationController pushViewController:_kaishixunjiactrl animated:YES];
        PinggujigouViewController* controller = [[PinggujigouViewController alloc] initWithNibName:@"PinggujigouViewController" bundle:nil];
        controller.title = @"评估机构";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

-(IBAction)rengongxunjia:(id)sender
{
    YinhangkedaichaxunViewController* controller = [[YinhangkedaichaxunViewController alloc] initWithNibName:@"YinhangkedaichaxunViewController" bundle:nil];
    controller.title = @"银行可贷金额查询";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.chakanCell;
}

@end
