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
#import "PinggujigouyinhangLV2ViewController.h"
#import "RengongxunjiaViewController.h"

enum YKDD_PICKER_TYPE {
    eDaikuanchengshu = 0,
    eNianlilv = 1,
    eDaikuannianxian = 2,
    };

@interface YinhangKedaieDetailViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray* _section0Cells;
    NSArray* _section1Cells;
    NSArray* _section2Cells;
    NSArray* _section0Titles;
    NSArray* _section0Values;
    NSArray* _section1Titles;
    NSArray* _section1Values;
    NSArray* _section2Titles;
    NSArray* _section2Values;
    NSArray*    _daikuanchengshuarray;
    NSArray*    _nianlilvarray;
    NSArray*    _daikuannianxianarray;
    enum YKDD_PICKER_TYPE _curPicker;
}

//view
@property (nonatomic,retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic,retain) IBOutlet UIView* contentView;
@property (nonatomic,retain) IBOutlet UIPickerView* picker;
@property (nonatomic,retain) IBOutlet UIButton* btn;

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

//part3
@property (nonatomic,retain) IBOutlet YinhangkedaieDetailCell* kehujingliCell;

//controller
@property (nonatomic,retain) IBOutlet YuegongViewController* yuegongCtrl;
@property (nonatomic,retain) IBOutlet PinggujigouyinhangLV2ViewController* kehujingliCtrl;
@property (nonatomic,retain) IBOutlet RengongxunjiaViewController* rengonggujiaCtrl;

-(IBAction)OnClikedRngonggujia:(id)sender;

@end
