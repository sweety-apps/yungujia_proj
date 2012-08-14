//
//  YinhangKedaieDetailViewController.h
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YinhangkedaieDetailCell.h"

@interface YinhangKedaieDetailViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray* _section0Cells;
    NSArray* _section1Cells;
    NSArray* _section0Titles;
    NSArray* _section0Values;
    NSArray* _section1Titles;
    NSArray* _section1Values;
    NSArray*    _daikuanchengshuarray;
}

//part1
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* keaijineCell;
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* pinggujiaCell;
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* jingzhiCell;
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* daikuangchengshuCell;
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* shuifeiCell;

//part2
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* huankuanfangshiCell;
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* daikuannianxianCell;
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* nianlilvCell;
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* yuegongCell;

@end
