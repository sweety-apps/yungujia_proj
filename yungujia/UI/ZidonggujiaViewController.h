//
//  ZidonggujiaViewController.h
//  yungujia
//
//  Created by Lee Justin on 12-9-6.
//
//

#import <UIKit/UIKit.h>
#import "XunjiajieguoViewController.h"
#import "ZidonggujiaCellViewController.h"

@interface ZidonggujiaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UINavigationBarDelegate>
{
    
}

//infos
@property (nonatomic,retain) NSString* headinfo;

//controllers
@property (nonatomic,retain) IBOutlet UINavigationController* navctrl;
@property (nonatomic,retain) IBOutlet XunjiajieguoViewController* xjjgctrl;

@end
