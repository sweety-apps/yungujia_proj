//
//  SystemMsgDetailViewController.h
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SystemMsgRecord.h"

@interface SystemMsgDetailViewController : UITableViewController
{
    SystemMsgRecord* _msgRecord;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil msgid:(NSString*)msgid;
@end