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
        _containerView = [[UIView alloc] initWithFrame:rect];
        
        _tipsLabel = [[UILabel alloc] initWithFrame:rect];
        _pushHandImageView = [[UIImageView alloc] initWithFrame:rect];
        _tipsBackGroundImageView = [[UIImageView alloc] initWithFrame:rect];
        
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.userInteractionEnabled = NO;
        
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.font = [UIFont systemFontOfSize:36.0];
        _tipsLabel.textAlignment = UITextAlignmentCenter;
        
        [_containerView addSubview:_tipsBackGroundImageView];
        [_containerView addSubview:_tipsLabel];
        [_containerView addSubview:_pushHandImageView];
        
        self.hidden = YES;
        
        _tipsContentStringArray = [[NSMutableArray array] retain];
        
        _currentLastSeconds = TIPS_LAST_DEFAULT_SECONDS;
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNilView(_tipsLabel);
    ReleaseAndNilView(_pushHandImageView);
    ReleaseAndNilView(_tipsBackGroundImageView);
    ReleaseAndNilView(_containerView);
    ReleaseAndNil(_tipsContentStringArray);
    if (_showingTimer)
    {
        [_showingTimer invalidate];
        _showingTimer = nil;
    }
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
        [self setAnimation:self andView:_containerView forState:@"hide"];
        [self setAnimation:self andView:_containerView forState:@"showing"];
        [self setAnimation:self andView:_containerView forState:@"show"];
        [self setAnimation:self andView:_containerView forState:@"hiding"];
        [self setCurrentState:@"hide"];
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
    
    [_tipsContentStringArray addObject:tipsContent];
    NSString* state = self.currentState;
    if([state isEqualToString:@"hide"])
    {
        
    }
    else if([state isEqualToString:@"show"])
    {
        
    }
    else if([state isEqualToString:@"showing"])
    {
        
    }
    else if([state isEqualToString:@"hiding"])
    {
        
    }
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
    if([state isEqualToString:@"hide"])
    {
        
    }
    else if([state isEqualToString:@"show"])
    {
        
    }
    else if([state isEqualToString:@"showing"])
    {
        
    }
    else if([state isEqualToString:@"hiding"])
    {
        
    }
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    
}

#pragma mark Animations

- (void)doAdjustViewAnimationWithContent:(NSString*)content withAnimation:(BOOL)animated
{
    if (_tipsBackGroundImageView.image)
    {
        CGSize sizeView = CGSizeZero;
        CGSize sizeImage = _tipsBackGroundImageView.image.size;
        sizeView = sizeImage;
        //CGSize sizeText = [content sizeWithFont:_tipsLabel.font forWidth:<#(CGFloat)#> lineBreakMode:];
    }
}

@end
