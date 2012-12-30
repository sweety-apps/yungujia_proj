//
//  TipsView.m
//  TimerCamera
//
//  Created by lijinxin on 12-12-31.
//
//

#import "TipsView.h"
#import "AppDelegate.h"

@implementation TipsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rect = frame;
        rect.origin = CGPointMake(0, 0);
//        _button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//        _button.frame = rect;
//        [self addSubview:_button];
        _currentLastSeconds = TIPS_LAST_DEFAULT_SECONDS;
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNilView(_tipsLabel);
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

#pragma mark TipsView public methods

static TipsView* gTipsView = nil;

+ (TipsView*)sharedInstance
{
    if (gTipsView == nil)
    {
        
        gTipsView = [[TipsView alloc] initWithFrame:CGRectZero];
    }
    return gTipsView;
}

- (void)setPushHandImage:(UIImage*)image
{
    
}

- (void)setTipsBackGroundImage:(UIImage*)image
{
    
}

- (UILabel*)getTipsLabel
{
    return _tipsLabel;
}

- (void)showTips:(NSString*)tipsContent
            over:(UIView*)superView
            last:(float)seconds
{
    _currentLastSeconds = seconds;
}

- (void)showTips:(NSString*)tipsContent
            over:(UIView*)superView
{
    [self showTips:tipsContent
              over:superView
              last:TIPS_LAST_DEFAULT_SECONDS];
}

- (void)showOverWindowTips:(NSString*)tipsContent
                      last:(float)seconds
{
    [self showTips:tipsContent
              over:((AppDelegate*)[UIApplication sharedApplication].delegate).window
              last:seconds];
}

- (void)showOverWindowTips:(NSString*)tipsContent
{
    [self showTips:tipsContent
              over:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
}

#pragma mark UIStateAnimation

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    
}

#pragma mark ShotTimerDelegate

- (void)onInterval:(float)leftTimeInterval forTimer:(ShotTimer*)timer
{
    
}

- (void)onFinishedTimer:(ShotTimer*)timer
{
    
}

- (void)onCancelledTimer:(ShotTimer*)timer
{
    
}

@end
