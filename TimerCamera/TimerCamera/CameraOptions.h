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
}

+(CameraOptions*)sharedInstance;

@property (nonatomic,retain) UIImagePickerController* imagePicker;
@property (nonatomic,assign) AVCaptureTorchMode light;
@property (nonatomic,assign) AVCaptureFlashMode flash;
@property (nonatomic,assign) AVCaptureFocusMode focus;
@property (nonatomic,assign) AVCaptureWhiteBalanceMode hdr;
@property (nonatomic,assign) AVCaptureExposureMode exposureMode;

-(AVCaptureDevice*)currentDevice;
-(AVCaptureDevice*)configurableDevice;

@end
