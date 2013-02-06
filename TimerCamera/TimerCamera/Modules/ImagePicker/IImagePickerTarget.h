//
//  IImagePickerTarget.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-3.
//
//

#import <Foundation/Foundation.h>

@protocol IImagePickerTarget <NSObject>

@required
- (int)getImageCount;
- (UIImage*)getImageAtIndex:(int)index;
- (NSString*)getImageTitleAtIndex:(int)index;
- (UIImage*)getRawImageAtIndex:(int)index;

@optional
- (BOOL)insertImageAtIndex:(int)index;
- (BOOL)removeImageAtIndex:(int)index;

@end
