//
//  NavigationBarBlackCat.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-11.
//
//

#import "NavigationBarBlackCat.h"

@implementation NavigationBarBlackCat

- (id)initWithFrame:(CGRect)frame
        forCatImage:(UIImage*)cat
forCatCloseEyeImage:(UIImage*)cc
        forEyeImage:(UIImage*)eye
{
    self = [super initWithFrame:frame
                    forCatImage:cat
            forCatCloseEyeImage:cc
                    forEyeImage:eye];
    if (self)
    {
        _button.hidden = YES;
        _button.userInteractionEnabled = NO;
        _button.frame = CGRectZero;
        _hasStoped = YES;
    }
    return self;
}

+ (NavigationBarBlackCat*)navigationBlackCatWithCatImage:(UIImage*)cat
                                     forCatCloseEyeImage:(UIImage*)cc
                                             forEyeImage:(UIImage*)eye
{
    CGRect rect = CGRectMake(0, 0, cat.size.width, cat.size.height);
    return [[[NavigationBarBlackCat alloc] initWithFrame:rect
                                             forCatImage:cat
                                     forCatCloseEyeImage:cc
                                             forEyeImage:eye] autorelease];
}

- (void)startBlackCatAnimation
{
    _hasStoped = NO;
    [self internalStartBlackCatAnimation];
}

- (void)stopBlackCatAnimation
{
    _hasStoped = YES;
    [self setCurrentState:@"normal"];
}

- (void)internalStartBlackCatAnimation
{
    if (!_hasStoped)
    {
        [self setCurrentState:@"animate2"];
    }
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark <UIStateAnimation>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    [super startStateAnimationForView:view forState:state];
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if(!_hasStoped && [state isEqualToString:@"animate2"])
    {
        [self performSelector:@selector(internalStartBlackCatAnimation)
                   withObject:nil afterDelay:0.4];
    }
    else
    {
        [super stopStateAnimationForView:view forState:state];
    }
}

@end
