//
//  YinhangKedaieDetailViewController.h
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YinhangkedaieDetailCell.h"
#import "YuegongViewController.h"

enum YKDD_PICKER_TYPE {
    eDaikuanchengshu = 0,
    eNianlilv = 1,
    };

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
    NSArray*    _nianlilvarray;
    enum YKDD_PICKER_TYPE _curPicker;
}

//view
@property (nonatomic,retain) IBOutlet UIPickerView* picker;

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

//controller
@property (nonatomic,retain) IBOutlet YuegongViewController* yuegongCtrl;

@end
