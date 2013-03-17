//
//  CommonAnimationButton.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-20.
//
//

#import <UIKit/UIKit.h>
#import "AlphaAnimationView.h"

@interface CommonAnimationButtonAnimationRecorder : NSObject
{
    NSMutableDictionary* _stateAnimationEnabledDict;
}

- (BOOL)isAnimationDisabledForState:(NSString*)state;
- (void)setAnimationDisabled:(BOOL)isDisabled forState:(NSString*)state;

@end

@interface CommonAnimationButton : UIStateAnimationView
{
    UIButton* _button;
    AlphaAnimationView* _normalView;
    AlphaAnimationView* _enabledView;
    UIImageView* _pressedView;
    BOOL _buttonEnabled;
    BOOL _enableAnimations;
    BOOL _disableStateWhenInit;
    CommonAnimationButtonAnimationRecorder* _stateAnimationRecorder;
}

@property (nonatomic,assign,readonly) UIButton* button;
@property (nonatomic,assign) BOOL buttonEnabled;
@property (nonatomic,assign) BOOL enableAnimations;
@property (nonatomic,assign) CommonAnimationButtonAnimationRecorder* stateAnimationRecorder;

- (id)initWithFrame:(CGRect)frame
    forNormalImage1:(UIImage*)ni1
    forNormalImage2:(UIImage*)ni2
    forPressedImage:(UIImage*)pi
   forEnabledImage1:(UIImage*)ei1
   forEnabledImage2:(UIImage*)ei2;

+ (CommonAnimationButton*)buttonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                                    forNormalImage2:(UIImage*)ni2
                                                    forPressedImage:(UIImage*)pi
                                                   forEnabledImage1:(UIImage*)ei1
                                                   forEnabledImage2:(UIImage*)ei2;

- (void)setButtonPressed;
- (void)setButtonReleased;
- (void)setButtonRestored;

- (void)reactiveAlphaAnimations;

+ (void)setAllCommonButtonEnabled:(BOOL)enabled;
+ (BOOL)isAllCommonButtonEnabled;

@end
