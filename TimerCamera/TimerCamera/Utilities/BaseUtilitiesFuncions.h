//
//  BaseUtilitiesFuncions.h
//  TimerCamera
//
//  Created by lijinxin on 13-1-23.
//
//

#import <Foundation/Foundation.h>

#define ReleaseAndNil(x) if(x){[(x) release]; (x) = nil; }
#define ReleaseAndNilView(x) if(x){[(x) removeFromSuperview]; [(x) release]; (x) = nil; }
#define LString(key) NSLocalizedStringFromTable((key), @"text",(key))

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_RETINA ([UIScreen mainScreen].scale > 1.0)


@interface BaseUtilitiesFuncions : NSObject

+ (UIImage*)grabUIView:(UIView*)view;
+ (long long)getCurrentTimeInMicroSeconds;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize;
+ (UIImage*)getSubImageFrom:(UIImage*)img WithRect:(CGRect)rect;
+ (UIImage*)scaleAndCropImage:(UIImage*)img CropSize:(CGSize)size;
+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count;
+ (UIColor*)getColorFromImage:(UIImage*)img atPoint:(CGPoint)point;
@end
