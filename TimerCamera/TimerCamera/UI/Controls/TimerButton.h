//
//  TimerButton.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"

@interface TimerButton : CommonAnimationButton <UIStateAnimation>
{
    UIImageView* _pressedView2;
    UIImage* _pressedImage1;
    UIImage* _pressedImage2;
    UIImage* _normalImage1;
}

- (id)initWithFrame:(CGRect)frame
    forNormalImage1:(UIImage*)ni1
    forNormalImage2:(UIImage*)ni2
   forPressedImage1:(UIImage*)pi1
   forPressedImage2:(UIImage*)pi2
   forEnabledImage1:(UIImage*)ei1
   forEnabledImage2:(UIImage*)ei2;

+ (TimerButton*)buttonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                          forNormalImage2:(UIImage*)ni2
                                         forPressedImage1:(UIImage*)pi1
                                         forPressedImage2:(UIImage*)pi2
                                         forEnabledImage1:(UIImage*)ei1
                                         forEnabledImage2:(UIImage*)ei2;

@end
