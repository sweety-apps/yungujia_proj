//
//  QRCodeScannerViewController.h
//  TimerCamera
//
//  Created by lijinxin on 13-3-10.
//
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import "TipsView.h"
#import "CommonAnimationButton.h"
#import "ShotButton.h"
#import "MessageBoxView.h"

#define kBGColor()  [UIColor colorWithRed:(140.0/255.0) green:(200.0/255.0) blue:(0.0/255.0) alpha:1.0]

typedef enum eQRCodeResultStringType{
    kQRRT_NormalText = 0,
    kQRRT_Url = 1,
    kQRRT_Email = 2,
    kQRCodeResultStringTypeCount,
}QRCodeResultStringType;

@interface QRCodeScannerViewController : ZXingWidgetController <BaseMessageBoxViewDelegate, ZXingDelegate>
{
    TipsView* _tipsView;
    CommonAnimationButton* _torchButton;
    ShotButton* _backButton;
    UIImageView* _frameImageView;
    UIImageView* _frameBackgroundView;
    UIImageView* _frameBackgroundUpFillView;
    UIImageView* _frameBackgroundDownFillView;
    UIView* _bottomGreenView;
    UIViewController* _ctrlToReleaseAfterShowed;
    BOOL _shouldShowAfterAppear;
    
    QRCodeResultStringType _scanResultType;
}

- (void)showControlsWithAnimationAndReleaseController:(UIViewController*)caller;
- (void)hideControlsWithAnimationAndCallCamera;

@end
