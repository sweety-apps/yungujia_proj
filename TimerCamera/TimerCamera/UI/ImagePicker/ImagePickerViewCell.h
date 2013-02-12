//
//  ImagePickerViewCell.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-5.
//
//

#import <UIKit/UIKit.h>

@interface ImagePickerViewCell : UIView
{
    UIView* _containerView;
    UIImageView* _imageView;
    UIImageView* _coverImage;
    UILabel* _label;
}

@property (retain, nonatomic) UIView* containerView;
@property (retain, nonatomic) UIImageView* imageView;
@property (retain, nonatomic) UIImageView* coverImage;
@property (retain, nonatomic) UILabel* label;


@end
