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

@synthesize tipsViewMaxWidth = _tipsViewMaxWidth;

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
        _tipsLabel.font = [UIFont systemFontOfSize:16.0];
        _tipsLabel.textAlignment = UITextAlignmentCenter;
        _tipsLabel.adjustsFontSizeToFitWidth = NO;
        
        [_containerView addSubview:_tipsBackGroundImageView];
        [_containerView addSubview:_tipsLabel];
        [_containerView addSubview:_pushHandImageView];
        
        self.hidden = YES;
        
        _tipsContentStringArray = [[NSMutableArray array] retain];
        
        _currentLastSeconds = TIPS_LAST_DEFAULT_SECONDS;
        _tipsViewMaxWidth = TIPS_VIEW_DEFAULT_WIDTH;
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

#pragma mark TipsView private methods

- (void)doCaculateRectWithContent:(NSString*)content
{
    if (_tipsBackGroundImageView.image)
    {
        CGSize sizeView = CGSizeZero;
        CGSize sizeImage = _tipsBackGroundImageView.image.size;
        CGSize sizeText = [content sizeWithFont:_tipsLabel.font];
        if (sizeText.width > (_tipsViewMaxWidth - TIPS_LABEL_LEFT_PADDING - TIPS_LABEL_RIGHT_PADDING))
        {
            //More Than One Line
            sizeText = CGSizeMake(_tipsViewMaxWidth - TIPS_LABEL_LEFT_PADDING - TIPS_LABEL_RIGHT_PADDING, 9999);
            sizeText = [content sizeWithFont:_tipsLabel.font constrainedToSize:sizeText];
        }
        sizeView.width = sizeText.width + TIPS_LABEL_LEFT_PADDING + TIPS_LABEL_RIGHT_PADDING;
        sizeView.height = sizeText.height + TIPS_LABEL_TOP_PADDING + TIPS_LABEL_BOTTOM_PADDING;
        sizeView.width = sizeView.width > sizeImage.width ? sizeView.width : sizeImage.width;
        sizeView.height = sizeView.height > sizeImage.height ? sizeView.height : sizeImage.height;
        sizeText.width = sizeView.width - TIPS_LABEL_LEFT_PADDING - TIPS_LABEL_RIGHT_PADDING;
        sizeText.height = sizeView.height - TIPS_LABEL_TOP_PADDING - TIPS_LABEL_BOTTOM_PADDING;
        
        _pushHandRect = CGRectZero;
        _bgRect = CGRectZero;
        _labelRect = CGRectZero;
        
        _pushHandRect.size = _pushHandImageView.image.size;
        _pushHandRect.origin.x = (sizeView.width - _pushHandRect.size.width) / 2.0;
        _pushHandRect.origin.y = 0;
        
        _bgRect.size = sizeView;
        _bgRect.origin = CGPointZero;
        
        _labelRect.size = sizeText;
        _labelRect.origin.x = TIPS_LABEL_LEFT_PADDING;
        _labelRect.origin.y = TIPS_LABEL_TOP_PADDING;
        
        _selfRect = _bgRect;
        if (_currentSuperView)
        {
            _selfRect.origin.x = (_currentSuperView.frame.size.width - _selfRect.size.width) / 2.0;
        }
    }
}

