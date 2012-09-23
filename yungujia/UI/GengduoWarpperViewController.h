//
//  GengduoWarpperViewController.h
//  yungujia
//
//  Created by lijinxin on 12-9-24.
//
//

#import <UIKit/UIKit.h>
#import "GengDuoViewController.h"

@interface GengduoWarpperViewController : UIViewController
{
    
}

//views
@property (nonatomic,retain) IBOutlet UINavigationBar* navbar;

//controllers
@property (nonatomic,retain) IBOutlet UIViewController* rootCtrl;
@property (nonatomic,retain) IBOutlet GengDuoViewController* gengduoCtrl;
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;

@end
