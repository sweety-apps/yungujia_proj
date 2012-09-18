//
//  AudioUtility.m
//  TimerCamera
//
//  Created by lijinxin on 12-9-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AudioUtility.h"
#import "AQRecorder.h"
#import "AQPlayer.h"

#define TempRecordFile @"tmp.caf"
#define DefaultDelegate 0x1
#define SafeDelete(x) if(x) { delete (x); (x) = NULL; }
#define UpdateTimerInterval 0.3 

#define kMinDBvalue (-80.0)
#define kMaxDBvalue (0.f)

inline double DbToAmp(double inDb)
{
	return pow(10., 0.05 * inDb);
}

#define DBToVol(x) ((x) >= kMaxDBvalue ? 1. : ((x) <= kMinDBvalue ? 0. : DbToAmp(x)))

#pragma mark - Recorder

@interface AQRecorderWarper : NSObject
{
    AQRecorder* _recorder;
    id<AudioUtilityVolumeDetectDelegate> _delegate;
    BOOL _detectWasInterrupted;
}

@property (nonatomic,assign) AQRecorder* recorder;
@property (nonatomic,retain) id<AudioUtilityVolumeDetectDelegate> delegate;
@property (nonatomic,assign) BOOL detectWasInterrupted;

@end

@implementation AQRecorderWarper

@synthesize recorder = _recorder;
@synthesize delegate = _delegate;
@synthesize detectWasInterrupted = _detectWasInterrupted;

- (id)init
{
    self = [super init];
    if (self) {
        _recorder = new AQRecorder();
        
    }
    return self;
}

- (void)dealloc
{
    SafeDelete(_recorder);
    self.delegate = nil;
    [super dealloc];
}

@end

#pragma mark - Playback

@interface AQPlayerWarper : NSObject
{
    AQPlayer* _player;
    NSString* _filePath;
    id<AudioUtilityPlaybackDelegate> _delegate;
    BOOL _playWasInterrupted;
}

@property (nonatomic,assign) AQPlayer* player;
@property (nonatomic,retain) NSString* filePath;
@property (nonatomic,retain) id<AudioUtilityPlaybackDelegate> delegate;
@property (nonatomic,assign) BOOL playWasInterrupted;

@end

@implementation AQPlayerWarper

@synthesize player = _player;
@synthesize filePath = _filePath;
@synthesize delegate = _delegate;
@synthesize playWasInterrupted = _playWasInterrupted;

- (id)init
{
    self = [super init];
    if (self) {
         _player = new AQPlayer();
    }
    return self;
}

- (id)initWithFile:(NSString*)filePath;
{
    self = [self init];
    if (self) {
        self.filePath = filePath;
        if ([_filePath length] > 0)
        {
            CFStringRef cfstr = CFStringCreateWithCString(kCFAllocatorDefault, [_filePath cStringUsingEncoding:NSUTF8StringEncoding], kCFStringEncodingUTF8);
            _player->CreateQueueForFile(cfstr);
            CFRelease(cfstr);
        }
    }
    return self;
}

- (void)dealloc
{
    SafeDelete(_player);
    self.filePath = nil;
    self.delegate = nil;
    [super dealloc];
}

@end

#pragma mark - AudioUtility

@interface AudioUtility (PrivateMethod)

- (AQPlayerWarper*)getPlayer:(NSString*)filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)delegate;

@end

static AudioUtility* gSI = nil;

@implementation AudioUtility


#pragma mark NSObject

- (id)init
{
    self = [super init];
    if (self) {
        _playWarperDict = [[NSMutableDictionary dictionary] retain];
        _recorderWarper = [[AQRecorderWarper alloc] init];
        
        _currentVolume = 0.;
        _currentPeakVolume = 0.;
        _detectVolume = 1.;
        
        [self setupNotifiesAndAudioSessions];
    }
    return self;
}

