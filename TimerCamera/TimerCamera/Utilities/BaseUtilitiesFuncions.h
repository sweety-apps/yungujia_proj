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

@interface BaseUtilitiesFuncions : NSObject

+ (UIImage*)grabUIView:(UIView*)view;
+ (long long)getCurrentTimeInMicroSeconds;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize;
@end
