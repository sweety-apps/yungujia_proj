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
    UIImageView* _grayCover;
    UILabel* _label;
    UIButton* _selectedBtn;
    float _imageBorderWidth;
}

@property (assign, nonatomic) UIImageView* imageView;
@property (assign, nonatomic) UIImageView* grayCover;
@property (assign, nonatomic) UILabel* label;
@property (assign, nonatomic) UIButton* selectedBtn;
@property (assign, nonatomic) float imageBorderWidth;


@end
