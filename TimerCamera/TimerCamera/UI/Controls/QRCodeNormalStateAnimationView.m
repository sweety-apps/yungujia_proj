//
//  QRCodeNormalStateAnimationView.m
//  TimerCamera
//
//  Created by lijinxin on 13-1-16.
//
//

#import "QRCodeNormalStateAnimationView.h"

@implementation QRCodeNormalStateAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectZero;
        rect.size = frame.size;
        
        _waterView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
        [self addSubview:_waterView];
        
        _animationInterval = kDefaultQRCodeStateAnimationInterval;
    }
    return self;
}

- (void)dealloc
{
    [_waterView removeFromSuperview];
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
    _waterView.frame = rect;
}

- (void)setWaterImage:(UIImage*)image
{
    _waterView.image = image;
}

- (void)alphaAnimationSelector
{
    _waterView.alpha = 0.0;
    _waterView.frame = _imageView1.frame;
    if (_disableAnimation || _animationStoped)
    {
        _imageView1.alpha = 1.0;
        _imageView2.alpha = 0.0;
        
        return;
    }
    CGRect waterNewRect1 = _waterView.frame;
    CGRect waterNewRect2 = _waterView.frame;
    waterNewRect1.origin.y += 15;
    waterNewRect2.origin.y += 30;
    
    [UIView animateWithDuration:_animationInterval*0.15 delay:_animationInterval*0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        _imageView1.alpha = 1.0;
        _imageView2.alpha = 1.0;
        _waterView.alpha = 1.0;
        _waterView.frame = waterNewRect1;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:_animationInterval*0.15 animations:^(){
            _waterView.frame = waterNewRect2;
            _waterView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:_animationInterval*0.2 animations:^{
                _imageView1.alpha = 1.0;
                _imageView2.alpha = 0.0;
            } completion:^(BOOL finished){
                if (!_animationStoped)
                {
                    [self performSelectorOnMainThread:@selector(alphaAnimationSelector) withObject:nil waitUntilDone:NO];
                }
            }];
        }];
    }];
}

#pragma mark <UIStateAnimation>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    _waterView.alpha = 0.0;
    _waterView.frame = _imageView1.frame;
    [super startStateAnimationForView:view forState:state];
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    _waterView.alpha = 0.0;
    _waterView.frame = _imageView1.frame;
    [super stopStateAnimationForView:view forState:state];
}

@end
