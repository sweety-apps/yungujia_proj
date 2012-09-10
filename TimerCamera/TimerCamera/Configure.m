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
    if (dict == nil)
    {
        dict = [NSMutableDictionary dictionary];
    }
    self.configDict = dict;
}

- (void)writeAll
{
    [_configDict writeToFile:_storePath atomically:YES];
}

@end
