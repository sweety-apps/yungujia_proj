//
//  Configure.h
//  TimerCamera
//
//  Created by Lee Justin on 12-9-10.
//
//

#import <Foundation/Foundation.h>

#pragma mark Key Defines

#define kTimerInterval @"TI"
#define kNumberOfContinueShot @"NOC"
#define kFlashMode @"FM"
#define kHDR @"HDR"
#define kLight @"LT"
#define kExposure @"EXP"
#define kFocus @"FCS"
#define kDevicePosition @"DP"

#pragma mark Initialized Values

#define kDefaultTimerIntervalValue 5
#define kDefaultNumberOfContinueShotValue 1
#define kDefaultFlashModeValue 0
#define kDefaultHDRValue 1
#define kDefaultLightValue 0
#define kDefaultExposureValue 2
#define kDefaultFocusValue 2
#define kDefaultDevicePositionValue 0

#pragma mark Config File Path

#define kConfigureStorePath @"/Library/Caches/config"

#pragma mark Useful Macro

#define getConfig(key) [[Configure sharedInstance].configDict objectForKey:(key)]
#define getConfigForInt(key) [(NSNumber*)getConfig(key) integerValue]
#define setConfig(key,val) [[Configure sharedInstance].configDict setValue:(val) forKey:(key)]
#define setConfigForInt(key,val) setConfig(key,[NSNumber numberWithInteger:(val)])
#define setAndSaveConfig(key,val) {setConfig(key,val);[[Configure sharedInstance] writeAll];}
#define setAndSaveConfigForInt(key,val) {setConfigForInt(key,val);[[Configure sharedInstance] writeAll];}

@interface Configure : NSObject
{
    NSDictionary* _configDict;
    NSString* _storePath;
}

@property (nonatomic, retain) NSDictionary* configDict;
@property (nonatomic, retain) NSString* storePath;

+ (Configure*)sharedInstance;
- (void)readAll;
- (void)writeAll;

@end
