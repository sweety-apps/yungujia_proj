//
//  PinggujigouViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinggujigouLV1CellViewController.h"
#import "PinggujigouxiangqingViewController.h"

@interface PinggujigouViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
}

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet PinggujigouxiangqingViewController* xiangqingctrl;

@end
