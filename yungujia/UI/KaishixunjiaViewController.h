//
//  KaishixunjiaViewController.h
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XunjiajieguoViewController.h"
#import "KaishixunjiaLoupanCellViewController.h"
#import "KaishixunjiaCell1ViewController.h"

@class XunJiaViewController;
@class LoudongTableViewController;
@class LoucengTableViewController;
@class FanghaoTableViewController;

@interface KaishixunjiaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    NSArray* _titles0;
    NSArray* _titles1;
    NSArray* _values0;
    NSArray* _values1;
    
    XunJiaViewController* _xunjiaCtrl;
    LoudongTableViewController* _loudongCtrl;
    LoucengTableViewController* _loucengCtrl;
    FanghaoTableViewController* _fanghaoCtrl;
    
    BOOL _disableLoupanXuanze;
}

//infos
@property (nonatomic,retain) NSString* loupan;
@property (nonatomic,retain) NSString* loudong;
@property (nonatomic,retain) NSString* louceng;
@property (nonatomic,retain) NSString* fanghao;

//views
@property (nonatomic,retain) IBOutlet UIView* contentView;
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;
@property (nonatomic,retain) IBOutlet UIButton* btn;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet XunjiajieguoViewController* jieguoctrl;

@property (nonatomic,retain) XunJiaViewController* xunjiaCtrl;
@property (nonatomic,retain) LoudongTableViewController* loudongCtrl;
@property (nonatomic,retain) LoucengTableViewController* loucengCtrl;
@property (nonatomic,retain) FanghaoTableViewController* fanghaoCtrl;

//disable loupan loudong louceng choosen
@property (nonatomic,assign) BOOL disableLoupanXuanze;

- (IBAction)push_XunjiaBtn:(id)sender;

@end
