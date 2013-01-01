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
        _tipsLabel = [[UILabel alloc] initWithFrame:rect];
        _pushHandImageView = [[UIImageView alloc] initWithFrame:rect];
        _tipsBackGroundImageView = [[UIImageView alloc] initWithFrame:rect];
        
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.font = [UIFont systemFontOfSize:36.0];
        
        [self addSubview:_tipsBackGroundImageView];
        [self addSubview:_tipsLabel];
        [self addSubview:_pushHandImageView];
        
        self.hidden = YES;
        
        _currentLastSeconds = TIPS_LAST_DEFAULT_SECONDS;
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNilView(_tipsLabel);
    ReleaseAndNilView(_pushHandImageView);
    ReleaseAndNilView(_tipsBackGroundImageView);
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

+ (TipsView*)tipsViewWithPushHand:(UIImage*)pushHandImage
                  backGroundImage:(UIImage*)bgImage
{
    return [[[TipsView alloc] initWithPushHand:pushHandImage backGroundImage:bgImage] autorelease];
}

- (TipsView*)initWithPushHand:(UIImage*)pushHandImage
              backGroundImage:(UIImage*)bgImage
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        [self setPushHandImage:pushHandImage];
        [self setTipsBackGroundImage:bgImage];
    }
    return self;
}

- (void)setPushHandImage:(UIImage*)image
{
    _pushHandImageView.image = image;
    CGRect rect = CGRectZero;
    rect.size = image.size;
    _pushHandImageView.frame = rect;
}

- (void)setTipsBackGroundImage:(UIImage*)image
{
    _tipsBackGroundImageView.image = image;
    CGRect rect = CGRectZero;
    rect.size = image.size;
    _tipsBackGroundImageView.frame = rect;
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
