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

@interface AlbumViewController : UIViewController <AssetImagePickerTargetDelegate, ImagePickerViewDelegate>
{
    AssetImagePickerTarget* _target;
    AlbumImagePickerView* _assetPicker;
}

- (void)showAlbumWithAnimation;
- (void)hideAlbumWithAnimation;

@end