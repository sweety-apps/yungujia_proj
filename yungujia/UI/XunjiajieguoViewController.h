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
    BOOL isStarSelecting;
}

//views
@property (nonatomic,retain) IBOutlet UIView* contentView;
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;

@property (nonatomic,retain) IBOutlet UILabel* lblLoupan;
@property (nonatomic,retain) IBOutlet UIButton* btnStar;
@property (nonatomic,retain) IBOutlet UILabel* lblWeiguanzhu;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView* atvWeiguanzhu;
@property (nonatomic,retain) IBOutlet UILabel* lblDanjia;
@property (nonatomic,retain) IBOutlet UILabel* lblZongjia;
@property (nonatomic,retain) IBOutlet UILabel* lblZoushi;
@property (nonatomic,retain) IBOutlet UILabel* lblZuigaojia;
@property (nonatomic,retain) IBOutlet UILabel* lblZuidijia;
@property (nonatomic,retain) IBOutlet UIImageView* imgBgImage;


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
- (IBAction)push_Star:(id)sender;

@end