- (void)dealloc
{
    [_playWarperDict release];
    _playWarperDict = nil;
    
    [_detectTimer invalidate];
    [_detectTimer release];
    _detectTimer = nil;
    
    [super dealloc];
}

#pragma mark AudioUtility

+ (AudioUtility*)sharedInstance
{
    if (gSI == nil)
    {
        gSI = [[AudioUtility alloc] init];
    }
    return gSI;
}

#pragma mark -- <Playback>

static void OnPlaybackHasFinished(AQPlayer* player, void* context)
{
    AudioUtility* au = (AudioUtility*)context;
    if (au)
    {
        AQPlayerWarper* p = [au getPlayer:(NSString*)player->GetFilePath() withDelegate:(id<AudioUtilityPlaybackDelegate>)DefaultDelegate];
        if(p && p.delegate && [p.delegate respondsToSelector:@selector(onFinishedPlayFile:forInstance:)])
        {
            [p.delegate onFinishedPlayFile:p.filePath forInstance:au];
        }
    }
}

- (AQPlayerWarper*)getPlayer:(NSString*)filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)delegate
{
    AQPlayerWarper* ret = [_playWarperDict objectForKey:filePath];
    if (ret == nil)
    {
        ret = [[AQPlayerWarper alloc] initWithFile:filePath];
        ret.player->finishCallback = OnPlaybackHasFinished;
        ret.player->finishCallbackContext = self;
        [_playWarperDict setObject:ret forKey:filePath];
    }
    if (delegate != (id<AudioUtilityPlaybackDelegate>)DefaultDelegate)
    {
        ret.delegate = delegate;
    }
    return ret;
}


- (void)preLoadFileForPlayback:(NSString*)filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)delegate
{
    [self getPlayer:filePath withDelegate:delegate];
}

- (void)preLoadFileForPlayback:(NSString*)filePath
{
    [self preLoadFileForPlayback:filePath withDelegate:nil];
}

- (void)playFile:(NSString*)filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)delegate isResume:(BOOL)isResume
{
    AQPlayerWarper* p = [self getPlayer:filePath withDelegate:delegate];
    if (p)
    {
        if (p.player->IsRunning())
        {
            p.player->StopQueue();
        }
        p.player->StartQueue(isResume);
        
        if(p && p.delegate && [p.delegate respondsToSelector:@selector(onStartPlayFile:forInstance:)])
        {
            [p.delegate onStartPlayFile:p.filePath forInstance:self];
        }
    }
}

- (void)playFile:(NSString*)filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)delegate
{
    [self playFile:filePath withDelegate:delegate isResume:NO];
}

- (void)playFile:(NSString*)filePath isResume:(BOOL)isResume
{
    [self playFile:filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)DefaultDelegate isResume:isResume];
}

- (void)playFile:(NSString*)filePath
{
    [self playFile:filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)DefaultDelegate isResume:NO];
}

- (void)stopPlayFile:(NSString*)filePath
{
    AQPlayerWarper* p = [self getPlayer:filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)DefaultDelegate];
    if (p)
    {
        if (p.player->IsRunning())
        {
            p.player->StopQueue();
        }
        #warning may need notify finished here
    }
}

- (void)pausePlayFile:(NSString*)filePath
{
    AQPlayerWarper* p = [self getPlayer:filePath withDelegate:(id<AudioUtilityPlaybackDelegate>)DefaultDelegate];
    if (p)
    {
        if (p.player->IsRunning())
        {
            p.player->PauseQueue();
        }
    }
}

#pragma mark -- <Detect>

