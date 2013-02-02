//
//  Configure.m
//  TimerCamera
//
//  Created by Lee Justin on 12-9-10.
//
//

#import "Configure.h"

static Configure* gSI = nil;

@interface Configure (PrivateMethod)

- (void)initializeValue;

@end

@implementation Configure

@synthesize configDict = _configDict;
@synthesize storePath = _storePath;

#pragma mark - NSObject

- (id)init
{
    self = [super init];
    if (self) {
        self.storePath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),kConfigureStorePath];
        [self readAll];
    }
    return self;
}

- (void)dealloc
{
    [self writeAll];
    self.configDict = nil;
    self.storePath = nil;
    [super dealloc];
}

#pragma mark - Configure

+ (Configure*)sharedInstance
{
    if (gSI == nil)
    {
        gSI = [[Configure alloc] init];
    }
    return gSI;
}

- (void)readAll
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithContentsOfFile:_storePath];
    BOOL needIntializeValues = NO;
    
    if (dict == nil)
    {
        dict = [NSMutableDictionary dictionary];
        needIntializeValues = YES;
    }
    
    self.configDict = dict;
    
    if (needIntializeValues)
    {
        [self initializeValue];
    }
}

- (void)writeAll
{
    [_configDict writeToFile:_storePath atomically:YES];
}

#pragma mark Configure(Private)

- (void)initializeValue
{
    [_configDict setValue:[NSNumber numberWithInteger:(kDefaultTimerIntervalValue)]
                   forKey:kTimerInterval];
    [_configDict setValue:[NSNumber numberWithInteger:(kDefaultNumberOfContinueShotValue)]
                   forKey:kNumberOfContinueShot];
    [_configDict setValue:[NSNumber numberWithInteger:(kDefaultFlashModeValue)]
                   forKey:kFlashMode];
    [_configDict setValue:[NSNumber numberWithInteger:(kDefaultHDRValue)]
                   forKey:kHDR];
    [_configDict setValue:[NSNumber numberWithInteger:(kDefaultLightValue)]
                   forKey:kLight];
    [_configDict setValue:[NSNumber numberWithInteger:(kDefaultExposureValue)]
                   forKey:kExposure];
    [_configDict setValue:[NSNumber numberWithInteger:(kDefaultFocusValue)]
                   forKey:kFocus];
    [_configDict setValue:[NSNumber numberWithInteger:(kDefaultDevicePositionValue)]
                   forKey:kDevicePosition];
}

@end
