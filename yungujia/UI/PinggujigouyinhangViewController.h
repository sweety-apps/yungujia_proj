//
//  PinggujigouyinhangViewController.h
//  yungujia
//
//  Created by Justin Lee on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinggujigouyinhangCellViewController.h"
#import "PinggujigouyinhangLV2ViewController.h"

@interface PinggujigouyinhangViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

//views

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet PinggujigouyinhangLV2ViewController* lv2ctrl;

//data
@property (nonatomic,retain) NSMutableArray* yinhang;
@property (nonatomic,retain) NSMutableArray* kehujingli;

@end
