//
//  QRCodeNormalStateAnimationView.h
//  TimerCamera
//
//  Created by lijinxin on 13-1-16.
//
//

#import <UIKit/UIKit.h>
#import "AlphaAnimationView.h"

#define kDefaultQRCodeStateAnimationInterval (8.0)

@interface QRCodeNormalStateAnimationView : AlphaAnimationView
{
    UIImageView* _waterView;
}

- (void)setWaterImage:(UIImage*)image;

@end
