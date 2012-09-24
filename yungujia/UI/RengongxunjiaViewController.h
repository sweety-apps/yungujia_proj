//
//  RengongxunjiaViewController.h
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KaishixunjiaCell1ViewController.h"

@interface RengongxunjiaViewController : UIViewController <UITextViewDelegate, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField* _mianji;
    UITextField* _chengjiaojia;
}

//views
@property (nonatomic,retain) IBOutlet UIView* contentView;
@property (nonatomic,retain) IBOutlet UIButton* btn;
@property (nonatomic,retain) IBOutlet UIButton* btnPinggujigou;
@property (nonatomic,retain) IBOutlet UITextView* textView;

@property (nonatomic,retain) IBOutlet UITableView* chakanpinggujigou;
@property (nonatomic,retain) IBOutlet UITableViewCell* chakanCell;

-(IBAction)rengongxunjia:(id)sender;
@end
