//
//  VolumeMonitor.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import "VolumeMonitor.h"

@implementation VolumeMonitor

@synthesize barButton = _barButton;
@synthesize stopButton = _stopButton;
@synthesize currentVolume = _currentVolume;
@synthesize peakVolume = _peakVolume;
@synthesize minPeakVolume = _minPeakVolume;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _backGroudView = [[UIImageView alloc] initWithFrame:rect];
        _volumeView = [[UIImageView alloc] initWithFrame:rect];
        _reachedPeakView = [[UIImageView alloc] initWithFrame:rect];
        _containerView = [[UIImageView alloc] initWithFrame:rect];
        _slideCover = [[SliderTouchCoverView sliderWithFrame:frame andDelegate:self] retain];
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
    ReleaseAndNilView(_slideCover);
    ReleaseAndNilView(_containerView);
    ReleaseAndNilView(_reachedPeakView);
    ReleaseAndNilView(_barButton);
    ReleaseAndNilView(_volumeView);
    ReleaseAndNilView(_backGroudView);
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
      withBarButton:(CommonAnimationButton*)barButton
     withStopButton:(CommonAnimationButton*)stopButton
    backGroundImage:(UIImage*)bgi
        volumeImage:(UIImage*)vi
   reachedPeakImage:(UIImage*)ri
{
    self = [self initWithFrame:frame];
    if (self)
    {
        //
        //CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        CGRect rect = frame;
        rect.origin = CGPointMake(0, 0);
        _containerView.backgroundColor = [UIColor clearColor];
        _backGroudView.image = bgi;
        _volumeView.image = vi;
        _reachedPeakView.image = ri;
        _reachedPeakView.frame = rect;
        _barButton = [barButton retain];
        _stopButton = [stopButton retain];
        _stopButton.frame = rect;
        _slideCover.frame = rect;
        _backGroudView.userInteractionEnabled = NO;
        _barButton.userInteractionEnabled = NO;
        _volumeView.userInteractionEnabled = NO;
        _containerView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        _slideCover.userInteractionEnabled = YES;
        
        [_containerView addSubview:_backGroudView];
        [_containerView addSubview:_barButton];
        [_containerView addSubview:_reachedPeakView];
        [_containerView addSubview:stopButton];
        [_containerView addSubview:_volumeView];
        [_containerView addSubview:_stopButton];
        [self addSubview:_slideCover];
    
        _stopButton.hidden = YES;
        _reachedPeakView.hidden = YES;
        
        //
        [self setAnimation:self andView:_containerView forState:@"hided"];
        [self setAnimation:self andView:_containerView forState:@"showing"];
        [self setAnimation:self andView:_containerView forState:@"hiding"];
        [self setAnimation:self andView:_containerView forState:@"monitor"];
        [self setAnimation:self andView:_containerView forState:@"draging"];
        [self setAnimation:self andView:_containerView forState:@"transToHolding"];
        [self setAnimation:self andView:_containerView forState:@"transToMonitor"];
        [self setAnimation:self andView:_containerView forState:@"holding"];
        
        [self setCurrentState:@"hided"];
        [self hideAnimateSelector:NO withStateTrans:NO];
        
        [self bringSubviewToFront:_slideCover];
    }
    return self;
}

+ (VolumeMonitor*)monitorWithBarButton:(CommonAnimationButton*)barButton
                        withStopButton:(CommonAnimationButton*)stopButton
                       backGroundImage:(UIImage*)bgi
                           volumeImage:(UIImage*)vi
                      reachedPeakImage:(UIImage*)ri
{
    CGRect rect = CGRectMake(0, 0, bgi.size.width, bgi.size.height);
    return [[[VolumeMonitor alloc] initWithFrame:rect
                                   withBarButton:barButton
                                  withStopButton:stopButton
                                 backGroundImage:bgi
                                     volumeImage:vi
                                reachedPeakImage:ri] autorelease];
}

- (void)showMonitor:(BOOL)animated
{
    [self setCurrentState:@"showing"];
}

- (void)hideMonitor:(BOOL)animated
{
    [self setCurrentState:@"hiding"];
}

- (BOOL)isDragingBar
{
    return _draging;
}

- (void)transToMonitorState
{
    if ([_currentState isEqualToString:@"holding"])
    {
        [self setCurrentState:@"transToMonitor"];
    }
}

- (void)transToHoldingState
{
    if (![_currentState isEqualToString:@"monitor"])
    {
        [self setCurrentState:@"transToHolding"];
    }
}

- (BOOL)isMonitorState
{
    return [_currentState isEqualToString:@"monitor"];
}

- (void)setCurrentVolume:(float)currentVolume
{
    _currentVolume = currentVolume < 0.0 ? 0.0 : (currentVolume > 1.0 ? 1.0 : currentVolume);
    if ([_currentState isEqualToString:@"monitor"])
    {
        [self volumeAnimateSelector:YES volume:_currentVolume interval:VOLUME_ANIMATION_INTERVAL complationAnimation:nil];
    }
}

