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
    
    _btnImagesNormal = [[NSArray arrayWithObjects:@"xunjia_normal",@"guanzhu_normal",@"gujiashi_normal",@"gengduo_normal", nil]retain];
    _btnImagesHighlighted = [[NSArray arrayWithObjects:@"xunjia_pushed",@"guanzhu_pushed",@"gujiashi_pushed",@"gengduo_pushed", nil]retain];
    _btnImagesSelected = [[NSArray arrayWithObjects:@"xunjia_actived",@"guanzhu_actived",@"gujiashi_actived",@"gengduo_actived", nil]retain];
    
    UIImage* firstImg = [UIImage imageNamed:(NSString*)[_btnImagesNormal objectAtIndex:0]];
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
        [btn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [btn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
        [btn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(OnItemHovered:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(OnItemPushed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    //init
    [self OnItemHovered:xunjia];
    [self OnItemPushed:xunjia];

    //badge
    _badge = [[[UIBadgeView alloc] initWithFrame:CGRectMake(gengduo.frame.size.width - 25, 0, 25, 25) ] autorelease ];
    [gengduo addSubview:_badge];
    _badge.shadowEnabled = YES;
    _badge.badgeString = @"3";

    //hide raw tabbar
    self.tabBar.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_btnImagesNormal release];
    [_btnImagesSelected release];
    [_btnImagesHighlighted release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        [btn setImage:[UIImage imageNamed:((NSString*)[_btnImagesNormal objectAtIndex:i])] forState:UIControlStateNormal];
    }
    btn = sender;
    self.selectedIndex = btn.tag;
    
    [btn setImage:[UIImage imageNamed:((NSString*)[_btnImagesSelected objectAtIndex:btn.tag])] forState:UIControlStateNormal];
}

-(void) hideTabbar:(BOOL)enable
{
    if (_tabBarHasHide == enable)
    {
        return;
    }
    
    for (int i = 0; i < [[self.view subviews] count]; ++i)
    {
        CGRect subRct = ((UIView*)[[self.view subviews] objectAtIndex:i]).frame;
        NSLog(@"Subviews %i [ %f, %f, %f, %f ]",i, subRct.origin.x, subRct.origin.y, subRct.size.width, subRct.size.height);
    }
    
    UIView* contentView = [[self.view subviews] objectAtIndex:0];
    
    CGRect newRect = contentView.frame;
    if (enable)
    {
        newRect.size.height += self.tabBar.frame.size.height;
        contentView.frame = newRect;
        
        [UIView beginAnimations:@"hideTabbar" context:nil];
        [UIView setAnimationDuration:0.15f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromLeft
                               forView:self.view 
                                 cache:YES];
        
        
        CGRect rct = _tabBarBg.frame;
        rct.origin.y += _tabBarBg.frame.size.height;
        _tabBarBg.frame = rct;
        
        for (int i = 0; i < [_tabBarItemBtns count]; ++i)
        {
            UIButton* btn = [_tabBarItemBtns objectAtIndex:i];
            rct = btn.frame;
            rct.origin.y += _tabBarBg.frame.size.height;
            btn.frame = rct;
        }
        
        /*
        _tabBarBg.hidden = enable;
        for (int i = 0; i < [_tabBarItemBtns count]; ++i)
        {
            UIButton* btn = [_tabBarItemBtns objectAtIndex:i];
            btn.hidden = enable;
        }*/
        
        [UIView commitAnimations];
        
        
    }
    else
    {
        [UIView beginAnimations:@"showTabbar" context:nil];
        [UIView setAnimationDuration:0.15f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromLeft
                               forView:self.view 
                                 cache:YES];
        
        
        
        CGRect rct = _tabBarBg.frame;
        rct.origin.y -= _tabBarBg.frame.size.height;
        _tabBarBg.frame = rct;
        
        for (int i = 0; i < [_tabBarItemBtns count]; ++i)
        {
            UIButton* btn = [_tabBarItemBtns objectAtIndex:i];
            rct = btn.frame;
            rct.origin.y -= _tabBarBg.frame.size.height;
            btn.frame = rct;
        }
        
        /*
        _tabBarBg.hidden = enable;
        for (int i = 0; i < [_tabBarItemBtns count]; ++i)
        {
            UIButton* btn = [_tabBarItemBtns objectAtIndex:i];
            btn.hidden = enable;
        }
         */
        
        newRect.size.height -= self.tabBar.frame.size.height;
        contentView.frame = newRect;
        
        [UIView commitAnimations];
        
    }
    
    _tabBarHasHide = enable;
}


@end
