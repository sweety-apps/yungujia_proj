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
    
    UIView* _viewToInsertBelow;
    BOOL _waitForPunchAnimation;
    
    CustomizedUIImagePickerController* _imagePickerController;
    BOOL _assetFailed;
}

- (void)showAlbumWithAnimation;
- (void)showAlbumWithAnimationAndReleaseCaller:(UIViewController*)caller;
- (void)showAlbumWithoutAnimationAndReleaseCaller:(UIViewController*)caller;
- (void)hideAlbumWithAnimation;
- (void)hideAlbumWithAnimationAndDoBlock:(void (^)(void))block
                         withFinishBlock:(void (^)(void))finishBlock;

+ (void)startTrackTouchSlideForView:(UIView*)view
                          startRect:(CGRect)sRect
                         acceptRect:(CGRect)aRect
                 onSlideBeginTarget:(id)slideTarget
                    onSlideBeginSel:(SEL)slideSel
             onSlideCancelledTarget:(id)cancelledTarget
                onSlideCancelledSel:(SEL)cancelledSel
                 onWillAcceptTarget:(id)willTarget
                    onWillAcceptSel:(SEL)willSel
                onAcceptTrackTarget:(id)target
                   onAcceptTrackSel:(SEL)sel;
+ (void)stopTrackTouchSlide;

+ (void)enableAlbumPunchAnimationForView:(UIView*)view catRect:(CGRect)rect;
+ (void)removeAlbumPunchAnimation;
+ (BOOL)canPerformPunchAnimation;
+ (BOOL)isAlbumPunchAnimationEnabled;

@end