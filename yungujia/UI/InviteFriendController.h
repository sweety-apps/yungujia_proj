//
//  InviteFriendController.h
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
//    UILabel* lblInfo;
    UITableView* _tableView;
    NSMutableArray* friendlist;
//    UITextField* txtTelNum;
//    UIButton*   btnSend;
}

//@property (retain,nonatomic) IBOutlet UILabel* lblInfo;
@property (retain,nonatomic) IBOutlet UITableView* tableView;
//@property (retain,nonatomic) IBOutlet UIButton* btnSend;
//@property (retain,nonatomic) IBOutlet UITextField* txtTelNum;
@end
