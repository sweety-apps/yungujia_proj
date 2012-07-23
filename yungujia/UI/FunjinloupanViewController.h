//
//  FunjinloupanViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoupanTableViewController.h"

@interface FunjinloupanViewController : UIViewController
{
    
}

//infos

//views
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet LoupanTableViewController* loupanctrl;

@end
