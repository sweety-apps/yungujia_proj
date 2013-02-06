//
//  BaseImagePickerTarget.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-3.
//
//

#import "BaseImagePickerTarget.h"

@implementation BaseImagePickerTarget

- (int)getImageCount
{
    return 0;
}

- (UIImage*)getImageAtIndex:(int)index
{
    return nil;
}

- (NSString*)getImageTitleAtIndex:(int)index
{
    return @"";
}

- (UIImage*)getRawImageAtIndex:(int)index
{
    return nil;
}

- (BOOL)insertImageAtIndex:(int)index
{
    return NO;
}

- (BOOL)removeImageAtIndex:(int)index
{
    return NO;
}

@end
