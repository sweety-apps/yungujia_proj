//
//  AppDelegate.m
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootTabBarController;
@synthesize loginViewController;
- (void)dealloc
{
    [_window release];
    [rootTabBarController release];
    [loginViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    [self ShowLoginView];
    [self.window makeKeyAndVisible];
    
    NSLog(@"I TMD test 1 xia!\n");
    NSLog(@"I TMD test 1 xia 2!\n");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

-(void)ShowMainView:(NSString*)nickname weiboaccount:(NSString*)account
{	
	if(loginViewController!=nil)
	{
		//[loginViewController endTimer];
		[loginViewController.view removeFromSuperview];
		self.loginViewController =nil;
	}
    if(rootTabBarController==nil)
	{
        UIViewController *viewController1 = [[[XunJiaViewController alloc] initWithNibName:@"XunJiaViewController" bundle:nil] autorelease];
        UIViewController *viewController2 = [[[GuanZhuViewController alloc] initWithNibName:@"GuanZhuViewController" bundle:nil] autorelease];
        UIViewController *viewController3 = [[[GuJiaShiViewController alloc] initWithNibName:@"GuJiaShiViewController" bundle:nil] autorelease];
        UIViewController *viewController4 = [[[GengDuoViewController alloc] initWithNibName:@"GengDuoViewController" bundle:nil] autorelease];
        
        self.rootTabBarController = [[[SwichTabBarViewController alloc] initWithNibName:@"SwichTabBarViewController" bundle:nil] autorelease];
        self.rootTabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2,viewController3, viewController4, nil];
	}

    
    [UIView beginAnimations:@"transToMain" context:nil];
    [UIView setAnimationDuration:0.75f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                           forView:self.window 
                             cache:YES];
    
	[self.window addSubview:rootTabBarController.view];
    
    [UIView commitAnimations];
}

-(void)ShowLoginView
{
    if(rootTabBarController!=nil)
	{
		[rootTabBarController.view removeFromSuperview];
		self.rootTabBarController =nil;
	}
	//创建新的并显示 
	if(loginViewController==nil)
	{
        LoginViewController* controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginViewController = [[UINavigationController alloc] initWithRootViewController:controller];
        [controller release];
        
	}
	[self.window addSubview:loginViewController.view];
}

@end
