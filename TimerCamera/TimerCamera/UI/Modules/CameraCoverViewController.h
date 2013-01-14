//
//  CameraCoverViewController.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-24.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"
#import "TimerButton.h"
#import "VolumeMonitor.h"
#import "ShotButton.h"
#import "BlackCat.h"
#import "AudioUtility.h"
#import "BaseCameraLogicViewController.h"
#import "TipsView.h"
#import "FocusAimer.h"

@interface CameraCoverViewController : BaseCameraLogicViewController <AudioUtilityPlaybackDelegate, AudioUtilityVolumeDetectDelegate>
{
    //Animation Views
    ShotButton* _shotButton;
    TimerButton* _timerButton;
    VolumeMonitor* _volMonitor;
    CommonAnimationButton* _configButton;
    CommonAnimationButton* _torchButton;
    CommonAnimationButton* _HDRButton;
    CommonAnimationButton* _frontButton;
    CommonAnimationButton* _albumButton;
    BlackCat* _animationCatButton;
    TipsView* _tipsView;
    
    NSTimer* _preStartTimingTimer;
    FocusAimer* _focusView;
    BOOL _isFlipingCamera;
    CGRect _albumRawRect;
}



- (void)showSubViews:(BOOL)animated delayed:(float)seconds;
- (void)showSubViews:(BOOL)animated;
- (void)hideSubViews:(BOOL)animated;

- (void)resetStatus;

- (void)startTiming;
- (void)endTiming;

@end
