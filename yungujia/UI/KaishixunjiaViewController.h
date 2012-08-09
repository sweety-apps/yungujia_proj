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

@interface KaishixunjiaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    
}

//infos
@property (nonatomic,retain) NSString* loupan;
@property (nonatomic,retain) NSString* loudong;
@property (nonatomic,retain) NSString* louceng;
@property (nonatomic,retain) NSString* fanghao;

//views
@property (nonatomic,retain) IBOutlet UIView* contentView;
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet XunjiajieguoViewController* jieguoctrl;

- (IBAction)push_XunjiaBtn:(id)sender;

@end
