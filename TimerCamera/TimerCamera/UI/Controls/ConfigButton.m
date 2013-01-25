//
//  ConfigButton.m
//  TimerCamera
//
//  Created by lijinxin on 13-1-25.
//
//

#import "ConfigButton.h"

#define ROUND_CENTER CGPointMake((19.0/40.0),(20.5/40.0)) //CGPointMake(19,20.5)

@implementation ConfigButton

@synthesize enableRotation = _enableRotation;

- (void)dealloc
{
    [self.layer removeAllAnimations];
    ReleaseAndNil(_rotateAnimation);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
    forNormalImage1:(UIImage*)ni1
    forNormalImage2:(UIImage*)ni2
    forPressedImage:(UIImage*)pi
{
    self = [super initWithFrame:frame
                forNormalImage1:ni1
                forNormalImage2:ni2
                forPressedImage:pi
               forEnabledImage1:nil
               forEnabledImage2:nil];
    if (self)
    {
        //pre alloc animations
        CABasicAnimation *rotateLayerAnimation = [[CABasicAnimation animationWithKeyPath:@"transform.rotation"] retain];
        rotateLayerAnimation.duration = 2.0;
        rotateLayerAnimation.fillMode = kCAFillModeBoth;
        rotateLayerAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360.)];
        rotateLayerAnimation.repeatCount = FLT_MAX;
        _rotateAnimation = rotateLayerAnimation;
        
        self.layer.anchorPoint = ROUND_CENTER;
        
        self.enableRotation = NO;
    }
    return self;
}

+ (ConfigButton*)configButtonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                                 forNormalImage2:(UIImage*)ni2
                                                 forPressedImage:(UIImage*)pi
{
    CGRect rect = CGRectMake(0, 0, pi.size.width, pi.size.height);
    return [[[ConfigButton alloc] initWithFrame:rect
                                forNormalImage1:ni1
                                forNormalImage2:ni2
                                forPressedImage:pi] autorelease];
}

-(void)setEnableRotation:(BOOL)enableRotation
{
    if (enableRotation != _enableRotation)
    {
        if (!_isPressing)
        {
            if (enableRotation)
            {
                [self.layer addAnimation:_rotateAnimation forKey:nil];
            }
            else
            {
                [self.layer removeAllAnimations];
            }
        }
        _enableRotation = enableRotation;
    }
}

- (void)onPressed:(id)sender
{
    _isPressing = YES;
    [self.layer removeAllAnimations];
    [super onPressed:sender];
}

- (void)onReleased:(id)sender
{
    if (_enableRotation)
    {
        [self.layer addAnimation:_rotateAnimation forKey:nil];
    }
    _isPressing = NO;
    [super onReleased:sender];
}

- (void)onRestored:(id)sender
{
    if (_enableRotation)
    {
        [self.layer addAnimation:_rotateAnimation forKey:nil];
    }
    _isPressing = NO;
    [super onRestored:sender];
}

@end
