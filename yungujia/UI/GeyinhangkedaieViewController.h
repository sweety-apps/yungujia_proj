//
//  GeyinhangkedaieViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeyinhangkedaieCellViewController.h"
#import "YinhangKedaieDetailViewController.h"

@interface GeyinhangkedaieViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

//infos
@property (nonatomic,retain) NSString* headinfo;

//views
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet YinhangKedaieDetailViewController* kdectrl;


@end
