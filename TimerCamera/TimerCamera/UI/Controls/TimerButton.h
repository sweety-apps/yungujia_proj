//
//  TimerButton.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationTripleStateButton.h"

@interface TimerButton : CommonAnimationTripleStateButton <UIStateAnimation>
{
    BOOL _transStateWithAnimation[kCountOfButtonTripleStates];
    UIImage* _normalImage1;
    UIImage* _normalImage2;
    UIImage* _normalPressedImage;
    
    UIImage* _hittedNormalImage1;
    UIImage* _hittedNormalImage2;
    UIImage* _hittedNormalPressedImage;
    NSTimer* _hittedRecoverTimer;
    BOOL _hasHitted;
}

+ (TimerButton*)timerButtonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                               forNormalImage2:(UIImage*)ni2
                                         forNormalPressedImage:(UIImage*)npi
                                              forEnabledImage1:(UIImage*)ei1
                                              forEnabledImage2:(UIImage*)ei2
                                        forEnabledPressedImage:(UIImage*)epi
                                               forExtendImage1:(UIImage*)xi1
                                               forExtendImage2:(UIImage*)xi2
                                         forExtendPressedImage:(UIImage*)xpi;

- (void)setHittedNormalImage1:(UIImage*)hni1
           hittedNormalImage2:(UIImage*)hni2
     hittedNormalPressedImage:(UIImage*)hnpi;

- (void)setHittedOnce;

- (void)setCurrentButtonState:(eButtonTripleState)currentButtonState withAnimation:(BOOL)animated;

@end