- (void)onUpdateDetect
{
    AQRecorderWarper* r = _recorderWarper;
    AudioQueueLevelMeterState	_chan_lvls[r.recorder->GetNumberChannels()];
    memset(_chan_lvls, 0, sizeof(AudioQueueLevelMeterState) * r.recorder->GetNumberChannels());
    UInt32 data_sz = sizeof(AudioQueueLevelMeterState) * r.recorder->GetNumberChannels();
    OSStatus status = AudioQueueGetProperty(r.recorder->Queue(), kAudioQueueProperty_CurrentLevelMeterDB, _chan_lvls, &data_sz);
    //kAudioQueueErr_EnqueueDuringReset
    if (status != noErr)
    {
        printf("ERROR: metering failed\n");
    }
    
    //caculate average level of all channels
    float lvl = 0.f;
    float lvlp = 0.f;
    for (int i=0; i< r.recorder->GetNumberChannels() ; i++)
    {
        lvl += DBToVol(_chan_lvls[i].mAveragePower);
        lvlp += DBToVol(_chan_lvls[i].mPeakPower);
    }
    lvl /= (float)r.recorder->GetNumberChannels();
    lvlp /= (float)r.recorder->GetNumberChannels();
    
    _currentVolume = lvl;
    _currentPeakVolume = lvlp;
    
    NSLog(@"[D]cur_VOL = %.4f, det_VOL = %f", _currentVolume, _detectVolume);
    
    if (r.delegate && [r.delegate respondsToSelector:@selector(onUpdate:peakVolume:forInstance:)])
    {
        [r.delegate onUpdate:lvl peakVolume:lvlp forInstance:self];
    }
    
    if (_currentVolume >= _detectVolume)
    {
        if (r.delegate && [r.delegate respondsToSelector:@selector(onDetected:peakVolume:higherThan:forInstance:)])
        {
            [r.delegate onDetected:lvl peakVolume:lvlp higherThan:_detectVolume forInstance:self];
        }
    }
}

// 0. ~ 1.0 for vol
- (void)startDetectingVolume:(float)vol
{
    vol = (vol > 1.) ? 1. : (vol < 0. ? 0. : vol);
    _detectVolume = vol;
    AQRecorderWarper* r = _recorderWarper;
    if (r.recorder->IsRunning())
    {
        r.recorder->StopRecord();
    }
    r.recorder->DisableRecordToFile(YES);
    r.recorder->StartRecord((CFStringRef)[NSTemporaryDirectory() stringByAppendingPathComponent:TempRecordFile]);
    
    //enable metering
    {
        UInt32 val = 1;
        OSStatus status = AudioQueueSetProperty(r.recorder->Queue(), kAudioQueueProperty_EnableLevelMetering, &val, sizeof(UInt32));
        if(status!=noErr)
        {
            printf("Error enabling level metering\n");
        }
    }
    
    _detectTimer = [[NSTimer scheduledTimerWithTimeInterval:UpdateTimerInterval target:self selector:@selector(onUpdateDetect) userInfo:nil repeats:YES] retain];
}

- (void)stopDectingVolume
{
    AQRecorderWarper* r = _recorderWarper;
    r.recorder->StopRecord();
    
    [_detectTimer invalidate];
    [_detectTimer release];
    _detectTimer = nil;
}

- (float)currentVolume
{
    return _currentVolume;
}

- (float)detectVolume
{
    return _detectVolume;
}

- (float)currentPeakVolume
{
    return _currentPeakVolume;
}

- (void)setVolumeDetectingDelegate:(id<AudioUtilityVolumeDetectDelegate>)delegate
{
    AQRecorderWarper* r = _recorderWarper;
    r.delegate = delegate;
}

#pragma mark -- <Notifies>

- (void)setupNotifiesAndAudioSessions
{
    // Allocate our singleton instance for the recorder & player object
	OSStatus error = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
	if (error)
    {
        printf("ERROR INITIALIZING AUDIO SESSION! %d\n", (int)error);
    }
	else 
	{
		UInt32 category = kAudioSessionCategory_PlayAndRecord;	
		error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
		if (error) printf("couldn't set audio category!");
        
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", (int)error);
		UInt32 inputAvailable = 0;
		UInt32 size = sizeof(inputAvailable);
		
		// we do not want to allow recording if input is not available
		error = AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &size, &inputAvailable);
		if (error) printf("ERROR GETTING INPUT AVAILABILITY! %d\n", (int)error);
		
		// we also need to listen to see if input availability changes
		error = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioInputAvailable, propListener, self);
		if (error) printf("ERROR ADDING AUDIO SESSION PROP LISTENER! %d\n", (int)error);
        
		error = AudioSessionSetActive(true); 
		if (error) printf("AudioSessionSetActive (true) failed");
	}
	
    /*
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueStopped:) name:@"playbackQueueStopped" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackQueueResumed:) name:@"playbackQueueResumed" object:nil];
    */
    
    [self registerForBackgroundNotifications];
}

