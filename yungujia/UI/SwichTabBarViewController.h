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
#import "GengduoWarpperViewController.h"
#import "UIBadgeView.h"

@interface SwichTabBarViewController : UITabBarController
{
    UIImageView* _tabBarBg;
    NSArray* _tabBarItemBtns;
    NSArray* _btnImagesNormal;
    NSArray* _btnImagesHighlighted;
    NSArray* _btnImagesSelected;
    UIButton* _lastPushedBtn;
    UIBadgeView* _badge;
    BOOL _tabBarHasHide;
}

-(IBAction)OnItemHovered:(id)sender;
-(IBAction)OnItemPushed:(id)sender;
-(void) hideTabbar:(BOOL)enable;
@end
