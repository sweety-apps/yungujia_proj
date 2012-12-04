//
//  ShotTimer.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-6.
//
//

#import "ShotTimer.h"
#import "Configure.h"

@implementation ShotTimer

@synthesize delegate = _delegate;
@synthesize initInterval = _initInterval;
@synthesize leftInterval = _leftInterval;

- (id)initWithTimeInterval:(float)timerInterval forDelegate:(id<ShotTimerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        _delegate = delegate;
        _initInterval = timerInterval;
        _leftInterval = _initInterval;
        _timer = nil;
    }
    return self;
}

- (void)onTimerStep
{
    if (_delegate && [_delegate respondsToSelector:@selector(onInterval:forTimer:)])
    {
        [_delegate onInterval:_leftInterval forTimer:self];
    }
    if (_leftInterval <= 0.0 && _timer)
    {
        [_timer invalidate];
        _timer = nil;
        if(_delegate && [_delegate respondsToSelector:@selector(onFinishedTimer:)])
        {
            [_delegate onFinishedTimer:self];
        }
        //[self autorelease];
    }
    _leftInterval -= 1.0;
}

- (void)restartTimer
{
    [self retain];
    if (_timer)
    {
        _leftInterval = 0.0;
        [_timer invalidate];
        _timer = nil;
        [self autorelease];
    }
    _leftInterval = _initInterval;
    [self onTimerStep];
    //[_timer fire];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimerStep) userInfo:nil repeats:YES];
}

- (void)restartTimerWithConfigInterval
{
    _initInterval = (float)getConfigForInt(kTimerInterval);
    [self restartTimer];
}

- (void)restartTimerWithInterval:(float)timerInterval
{
    _initInterval = timerInterval;
    [self restartTimer];
}

- (void)cancelTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
        if(_delegate && [_delegate respondsToSelector:@selector(onCancelledTimer:)])
        {
            [_delegate onCancelledTimer:self];
        }
    }
}

-(void)dealloc
{
    [self cancelTimer];
    [super dealloc];
}

+ (ShotTimer*)timerStart:(float)timerInterval forDelegate:(id<ShotTimerDelegate>)delegate
{
    ShotTimer* ret = [[[ShotTimer alloc] initWithTimeInterval:timerInterval forDelegate:delegate] autorelease];
    [ret restartTimer];
    return ret;
}

+ (ShotTimer*)timerStartWithConfigIntervalForDelegate:(id<ShotTimerDelegate>)delegate
{
    return [ShotTimer timerStart:getConfigForInt(kTimerInterval) forDelegate:delegate];
}

@end
