//
//  GuanZhuViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuanzhuLV1CellViewController.h"
#import "KaishixunjiaViewController.h"

@interface GuanZhuViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>
{
    
}

//infos


//views
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet KaishixunjiaViewController* xunjiactrl;

@end
