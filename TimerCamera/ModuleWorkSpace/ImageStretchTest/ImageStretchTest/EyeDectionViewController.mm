//
//  EyeDectionViewController.m
//  ImageStretchTest
//
//  Created by lijinxin on 13-3-29.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#import "EyeDectionViewController.h"
#import <opencv.hpp>
#import <opencv2/highgui/cap_ios.h>

using namespace cv;

@interface EyeDectionViewController (opencvCamera) <CvVideoCameraDelegate>

@property (retain,nonatomic) CvVideoCamera* videoCamera;

@end

@implementation EyeDectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    _imageView = [[UIImageView alloc] initWithFrame:rect];
    [self.view addSubview:_imageView];
    
    self.videoCamera = nil;
    CvVideoCamera* _tvideoCamera = [[CvVideoCamera alloc] initWithParentView:_imageView];
    self.videoCamera = _tvideoCamera;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    //self.videoCamera.grayscale = NO;
    
    [self.videoCamera start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.videoCamera = nil;
    [super dealloc];
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    // Do some OpenCV stuff with the image
    Mat image_copy;
    cvtColor(image, image_copy, CV_BGRA2BGR);
    
    // invert image
    bitwise_not(image_copy, image_copy);
    cvtColor(image_copy, image, CV_BGR2BGRA);
}
#endif

#pragma mark - property re-defines

- (CvVideoCamera *)videoCamera
{
    return (CvVideoCamera *)_cvObject;
}

- (void)setVideoCamera:(CvVideoCamera *)videoCamera
{
    [videoCamera retain];
    [_cvObject release];
    _cvObject = videoCamera;
}

@end
