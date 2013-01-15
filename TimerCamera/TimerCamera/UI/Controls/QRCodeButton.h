//
//  QRCodeButton.h
//  TimerCamera
//
//  Created by lijinxin on 13-1-14.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"
#import "QRCodeNormalStateAnimationView.h"

@interface QRCodeButton : CommonAnimationButton
{
    QRCodeNormalStateAnimationView* _QRCodeView;
}

- (id)initQRCodeButtonWithFrame:(CGRect)frame
                forNormalImage1:(UIImage*)ni1
                forNormalImage2:(UIImage*)ni2
                  forWaterImage:(UIImage*)wi
                forPressedImage:(UIImage*)pi;

+ (QRCodeButton*)QRCodebuttonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                                 forNormalImage2:(UIImage*)ni2
                                                   forWaterImage:(UIImage*)wi
                                                 forPressedImage:(UIImage*)pi;

@end
