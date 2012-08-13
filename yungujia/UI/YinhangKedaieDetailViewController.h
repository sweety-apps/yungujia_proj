//
//  YinhangKedaieDetailViewController.h
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YinhangKedaieDetailViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDictionary* _section0Dict;
    NSDictionary* _section1Dict;
    NSArray*    _daikuanchengshuarray;
    
}
@end
