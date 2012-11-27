//
//  CameraCoverViewController.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-24.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"
#import "TimerButton.h"

@interface CameraCoverViewController : UIViewController
{
    //Animation Views
    CommonAnimationButton* _shotButton;
    TimerButton* _timerButton;
    CommonAnimationButton* _configButton;
    CommonAnimationButton* _torchButton;
    CommonAnimationButton* _HDRButton;
    CommonAnimationButton* _frontButton;
    CommonAnimationButton* _animationCatButton;
}

- (void)showSubViews:(BOOL)animated delayed:(float)seconds;
- (void)showSubViews:(BOOL)animated;
- (void)hideSubViews:(BOOL)animated;

@end
