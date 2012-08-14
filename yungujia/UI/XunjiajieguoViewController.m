//
//  XunjiajieguoViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XunjiajieguoViewController.h"
#import "PinggujigouViewController.h"

@interface XunjiajieguoViewController ()

@end

@implementation XunjiajieguoViewController

@synthesize contentView = _contentView;

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;


@synthesize rengongctrl = _rengongctrl;
@synthesize yinhangctrl = _yinhangctrl;

@synthesize btnRngong = _btnRngong;
@synthesize btnKde = _btnKde;
@synthesize btnShilian = _btnShilian;
@synthesize btnDuanxin = _btnDuanxin;

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
    
    btn_img = [UIImage imageNamed:@"btnGray"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btnRngong setBackgroundImage:btn_img forState:UIControlStateNormal];
    
    btn_img = [UIImage imageNamed:@"buttonn"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btnKde setBackgroundImage:btn_img forState:UIControlStateNormal];
    
    btn_img = [UIImage imageNamed:@"btnGray"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btnDuanxin setBackgroundImage:btn_img forState:UIControlStateNormal];
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
    PinggujigouxiangqingViewController* controller = [[PinggujigouxiangqingViewController alloc] initWithNibName:@"PinggujigouxiangqingViewController" bundle:nil];
    controller.title = @"评估机构";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
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
