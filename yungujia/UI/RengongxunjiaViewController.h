//
//  RengongxunjiaViewController.h
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RengongxunjiaViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate>

//views
@property (nonatomic,retain) IBOutlet UIView* contentView;
@property (nonatomic,retain) IBOutlet UIButton* btn;
@property (nonatomic,retain) IBOutlet UIButton* btnPinggujigou;

@property (nonatomic,retain) IBOutlet UITableView* chakanpinggujigou;
@property (nonatomic,retain) IBOutlet UITableViewCell* chakanCell;

@end
