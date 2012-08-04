//
//  GengDuoViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GengDuoViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray* datasource;
    UILabel* _labelName;
}
//@property (nonatomic,retain) IBOutlet UINavigationBar* navigation;
@property (nonatomic,retain) NSMutableArray* datasource;
@property (nonatomic,retain) IBOutlet UILabel* labelName;
-(IBAction)actionLogout:(id)sender;
@end