- (void)onFinishedShow
{
    [self setCurrentState:@"hiding"];
    _showingTimer = nil;
}

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
    if (superView)
    {
        [superView addSubview:self];
    }
    _currentSuperView = superView;
    
    [_tipsContentStringArray addObject:tipsContent];
    NSString* state = self.currentState;
    if([state isEqualToString:@"hide"])
    {
        [self setCurrentState:@"showing"];
    }
    else if([state isEqualToString:@"show"])
    {
        if (_showingTimer)
        {
            [_showingTimer invalidate];
        }
        _showingTimer = [NSTimer scheduledTimerWithTimeInterval:_currentLastSeconds
                                                         target:self
                                                       selector:@selector(onFinishedShow)
                                                       userInfo:nil
                                                        repeats:NO];
        [_tipsContentStringArray removeAllObjects];
        [self doBgAdjustForContent:tipsContent withAnimation:YES];
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
        if ([_tipsContentStringArray count] > 0)
        {
            [self setCurrentState:@"showing"];
        }
    }
    else if([state isEqualToString:@"show"])
    {
        _showingTimer = [NSTimer scheduledTimerWithTimeInterval:_currentLastSeconds
                                                         target:self
                                                       selector:@selector(onFinishedShow)
                                                       userInfo:nil
                                                        repeats:NO];
        if ([_tipsContentStringArray count] > 0)
        {
            NSString* tipsContent = [_tipsContentStringArray lastObject];
            [_tipsContentStringArray removeAllObjects];
            [self doBgAdjustForContent:tipsContent withAnimation:YES];
        }
    }
    else if([state isEqualToString:@"showing"])
    {
        NSString* tipsContent = [_tipsContentStringArray lastObject];
        [_tipsContentStringArray removeAllObjects];
        [self doBgAdjustForContent:tipsContent withAnimation:NO];
        [self doHandPush];
    }
    else if([state isEqualToString:@"hiding"])
    {
        [self doHandPull];
    }
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    
}

#pragma mark Animations

- (void)doHandPush
{
    self.hidden = NO;
    CGRect rect = _bgRect;
    CGRect rectHand = _pushHandRect;
    rect.origin.x = 0;
    rect.origin.y = -_bgRect.size.height;
    _containerView.frame = rect;
    rectHand.origin.y -= 2;
    _pushHandImageView.frame = rectHand;
    rect.origin.y = 0;
    _tipsLabel.alpha = 0.0;
    
    [UIView animateWithDuration:0.15 animations:^(){
        _containerView.frame = rect;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 animations:^(){
            _pushHandImageView.frame = _pushHandRect;
        } completion:^(BOOL finshed){
            [UIView animateWithDuration:0.15 animations:^(){
                CGRect rectHand = _pushHandRect;
                rectHand.origin.y -= _pushHandRect.size.height;
                _pushHandImageView.frame = rectHand;
                _tipsLabel.alpha = 1.0;
            } completion:^(BOOL finshed){
                [self setCurrentState:@"show"];
            }];
        }];
        
    }];
}

- (void)doHandPull
{
    self.hidden = NO;
    CGRect rect = _bgRect;
    CGRect rectHand = _pushHandRect;
    _containerView.frame = rect;
    rectHand.origin.y -= rectHand.size.height;
    _pushHandImageView.frame = rectHand;
    rectHand.origin.y = -2;
    _tipsLabel.alpha = 1.0;
    
    [UIView animateWithDuration:0.1 animations:^(){
        _pushHandImageView.frame = rectHand;
        _tipsLabel.alpha = 0.0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.05 animations:^(){
            _pushHandImageView.frame = _pushHandRect;
        } completion:^(BOOL finshed){
            [UIView animateWithDuration:0.15 animations:^(){
                CGRect rect = _bgRect;
                rect.origin.y -= _bgRect.size.height;
                _containerView.frame = rect;
            } completion:^(BOOL finshed){
                self.hidden = YES;
                [self setCurrentState:@"hide"];
            }];
        }];
        
    }];
}

- (void)doBgAdjustForContent:(NSString*)content withAnimation:(BOOL)animated
{
    [self doCaculateRectWithContent:content];
    
    _tipsLabel.alpha = 1.0;
    
    if(animated)
    {
        [UIView animateWithDuration:0.2 animations:^(){
            _tipsLabel.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 animations:^(){
                self.frame = _selfRect;
                _containerView.frame = _bgRect;
                _tipsBackGroundImageView.frame = _bgRect;
            } completion:^(BOOL finished){
                _tipsLabel.frame = _labelRect;
                _tipsLabel.text = content;
                [UIView animateWithDuration:0.4 animations:^(){
                    _tipsLabel.alpha = 1.0;
                } completion:^(BOOL finished){
                    
                }];
            }];
        }];
    }
    else
    {
        self.frame = _selfRect;
        _containerView.frame = _bgRect;
        _tipsBackGroundImageView.frame = _bgRect;
        _tipsLabel.frame = _labelRect;
        _tipsLabel.text = content;
    }
}

@end
