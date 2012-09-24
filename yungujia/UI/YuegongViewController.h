//
//  YuegongViewController.h
//  yungujia
//
//  Created by lijinxin on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuegongCellViewController.h"
#import "YuegongGengduoCellViewController.h"


@interface YuegongViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    int _rowCount;
    YuegongGengduoCell* _gengduoCell;
}

//view
@property (nonatomic,retain) IBOutlet UITableView* tableView;

@end
