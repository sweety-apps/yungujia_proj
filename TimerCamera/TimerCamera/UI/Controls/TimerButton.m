//
//  TimerButton.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import "TimerButton.h"

@implementation TimerButton

@synthesize timerEnabled = _timerEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNil(_pressedImage1);
    ReleaseAndNil(_pressedImage2);
    ReleaseAndNil(_normalImage1);
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

- (void)onPressed:(id)sender
{
    if (!_buttonEnabled)
    {
        [self setCurrentState:@"pressed"];
    }
    else
    {
        [self setCurrentState:@"pressed2"];
    }
}

- (void)onReleased:(id)sender
{
    if (!_buttonEnabled)
    {
        _timerEnabled = YES;
        _normalView.disableAnimation = YES;
        [self setCurrentState:@"enableAnimate"];
    }
    else
    {
        _timerEnabled = NO;
        _enabledView.disableAnimation = YES;
        [self setCurrentState:@"disableAnimate"];
    }
}

- (void)onRestored:(id)sender
{
    self.buttonEnabled = _buttonEnabled;
}

- (id)initWithFrame:(CGRect)frame
    forNormalImage1:(UIImage*)ni1
    forNormalImage2:(UIImage*)ni2
   forPressedImage1:(UIImage*)pi1
   forPressedImage2:(UIImage*)pi2
   forEnabledImage1:(UIImage*)ei1
   forEnabledImage2:(UIImage*)ei2
{
    self = [self initWithFrame:frame
               forNormalImage1:ni1
               forNormalImage2:ni2
               forPressedImage:pi1
              forEnabledImage1:ei1
              forEnabledImage2:ei2];
    if (self)
    {
        CGRect rect = frame;
        rect.origin = CGPointMake(0, 0);
        _pressedView2 = [[UIImageView alloc] initWithFrame:rect];
        [self setAnimation:nil andView:_pressedView2 forState:@"pressed2"];
        
        pi2 = pi2 ? pi2 : (pi1 ? pi1 : ni1);
        [_pressedView2 setImage:pi2];
        
        [self setAnimation:self andView:_pressedView forState:@"enableAnimate"];
        [self setAnimation:self andView:_pressedView2 forState:@"disableAnimate"];
        
        _pressedImage1 = [pi1 retain];
        _pressedImage2 = [pi2 retain];
        _normalImage1 = [ni1 retain];
    }
    return self;
}

+ (TimerButton*)buttonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                          forNormalImage2:(UIImage*)ni2
                                         forPressedImage1:(UIImage*)pi1
                                         forPressedImage2:(UIImage*)pi2
                                         forEnabledImage1:(UIImage*)ei1
                                         forEnabledImage2:(UIImage*)ei2
{
    CGRect rect = CGRectMake(0, 0, pi1.size.width, pi1.size.height);
    return [[[TimerButton alloc] initWithFrame:rect
                               forNormalImage1:ni1
                               forNormalImage2:ni2
                              forPressedImage1:pi1
                              forPressedImage2:pi2
                              forEnabledImage1:ei1
                              forEnabledImage2:ei2] autorelease];
}

- (void)setButtonEnabled:(BOOL)buttonEnabled
{
    if (_buttonEnabled != buttonEnabled)
    {
        if (buttonEnabled)
        {
            _timerEnabled = YES;
            [self setCurrentState:@"enabled"];
        }
        else
        {
            _timerEnabled = NO;
            [self setCurrentState:@"normal"];
        }
    }
    _buttonEnabled = buttonEnabled;
}

#pragma mark <UIStateAnimation>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if ([state isEqualToString:@"enableAnimate"])
    {
        _button.hidden = YES;
        [self enableAnimateSelector];
    }
    else if([state isEqualToString:@"disableAnimate"])
    {
        _button.hidden = YES;
        [self disableAnimateSelector];
    }
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if ([state isEqualToString:@"enableAnimate"])
    {
        _button.hidden = NO;
    }
    else if([state isEqualToString:@"disableAnimate"])
    {
        _button.hidden = NO;
    }
}

#pragma mark Animations

- (void)doBounceAnimate:(UIImageView*)view
             startImage:(UIImage*)si
               endImage:(UIImage*)ei
               isEnable:(BOOL)isEnable
               endBlock:(void (^)(void))endBlock
{
#define BOUNCE_OFFSET (3)
    void (^doMoveDownView)(void) = ^(void){
        CGRect rect = CGRectZero;
        
        ////
        rect = view.frame;
        rect.origin.y += rect.size.height;
        view.frame = rect;
    };
    
    void (^doMoveUpView)(void) = ^(void){
        CGRect rect = CGRectZero;
        
        ////
        rect = view.frame;
        rect.origin.y -= rect.size.height + BOUNCE_OFFSET;
        view.frame = rect;
    };

    void (^doBounceDownView)(void) = ^(void){
        CGRect rect = CGRectZero;
        
        ////
        rect = view.frame;
        rect.origin.y += BOUNCE_OFFSET;
        view.frame = rect;
    };
    
    void (^doMoveLeftView)(void) = ^(void){
        CGRect rect = CGRectZero;
        
        ////
        rect = view.frame;
        rect.origin.x -= rect.size.width;
        view.frame = rect;
    };
    
    void (^doMoveRightView)(void) = ^(void){
        CGRect rect = CGRectZero;
        
        ////
        rect = view.frame;
        rect.origin.x += rect.size.width + BOUNCE_OFFSET;
        view.frame = rect;
    };
    
    void (^doBounceLeftView)(void) = ^(void){
        CGRect rect = CGRectZero;
        
        ////
        rect = view.frame;
        rect.origin.x -= BOUNCE_OFFSET;
        view.frame = rect;
    };
    
    view.image = si;
    
    if (isEnable)
    {
        [UIView animateWithDuration:0.6
                         animations:doMoveDownView
                         completion:^(BOOL finished){
                             view.image = ei;
                             [UIView animateWithDuration:0.3
                                              animations:doMoveUpView
                                              completion:^(BOOL finished){
                                                  [UIView animateWithDuration:0.1
                                                                   animations:doBounceDownView
                                                                   completion:^(BOOL finished){
                                                                       endBlock();
                                                                   }];
                             }];
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.3
                         animations:doMoveDownView
                         completion:^(BOOL finished){
                             view.image = ei;
                             doMoveUpView();
                             doBounceDownView();
                             doMoveLeftView();
                             [UIView animateWithDuration:0.3
                                              animations:doMoveRightView
                                              completion:^(BOOL finished){
                                                  [UIView animateWithDuration:0.1
                                                                   animations:doBounceLeftView
                                                                   completion:^(BOOL finished){
                                                                       endBlock();
                                                                   }];
                                              }];
                         }];
    }
}

- (void)enableAnimateSelector
{
    [self doBounceAnimate:_pressedView
               startImage:_pressedImage1
                 endImage:_pressedImage2
                 isEnable:YES
                 endBlock:^(){
                     _pressedView.image = _pressedImage1;
                     _pressedView2.image = _pressedImage2;
                     self.buttonEnabled = YES;
                 }];
}

- (void)disableAnimateSelector
{
    [self doBounceAnimate:_pressedView2
               startImage:_pressedImage2
                 endImage:_normalImage1
                 isEnable:NO
                 endBlock:^(){
                     _pressedView.image = _pressedImage1;
                     _pressedView2.image = _pressedImage2;
                     self.buttonEnabled = NO;
                 }];
}

@end
