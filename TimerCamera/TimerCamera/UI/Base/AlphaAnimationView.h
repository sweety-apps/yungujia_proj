//
//  AlphaAnimationView.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-20.
//
//

#import <UIKit/UIKit.h>
#import "UIStateAnimationView.h"

#define kDefaultAlphaAnimationInterval 1.0

@interface AlphaAnimationView : UIView <UIStateAnimation>
{
    UIImageView* _imageView1;
    UIImageView* _imageView2;
    float _animationInterval;
    BOOL _animationStoped;
    BOOL _disableAnimation;
}

@property (nonatomic,assign) float animationInterval;
@property (nonatomic,assign) BOOL disableAnimation;

- (void)setImage1:(UIImage*)image;
- (void)setImage2:(UIImage*)image;

- (UIImage*)getImage1;
- (UIImage*)getImage2;

@end
