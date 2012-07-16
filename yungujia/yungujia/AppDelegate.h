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
    LoginViewController* loginviewcontroller;
    SwichTabBarViewController* rootTabBarController;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet SwichTabBarViewController* rootTabBarController;
@property (nonatomic, retain) IBOutlet LoginViewController *loginViewController;
-(void)ShowMainView:(NSString*)nickname weiboaccount:(NSString*)account;
-(void)ShowLoginView;
@end
