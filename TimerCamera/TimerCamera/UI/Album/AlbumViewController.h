//
//  AlbumViewController.h
//  TimerCamera
//
//  Created by lijinxin on 13-1-14.
//
//

#import <UIKit/UIKit.h>
#import "AssetImagePickerTarget.h"
#import "AlbumImagePickerView.h"
#import "CustomizedUIImagePickerController.h"

@interface AlbumViewController : UIViewController <AssetImagePickerTargetDelegate, ImagePickerViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    AssetImagePickerTarget* _target;
    AlbumImagePickerView* _assetPicker;
    UIImageView* _albumCoverImageView;
    UIViewController* _callerController;
    TipsView* _tipsView;
    
    CustomizedUIImagePickerController* _imagePickerController;
    BOOL _assetFailed;
}

- (void)showAlbumWithAnimation;
- (void)showAlbumWithAnimationAndReleaseCaller:(UIViewController*)caller;
- (void)hideAlbumWithAnimation;
- (void)hideAlbumWithAnimationAndDoBlock:(void (^)(void))block
                         withFinishBlock:(void (^)(void))finishBlock;

@end