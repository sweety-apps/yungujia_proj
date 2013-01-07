//
//  FocusAimer.h
//  TimerCamera
//
//  Created by Lee Justin on 13-1-7.
//
//

#import <UIKit/UIKit.h>
#import "AlphaAnimationView.h"

@interface FocusAimer : UIStateAnimationView <UIStateAnimation>
{
    AlphaAnimationView* _aimingView;
    UIImageView* _focusView;
    CGPoint _focusPoint;
}

+ (FocusAimer*)focusAimerWithFocusImage:(UIImage*)focusImage
                         andAimingImage:(UIImage*)aimingImage;

- (FocusAimer*)initWithFocusImage:(UIImage*)focusImage
                   andAimingImage:(UIImage*)aimingImage;

- (void)focusAndAimAtPoint:(CGPoint)point;

@end
