//
//  ShotButton.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"

@interface ShotButton : CommonAnimationButton
{
    UIImageView* _coverIconView;
    UILabel* _coverLabel;
}

@property (nonatomic,readonly,retain) UIImageView* coverIconView;
@property (nonatomic,readonly,retain) UILabel* coverLabel;

- (void)setIcon:(UIImage*)icon;
- (void)setLabelString:(NSString*)string;

- (id)initWithFrame:(CGRect)frame
    forNormalImage1:(UIImage*)ni1
    forNormalImage2:(UIImage*)ni2
    forPressedImage:(UIImage*)pi
   forEnabledImage1:(UIImage*)ei1
   forEnabledImage2:(UIImage*)ei2
            forIcon:(UIImage*)ic;

+ (ShotButton*)buttonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                         forNormalImage2:(UIImage*)ni2
                                         forPressedImage:(UIImage*)pi
                                        forEnabledImage1:(UIImage*)ei1
                                        forEnabledImage2:(UIImage*)ei2
                                                 forIcon:(UIImage*)ic;


@end