#pragma mark AudioSession listeners

- (void)handleInterruptForDetecting:(BOOL)isResume
{
    AQRecorderWarper* r = _recorderWarper;
    
    if (isResume)
    {
        if(r.detectWasInterrupted)
        {
            [self startDetectingVolume:_detectVolume];
            r.detectWasInterrupted = NO;
        }
    }
    else
    {
        if (r.recorder->IsRunning())
        {
            [self stopDectingVolume];
            r.detectWasInterrupted = YES;
        }
    }
}

- (void)handleInterruptForPlayback:(BOOL)isResume
{
    NSArray* allkey = [_playWarperDict allKeys];
    for (int i = 0; i < [allkey count]; ++i)
    {
        NSString* key = [allkey objectAtIndex:i];
        AQPlayerWarper* p = [self getPlayer:key withDelegate:(id<AudioUtilityPlaybackDelegate>)DefaultDelegate];
        
        if (isResume)
        {
            if(p.playWasInterrupted)
            {
                [self playFile:key isResume:YES];
                p.playWasInterrupted = NO;
            }
        }
        else
        {
            if (p.player->IsRunning())
            {
                //[self pausePlayFile:key];
                [self stopPlayFile:key];
                p.playWasInterrupted = YES;
            }
        }
        
    }
    
}

- (void)handleInterrupt:(BOOL)isResume
{
    [self handleInterruptForDetecting:isResume];
    [self handleInterruptForPlayback:isResume];
}

void interruptionListener(	void *	inClientData,
                          UInt32	inInterruptionState)
{
	AudioUtility *THIS = (AudioUtility*)inClientData;
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{
        [THIS handleInterrupt:NO];
	}
    else if (inInterruptionState == kAudioSessionEndInterruption)
	{
        [THIS handleInterrupt:YES];
	}
}

void propListener(	void *                  inClientData,
                  AudioSessionPropertyID	inID,
                  UInt32                  inDataSize,
                  const void *            inData)
{
	AudioUtility *THIS = (AudioUtility*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;			
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{
			if (reasonVal == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
			{			
				[THIS handleInterruptForPlayback:NO];	
			}
            
			// stop the queue if we had a non-policy route change
			[THIS handleInterruptForDetecting:NO];
		}	
	}
	else if (inID == kAudioSessionProperty_AudioInputAvailable)
	{
		if (inDataSize == sizeof(UInt32)) {
			UInt32 isAvailable = *(UInt32*)inData;
			// disable recording if input is not available
            if ((isAvailable > 0) ? YES : NO)
            {
                [THIS handleInterruptForDetecting:YES];
            }
		}
	}
}

/*
#pragma mark ------ playback Notification routines

- (void)playbackQueueStopped:(NSNotification *)note
{ 
}

- (void)playbackQueueResumed:(NSNotification *)note
{
}
*/

#pragma mark ------ background notifications
- (void)registerForBackgroundNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resignActive)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(enterForeground)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

- (void)resignActive
{
    [self handleInterruptForDetecting:NO];
    [self handleInterruptForPlayback:NO];
}

- (void)enterForeground
{
    OSStatus error = AudioSessionSetActive(true);
    if (error) printf("AudioSessionSetActive (true) failed");
    [self handleInterruptForDetecting:YES];
    [self handleInterruptForPlayback:YES];
}

@end
