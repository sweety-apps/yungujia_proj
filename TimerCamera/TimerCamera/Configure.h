//
//  Configure.h
//  TimerCamera
//
//  Created by Lee Justin on 12-9-10.
//
//

#import <Foundation/Foundation.h>

#define kTimerInterval @"TI"
#define kNumberOfContinueShot @"NOC"
#define kFlashMode @"FM"
#define kHDR @"HDR"
#define kLight @"LT"
#define kExposure @"EXP"
#define kFocus @"FCS"
#define kDevicePosition @"DP"

#define kConfigureStorePath @"/Library/Caches/config"

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