- (void)setPeakVolume:(float)peakVolume
{
    peakVolume = peakVolume < _minPeakVolume ? _minPeakVolume : (peakVolume > 1.0 ? 1.0 : peakVolume);
    float x = self.frame.size.width * (1.0 - peakVolume);
    CGRect rect = _barButton.frame;
    rect.origin.x = x;
    _barButton.frame = rect;
    _reachedPeakView.frame = rect;
    _peakVolume = peakVolume;
}

#pragma mark Animation Selectors

- (void)hideAnimateSelector:(BOOL)animated withStateTrans:(BOOL)trans
{
    void (^hide)(void) = ^(void){
        _containerView.hidden = YES;
    };
    void (^remove)(void) = ^(void){
        CGRect rect = _containerView.frame;
        rect.origin.x += rect.size.width;
        _containerView.frame = rect;
    };
    
    if (animated)
    {
        if (trans)
        {
            [UIView animateWithDuration:0.3 animations:remove completion:^(BOOL finished){
                hide();
                [self setCurrentState:@"hided"];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:remove completion:^(BOOL finished){
                hide();
            }];
        }
    }
    else
    {
        remove();
        hide();
        if (trans)
        {
            [self setCurrentState:@"hided"];
        }
    }
}

- (void)showAnimateSelector:(BOOL)animated withStateTrans:(BOOL)trans
{
#define BOUNCE_OFFSET (4)
    _containerView.hidden = NO;
    void (^move)(void) = ^(void){
        CGRect rect = _containerView.frame;
        rect.origin.x -= rect.size.width + BOUNCE_OFFSET;
        _containerView.frame = rect;
        
    };
    void (^bounce)(void) = ^(void){
        CGRect rect = _containerView.frame;
        rect.origin.x += BOUNCE_OFFSET;
        _containerView.frame = rect;
    };
    
    if (animated)
    {
        if (trans)
        {
            [UIView animateWithDuration:0.25 animations:move completion:^(BOOL finished){
                [UIView animateWithDuration:0.1 animations:bounce completion:^(BOOL finished){
                    [self setCurrentState:@"monitor"];
                }];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:move completion:^(BOOL finished){
                [UIView animateWithDuration:0.1 animations:bounce completion:^(BOOL finished){
                }];
            }];
        }
        
    }
    else
    {
        move();
        bounce();
        if (trans)
        {
            [self setCurrentState:@"monitor"];
        }
    }
}

- (void)volumeAnimateSelector:(BOOL)animated volume:(float)newlevel interval:(float)second complationAnimation:(void (^)(void))comp
{
    CGRect volFrame = CGRectZero;
    newlevel = newlevel < 0.0 ? 0.0 : (newlevel > _peakVolume ? _peakVolume : newlevel);
    float x = self.frame.size.width * (1.0 - newlevel);
    CGRect rect = _volumeView.frame;
    rect.origin.x = x;
    volFrame = rect;
    
    if (animated)
    {
        [UIView animateWithDuration:second
                         animations:^(){_volumeView.frame = volFrame;}
                         completion:^(BOOL finished){
                             if (comp)
                             {
                                 comp();
                             }
                         }];
    }
    else
    {
        _volumeView.frame = volFrame;
        if (comp)
        {
            comp();
        }
    }
}

- (void)tarnsToHoldingAnimateSelector:(BOOL)animated
{
#define PEAK_SCALE (1.2)
    _slideCover.hidden = YES;
    
    void (^preReached)(void) = ^(void) {
        _barButton.hidden = YES;
        _reachedPeakView.alpha = 1.0;
        _reachedPeakView.hidden = NO;
    };
    
    void (^reached)(void) = ^(void) {
        CGRect rect = _barButton.frame;
        rect.origin.x -= (rect.size.width * (PEAK_SCALE - 1.0));
        rect.origin.y -= (rect.size.height * (PEAK_SCALE - 1.0));
        rect.size.width *= PEAK_SCALE;
        rect.size.height *= PEAK_SCALE;
        _reachedPeakView.frame = rect;
        _reachedPeakView.alpha = 0.0;
        _backGroudView.alpha = 0.0;
        _volumeView.alpha = 0.0;
    };
    
    void (^endReached)(void) = ^(void) {
        CGRect rect = _barButton.frame;
        _reachedPeakView.frame = rect;
        _reachedPeakView.alpha = 1.0;
        _reachedPeakView.hidden = YES;
        _backGroudView.alpha = 1.0;
        _volumeView.alpha = 1.0;
        _backGroudView.hidden = YES;
        _volumeView.hidden = YES;
        [self volumeAnimateSelector:NO volume:0.0 interval:0.0 complationAnimation:nil];
    };
    
    void (^prepareStopButton)(void) = ^(void) {
        _stopButton.hidden = NO;
        _stopButton.alpha = 0.0;
    };
    
    void (^showStopButton)(void) = ^(void) {
        _stopButton.alpha = 1.0;
    };
    
    void (^endShowStopButton)(void) = ^(void) {
        [self volumeAnimateSelector:NO volume:0.0 interval:0.0 complationAnimation:nil];
        [self setCurrentState:@"holding"];
    };
    
    if (animated)
    {
        void (^warper)(void) = ^(void){
            preReached();
            [UIView animateWithDuration:0.5 animations:reached completion:^(BOOL finished){
                endReached();
                prepareStopButton();
                [UIView animateWithDuration:0.5 animations:showStopButton completion:^(BOOL finished){
                    endShowStopButton();
                }];
            }];
        };
        [self volumeAnimateSelector:YES volume:_peakVolume interval:VOLUME_ANIMATION_INTERVAL complationAnimation:warper];
    }
    else
    {
        [self volumeAnimateSelector:NO volume:_peakVolume interval:0.0 complationAnimation:nil];
        preReached();
        reached();
        endReached();
        prepareStopButton();
        showStopButton();
        endShowStopButton();
    }
}

- (void)transToMonitorAnimateSelector:(BOOL)animated
{
    _slideCover.hidden = NO;
    [self bringSubviewToFront:_slideCover];
    
    void (^preHideStopButton)(void) = ^(void) {
        _stopButton.hidden = NO;
        _stopButton.alpha = 1.0;
    };
    
    void (^hideStopButton)(void) = ^(void) {
        _stopButton.alpha = 0.0;
    };
    
    void (^endHideStopButton)(void) = ^(void) {
        _stopButton.hidden = YES;
        _stopButton.alpha = 1.0;
    };
    
    void (^toMonitor)(BOOL) = ^(BOOL animated) {
        _barButton.hidden = NO;
        [self hideAnimateSelector:NO withStateTrans:NO];
        [self showAnimateSelector:animated withStateTrans:YES];
    };
    
    preHideStopButton();
    if (animated)
    {
        [UIView animateWithDuration:0.3 animations:hideStopButton completion:^(BOOL finished){
            endHideStopButton();
            toMonitor(YES);
        }];
    }
    else
    {
        hideStopButton();
        endHideStopButton();
        toMonitor(NO);
    }
}

#pragma mark <UIStateAnimation>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if([state isEqualToString:@"draging"])
    {
    }
    else if([state isEqualToString:@"monitor"])
    {
        [self volumeAnimateSelector:YES volume:_currentVolume interval:VOLUME_ANIMATION_INTERVAL complationAnimation:nil];
    }
    else if([state isEqualToString:@"transToHolding"])
    {
        [self tarnsToHoldingAnimateSelector:YES];
    }
    else if([state isEqualToString:@"transToMonitor"])
    {
        [self transToMonitorAnimateSelector:YES];
    }
    else if([state isEqualToString:@"showing"])
    {
        [self showAnimateSelector:YES withStateTrans:YES];
    }
    else if([state isEqualToString:@"hiding"])
    {
        [self hideAnimateSelector:YES withStateTrans:YES];
    }
    else if([state isEqualToString:@"hided"])
    {
        [self volumeAnimateSelector:NO volume:0.0 interval:0.0 complationAnimation:nil];
    }
    else if ([state isEqualToString:@"holding"])
    {
        
    }
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if([state isEqualToString:@"draging"])
    {
    }
    else if([state isEqualToString:@"monitor"])
    {
    }
    else if([state isEqualToString:@"transToHolding"])
    {
    }
    else if([state isEqualToString:@"transToMonitor"])
    {
    }
    else if([state isEqualToString:@"holding"])
    {
    }
    else if([state isEqualToString:@"showing"])
    {
    }
    else if([state isEqualToString:@"hiding"])
    {
    }
    else if([state isEqualToString:@"hided"])
    {
    }
    else if ([state isEqualToString:@"holding"])
    {
    }
}

#pragma mark <SliderTouchCoverViewDelegate>

- (void) onBeginTouch:(SliderTouchCoverView*)view atPoint:(CGPoint)point
{
    if([_currentState isEqualToString:@"monitor"])
    {
        float minPeakX = 0;
        float maxPeakX = view.frame.size.width * (1.0 - _minPeakVolume);
        if (point.x >= minPeakX && point.x <= maxPeakX)
        {
            float peak = 1.0 - (point.x / maxPeakX);
            [self setPeakVolume:peak];
            [_barButton setButtonPressed];
            _draging = YES;
            [self setCurrentState:@"draging"];
        }
    }
}

- (void) onEndTouch:(SliderTouchCoverView*)view atPoint:(CGPoint)point
{
    if(_draging)
    {
        [_barButton setButtonReleased];
        _draging = NO;
        [self setCurrentState:@"monitor"];
    }
}

- (void) onMoveTouch:(SliderTouchCoverView*)view atPoint:(CGPoint)point
{
    if(_draging)
    {
        float minPeakX = 0;
        float maxPeakX = view.frame.size.width * (1.0 - _minPeakVolume);
        if (point.x >= minPeakX && point.x <= maxPeakX)
        {
            float peak = 1.0 - (point.x / maxPeakX);
            [self setPeakVolume:peak];
        }
    }
}

- (void) onCancelTouch:(SliderTouchCoverView*)view atPoint:(CGPoint)point
{
    if (_draging)
    {
        [_barButton setButtonRestored];
        _draging = NO;
        [self setCurrentState:@"monitor"];
    }
}

@end
