//
//  CommonAnimationTripleStateButton.h
//  TimerCamera
//
//  Created by lijinxin on 13-1-23.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"

typedef enum tagButtonTripleState{
    kNormalButtonState = 0,
    kEnableButtonState = 1,
    kExtendButtonState = 2,
    kCountOfButtonTripleStates,
}eButtonTripleState;

@interface CommonAnimationTripleStateButton : CommonAnimationButton
{
    AlphaAnimationView* _extendView;
    UIImageView* _enabledPressedView;
    UIImageView* _extendPressedView;
    eButtonTripleState _currentButtonState;
    AlphaAnimationView* _stayViewTable[kCountOfButtonTripleStates];
    UIImageView* _pressedViewTable[kCountOfButtonTripleStates];
}

-       (id)initWithFrame:(CGRect)frame
          forNormalImage1:(UIImage*)ni1
          forNormalImage2:(UIImage*)ni2
    forNormalPressedImage:(UIImage*)npi
         forEnabledImage1:(UIImage*)ei1
         forEnabledImage2:(UIImage*)ei2
   forEnabledPressedImage:(UIImage*)epi
          forExtendImage1:(UIImage*)xi1
          forExtendImage2:(UIImage*)xi2
    forExtendPressedImage:(UIImage*)xpi;

+ (CommonAnimationTripleStateButton*)tripleButtonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                                                     forNormalImage2:(UIImage*)ni2
                                                               forNormalPressedImage:(UIImage*)npi
                                                                    forEnabledImage1:(UIImage*)ei1
                                                                    forEnabledImage2:(UIImage*)ei2
                                                              forEnabledPressedImage:(UIImage*)epi
                                                                     forExtendImage1:(UIImage*)xi1
                                                                     forExtendImage2:(UIImage*)xi2
                                                               forExtendPressedImage:(UIImage*)xpi;

@property (nonatomic, assign) eButtonTripleState currentButtonState;

@end
