//
//  SousuoloupanViewController.h
//  yungujia
//
//  Created by lijinxin on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoupanTableViewController.h"

@interface SousuoloupanViewController : UIViewController <UISearchBarDelegate>
{
    
}

//infos

//views
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;
@property (nonatomic,retain) IBOutlet UISearchBar* searchbar;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet LoupanTableViewController* loupanctrl;

- (void)doHideKeyBoard;

@end
