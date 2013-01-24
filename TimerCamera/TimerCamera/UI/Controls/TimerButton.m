//
//  TimerButton.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import "TimerButton.h"

#define BUTTON_RECT CGRectMake(13,45,60,63)

#define HittedStateLastSeconds (5.0)

static NSString* stayStateTable[kCountOfButtonTripleStates] = {@"normal",@"enabled",@"extend"};
static NSString* pressedStateTable[kCountOfButtonTripleStates] = {@"pressed",@"pressed1",@"pressed2"};

@implementation TimerButton

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
    [self releaseAllRetainedImages];
    [_hittedRecoverTimer invalidate];
    [super dealloc];
}

#pragma mark Override method

- (void)onReleased:(id)sender
{
    _stayViewTable[_currentButtonState].disableAnimation = YES;
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
    forExtendPressedImage:(UIImage*)xpi
{
    for (int i = kNormalButtonState; i < kCountOfButtonTripleStates; ++i)
    {
        _transStateWithAnimation[i] = NO;
    }
    self = [super initWithFrame:frame
                forNormalImage1:ni1
                forNormalImage2:ni2
          forNormalPressedImage:npi
               forEnabledImage1:ei1
               forEnabledImage2:ei2
         forEnabledPressedImage:epi
                forExtendImage1:xi1
                forExtendImage2:xi2
          forExtendPressedImage:xpi];
    if (self)
    {
        for (int i = kNormalButtonState; i < kCountOfButtonTripleStates; ++i)
        {
            [self setAnimation:self andView:_stayViewTable[i] forState:stayStateTable[i]];
            [self setAnimation:self andView:_pressedViewTable[i] forState:pressedStateTable[i]];
        }
    }
    return self;
}

#pragma mark Private Methods

- (void)releaseAllRetainedImages
{
    ReleaseAndNil(_normalImage1);
    ReleaseAndNil(_normalImage2);
    ReleaseAndNil(_normalPressedImage);
    ReleaseAndNil(_hittedNormalImage1);
    ReleaseAndNil(_hittedNormalImage2);
    ReleaseAndNil(_hittedNormalPressedImage);
}

- (void)startHittedState
{
    if (_hittedNormalImage1)
    {
        [_stayViewTable[kNormalButtonState] setImage1:_hittedNormalImage1];
    }
    if (_hittedNormalImage2)
    {
        [_stayViewTable[kNormalButtonState] setImage2:_hittedNormalImage2];
    }
    if (_hittedNormalPressedImage)
    {
        _pressedViewTable[kNormalButtonState].image = _hittedNormalPressedImage;
    }
}

- (void)endHittedState
{
    _hittedRecoverTimer = nil;
    if (_normalImage1)
    {
        [_stayViewTable[kNormalButtonState] setImage1:_normalImage1];
    }
    if (_normalImage1)
    {
        [_stayViewTable[kNormalButtonState] setImage2:_normalImage2];
    }
    if (_normalPressedImage)
    {
        _pressedViewTable[kNormalButtonState].image = _normalPressedImage;
    }
}

#pragma mark TimerButton Methods

+ (TimerButton*)timerButtonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                               forNormalImage2:(UIImage*)ni2
                                         forNormalPressedImage:(UIImage*)npi
                                              forEnabledImage1:(UIImage*)ei1
                                              forEnabledImage2:(UIImage*)ei2
                                        forEnabledPressedImage:(UIImage*)epi
                                               forExtendImage1:(UIImage*)xi1
                                               forExtendImage2:(UIImage*)xi2
                                         forExtendPressedImage:(UIImage*)xpi
{
    CGRect rect = CGRectMake(0, 0, npi.size.width, npi.size.height);
    return [[[TimerButton alloc] initWithFrame:rect
                              forNormalImage1:ni1
                              forNormalImage2:ni2
                        forNormalPressedImage:npi
                             forEnabledImage1:ei1
                             forEnabledImage2:ei2
                       forEnabledPressedImage:epi
                              forExtendImage1:xi1
                              forExtendImage2:xi2
                        forExtendPressedImage:xpi] autorelease];
}

- (void)setHittedNormalImage1:(UIImage*)hni1
           hittedNormalImage2:(UIImage*)hni2
     hittedNormalPressedImage:(UIImage*)hnpi
{
    [self releaseAllRetainedImages];
    
    _hittedNormalImage1 = [hni1 retain];
    _hittedNormalImage2 = [hni2 retain];
    _hittedNormalPressedImage = [hnpi retain];
    
    _normalImage1 = [[_normalView getImage1] retain];
    _normalImage2 = [[_normalView getImage2] retain];
    _normalPressedImage = [_pressedView.image retain];
}

- (void)setHittedOnce
{
    _hasHitted = YES;
}

- (void)setCurrentButtonState:(eButtonTripleState)currentButtonState withAnimation:(BOOL)animated
{
    _transStateWithAnimation[currentButtonState] = animated;
    if (animated)
    {
        [self doMoveDownAnimationToButtonState:currentButtonState];
    }
    else
    {
        [super setCurrentButtonState:currentButtonState];
    }
}

- (void)setCurrentButtonState:(eButtonTripleState)currentButtonState
{
    [self setCurrentButtonState:currentButtonState withAnimation:NO];
}

#pragma mark <UIStateAnimation>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if (_hasHitted && [state isEqualToString:stayStateTable[kNormalButtonState]])
    {
        [self startHittedState];
        _hittedRecoverTimer = [NSTimer
                               scheduledTimerWithTimeInterval:HittedStateLastSeconds
                               target:self
                               selector:@selector(endHittedState)
                               userInfo:nil repeats:NO];
        _hasHitted = NO;
    }
    for (int i = kNormalButtonState; i < kCountOfButtonTripleStates; ++i)
    {
        if ([state isEqualToString:stayStateTable[i]])
        {
            if (_transStateWithAnimation[i])
            {
                //do move right animation
                [self doMoveRightAnimation];
            }
            //start Alpha Animation
            [_stayViewTable[i] startStateAnimationForView:_stayViewTable[i] forState:state];
        }
    }
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    for (int i = kNormalButtonState; i < kCountOfButtonTripleStates; ++i)
    {
        if ([state isEqualToString:stayStateTable[i]])
        {
            //stop Alpha Animation
            [_stayViewTable[i] stopStateAnimationForView:_stayViewTable[i] forState:state];
        }
    }
    if ([state isEqualToString:pressedStateTable[kNormalButtonState]] && _hittedRecoverTimer)
    {
        [_hittedRecoverTimer invalidate];
        [self endHittedState];
    }
}

