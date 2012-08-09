//
//  RengongxunjiaViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RengongxunjiaViewController.h"

@interface RengongxunjiaViewController ()

@end

@implementation RengongxunjiaViewController

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

@end
