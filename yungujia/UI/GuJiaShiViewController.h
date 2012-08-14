//
//  GuJiaShiViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GujiashihuijiaViewController.h"
#import "PinggujigouViewController.h"

@interface GuJiaShiViewController : UIViewController
{
    
}

//views
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;


//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet GujiashihuijiaViewController* gujiashihuijiactrl;
@property (nonatomic,retain) IBOutlet PinggujigouViewController* pinggujigouctrl;
@property (nonatomic,retain) IBOutlet UIButton* btngujiashi;
@property (nonatomic,retain) IBOutlet UIButton* btnpinggujigou;

- (IBAction)SelectedSegement:(id)sender;
- (IBAction)PushSegement0:(id)sender;
- (IBAction)PushSegement1:(id)sender;

@end
