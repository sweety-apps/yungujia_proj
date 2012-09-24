//
//  GujiashihuijiaViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuijiaLV1CellViewController.h"
#import "HuijiaxiangqingViewController.h"

@interface GujiashihuijiaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

//infos
@property (nonatomic,retain) NSString* headinfo;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet HuijiaxiangqingViewController* xiangqingctrl;

@end
