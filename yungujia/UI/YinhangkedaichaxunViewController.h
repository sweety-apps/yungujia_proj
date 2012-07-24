//
//  YinhangkedaichaxunViewController.h
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeyinhangkedaieViewController.h"

@interface YinhangkedaichaxunViewController : UIViewController

{
    
}

//views
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet GeyinhangkedaieViewController* gyhkdectrl;

- (IBAction)push_Kaishijisuan:(id)sender;

@end
