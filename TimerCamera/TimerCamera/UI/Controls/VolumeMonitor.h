//
//  VolumeMonitor.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"

@interface VolumeMonitor : UIStateAnimationView <UIStateAnimation>
{
    CommonAnimationButton* _barButton;
    UIImageView* _backGroudView;
    UIImageView* _volumeView;
    float _currentVolme;
    float _peakVolume;
    float _minPeakVolume;
    BOOL _draging;
}

@property (nonatomic,retain) CommonAnimationButton* barButton;
@property (nonatomic,assign) float currentVolume; //0-1.0
@property (nonatomic,assign) float peakVolume;  //0-1.0
@property (nonatomic,assign) float minPeakVolume;  //0-1.0


- (id)initWithFrame:(CGRect)frame
      withBarButton:(CommonAnimationButton*)barButton
    backGroundImage:(UIImage*)bgi
        volumeImage:(UIImage*)vi;

+ (VolumeMonitor*)buttonWithBarButton:(CommonAnimationButton*)barButton
    backGroundImage:(UIImage*)bgi
        volumeImage:(UIImage*)vi;

- (void)showMonitor:(BOOL)animated;
- (void)hideMonitor:(BOOL)animated;
- (BOOL)isDragingBar;
- (void)transToMonitorState;
- (void)transToHoldingState;

@end
