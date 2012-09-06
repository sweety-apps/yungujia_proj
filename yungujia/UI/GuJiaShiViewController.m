//
//  GuJiaShiViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GuJiaShiViewController.h"

@interface GuJiaShiViewController ()

@end

@implementation GuJiaShiViewController

@synthesize navbar = _navbar;
@synthesize btngujiashi = _btngujiashi;
@synthesize btnzidonggujia = _btnzidonggujia;

@synthesize navctrl = _navctrl;
@synthesize gujiashihuijiactrl = _gujiashihuijiactrl;
@synthesize zidonggujictrl = _zidonggujictrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"询价纪录";
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
    
    UIImage* navBgImg = [UIImage imageNamed:@"naviBarBg.png"];
    navBgImg = [navBgImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [Utils setAtNavigationBar:self.navbar withBgImage:navBgImg];
}

- (IBAction)SelectedSegement:(id)sender
{
    if([sender isEqual:self.btnzidonggujia])
    {
        [self PushSegement0:nil];
    }
    else if ([sender isEqual:self.btngujiashi] )
    {
        [self PushSegement1:nil];
    }
}

- (IBAction)PushSegement0:(id)sender
{
    self.btngujiashi.selected = NO;
    self.btnzidonggujia.selected = YES;
    if (_zidonggujictrl == nil)
    {
        self.zidonggujictrl = [[ZidonggujiaViewController alloc]initWithNibName:@"ZidonggujiaViewController" bundle:nil];
    }
    [_zidonggujictrl.view removeFromSuperview];
    _zidonggujictrl.navctrl = _navctrl;
    [_navctrl.topViewController.view addSubview:_zidonggujictrl.view];
}

- (IBAction)PushSegement1:(id)sender
{
    self.btngujiashi.selected = YES;
    self.btnzidonggujia.selected = NO;
    if (_gujiashihuijiactrl == nil)
    {
        self.gujiashihuijiactrl = [[GujiashihuijiaViewController alloc]initWithNibName:@"GujiashihuijiaViewController" bundle:nil];
    }
    [_gujiashihuijiactrl.view removeFromSuperview];
    _gujiashihuijiactrl.navctrl = _navctrl;
    [_navctrl.topViewController.view addSubview:_gujiashihuijiactrl.view]; 
    //[_navctrl pushViewController:self.sousuoloupanctrl animated:NO];
}



- (void)viewDidUnload
{
    [_navctrl.view removeFromSuperview];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
