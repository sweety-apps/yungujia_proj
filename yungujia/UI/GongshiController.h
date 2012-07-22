//
//  GongshiController.h
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GongshiController : UIViewController
{
    UITableView* _tableView;
    NSMutableArray* gongshilist;
}
@property (retain,nonatomic) IBOutlet UITableView* tableView;
@end
