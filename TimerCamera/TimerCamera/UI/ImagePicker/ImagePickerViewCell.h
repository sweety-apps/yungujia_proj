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
    UIImageView* _imageView;
    UIImageView* _coverImage;
    UILabel* _label;
}

@property (assign, nonatomic) UIImageView* imageView;
@property (assign, nonatomic) UIImageView* coverImage;
@property (assign, nonatomic) UILabel* label;


@end
