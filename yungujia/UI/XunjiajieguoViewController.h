//
//  XunjiajieguoViewController.h
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RengongxunjiaViewController.h"
#import "YinhangkedaichaxunViewController.h"

@interface XunjiajieguoViewController : UIViewController
{
    
}

//views
@property (nonatomic,retain) IBOutlet UIView* contentView;
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;
@property (nonatomic,retain) IBOutlet UIButton* btnRngong;
@property (nonatomic,retain) IBOutlet UIButton* btnKde;
@property (nonatomic,retain) IBOutlet UIButton* btnShilian;
@property (nonatomic,retain) IBOutlet UIButton* btnDuanxin;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet RengongxunjiaViewController* rengongctrl;
@property (nonatomic,retain) IBOutlet YinhangkedaichaxunViewController* yinhangctrl;

- (IBAction)push_Pinggujigou:(id)sender;
- (IBAction)push_RengongxunjiaBtn:(id)sender;
- (IBAction)push_KedaijineBtn:(id)sender;

@end
