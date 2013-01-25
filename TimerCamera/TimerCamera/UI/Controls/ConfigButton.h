//
//  ConfigButton.h
//  TimerCamera
//
//  Created by lijinxin on 13-1-25.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "CommonAnimationButton.h"

@interface ConfigButton : CommonAnimationButton
{
    CABasicAnimation* _rotateAnimation;
    BOOL _enableRotation;
    BOOL _isPressing;
}

- (id)initWithFrame:(CGRect)frame
    forNormalImage1:(UIImage*)ni1
    forNormalImage2:(UIImage*)ni2
    forPressedImage:(UIImage*)pi;

+ (ConfigButton*)configButtonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                                 forNormalImage2:(UIImage*)ni2
                                                 forPressedImage:(UIImage*)pi;

@property (nonatomic, assign) BOOL enableRotation;

@end
