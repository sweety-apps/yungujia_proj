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
#define TIPS_LAST_DEFAULT_SECONDS (1.6)
#define TIPS_VIEW_DEFAULT_WIDTH (170)
#define TIPS_LABEL_TOP_PADDING (20.0)
#define TIPS_LABEL_BOTTOM_PADDING (17.0)
#define TIPS_LABEL_LEFT_PADDING (15.0)
#define TIPS_LABEL_RIGHT_PADDING (15.0)

@interface TipsView : UIStateAnimationView <UIStateAnimation>
{
    UIView* _currentSuperView;
    UIView* _containerView;
    UILabel* _tipsLabel;
    UIImageView* _pushHandImageView;
    UIImageView* _tipsBackGroundImageView;
    float _currentLastSeconds;
    NSTimer* _showingTimer;
    NSMutableArray* _tipsContentStringArray;
    CGFloat _tipsViewMaxWidth;
    
    CGRect _pushHandRect;
    CGRect _bgRect;
    CGRect _labelRect;
    CGRect _selfRect;
}

@property (nonatomic,assign) CGFloat tipsViewMaxWidth;

+ (TipsView*)sharedInstance;
+ (TipsView*)tipsViewWithPushHand:(UIImage*)pushHandImage
                  backGroundImage:(UIImage*)bgImage;
- (TipsView*)initWithPushHand:(UIImage*)pushHandImage
              backGroundImage:(UIImage*)bgImage;

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
