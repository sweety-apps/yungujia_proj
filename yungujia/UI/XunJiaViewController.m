//
//  XunJiaViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XunJiaViewController.h"

@interface XunJiaViewController ()

@end

@implementation XunJiaViewController
@synthesize navbar = _navbar;
@synthesize segment = _segment;


@synthesize navctrl = _navctrl;
@synthesize sousuoloupanctrl = _sousuoloupanctrl;
@synthesize fujinloupanctrl = _fujinloupanctrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"询价";
        //self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:_navctrl.view];
    [self PushSegement0:nil];
    
    UIImage* navBgImg = [UIImage imageNamed:@"tabbarBg.png"];
    navBgImg = [navBgImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [Utils setAtNavigationBar:self.navbar withBgImage:navBgImg];
}

- (IBAction)SelectedSegement:(id)sender
{
    if (self.segment.selectedSegmentIndex == 0)
    {
        [self PushSegement0:nil];
    }
    else if(self.segment.selectedSegmentIndex == 1)
    {
        [self PushSegement1:nil];
    }
}

- (IBAction)PushSegement0:(id)sender
{
    self.segment.selectedSegmentIndex = 0;
    if (_sousuoloupanctrl == nil)
    {
        self.sousuoloupanctrl = [[SousuoloupanViewController alloc]initWithNibName:@"SousuoloupanViewController" bundle:nil];
    }
    [_sousuoloupanctrl.view removeFromSuperview];
    [_navctrl.topViewController.view addSubview:_sousuoloupanctrl.view]; 
    _sousuoloupanctrl.navctrl = _navctrl;
    _sousuoloupanctrl.navbar = _navbar;
    _sousuoloupanctrl.loupanctrl.navctrl = _navctrl;
    _sousuoloupanctrl.loupanctrl.navbar = _navbar;
    //[_navctrl pushViewController:self.sousuoloupanctrl animated:NO];
}

- (IBAction)PushSegement1:(id)sender
{
    self.segment.selectedSegmentIndex = 1;
    if (_fujinloupanctrl == nil)
    {
        self.fujinloupanctrl = [[FunjinloupanViewController alloc]initWithNibName:@"FunjinloupanViewController" bundle:nil];
    }
    [_fujinloupanctrl.view removeFromSuperview];
    [_navctrl.topViewController.view addSubview:_fujinloupanctrl.view]; 
    _fujinloupanctrl.navctrl = _navctrl;
    _fujinloupanctrl.navbar = _navbar;
    _fujinloupanctrl.loupanctrl.navctrl = _navctrl;
    _fujinloupanctrl.loupanctrl.navbar = _navbar;
}

- (void)viewDidUnload
{
    [_navbar removeFromSuperview];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
