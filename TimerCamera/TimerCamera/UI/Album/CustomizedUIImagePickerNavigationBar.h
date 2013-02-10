//
//  CustomizedUIImagePickerNavigationBar.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-11.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"
#import "NavigationBarBlackCat.h"

@interface CustomizedUIImagePickerNavigationBar : UIView
{
    CommonAnimationButton* _backBtn;
    CommonAnimationButton* _cancelBtn;
    NavigationBarBlackCat* _blackCat;
    UIView* _catContainer;
}

@property (nonatomic,retain) CommonAnimationButton* backBtn;
@property (nonatomic,retain) CommonAnimationButton* cancelBtn;

@end
