//
//  AlbumImagePickerView.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-8.
//
//

#import <UIKit/UIKit.h>
#import "ImagePickerView.h"
#import "CommonAnimationButton.h"

@interface AlbumImagePickerView : ImagePickerView
{
    CommonAnimationButton* _cameraBtn;
    CommonAnimationButton* _editorBtn;
    CommonAnimationButton* _menuBtn;
    UIImage* _borderImage;
    UIImage* _selectedImage;
    UILabel* _noImageNotifyLbl;
}

-       (id)initWithFrame:(CGRect)frame
                andTarget:(id<IImagePickerTarget>)target
              andDelegate:(id<ImagePickerViewDelegate>)pickerDelegate
             cameraButton:(CommonAnimationButton*)cameraBtn
             editorButton:(CommonAnimationButton*)editorBtn
               menuButton:(CommonAnimationButton*)menuBtn
         imageBorderImage:(UIImage*)borderImg
 imageBorderSelectedImage:(UIImage*)borderSelectedImg;


+ (AlbumImagePickerView*)albumImagePickerWitWithFrame:(CGRect)frame
                                            andTarget:(id<IImagePickerTarget>)target
                                          andDelegate:(id<ImagePickerViewDelegate>)pickerDelegate
                                         cameraButton:(CommonAnimationButton*)cameraBtn
                                         editorButton:(CommonAnimationButton*)editorBtn
                                           menuButton:(CommonAnimationButton*)menuBtn
                                     imageBorderImage:(UIImage*)borderImg
                             imageBorderSelectedImage:(UIImage*)borderSelectedImg;

@end
