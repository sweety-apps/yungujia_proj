//
//  PinggujigouyinhangLV2ViewController.h
//  yungujia
//
//  Created by lijinxin on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinggujigouyinhangCellViewController.h"

@interface PinggujigouyinhangLV2ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    
}

//views

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;

//data
@property (nonatomic,retain) NSMutableArray* name;
@property (nonatomic,retain) NSMutableArray* dianhua;

@end