#pragma mark Animations

- (void)doMoveRightAnimation
{
#define BOUNCE_OFFSET (3)
    AlphaAnimationView* view = _stayViewTable[_currentButtonState];
    CGRect rawRect = view.frame;
    CGRect originalRect = rawRect;
    originalRect.origin.x -= rawRect.size.width;
    CGRect tmpRect = rawRect;
    tmpRect.origin.x += BOUNCE_OFFSET;
    
    view.frame = originalRect;
    
    //prevent from press
    _button.hidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^(){
        view.frame = tmpRect;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 animations:^(){
            view.frame = rawRect;
        } completion:^(BOOL finished){
            _button.hidden = NO;
            _transStateWithAnimation[_currentButtonState] = NO;
        }];
    }];
}

- (void)doMoveDownAnimationToButtonState:(eButtonTripleState)currentButtonState
{
    UIImageView* pressedView = _pressedViewTable[_currentButtonState];
    CGRect rawRect = pressedView.frame;
    CGRect dstRect = rawRect;
    dstRect.origin.y += dstRect.size.height;
    
    //prevent from press
    _button.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^(){
        pressedView.frame = dstRect;
    } completion:^(BOOL finished){
        pressedView.frame = rawRect;
        _button.hidden = NO;
        [super setCurrentButtonState:currentButtonState];
    }];
}

@end
