//
//  XunjiajieguoViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XunjiajieguoViewController.h"

@interface XunjiajieguoViewController ()

@end

@implementation XunjiajieguoViewController

@synthesize contentView = _contentView;

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;


@synthesize rengongctrl = _rengongctrl;
@synthesize yinhangctrl = _yinhangctrl;

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

#pragma mark - XunjiajieguoViewController

- (IBAction)push_Pinggujigou:(id)sender
{
    
}

- (IBAction)push_RengongxunjiaBtn:(id)sender
{
    _rengongctrl.title = @"人工询价";
    _rengongctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_rengongctrl animated:YES];
}

- (IBAction)push_KedaijineBtn:(id)sender
{
    _yinhangctrl.title = @"银行可贷金额查询";
    [self.navigationController pushViewController:_yinhangctrl animated:YES];
}

@end
