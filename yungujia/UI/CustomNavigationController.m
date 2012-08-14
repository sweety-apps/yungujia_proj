//
//  CustomNavigationController.m
//  yungujia
//
//  Created by lijinxin on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

@synthesize backItemText = _backItemText;
@synthesize backButton = _backButton;

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)popSelf
{
    [self popViewControllerAnimated:YES];
}

- (void)customBackBtn:(UIViewController *)viewController lastViewController:(UIViewController *)lastCtrl
{
    UINavigationItem* bi = viewController.navigationItem;
    
    UIImage* originalImage = [UIImage imageNamed:@"returnBtn_normal"];
    UIImage* btnImage;
    if ([originalImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        //这个裁减范围和传入的图片有关。
        btnImage = [originalImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 24, 0, 16)];
    }
    else {
        btnImage = [originalImage stretchableImageWithLeftCapWidth:33 topCapHeight:15];
    }

//    UIImage* btnImage = [UIImage imageNamed:@"returnBtn_normal"];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, btnImage.size.width, btnImage.size.height);
    
    CGRect lbl_rct = btn.frame;
    lbl_rct.origin.x += 5;
    lbl_rct.size.width -= 5;
    UILabel* lbl = [[[UILabel alloc] initWithFrame:lbl_rct] autorelease];
    if (lastCtrl == nil || lastCtrl.title == nil || [lastCtrl.title length] == 0)
    {
        lbl.text = @"返回";
        [btn setTitle:@"返回" forState:UIControlStateNormal];
    }
    else
    {
        lbl.text = lastCtrl.title;
        [btn setTitle:[lastCtrl.title substringToIndex:4] forState:UIControlStateNormal];
    }
    
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    btn.titleLabel.textAlignment = UITextAlignmentCenter;
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.titleLabel.shadowOffset = CGSizeMake(1, 1);
    btn.titleLabel.shadowColor = [UIColor colorWithWhite:0.f alpha:0.7];
    btn.titleLabel.backgroundColor = [UIColor clearColor];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    CGSize labelSize = [btn.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:13]];
    btn.frame = CGRectMake(0, 0, labelSize.width+16, btnImage.size.height);
    //lbl.shadowColor = [UI]
    
    UIBarButtonItem* bbi = [[[UIBarButtonItem alloc] initWithCustomView:btn]autorelease];
    //bi.backBarButtonItem = bbi;
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"returnBtn_pushed"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
//    [btn addSubview:lbl];
    if (lastCtrl != nil)
    {
        bi.leftBarButtonItem = bbi;
    }
    
    self.backItemText = lbl;
    self.backButton = btn;
    
}

- (void)customRightBtn:(UIViewController *)viewController
{
    NSLog(@"%@",viewController.navigationItem.rightBarButtonItem.title);
    if (viewController != nil && viewController.navigationItem.rightBarButtonItem.title != nil && [viewController.navigationItem.rightBarButtonItem.title length] != 0)
    {
        UINavigationItem* bi = viewController.navigationItem;
        
        UIImage* btnImage = [UIImage imageNamed:@"topBtn_normal"];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, btnImage.size.width, btnImage.size.height);
        
        CGRect lbl_rct = btn.frame;
        lbl_rct.origin.x += 5;
        lbl_rct.size.width -= 5;
        UILabel* lbl = [[[UILabel alloc] initWithFrame:lbl_rct] autorelease];

        lbl.text = viewController.navigationItem.rightBarButtonItem.title;
        lbl.font = [UIFont boldSystemFontOfSize:13];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.textColor = [UIColor whiteColor];
        lbl.shadowOffset = CGSizeMake(1, 1);
        lbl.shadowColor = [UIColor colorWithWhite:0.f alpha:0.7];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.adjustsFontSizeToFitWidth = YES;
        UIBarButtonItem* bbi = [[[UIBarButtonItem alloc] initWithCustomView:btn]autorelease];
        bi.rightBarButtonItem = bbi;
        [btn setImage:btnImage forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"topBtn_pushed"] forState:UIControlStateHighlighted];
        [btn addTarget:viewController action:@selector(rightclick) forControlEvents:UIControlEventTouchUpInside];
        [btn addSubview:lbl];
        
        self.backItemText = lbl;
        self.backButton = btn;
    }
    

    

}

#pragma mark - UINavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController* lastCtrl = [super topViewController];
    [super pushViewController:viewController animated:animated];
    [self customBackBtn:viewController lastViewController:lastCtrl];
    [self customRightBtn:viewController];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController* ret = [super popViewControllerAnimated:animated];
    return ret;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray* ret = [super popToViewController:viewController animated:animated];
    return ret;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray* ret = [super popToRootViewControllerAnimated:animated];
    return ret;
}

@end
