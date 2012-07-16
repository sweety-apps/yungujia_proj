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

@property (nonatomic,retain) IBOutlet UITabBarItem* xunjiaBtn;
@property (nonatomic,retain) IBOutlet UITabBarItem* guanzhuBtn;
@property (nonatomic,retain) IBOutlet UITabBarItem* gujiashiBtn;
@property (nonatomic,retain) IBOutlet UITabBarItem* gengduoBtn;

@end
