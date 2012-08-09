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
    
    UIImage* tabBarImg = [UIImage imageNamed:@"tabbarBg"];
    self.tabBar.backgroundImage = tabBarImg;
    self.tabBar.tintColor = [UIColor clearColor];
    self.tabBar.selectedImageTintColor = [UIColor clearColor];
    self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbarBg"];
    self.tabBar.userInteractionEnabled = YES;
    [self.view addSubview:self.tabBar];
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
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITabBarItem* tbi = nil;
    
    tbi = ((UITabBarItem*)[self.tabBar.items objectAtIndex:0]);
    tbi.title = @"";
    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"xunjia_pushed"] withFinishedUnselectedImage:[UIImage imageNamed:@"xunjia_normal"]];
    
    tbi = ((UITabBarItem*)[self.tabBar.items objectAtIndex:1]);
    tbi.title = @"";
    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"guanzhu_pushed"] withFinishedUnselectedImage:[UIImage imageNamed:@"guanzhu_normal"]];
    
    tbi = ((UITabBarItem*)[self.tabBar.items objectAtIndex:2]);
    tbi.title = @"";
    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"gujiashi_pushed"] withFinishedUnselectedImage:[UIImage imageNamed:@"gujiashi_normal"]];
    
    tbi = ((UITabBarItem*)[self.tabBar.items objectAtIndex:3]);
    tbi.title = @"";
    [tbi setFinishedSelectedImage:[UIImage imageNamed:@"gengduo_pushed"] withFinishedUnselectedImage:[UIImage imageNamed:@"gengduo_normal"]];
    
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    
    [super touchesEnded:touches withEvent:event];
}


@end
