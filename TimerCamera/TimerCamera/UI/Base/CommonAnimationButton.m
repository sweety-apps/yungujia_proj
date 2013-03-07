//
//  CommonAnimationButton.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-20.
//
//

#import "CommonAnimationButton.h"

#pragma mark - CommonAnimationButtonAnimationRecorder

@implementation CommonAnimationButtonAnimationRecorder

- (id)init
{
    self = [super init];
    if (self) {
        _stateAnimationEnabledDict = [[NSMutableDictionary dictionary] retain];
    }
    return self;
}

- (BOOL)isAnimationDisabledForState:(NSString*)state
{
    BOOL ret = NO;
    NSNumber* boolNum = [_stateAnimationEnabledDict objectForKey:state];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

- (void)setAnimationDisabled:(BOOL)isDisabled forState:(NSString*)state
{
    [_stateAnimationEnabledDict setObject:[NSNumber numberWithBool:isDisabled] forKey:state];
}

- (void)dealloc
{
    [_stateAnimationEnabledDict removeAllObjects];
    ReleaseAndNil(_stateAnimationEnabledDict);
    [super dealloc];
}

@end

#pragma mark - CommonAnimationButton

static BOOL gAllButtonEnabled = YES;

#define kAllButtonEnableChanged @"AllButtonEnableChanged"

@implementation CommonAnimationButton

@synthesize button = _button;
@synthesize buttonEnabled = _buttonEnabled;
@synthesize enableAnimations = _enableAnimations;
@synthesize stateAnimationRecorder = _stateAnimationRecorder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rect = frame;
        rect.origin = CGPointMake(0, 0);
        _button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _button.frame = rect;
        [self addSubview:_button];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAllButtonEnableChanged:)
                                                     name:kAllButtonEnableChanged
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    ReleaseAndNilView(_button);
    ReleaseAndNilView(_normalView);
    ReleaseAndNilView(_enabledView);
    ReleaseAndNilView(_pressedView);
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

- (void)handleAllButtonEnableChanged:(NSNotification*)notify
{
    _button.enabled = gAllButtonEnabled;
}

- (void)onPressed:(id)sender
{
    [self setCurrentState:@"pressed"];
}

- (void)onReleased:(id)sender
{
    //self.buttonEnabled = !_buttonEnabled;
    if (!_buttonEnabled)
    {
        if (_stateAnimationRecorder)
        {
            [_stateAnimationRecorder setAnimationDisabled:YES forState:@"normal"];
        }
        _normalView.disableAnimation = YES;
    }
    else
    {
        if (_stateAnimationRecorder)
        {
            [_stateAnimationRecorder setAnimationDisabled:YES forState:@"enabled"];
        }
        _enabledView.disableAnimation = YES;
    }
    self.buttonEnabled = _buttonEnabled;
}

- (void)onRestored:(id)sender
{
    self.buttonEnabled = _buttonEnabled;
}

- (id)initWithFrame:(CGRect)frame
    forNormalImage1:(UIImage*)ni1
    forNormalImage2:(UIImage*)ni2
    forPressedImage:(UIImage*)pi
   forEnabledImage1:(UIImage*)ei1
   forEnabledImage2:(UIImage*)ei2
{
    self = [self initWithFrame:frame];
    if (self)
    {
        BOOL needEnableState = (ei1 || ei1) ? YES : NO;
        CGRect rect = frame;
        rect.origin = CGPointMake(0, 0);
        _normalView = [[AlphaAnimationView alloc] initWithFrame:rect];
        _enabledView = needEnableState ? [[AlphaAnimationView alloc] initWithFrame:rect] : [_normalView retain];
        _pressedView = [[UIImageView alloc] initWithFrame:rect];
        [self setAnimation:_normalView andView:_normalView forState:@"normal"];
        [self setAnimation:_enabledView andView:_enabledView forState:@"enabled"];
        [self setAnimation:nil andView:_pressedView forState:@"pressed"];
        
        [_normalView setImage1:ni1];
        [_normalView setImage2:ni2];
        [_pressedView setImage:pi];
        ei1 = ei1 ? ei1 : ni1;
        ei2 = ei2 ? ei2 : ni2;
        [_enabledView setImage1:ei1];
        [_enabledView setImage2:ei2];
        
        if (!_disableStateWhenInit)
        {
            [self setCurrentState:@"normal"];
        }
        [_button addTarget:self action:@selector(onPressed:) forControlEvents:UIControlEventTouchDown];
        [_button addTarget:self action:@selector(onReleased:) forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(onRestored:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return self;
}

- (void)setCurrentState:(NSString *)currentState
{
    [super setCurrentState:currentState];
    [self bringSubviewToFront:_button];
    self.userInteractionEnabled = YES;
}

+ (CommonAnimationButton*)buttonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                                    forNormalImage2:(UIImage*)ni2
                                                    forPressedImage:(UIImage*)pi
                                                   forEnabledImage1:(UIImage*)ei1
                                                   forEnabledImage2:(UIImage*)ei2
{
    CGRect rect = CGRectMake(0, 0, pi.size.width, pi.size.height);
    return [[[CommonAnimationButton alloc] initWithFrame:rect
                                         forNormalImage1:ni1
                                         forNormalImage2:ni2
                                         forPressedImage:pi
                                        forEnabledImage1:ei1
                                        forEnabledImage2:ei2] autorelease];
}

- (void)setButtonPressed
{
    [self onPressed:_button];
}

- (void)setButtonReleased
{
    [self onReleased:_button];
}

- (void)setButtonRestored
{
    [self onRestored:_button];
}

- (void)setButtonEnabled:(BOOL)buttonEnabled
{
    if (buttonEnabled)
    {
        [self setCurrentState:@"enabled"];
    }
    else
    {
        [self setCurrentState:@"normal"];
    }
    _buttonEnabled = buttonEnabled;
}

- (void)setEnableAnimations:(BOOL)enableAnimations
{
    if (_enableAnimations != enableAnimations)
    {
        if (enableAnimations)
        {
            _normalView.disableAnimation = NO;
            _enabledView.disableAnimation = NO;
        }
        else
        {
            _normalView.disableAnimation = YES;
            _enabledView.disableAnimation = YES;
        }
    }
    _enableAnimations = enableAnimations;
}

- (void)setStateAnimationRecorder:(CommonAnimationButtonAnimationRecorder *)stateAnimationRecorder
{
    _stateAnimationRecorder = stateAnimationRecorder;
    if (_stateAnimationRecorder)
    {
        _normalView.disableAnimation = [_stateAnimationRecorder isAnimationDisabledForState:@"normal"];
        if (_enabledView != _normalView)
        {
            _enabledView.disableAnimation = [_stateAnimationRecorder isAnimationDisabledForState:@"enabled"];
        }
    }
}

+ (void)setAllCommonButtonEnabled:(BOOL)enabled
{
    gAllButtonEnabled = enabled;
    [[NSNotificationCenter defaultCenter]
     postNotification:[NSNotification
                       notificationWithName:kAllButtonEnableChanged
                       object:nil]];
}

+ (BOOL)isAllCommonButtonEnabled
{
    return gAllButtonEnabled;
}

@end
