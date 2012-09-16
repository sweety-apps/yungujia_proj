//
//  AudioUtility.h
//  TimerCamera
//
//  Created by lijinxin on 12-9-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioUtility;

@protocol AudioUtilityVolumeDetectDelegate <NSObject>

- (void)onDetected:(float)currentVolume
        higherThan:(float)detectVolume
       forInstance:(AudioUtility*)util;

- (void)onUpdate:(float)currentVolume
     forInstance:(AudioUtility*)util;

@end

@protocol AudioUtilityPlaybackDelegate <NSObject>

- (void)onStartPlayFile:(NSString*)filePath
            forInstance:(AudioUtility*)util;

- (void)onFinishedPlayFile:(NSString*)filePath
               forInstance:(AudioUtility*)util;

@end

@interface AudioUtility : NSObject
{
    //for detect Volume while recording
    id _recorderWarper;
    float _currentVolume;
    float _detectVolume;
    NSTimer* _detectTimer;
    //for playback
    NSMutableDictionary* _playWarperDict;
}

+ (AudioUtility*)sharedInstance;


#pragma mark Playback API

- (void)preLoadFileForPlayback:(NSString*)filePath;
- (void)preLoadFileForPlayback:(NSString*)filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)delegate;

- (void)playFile:(NSString*)filePath;
- (void)playFile:(NSString*)filePath isResume:(BOOL)isResume;
- (void)playFile:(NSString*)filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)delegate;
- (void)playFile:(NSString*)filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)delegate isResume:(BOOL)isResume;

- (void)stopPlayFile:(NSString*)filePath;
//- (void)pausePlayFile:(NSString*)filePath;

#pragma mark VolumeDetect API

// 0. ~ 1.0 for vol
- (void)startDetectingVolume:(float)vol;
- (void)stopDectingVolume;
- (float)currentVolume;
- (float)detectVolume;
- (void)setVolumeDetectingDelegate:(id<AudioUtilityVolumeDetectDelegate>)delegate;

@end
