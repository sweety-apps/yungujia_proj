//
//  CameraCoverViewController.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-24.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"
#import "CommonAnimationTripleStateButton.h"
#import "TimerButton.h"
#import "VolumeMonitor.h"
#import "ShotButton.h"
#import "BlackCat.h"
#import "AudioUtility.h"
#import "BaseCameraLogicViewController.h"
#import "QRCodeButton.h"
#import "TipsView.h"
#import "FocusAimer.h"
#import "ConfigButton.h"
#import "EmiterCoverView.h"
#import "CountView.h"
#import "MessageBoxView.h"

@interface CameraCoverViewController : BaseCameraLogicViewController <AudioUtilityPlaybackDelegate, AudioUtilityVolumeDetectDelegate, BaseMessageBoxViewDelegate>
{
    //Animation Views
    ShotButton* _shotButton;
    TimerButton* _timerButton;
    VolumeMonitor* _volMonitor;
    ConfigButton* _configButton;
    CommonAnimationTripleStateButton* _torchButton;
    CommonAnimationButton* _frontButton;
    CommonAnimationButton* _albumButton;
    BlackCat* _animationCatButton;
    QRCodeButton* _QRCodeButton;
    TipsView* _tipsView;
    CountView* _countView;
    
    EmiterCoverView* _flipEmitterCover;
    
    NSTimer* _preStartTimingTimer;
    FocusAimer* _focusView;
    BOOL _isFlipingCamera;
    CGRect _albumRawRect;
}



- (void)showSubViews:(BOOL)animated delayed:(float)seconds;
- (void)showSubViews:(BOOL)animated;
- (void)hideSubViews:(BOOL)animated;

- (void)resetStatus;

@end
