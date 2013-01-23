//
//  CommonAnimationTripleStateButton.m
//  TimerCamera
//
//  Created by lijinxin on 13-1-23.
//
//

#import "CommonAnimationTripleStateButton.h"

static NSString* stayStateTable[kCountOfButtonTripleStates] = {@"normal",@"enabled",@"extend"};
static NSString* pressedStateTable[kCountOfButtonTripleStates] = {@"pressed",@"pressed1",@"pressed2"};

@implementation CommonAnimationTripleStateButton

@synthesize currentButtonState = _currentButtonState;

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
    ReleaseAndNilView(_extendView);
    ReleaseAndNilView(_enabledPressedView);
    ReleaseAndNilView(_extendPressedView);
    
    [super dealloc];
}

#pragma mark CommonAnimationTripleStateButton methods

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
    self = [self initWithFrame:frame
               forNormalImage1:ni1
               forNormalImage2:ni2
               forPressedImage:npi
              forEnabledImage1:ei1
              forEnabledImage2:ei2];
    if (self)
    {
        CGRect rect = frame;
        rect.origin = CGPointZero;
        _extendView = [[AlphaAnimationView alloc] initWithFrame:rect];
        _enabledPressedView = [[UIImageView alloc] initWithFrame:rect];
        _extendPressedView = [[UIImageView alloc] initWithFrame:rect];
        
        [_extendView setImage1:xi1];
        [_extendView setImage2:xi2];
        _enabledPressedView.image = epi;
        _extendPressedView.image = xpi;
        
        [self setAnimation:_extendView andView:_extendView forState:stayStateTable[kExtendButtonState]];
        [self setAnimation:nil andView:_enabledPressedView forState:pressedStateTable[kEnableButtonState]];
        [self setAnimation:nil andView:_extendPressedView forState:pressedStateTable[kExtendButtonState]];
        
        _currentButtonState = kNormalButtonState;
        
        _stayViewTable[kNormalButtonState] = _normalView;
        _stayViewTable[kEnableButtonState] = _enabledView;
        _stayViewTable[kExtendButtonState] = _extendView;
        
        _pressedViewTable[kNormalButtonState] = _pressedView;
        _pressedViewTable[kEnableButtonState] = _enabledPressedView;
        _pressedViewTable[kExtendButtonState] = _extendPressedView;
    }
    return self;
}

+ (CommonAnimationTripleStateButton*)tripleButtonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
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
    return [[[CommonAnimationTripleStateButton alloc] initWithFrame:rect
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

#pragma mark Override methods

- (void)onPressed:(id)sender
{
    [self setCurrentState:pressedStateTable[_currentButtonState]];
}

- (void)onReleased:(id)sender
{
    //self.buttonEnabled = !_buttonEnabled;
    _stayViewTable[_currentButtonState].disableAnimation = YES;
    [self setCurrentState:stayStateTable[_currentButtonState]];
    //self.buttonEnabled = _buttonEnabled;
}

- (void)onRestored:(id)sender
{
    //self.buttonEnabled = _buttonEnabled;
    [self setCurrentState:stayStateTable[_currentButtonState]];
}

#pragma mark property re-defines

- (void)setCurrentButtonState:(eButtonTripleState)currentButtonState
{
    if(currentButtonState >= kNormalButtonState && currentButtonState < kCountOfButtonTripleStates)
    {
        _currentButtonState = currentButtonState;
        [self setCurrentState:stayStateTable[currentButtonState]];
    }
}

@end
