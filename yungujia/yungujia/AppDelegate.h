//
//  AppDelegate.h
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwichTabBarViewController.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    UINavigationController* loginviewcontroller;
    SwichTabBarViewController* rootTabBarController;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet SwichTabBarViewController* rootTabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *loginViewController;
-(void)ShowMainView:(NSString*)nickname weiboaccount:(NSString*)account;
-(void)ShowLoginView;

- (void)makeTabBarHidden:(BOOL)hide;
+ (AppDelegate*)sharedInstance;

@end
