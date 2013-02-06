//
//  ThumbNailManager.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-5.
//
//

#import "ThumbNailManager.h"

@implementation ThumbNailManager

static ThumbNailManager* gMgr = nil;

- (id)init
{
    self = [super init];
    if (self)
    {
        _dirPath = [[NSString stringWithFormat:@"%@%@",NSHomeDirectory(),kThumbNailStorePath] retain];
        [self ensurePathExists];
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNil(_dirPath);
    [super dealloc];
}

- (void)ensurePathExists
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:_dirPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:_dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString*)getKeyWithSize:(CGSize)size andId:(NSString*)identify
{
    return [NSString stringWithFormat:@"%.0fx%.0f_%@",size.width,size.height,identify];
}

- (BOOL)findImageInPath:(NSString*)key
{
    NSString* fullPath = [NSString stringWithFormat:@"%@/%@",_dirPath,key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        return YES;
    }
    return NO;
}

- (UIImage*)getImageWithKey:(NSString*)key
{
    NSString* fullPath = [NSString stringWithFormat:@"%@/%@",_dirPath,key];
    return [UIImage imageWithContentsOfFile:fullPath];
}

+ (ThumbNailManager*)sharedInstance
{
    if (!gMgr)
    {
        gMgr = [[ThumbNailManager alloc] init];
    }
    return gMgr;
}

- (void)addThumbNailForImage:(UIImage*)image
                withCropSize:(CGSize)size
                       andId:(NSString*)identify
                   overwrite:(BOOL)overwrite
{
    NSString* key = [self getKeyWithSize:size andId:identify];
    
    if (overwrite || ![self findImageInPath:key])
    {
        image = [BaseUtilitiesFuncions scaleAndCropImage:image CropSize:size];
        NSData* thumbnail = UIImagePNGRepresentation(image);
        [thumbnail writeToFile:[NSString stringWithFormat:@"%@/%@",_dirPath,key] atomically:YES];
    }
}

- (UIImage*)getThumbNailForCropSize:(CGSize)size
                              andId:(NSString*)identify
{
    NSString* key = [self getKeyWithSize:size andId:identify];
    if ([self findImageInPath:key])
    {
        return [self getImageWithKey:key];
    }
    return nil;
}


@end
