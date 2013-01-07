//
//  FocusAimer.m
//  TimerCamera
//
//  Created by Lee Justin on 13-1-7.
//
//

#import "FocusAimer.h"

@implementation FocusAimer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    ReleaseAndNilView(_focusView);
    ReleaseAndNilView(_aimingView);
    [super dealloc];
}


#pragma mark FocusAimer Public Methods

+ (FocusAimer*)focusAimerWithFocusImage:(UIImage*)focusImage
                         andAimingImage:(UIImage*)aimingImage
{
    return [[[FocusAimer alloc] initWithFocusImage:focusImage
                                    andAimingImage:aimingImage] autorelease];
}

- (FocusAimer*)initWithFocusImage:(UIImage*)focusImage
                   andAimingImage:(UIImage*)aimingImage
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        CGRect rect = CGRectZero;
        rect.size = focusImage.size;
        _aimingView = [[AlphaAnimationView alloc] initWithFrame:rect];
        _focusView = [[UIImageView alloc] initWithFrame:rect];
        self.frame = rect;
        
        _focusView.contentMode = UIViewContentModeScaleToFill;
        
        [_aimingView setImage1:aimingImage];
        [_aimingView setImage2:focusImage];
        _aimingView.animationInterval = 0.25;
        
        _focusView.image = focusImage;
        
        [self setAnimation:self andView:_focusView forState:@"holdind"];
        [self setAnimation:self andView:_focusView forState:@"focusing"];
        [self setAnimation:self andView:_aimingView forState:@"aiming"];
        
        [self setCurrentState:@"holdind"];
    }
    return self;
}

- (void)focusAndAimAtPoint:(CGPoint)point
{
    _focusPoint = point;
    [self setCurrentState:@"focusing"];
}

#pragma mark FocusAimer Private Methods

- (void)transToHolding
{
    self.hidden = YES;
    _aimingView.disableAnimation = YES;
}

#pragma mark <UIStateAnimation>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if([state isEqualToString:@"holdind"])
    {
        [self transToHolding];
    }
    else if([state isEqualToString:@"focusing"])
    {
        [self doFocusAnimation];
    }
    else if([state isEqualToString:@"aiming"])
    {
        [self doAmingAnimation];
    }
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    
}

#pragma mark Animations

- (void)doFocusAnimation
{
    self.hidden = NO;
    CGRect frame = CGRectZero;
    CGSize size = _focusView.image.size;
    CGPoint point = _focusPoint;
    size.width *= 2.0;
    size.height *= 2.0;
    point.x -= (size.width * 0.5);
    point.y -= (size.height * 0.5);
    frame.size = size;
    _focusView.frame = frame;
    frame.origin = point;
    self.frame = frame;
    _focusView.alpha = 0.0;
    
    size = _focusView.image.size;
    point.x = _focusPoint.x - (size.width * 0.5);
    point.y = _focusPoint.y - (size.height * 0.5);
    frame.origin = point;
    //frame.size = size;
    
    [UIView animateWithDuration:0.2 animations:^(){
        self.frame = frame;
        _focusView.alpha = 1.0;
        CGRect rect = CGRectZero;
        rect.size = size;
        _focusView.frame = rect;
    } completion:^(BOOL finished){
        CGRect rect = frame;
        rect.size = size;
        self.frame = rect;
        [self setCurrentState:@"aiming"];
    }];
}

- (void)doAmingAnimation
{
    _aimingView.alpha = 0.9;
    _aimingView.disableAnimation = NO;
    [_aimingView startStateAnimationForView:_aimingView forState:@"aiming"];
    [UIView animateWithDuration:1.0 animations:^(){
        _aimingView.alpha = 1.0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.3 animations:^(){
            _aimingView.alpha = 0.0;
        } completion:^(BOOL finished){
            [_aimingView stopStateAnimationForView:_aimingView forState:@"aiming"];
            [self setCurrentState:@"holding"];
        }];
    }];
}

@end
