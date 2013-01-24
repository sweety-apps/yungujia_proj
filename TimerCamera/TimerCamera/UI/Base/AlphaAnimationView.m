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
@synthesize disableAnimation = _disableAnimation;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterFourgroud) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    CGRect rect = frame;
    rect.origin = CGPointMake(0, 0);
    _imageView1.frame = rect;
    _imageView2.frame = rect;
}

- (void)setImage1:(UIImage*)image
{
    _imageView1.image = image;
}

- (void)setImage2:(UIImage*)image
{
    _imageView2.image = image;
}

- (UIImage*)getImage1
{
    return _imageView1.image;
}

- (UIImage*)getImage2
{
    return _imageView2.image;
}

- (void)alphaAnimationSelector
{
    if (_disableAnimation || _animationStoped)
    {
        _imageView1.alpha = 1.0;
        _imageView2.alpha = 0.0;
        return;
    }
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

-(void)setDisableAnimation:(BOOL)disableAnimation
{
    if (_disableAnimation != disableAnimation)
    {
        _disableAnimation = disableAnimation;
        [self alphaAnimationSelector];
    }
}

#pragma mark Global Notification

-(void)onEnterFourgroud
{
    if (!_animationStoped)
    {
        [self alphaAnimationSelector];
    }
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
