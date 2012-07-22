//
//  XunJiaViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SousuoloupanViewController.h"
#import "FunjinloupanViewController.h"

@interface XunJiaViewController : UIViewController
{
    
}

//views
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;
@property (nonatomic,retain) IBOutlet UISegmentedControl* segment;


//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet SousuoloupanViewController* sousuoloupanctrl;
@property (nonatomic,retain) IBOutlet FunjinloupanViewController* fujinloupanctrl;

- (IBAction)SelectedSegement:(id)sender;
- (IBAction)PushSegement0:(id)sender;
- (IBAction)PushSegement1:(id)sender;

@end
