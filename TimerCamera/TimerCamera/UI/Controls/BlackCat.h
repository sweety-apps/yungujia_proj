//
//  BlackCat.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import "UIStateAnimationView.h"

@interface BlackCat : UIStateAnimationView <UIStateAnimation>
{
    UIButton* _button;
    UIImageView* _catView;
    UIImageView* _leftEyeView;
    UIImageView* _rightEyeView;
    UIImage* _catCloseEyeImage;
}

@property (nonatomic,assign,readonly) UIButton* button;

- (id)initWithFrame:(CGRect)frame
        forCatImage:(UIImage*)cat
forCatCloseEyeImage:(UIImage*)cc
        forEyeImage:(UIImage*)eye;

+ (BlackCat*)catWithCatImage:(UIImage*)cat
         forCatCloseEyeImage:(UIImage*)cc
                 forEyeImage:(UIImage*)eye;
@end
