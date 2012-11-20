//
//  AlphaAnimationView.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-20.
//
//

#import "AlphaAnimationView.h"

@implementation AlphaAnimationView

@synthesize animationInterval = _animationInterval;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rect = frame;
        rect.origin = CGPointMake(0, 0);
        _imageView1 = [[[UIImageView alloc] initWithFrame:rect] autorelease];
        _imageView2 = [[[UIImageView alloc] initWithFrame:rect] autorelease];
        [self addSubview:_imageView1];
        [self addSubview:_imageView2];
        _animationInterval = kDefaultAlphaAnimationInterval;
        _animationStoped = YES;
    }
    return self;
}

- (void)dealloc
{
    [_imageView1 removeFromSuperview];
    [_imageView2 removeFromSuperview];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imageView1.frame = frame;
    _imageView2.frame = frame;
}

- (void)setImage1:(UIImage*)image
{
    _imageView1.image = image;
}

- (void)setImage2:(UIImage*)image
{
    _imageView2.image = image;
}

- (void)alphaAnimationSelector
{
    [UIView animateWithDuration:_animationInterval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _imageView1.alpha = 1.0;
        _imageView2.alpha = 1.0;
    } completion:^(BOOL finished){
        if (finished)
        {
            //_imageView1.alpha = 0.0;
            //_imageView2.alpha = 1.0;
            [UIView animateWithDuration:_animationInterval delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                _imageView1.alpha = 1.0;
                _imageView2.alpha = 0.0;
            } completion:^(BOOL finished){
                if (finished && !_animationStoped)
                {
                    [self performSelectorOnMainThread:@selector(alphaAnimationSelector) withObject:nil waitUntilDone:NO];
                }
            }];
        }
    }];
}

#pragma mark <UIStateAnimation>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    _imageView1.alpha = 1.0;
    _imageView2.alpha = 0.0;
    _animationStoped = NO;
    [self alphaAnimationSelector];
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    _animationStoped = YES;
    _imageView1.alpha = 1.0;
    _imageView2.alpha = 0.0;
}

@end
