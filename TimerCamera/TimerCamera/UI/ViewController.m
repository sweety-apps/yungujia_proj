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

@synthesize containerView = _containerView;
@synthesize picutureView = _picutureView;
@synthesize shotBtn = _shotBtn;
@synthesize flashBtn = _flashBtn;
@synthesize positionBtn = _positionBtn;
@synthesize optionBtn = _optionBtn;
@synthesize bottomBar = _bottomBar;
@synthesize tipLabel = _tipLabel;

@synthesize tapGesture = _tapGesture;
@synthesize pinchGesture = _pinchGesture;

@synthesize imageSaveQueue = _imageSaveQueue;

@synthesize currentScale = _currentScale;

@synthesize peakView = _peakView;
@synthesize volView = _volView;

#pragma mark - Animation Views

- (void)createSubViews
{
    CGRect rect = CGRectZero;
    
    _animationCatButton = [CommonAnimationButton
                           buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_with_eye"]
                           forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_with_eye"]
                           forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]
                           forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]
                           forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]];
    rect = _animationCatButton.frame;
    rect.origin.x = 122;
    rect.origin.y = _containerView.frame.size.height - 82;
    _animationCatButton.frame = rect;
    [_containerView addSubview:_animationCatButton];
    
    
    _shotButton = [CommonAnimationButton
                   buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal1"]
                   forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal2"]
                   forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_pressed"]
                   forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal1"]
                   forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal2"]];
    rect = _shotButton.frame;
    rect.origin.x = _containerView.frame.size.width - rect.size.width;
    rect.origin.y = _containerView.frame.size.height - rect.size.height;
    _shotButton.frame = rect;
    [_containerView addSubview:_shotButton];
    
    
    _timerButton = [CommonAnimationButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_pressed"]
                    forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_enable1"]
                    forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_enable2"]];
    rect = _timerButton.frame;
    rect.origin.x = 0;
    rect.origin.y = _containerView.frame.size.height - rect.size.height;
    _timerButton.frame = rect;
    [_containerView addSubview:_timerButton];
    
    
    _configButton = [CommonAnimationButton
                   buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal1"]
                   forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal2"]
                   forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_pressed"]
                   forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal1"]
                   forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal2"]];
    rect = _configButton.frame;
    rect.origin.x = 0;
    rect.origin.y = 50;
    _configButton.frame = rect;
    [_containerView addSubview:_configButton];
    
    
    _torchButton = [CommonAnimationButton
                   buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_normal1"]
                   forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_normal2"]
                   forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/torch_pressed"]
                   forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable1"]
                   forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable2"]];
    rect = _torchButton.frame;
    rect.origin.x = _containerView.frame.size.width - rect.size.width;
    rect.origin.y = 49;
    _torchButton.frame = rect;
    [_containerView addSubview:_torchButton];
    
    
    _HDRButton = [CommonAnimationButton
                  buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/HDR_normal1"]
                  forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/HDR_normal2"]
                  forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/HDR_pressed"]
                  forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/HDR_enable1"]
                  forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/HDR_enable2"]];
    rect = _HDRButton.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _HDRButton.frame = rect;
    [_containerView addSubview:_HDRButton];
    
    
    _frontButton = [CommonAnimationButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/front_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/front_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/front_pressed"]
                    forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/front_normal1"]
                    forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/front_normal2"]];
    rect = _frontButton.frame;
    rect.origin.x = _containerView.frame.size.width - rect.size.width;
    rect.origin.y = 0;
    _frontButton.frame = rect;
    [_containerView addSubview:_frontButton];
}

- (void)destorySubViews
{
    [_shotButton removeFromSuperview];
    _shotButton = nil;
    [_timerButton removeFromSuperview];
    _timerButton = nil;
    [_configButton removeFromSuperview];
    _configButton = nil;
    [_torchButton removeFromSuperview];
    _torchButton = nil;
    [_HDRButton removeFromSuperview];
    _HDRButton = nil;
    [_frontButton removeFromSuperview];
    _frontButton = nil;
    [_animationCatButton removeFromSuperview];
    _animationCatButton = nil;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _picutureView.hidden = YES;
    
    self.imageSaveQueue = [NSMutableArray array];
    
    [CameraOptions sharedInstance].imagePicker.delegate = self;
    [self.view addSubview:[CameraOptions sharedInstance].imagePicker.view];
    [_containerView retain];
    [_containerView removeFromSuperview];
    [CameraOptions sharedInstance].imagePicker.cameraOverlayView = _containerView;
    [_containerView release];
    [CameraOptions sharedInstance].imagePicker.view.frame = self.view.frame;
    
    _lastScale = 1.0;
    _currentScale = 1.0;
    
    _tipLabel.text = @"";
    
    //[NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(detectCameraSize) userInfo:nil repeats:YES];
    [self createSubViews];
}

- (void)dealloc
{
    self.imageSaveQueue = nil;
    
    [self destorySubViews];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.imageSaveQueue = nil;
    
    [self destorySubViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)detectCameraSize
{
    CGAffineTransform af = [CameraOptions sharedInstance].imagePicker.cameraViewTransform;
    NSLog(@"CameraSize = ( %f , %f , %f , %f , %f , %f )",af.a,af.b,af.c,af.d,af.tx,af.ty);
}

#pragma mark - UIImagePickerControllerDelegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"Picture Saved!");
    [self.imageSaveQueue removeObject:image];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"OH YEAH!!! Take a pic, size = (%f,%f)",image.size.width, image.size.height);
    _picutureView.hidden = NO;
    _picutureView.image = image;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    return;
    
    NSLog(@"OH YEAH!!! Take a Media");
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"OH YEAH!!! Take a pic, size = (%f,%f)",image.size.width, image.size.height);
    _picutureView.hidden = NO;
    _picutureView.image = image;
    
    [self.imageSaveQueue addObject:image];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //save jpeg photo
    if (0)
    {
        NSData* jpg = UIImageJPEGRepresentation(image, 1.0);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"OH NO!!! Picture Take Cancelled");
}

#pragma mark - UINavigationControllerDelegate

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

#pragma mark - UI Event Handle

- (IBAction)OnClickedShot:(id)sender
{
    if (_timer)
    {
        //[_timer restartTimerWithConfigInterval];
    }
    else
    {
        _timer = [ShotTimer timerStartWithConfigIntervalForDelegate:self];
    }
}

- (IBAction)OnClickedLight:(id)sender
{
    if ([CameraOptions sharedInstance].flash == AVCaptureFlashModeOn)
    {
        [CameraOptions sharedInstance].flash = AVCaptureFlashModeOff;
    }
    else
    {
        [CameraOptions sharedInstance].flash = AVCaptureFlashModeOn;
    }
}

- (IBAction)OnClickedTorch:(id)sender
{
    if ([CameraOptions sharedInstance].light == AVCaptureTorchModeOn)
    {
        [CameraOptions sharedInstance].light = AVCaptureTorchModeOff;
    }
    else
    {
        [CameraOptions sharedInstance].light = AVCaptureTorchModeOn;
    }
}

- (IBAction)OnClickedHDR:(id)sender
{
    if ([CameraOptions sharedInstance].hdr == AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance)
    {
        [CameraOptions sharedInstance].hdr = AVCaptureWhiteBalanceModeLocked;
    }
    else
    {
        [CameraOptions sharedInstance].hdr = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
    }
    
}

- (IBAction)OnClickedFront:(id)sender
{
    if ([CameraOptions sharedInstance].imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        [CameraOptions sharedInstance].imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    else
    {
        [CameraOptions sharedInstance].imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
}

#pragma mark - Animations

- (void)PrepareLoadingAnimation
{
    [self onFinishedLoadingAnimation:_laiv];
    _laiv = [[LoadingAnimateImageView viewWithDelegate:self image:[UIImage imageNamed:@"/Resource/Picture/camera_open"] forTimeInterval:1.0 preLoadImage:[UIImage imageNamed:@"Default"] forPreloadAnimateInterval:0.3] retain];
    if (_laiv)
    {
        [self.view addSubview:_laiv];
        [self.view bringSubviewToFront:_laiv];
    }
}

- (void)ShowLoadingAnimation
{
    
    if (_laiv)
    {
        [self.view bringSubviewToFront:_laiv];
        [_laiv startPreloadingAnimation];
        [_laiv startLoadingAnimation];
    }
}

#pragma mark LoadingAnimateImageViewDelegate

- (void)onFinishedLoadingAnimation:(LoadingAnimateImageView*)view
{
    [_laiv removeFromSuperview];
    ReleaseAndNil(_laiv);
}

#pragma mark - test code

- (IBAction)OnClickedVolume:(id)sender
{
    [[AudioUtility sharedInstance] setVolumeDetectingDelegate:self];
    [[AudioUtility sharedInstance] startDetectingVolume:0.5];
}

- (IBAction)OnClickedSound:(id)sender
{
    NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/Resource/Sound/long_low_short_high.caf"];
    [[AudioUtility sharedInstance] playFile:filePath withDelegate:self];
}

- (void)test
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum/*UIImagePickerControllerSourceTypePhotoLibrary*/]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//UIImagePickerControllerSourceTypeSavedPhotosAlbum;//
        imagePicker.delegate = self;
        [imagePicker setAllowsEditing:YES];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        //self.popoverController = popover;
        [popover presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[popover release];
        [imagePicker release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)onTest:(id)sender
{
    [self test];
    return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//UIImagePickerControllerSourceTypeCamera;//UIImagePickerControllerSourceTypePhotoLibrary;//
    
    ipc.delegate = self;
    
    ipc.allowsEditing = YES;
    
    ipc.videoQuality = UIImagePickerControllerQualityTypeMedium;
    
    ipc.videoMaximumDuration = 30.0f; // 30 seconds
    
    ///ipc.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    
    //主要是下边的两能数，@"public.movie", @"public.image"  一个是录像，一个是拍照
    
    ipc.mediaTypes = [NSArray arrayWithObjects:@"public.movie", @"public.image", nil];
    
    //ipc.showsCameraControls = NO;
    
    [self presentModalViewController:ipc animated:NO];
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

#pragma mark - UIGestureRecognizer Handlers

-(IBAction)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        CGPoint pt = [gestureRecognizer locationInView:_containerView];
        NSLog(@"Get a touch ( %f , %f )",pt.x,pt.y);
        pt.x /= self.view.frame.size.width;
        pt.y /= self.view.frame.size.height;
        NSLog(@"Location touch ( %f , %f )",pt.x,pt.y);
        [CameraOptions sharedInstance].exporePoint = pt;
        [CameraOptions sharedInstance].focusPoint = pt;
    }
}

-(IBAction)handlePinchGesture:(UIPinchGestureRecognizer*)gestureRecognizer
{
    //当手指离开屏幕时,将lastscale设置为1.0
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [gestureRecognizer scale]);
    self.currentScale = scale;
    
    _lastScale = [gestureRecognizer scale];
}

#pragma mark - properties re-define

- (void)setCurrentScale:(CGFloat)currentScale
{
    CGFloat scale = currentScale;
    CGAffineTransform currentTransform = [CameraOptions sharedInstance].imagePicker.cameraViewTransform;
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    if (newTransform.a > [CameraOptions sharedInstance].maxScale)
    {
        newTransform.a = [CameraOptions sharedInstance].maxScale;
        newTransform.d = [CameraOptions sharedInstance].maxScale;
    }
    if (newTransform.a < [CameraOptions sharedInstance].minScale)
    {
        newTransform.a = [CameraOptions sharedInstance].minScale;
        newTransform.d = [CameraOptions sharedInstance].minScale;
    }
    
    [CameraOptions sharedInstance].imagePicker.cameraViewTransform = newTransform;
    _currentScale = newTransform.a;
}

#pragma mark - AudioUtilityVolumeDetectDelegate

#define kVolLength (145)

- (void)onDetected:(float)currentVolume
        peakVolume:(float)peakVolume
        higherThan:(float)detectVolume
       forInstance:(AudioUtility*)util
{
    NSLog(@"[PEAK] Reached Peak!");
    [[AudioUtility sharedInstance] stopDectingVolume];
    [self OnClickedShot:nil];
}

- (void)onUpdate:(float)currentVolume
      peakVolume:(float)peakVolume
     forInstance:(AudioUtility*)util
{
    CGRect rct = {0};
    //vol
    rct = _volView.frame;
    rct.size.height = currentVolume * kVolLength;
    _volView.frame = rct;
    
    //peak
    rct = _peakView.frame;
    rct.origin.y = peakVolume * kVolLength;
    _peakView.frame = rct;
}

#pragma mark - AudioUtilityPlaybackDelegate

- (void)onStartPlayFile:(NSString*)filePath
            forInstance:(AudioUtility*)util
{
    
}

- (void)onFinishedPlayFile:(NSString*)filePath
               forInstance:(AudioUtility*)util
{
    
}

#pragma mark - ShotTimerDelegate

- (void)onInterval:(float)leftTimeInterval forTimer:(ShotTimer*)timer
{
    if (leftTimeInterval > 0.0)
    {
        [self OnClickedSound:nil];
    }
    _tipLabel.text = [NSString stringWithFormat:@"%.0f",leftTimeInterval];
    NSLog(@"[TIMER LEFT] %0.f sec",leftTimeInterval);
}

- (void)onFinishedTimer:(ShotTimer*)timer
{
    _timer = nil;
    [[CameraOptions sharedInstance].imagePicker takePicture];
}

@end
