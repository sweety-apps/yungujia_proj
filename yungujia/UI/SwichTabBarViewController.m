//
//  SwichTabBarViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SwichTabBarViewController.h"

@interface SwichTabBarViewController ()

@end

@implementation SwichTabBarViewController


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
    
    //custom bg
    UIImage* tabBarImg = [UIImage imageNamed:@"tabbarBg"];
    _tabBarBg = [[[UIImageView alloc] initWithImage:tabBarImg] autorelease];
    CGRect rect = self.tabBar.frame;
    rect.origin.y = CGRectGetMaxY(rect) - tabBarImg.size.height;
    rect.size.height = tabBarImg.size.height;
    self.tabBar.frame = rect;
    _tabBarBg.frame = rect;
    self.tabBar.userInteractionEnabled = YES;
    [self.view addSubview:self.tabBar];
    [self.view addSubview:_tabBarBg];
    //[self.tabBar.superview bringSubviewToFront:_tabBarBg];
    
    //custom items
    CGFloat btnInterlace = _tabBarBg.frame.size.width / 4.f;
    
    CGPoint pt = CGPointMake(_tabBarBg.frame.origin.x, _tabBarBg.frame.origin.y) ;
    
    UIImage* firstImg = [UIImage imageNamed:@"xunjia_normal"];
    rect.origin = pt;
    rect.size = firstImg.size;
    UIButton* xunjia = [UIButton buttonWithType:UIButtonTypeCustom];
    [xunjia setImage:firstImg forState:UIControlStateNormal];
    [xunjia setImage:[UIImage imageNamed:@"xunjia_pushed"] forState:UIControlStateHighlighted];
    [xunjia setImage:[UIImage imageNamed:@"xunjia_actived"] forState:UIControlStateSelected];
    xunjia.frame = rect;
    
    pt.x += btnInterlace;
    rect.origin = pt;
    rect.size = firstImg.size;
    UIButton* guanzhu = [UIButton buttonWithType:UIButtonTypeCustom];
    [guanzhu setImage:[UIImage imageNamed:@"guanzhu_normal"] forState:UIControlStateNormal];
    [guanzhu setImage:[UIImage imageNamed:@"guanzhu_pushed"] forState:UIControlStateHighlighted];
    [guanzhu setImage:[UIImage imageNamed:@"guanzhu_actived"] forState:UIControlStateSelected];
    guanzhu.frame = rect;
    
    pt.x += btnInterlace;
    rect.origin = pt;
    rect.size = firstImg.size;
    UIButton* gujiashi = [UIButton buttonWithType:UIButtonTypeCustom];
    [gujiashi setImage:[UIImage imageNamed:@"gujiashi_normal"] forState:UIControlStateNormal];
    [gujiashi setImage:[UIImage imageNamed:@"gujiashi_pushed"] forState:UIControlStateHighlighted];
    [gujiashi setImage:[UIImage imageNamed:@"gujiashi_actived"] forState:UIControlStateSelected];
    gujiashi.frame = rect;
    
    pt.x += btnInterlace;
    rect.origin = pt;
    rect.size = firstImg.size;
    UIButton* gengduo = [UIButton buttonWithType:UIButtonTypeCustom];
    [gengduo setImage:[UIImage imageNamed:@"gengduo_normal"] forState:UIControlStateNormal];
    [gengduo setImage:[UIImage imageNamed:@"gengduo_pushed"] forState:UIControlStateHighlighted];
    [gengduo setImage:[UIImage imageNamed:@"gengduo_actived"] forState:UIControlStateSelected];
    gengduo.frame = rect;
    
    _tabBarItemBtns = [[NSArray arrayWithObjects:xunjia,guanzhu,gujiashi,gengduo, nil] retain];
    
    for (int i = 0; i < [_tabBarItemBtns count]; ++i)
    {
        UIButton* btn = [_tabBarItemBtns objectAtIndex:i];
        btn.tag = i;
        [btn addTarget:self action:@selector(OnItemHovered:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(OnItemPushed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    //init
    [self OnItemHovered:xunjia];
    [self OnItemPushed:xunjia];
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

-(void) customTabBarItems
{
    /*
    UITabBarItem* tbi = nil;
    
    tbi = ((UITabBarItem*)[self.tabBar.items objectAtIndex:0]);
    tbi.title = @"";
    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"xunjia_actived"] withFinishedUnselectedImage:[UIImage imageNamed:@"xunjia_normal"]];
    
    tbi = ((UITabBarItem*)[self.tabBar.items objectAtIndex:1]);
    tbi.title = @"";
    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"guanzhu_actived"] withFinishedUnselectedImage:[UIImage imageNamed:@"guanzhu_normal"]];
    
    tbi = ((UITabBarItem*)[self.tabBar.items objectAtIndex:2]);
    tbi.title = @"";
    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"gujiashi_actived"] withFinishedUnselectedImage:[UIImage imageNamed:@"gujiashi_normal"]];
    
    tbi = ((UITabBarItem*)[self.tabBar.items objectAtIndex:3]);
    tbi.title = @"";
    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"gengduo_actived"] withFinishedUnselectedImage:[UIImage imageNamed:@"gengduo_normal"]];
    tbi.badgeValue = @"3";
     */
}

-(IBAction)OnItemHovered:(id)sender
{
    
}

-(IBAction)OnItemPushed:(id)sender
{
    UIButton* btn = nil;
    for (int i = 0; i < [_tabBarItemBtns count]; ++i)
    {
        btn = [_tabBarItemBtns objectAtIndex:i];
        btn.selected = NO;
    }
    btn = sender;
    btn.selected = !btn.selected;
    self.selectedIndex = btn.tag;
}


@end
