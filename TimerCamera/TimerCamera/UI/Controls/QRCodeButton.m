//
//  QRCodeButton.m
//  TimerCamera
//
//  Created by lijinxin on 13-1-14.
//
//

#import "QRCodeButton.h"

#define BUTTON_RECT CGRectMake(1,26,61,55)

@implementation QRCodeButton

- (id)initQRCodeButtonWithFrame:(CGRect)frame
                forNormalImage1:(UIImage*)ni1
                forNormalImage2:(UIImage*)ni2
                  forWaterImage:(UIImage*)wi
                forPressedImage:(UIImage*)pi
{
    _disableStateWhenInit = YES;
    self = [super initWithFrame:frame
                forNormalImage1:ni1
                forNormalImage2:ni2
                forPressedImage:pi
               forEnabledImage1:ni1
               forEnabledImage2:ni2];
    if (self)
    {
        CGRect rect = frame;
        rect.origin = CGPointMake(0, 0);
        _QRCodeView = [[QRCodeNormalStateAnimationView alloc] initWithFrame:rect];
        [_QRCodeView setImage1:ni1];
        [_QRCodeView setImage2:ni2];
        [_QRCodeView setWaterImage:wi];
        ReleaseAndNilView(_normalView);
        ReleaseAndNilView(_enabledView);
        _normalView = _QRCodeView;
        _enabledView = [_QRCodeView retain];
        
        [self setAnimation:_normalView andView:_normalView forState:@"normal"];
        [self setAnimation:_enabledView andView:_enabledView forState:@"enabled"];
        
        [self setCurrentState:@"normal"];
        self.button.frame = BUTTON_RECT;
    }
    return self;
}

+ (QRCodeButton*)QRCodebuttonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                                 forNormalImage2:(UIImage*)ni2
                                                   forWaterImage:(UIImage*)wi
                                                 forPressedImage:(UIImage*)pi
{
    CGRect rect = CGRectMake(0, 0, pi.size.width, pi.size.height);
    return [[[QRCodeButton alloc] initQRCodeButtonWithFrame:rect
                                            forNormalImage1:ni1
                                            forNormalImage2:ni2
                                              forWaterImage:wi
                                            forPressedImage:pi] autorelease];
}

- (void)onReleased:(id)sender
{
    self.buttonEnabled = _buttonEnabled;
}

@end
