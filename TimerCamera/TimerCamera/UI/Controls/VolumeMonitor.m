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
@synthesize currentVolume = _currentVolme;
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
    ReleaseAndNilView(_barButton);
    ReleaseAndNilView(_volumeView);
    ReleaseAndNilView(_backGroudView);
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
      withBarButton:(CommonAnimationButton*)barButton
    backGroundImage:(UIImage*)bgi
        volumeImage:(UIImage*)vi
{
    self = [self initWithFrame:frame];
    if (self)
    {
        //
        //CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _backGroudView.image = bgi;
        _volumeView.image = vi;
        _backGroudView.userInteractionEnabled = NO;
        _barButton.userInteractionEnabled = NO;
        _volumeView.userInteractionEnabled = NO;
        self.userInteractionEnabled = YES;
        
        [_backGroudView addSubview:barButton];
        [_backGroudView addSubview:_volumeView];
        
        //
        [self setAnimation:self andView:_backGroudView forState:@"normal"];
        [self setAnimation:self andView:_backGroudView forState:@"monitor"];
        [self setAnimation:self andView:_backGroudView forState:@"draging"];
        [self setAnimation:self andView:_backGroudView forState:@"holding"];
        
        [self hideMonitor:NO];
    }
    return self;
}

+ (VolumeMonitor*)buttonWithBarButton:(CommonAnimationButton*)barButton
                      backGroundImage:(UIImage*)bgi
                          volumeImage:(UIImage*)vi
{
    CGRect rect = CGRectMake(0, 0, bgi.size.width, bgi.size.height);
    return [[[VolumeMonitor alloc] initWithFrame:rect
                                   withBarButton:barButton
                                 backGroundImage:bgi
                                     volumeImage:vi] autorelease];
}

- (void)showMonitor:(BOOL)animated
{
    
}

- (void)hideMonitor:(BOOL)animated
{
    
}

- (BOOL)isDragingBar
{
    return _draging;
}

- (void)transToMonitorState
{
    if (![_currentState isEqualToString:@"monitor"])
    {
        [self setCurrentState:@"monitor"];
    }
}

- (void)transToHoldingState
{
    if (![_currentState isEqualToString:@"holding"])
    {
        [self setCurrentState:@"holding"];
    }
}

#pragma mark Animation Selectors

- (void)hideAnimateSelector:(BOOL)animated
{
    
}

- (void)showAnimateSelector:(BOOL)animated
{
    
}

- (void)volumeAnimateSelector:(BOOL)animated volume:(float)newlevel interval:(float)second
{
    
}

- (void)reachPeakAnimateSelector:(BOOL)animated
{
    
}

- (void)normalAnimateSelector:(BOOL)animated
{
    
}

#pragma mark <UIStateAnimation>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if ([state isEqualToString:@"normal"])
    {
    }
    else if([state isEqualToString:@"draging"])
    {
    }
    else if([state isEqualToString:@"monitor"])
    {
    }
    else if([state isEqualToString:@"holding"])
    {
    }
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if ([state isEqualToString:@"normal"])
    {
    }
    else if([state isEqualToString:@"draging"])
    {
    }
    else if([state isEqualToString:@"monitor"])
    {
    }
    else if([state isEqualToString:@"holding"])
    {
    }
}

#pragma mark Touch Handler

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([_currentState isEqualToString:@"monitor"])
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        float minPeakX = 0;
        float maxPeakX = self.frame.size.width * (1.0 - _minPeakVolume);
        if (point.x >= minPeakX && point.x <= maxPeakX)
        {
            CGRect rect = _barButton.frame;
            rect.origin.x = point.x;
            _barButton.frame = rect;
            [_barButton setButtonPressed];
            _draging = YES;
            [self setCurrentState:@"draging"];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_draging)
    {
        [_barButton setButtonReleased];
        _draging = NO;
        [self setCurrentState:@"monitor"];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_draging)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        float minPeakX = 0;
        float maxPeakX = self.frame.size.width * (1.0 - _minPeakVolume);
        if (point.x >= minPeakX && point.x <= maxPeakX)
        {
            CGRect rect = _barButton.frame;
            rect.origin.x = point.x;
            _barButton.frame = rect;
        }
    }
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_draging)
    {
        [_barButton setButtonRestored];
        _draging = NO;
        [self setCurrentState:@"monitor"];
    }
    [super touchesCancelled:touches withEvent:event];
}

@end
