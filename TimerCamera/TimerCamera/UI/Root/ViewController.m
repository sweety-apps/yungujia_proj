//
//  ViewController.m
//  TimerCamera
//
//  Created by lijinxin on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (_coverController == nil)
    {
        _coverController = [[CameraCoverViewController alloc] init];
    }
    
    //[CameraOptions sharedInstance].imagePicker.delegate = self;
    //[self.view addSubview:[CameraOptions sharedInstance].imagePicker.view];
    //[CameraOptions sharedInstance].imagePicker.cameraOverlayView = _containerView;
    [self.view addSubview:_coverController.view];
    //[_coverController.view addGestureRecognizer:_tapGesture];
    //[_coverController.view addGestureRecognizer:_pinchGesture];
    //_tapGesture.cancelsTouchesInView = NO;
    //[CameraOptions sharedInstance].imagePicker.view.frame = self.view.frame;
    
    //[NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(detectCameraSize) userInfo:nil repeats:YES];
}

- (void)dealloc
{
    [_coverController.view removeFromSuperview];
    ReleaseAndNil(_coverController);
    
    [_albumController.view removeFromSuperview];
    ReleaseAndNil(_albumController);
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [_coverController.view removeFromSuperview];
    ReleaseAndNil(_coverController);
    
    [_albumController.view removeFromSuperview];
    ReleaseAndNil(_albumController);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Animations

- (void)PrepareLoadingAnimation
{
    [self onFinishedLoadingAnimation:_laiv];
    _laiv = [[LoadingAnimateImageView viewWithDelegate:self image:[UIImage imageNamed:@"/Resource/Picture/camera_open"] forTimeInterval:0.8 preLoadImage:[UIImage imageNamed:@"Default"] forPreloadAnimateInterval:0.2] retain];
    if (_laiv)
    {
        [self.view addSubview:_laiv];
        [self.view bringSubviewToFront:_laiv];
    }
    
    CGRect rect = CGRectZero;
    rect.size = self.view.frame.size;
    _coverController.view.frame = rect;
    [_coverController hideSubViews:NO];
    
    [_coverController resetStatus];
}

- (void)ShowLoadingAnimation
{
    if (_laiv)
    {
        [self.view bringSubviewToFront:_laiv];
        [_laiv startPreloadingAnimation];
        [_laiv startLoadingAnimation];
    }
    
    [_coverController showSubViews:YES delayed:0.7];
}

#pragma mark LoadingAnimateImageViewDelegate

- (void)onFinishedLoadingAnimation:(LoadingAnimateImageView*)view
{
    ReleaseAndNilView(_laiv);
    
    //[_coverController showSubViews:YES];
}

#pragma mark Controller Caller

- (void)showAlbum
{
    if (!_albumController)
    {
        _albumController = [[AlbumViewController alloc] init];
    }
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    _albumController.view.frame = rect;
    [self.view addSubview:_albumController.view];
    [_albumController showAlbumWithAnimation];
}

@end
