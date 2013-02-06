//
//  ImagePickerView.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-3.
//
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "IImagePickerTarget.h"
#import "ImagePickerViewCell.h"

@class ImagePickerView;

@protocol ImagePickerViewDelegate <NSObject>

- (void)onPickedImage:(UIImage*)image forView:(ImagePickerView*)pickerView;
- (void)onCancelledPick:(ImagePickerView*)pickerView;

@end

@interface ImagePickerView : UIView <iCarouselDataSource, iCarouselDelegate>
{
    id<IImagePickerTarget> _target;
    id<ImagePickerViewDelegate> _pickerDelegate;
    iCarousel* _carouselView;
    CGSize _imageViewSize;
    BOOL _imageViewUseBounds;
}

@property (nonatomic, retain) id<IImagePickerTarget> target;
@property (nonatomic, assign) id<ImagePickerViewDelegate> pickerDelegate;

@property (nonatomic, assign) CGSize imageViewSize;
@property (nonatomic, assign) BOOL imageViewUseBounds;

- (id)initWithFrame:(CGRect)frame
          andTarget:(id<IImagePickerTarget>)target
        andDelegate:(id<ImagePickerViewDelegate>)pickerDelegate;

+ (ImagePickerView*)imagePickerWitWithFrame:(CGRect)frame
                                  andTarget:(id<IImagePickerTarget>)target
                              andDelegate:(id<ImagePickerViewDelegate>)pickerDelegate;

- (void)reloadData;

@end
