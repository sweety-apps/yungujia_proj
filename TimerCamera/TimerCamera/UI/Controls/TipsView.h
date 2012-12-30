//
//  TipsView.h
//  TimerCamera
//
//  Created by lijinxin on 12-12-31.
//
//

#import <UIKit/UIKit.h>
#import "UIStateAnimationView.h"
#import "ShotTimer.h"

#define TIPS_LAST_INFINITE (-1.0)
#define TIPS_LAST_DEFAULT_SECONDS (2.0)

@interface TipsView : UIStateAnimationView <UIStateAnimation,ShotTimerDelegate>
{
    UIView* _currentSuperView;
    UILabel* _tipsLabel;
    float _currentLastSeconds;
    ShotTimer* _showingTimer;
}

+ (TipsView*)sharedInstance;

- (void)setPushHandImage:(UIImage*)image;

- (void)setTipsBackGroundImage:(UIImage*)image;

- (UILabel*)getTipsLabel;

- (void)showTips:(NSString*)tipsContent
            over:(UIView*)superView
            last:(float)seconds;

- (void)showTips:(NSString*)tipsContent
            over:(UIView*)superView;

- (void)showOverWindowTips:(NSString*)tipsContent
                      last:(float)seconds;

- (void)showOverWindowTips:(NSString*)tipsContent;

@end
