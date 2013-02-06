//
//  ThumbNailManager.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-5.
//
//

#import <Foundation/Foundation.h>

#define kThumbNailStorePath @"/Library/Caches/thumbnails"

@interface ThumbNailManager : NSObject
{
    NSString* _dirPath;
}

+ (ThumbNailManager*)sharedInstance;
- (void)addThumbNailForImage:(UIImage*)image
                withCropSize:(CGSize)size
                       andId:(NSString*)identify
                   overwrite:(BOOL)overwrite;
- (UIImage*)getThumbNailForCropSize:(CGSize)size
                              andId:(NSString*)identify;

@end
