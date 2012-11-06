//
//  CameraOptions.h
//  TimerCamera
//
//  Created by Lee Justin on 12-9-10.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Configure.h"

@interface CameraOptions : NSObject
{
    UIImagePickerController* _imagePicker;
    AVCaptureTorchMode _light;
    AVCaptureFlashMode _flash;
    AVCaptureFocusMode _focus;
    AVCaptureWhiteBalanceMode _hdr;
    AVCaptureExposureMode _exposureMode;
    
    CGPoint _exporePoint;
    CGPoint _focusPoint;
    
    CGFloat _maxScale;
    CGFloat _minScale;
    
    BOOL _isFlashAndLightAvailible;
}

+(CameraOptions*)sharedInstance;

-(void)restoreState;

@property (nonatomic,retain) UIImagePickerController* imagePicker;
@property (nonatomic,assign) AVCaptureTorchMode light;
@property (nonatomic,assign) AVCaptureFlashMode flash;
@property (nonatomic,assign) AVCaptureFocusMode focus;
@property (nonatomic,assign) AVCaptureWhiteBalanceMode hdr;
@property (nonatomic,assign) AVCaptureExposureMode exposureMode;
@property (nonatomic,assign) CGPoint exporePoint;
@property (nonatomic,assign) CGPoint focusPoint;
@property (nonatomic,assign,readonly) CGFloat maxScale;
@property (nonatomic,assign,readonly) CGFloat minScale;

@property (nonatomic,assign,readonly) BOOL isFlashAndLightAvailible;

-(AVCaptureDevice*)currentDevice;
-(AVCaptureDevice*)configurableDevice;

@end
