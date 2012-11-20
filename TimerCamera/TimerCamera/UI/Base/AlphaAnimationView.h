//
//  AlphaAnimationView.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-20.
//
//

#import <UIKit/UIKit.h>
#import "UIStateAnimationView.h"

#define kDefaultAlphaAnimationInterval 1.5

@interface AlphaAnimationView : UIView <UIStateAnimation>
{
    UIImageView* _imageView1;
    UIImageView* _imageView2;
    float _animationInterval;
    BOOL _animationStoped;
}

@property (nonatomic,assign) float animationInterval;

- (void)setImage1:(UIImage*)image;
- (void)setImage2:(UIImage*)image;

@end
