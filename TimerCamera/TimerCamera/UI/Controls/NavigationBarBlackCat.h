//
//  NavigationBarBlackCat.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-11.
//
//

#import "BlackCat.h"

@interface NavigationBarBlackCat : BlackCat
{
    BOOL _hasStoped;
}

+ (NavigationBarBlackCat*)navigationBlackCatWithCatImage:(UIImage*)cat
                                     forCatCloseEyeImage:(UIImage*)cc
                                             forEyeImage:(UIImage*)eye;

- (void)startBlackCatAnimation;
- (void)stopBlackCatAnimation;

@end
