//
//  BaseCameraLogicViewController.h
//  TimerCamera
//
//  Created by lijinxin on 12-12-4.
//
//

#import <UIKit/UIKit.h>
#import "CameraOptions.h"
#import "AudioUtility.h"
#import "ShotTimer.h"

#define kBGColor()  [UIColor colorWithRed:(140.0/255.0) green:(200.0/255.0) blue:(0.0/255.0) alpha:1.0]

@interface BaseCameraLogicViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, AudioUtilityPlaybackDelegate, AudioUtilityVolumeDetectDelegate, ShotTimerDelegate>
{
    NSMutableArray* _imageSaveQueue;
    
    UITapGestureRecognizer* _tapGesture;
    UIPinchGestureRecognizer* _pinchGesture;
    
    CGFloat _lastScale;
    
    CGFloat _currentScale;
    
    ShotTimer* _timer;
    
    UIImageView* _picturePreview;
    UITapGestureRecognizer* _previewTap;
    
    UIView* _takingPictureFlashEffectView;
    
    BOOL _isTakingPicture;
}

@property (nonatomic,retain) IBOutlet UITapGestureRecognizer* tapGesture;
@property (nonatomic,retain) IBOutlet UIPinchGestureRecognizer* pinchGesture;

@property (nonatomic,retain) NSMutableArray* imageSaveQueue;
@property (nonatomic,assign) CGFloat currentScale;
@property (nonatomic,retain,readonly) ShotTimer* timer;

- (IBAction)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer;
- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer*)gestureRecognizer;

- (void)startTimer:(int)seconds;
- (void)startTimer;
- (void)cancelTimer;
- (void)onInterval:(float)leftTimeInterval forTimer:(ShotTimer*)timer;
- (void)onFinishedTimer:(ShotTimer*)timer;

- (void)takePicture;

- (BOOL)shouldSavePhoto:(UIImage*)image;

- (void)doImageCollectionAnimationFrom:(CGRect)srcRect
                                    to:(CGRect)destRect
                             withImage:(UIImage*)image
                             superView:(UIView*)superView
                    insertAboveSubView:(UIView*)subView
                         animatedBlock:(void (^)(void))animation
                             doneBlock:(void (^)(void))doneBlock
                 shouldFlipRightToLeft:(BOOL)flip
                             useBorder:(BOOL)border;

- (CGRect)getCameraScaledRectWithHeightWidthRatio:(float)ratio;

@end
