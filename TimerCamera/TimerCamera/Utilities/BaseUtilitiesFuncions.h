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

@interface BaseUtilitiesFuncions : NSObject

+ (UIImage*)grabUIView:(UIView*)view;

@end
