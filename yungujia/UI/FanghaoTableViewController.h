//
//  FanghaoTableViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FanghaoCellViewController.h"
#import "KaishixunjiaViewController.h"

@interface FanghaoTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

//infos
@property (nonatomic,retain) NSString* headinfo;

//views
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet KaishixunjiaViewController* kaishixunjiactrl;

@end
