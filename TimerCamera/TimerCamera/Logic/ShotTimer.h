//
//  ShotTimer.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-6.
//
//

#import <Foundation/Foundation.h>

@class ShotTimer;

@protocol ShotTimerDelegate <NSObject>

- (void)onInterval:(float)leftTimeInterval forTimer:(ShotTimer*)timer;
- (void)onFinishedTimer:(ShotTimer*)timer;

@end

@interface ShotTimer : NSObject
{
    NSTimer* _timer;
    id<ShotTimerDelegate> _delegate;
    float _initInterval;
    float _leftInterval;
}

@property (nonatomic,assign) id<ShotTimerDelegate> delegate;
@property (nonatomic,assign) float initInterval;
@property (nonatomic,assign) float leftInterval;

- (id)initWithTimeInterval:(float)timerInterval forDelegate:(id<ShotTimerDelegate>)delegate;

- (void)restartTimer;
- (void)restartTimerWithConfigInterval;
- (void)restartTimerWithInterval:(float)timerInterval;

+ (ShotTimer*)timerStart:(float)timerInterval forDelegate:(id<ShotTimerDelegate>)delegate;
+ (ShotTimer*)timerStartWithConfigIntervalForDelegate:(id<ShotTimerDelegate>)delegate;

@end
