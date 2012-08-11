//
//  SwichTabBarViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XunJiaViewController.h"
#import "GuanZhuViewController.h"
#import "GuJiaShiViewController.h"
#import "GengDuoViewController.h"

@interface SwichTabBarViewController : UITabBarController
{
    UIImageView* _tabBarBg;
    NSArray* _tabBarItemBtns;
    UIButton* _lastPushedBtn;
}

-(void) customTabBarItems;
-(IBAction)OnItemHovered:(id)sender;
-(IBAction)OnItemPushed:(id)sender;

@end
