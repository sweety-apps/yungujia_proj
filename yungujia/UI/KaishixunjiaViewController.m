//
//  KaishixunjiaViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KaishixunjiaViewController.h"

@interface KaishixunjiaViewController ()

@end

@implementation KaishixunjiaViewController

@synthesize contentView = _contentView;

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;

@synthesize loupan = _loupan;
@synthesize loudong = _loudong;
@synthesize louceng = _louceng;
@synthesize fanghao = _fanghao;

@synthesize jieguoctrl = _jieguoctrl;

#pragma mark - UIViewController

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

#pragma mark - KaishixunjiaViewController

- (IBAction)push_XunjiaBtn:(id)sender
{
    _jieguoctrl.title = @"询价结果";
    [self.navigationController pushViewController:_jieguoctrl animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType != UITableViewCellAccessoryNone)
        {
            //[self.navigationController pushViewController:_kaishixunjiactrl animated:YES];
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
    else
    {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (tableView.tag == 0)
    {
        NSString* reuseID = @"KaishixunjiaLoupanCell";
        
        KaishixunjiaLoupanCell *cell = (KaishixunjiaLoupanCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
        if (cell == nil)
        {
            // Create a temporary UIViewController to instantiate the custom cell.
            KaishixunjiaLoupanCellViewController* temporaryController = [[KaishixunjiaLoupanCellViewController alloc] initWithNibName:@"KaishixunjiaLoupanCellViewController" bundle:nil];
            // Grab a pointer to the custom cell.
            cell = (KaishixunjiaLoupanCell *)temporaryController.view;
            [temporaryController release];
        }
        return cell;
    }
    else
    {
        NSString* reuseID = @"KaishixunjiaCell1Cell";
        
        KaishixunjiaCell1Cell *cell = (KaishixunjiaCell1Cell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
        if (cell == nil)
        {
            // Create a temporary UIViewController to instantiate the custom cell.
            KaishixunjiaCell1ViewController* temporaryController = [[KaishixunjiaCell1ViewController alloc] initWithNibName:@"KaishixunjiaCell1ViewController" bundle:nil];
            // Grab a pointer to the custom cell.
            cell = (KaishixunjiaCell1Cell *)temporaryController.view;
            [temporaryController release];
        }
        
        cell.detail.delegate = self;
        return cell;
    }
    
    
    
    //cell.xxhao.text = [NSString stringWithFormat:@"50%d",row + 1];
    //cell.xxhuayuan.text = @"万科金色家园";
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return nil;
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
    [self moveviewsup:-200];
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    [self moveviewsup:200];
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    //    self.view.center=CGPointMake(160,208); 
    return YES;
}

@end
