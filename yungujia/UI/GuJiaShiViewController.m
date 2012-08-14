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
@synthesize btnpinggujigou = _btnpinggujigou;

@synthesize navctrl = _navctrl;
@synthesize gujiashihuijiactrl = _gujiashihuijiactrl;
@synthesize pinggujigouctrl = _pinggujigouctrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"估价师";
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
    if ([sender isEqual:self.btngujiashi] )
    {
        [self PushSegement0:nil];
    }
    else if([sender isEqual:self.btnpinggujigou])
    {
        [self PushSegement1:nil];
    }
}

- (IBAction)PushSegement0:(id)sender
{
    self.btngujiashi.selected = true;
    self.btnpinggujigou.selected = false;
    if (_gujiashihuijiactrl == nil)
    {
        self.gujiashihuijiactrl = [[GujiashihuijiaViewController alloc]initWithNibName:@"GujiashihuijiaViewController" bundle:nil];
    }
    [_gujiashihuijiactrl.view removeFromSuperview];
    _gujiashihuijiactrl.navctrl = _navctrl;
    [_navctrl.topViewController.view addSubview:_gujiashihuijiactrl.view]; 
    //[_navctrl pushViewController:self.sousuoloupanctrl animated:NO];
}

- (IBAction)PushSegement1:(id)sender
{
    self.btngujiashi.selected = false;
    self.btnpinggujigou.selected = true;
    if (_pinggujigouctrl == nil)
    {
        self.pinggujigouctrl = [[PinggujigouViewController alloc]initWithNibName:@"PinggujigouViewController" bundle:nil];
    }
    [_pinggujigouctrl.view removeFromSuperview];
    _pinggujigouctrl.navctrl = _navctrl;
    [_navctrl.topViewController.view addSubview:_pinggujigouctrl.view]; 
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
