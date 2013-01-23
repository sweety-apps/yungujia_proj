//
//  BaseCameraLogicViewController.m
//  TimerCamera
//
//  Created by lijinxin on 12-12-4.
//
//

#import "BaseCameraLogicViewController.h"
#import "Configure.h"

@interface BaseCameraLogicViewController ()

@end

@implementation BaseCameraLogicViewController

@synthesize tapGesture = _tapGesture;
@synthesize pinchGesture = _pinchGesture;

@synthesize imageSaveQueue = _imageSaveQueue;

@synthesize currentScale = _currentScale;

@synthesize timer = _timer;


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = kBGColor();
    
    if (_tapGesture)
    {
        [_tapGesture retain];
    }
    else
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        _tapGesture.delegate = self;
    }
    
    if (_pinchGesture)
    {
        [_pinchGesture retain];
    }
    else
    {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        _pinchGesture.delegate = self;
    }
    
    self.imageSaveQueue = [NSMutableArray array];
    
    [CameraOptions sharedInstance].imagePicker.delegate = self;
    [self.view addSubview:[CameraOptions sharedInstance].imagePicker.view];
    //[CameraOptions sharedInstance].imagePicker.cameraOverlayView = _containerView;
    [self.view addGestureRecognizer:_tapGesture];
    [self.view addGestureRecognizer:_pinchGesture];
    _tapGesture.cancelsTouchesInView = NO;
    [CameraOptions sharedInstance].imagePicker.view.frame = self.view.frame;
    [CameraOptions sharedInstance].exposureMode = AVCaptureExposureModeContinuousAutoExposure;//AVCaptureExposureModeLocked;//
    [CameraOptions sharedInstance].focus = AVCaptureFocusModeContinuousAutoFocus;//AVCaptureFocusModeLocked;//AVCaptureFocusModeContinuousAutoFocus;
    
    _lastScale = 1.0;
    _currentScale = 1.0;
}

- (void)dealloc
{
    ReleaseAndNilView(_picturePreview);
    ReleaseAndNil(_tapGesture);
    ReleaseAndNil(_pinchGesture);
    
    self.imageSaveQueue = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    ReleaseAndNilView(_picturePreview);
    ReleaseAndNil(_tapGesture);
    ReleaseAndNil(_pinchGesture);
    ReleaseAndNilView(_takingPictureFlashEffectView);
    
    self.imageSaveQueue = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark Private Methods

- (void)detectCameraSize
{
    CGAffineTransform af = [CameraOptions sharedInstance].imagePicker.cameraViewTransform;
    NSLog(@"CameraSize = ( %f , %f , %f , %f , %f , %f )",af.a,af.b,af.c,af.d,af.tx,af.ty);
}

- (void)showPreview:(UIImage*)image
{
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    _picturePreview = [[UIImageView alloc] initWithImage:image];
    _picturePreview.userInteractionEnabled = YES;
    //_picturePreview.frame = CGRectZero;
    rect.origin.x = rect.size.width;
    _picturePreview.frame = rect;
    rect.origin.x = 0;
    _previewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePreview)];
    [_picturePreview addGestureRecognizer:_previewTap];
    
    [self.view addSubview:_picturePreview];
    
    [UIView animateWithDuration:0.5 animations:^(){_picturePreview.frame = rect;}];
}

- (void)hidePreview
{
    if (_picturePreview)
    {
        CGRect rect = _picturePreview.frame;
        rect.origin.x = rect.size.width;
        [UIView animateWithDuration:0.8 animations:^(){_picturePreview.frame = rect;} completion:^(BOOL finished){
            [_picturePreview removeGestureRecognizer:_previewTap];
            ReleaseAndNil(_previewTap);
            ReleaseAndNilView(_picturePreview);
        }];
    }
}

- (void)doImageCollectionAnimationFrom:(CGRect)srcRect
                                    to:(CGRect)destRect
                             withImage:(UIImage*)image
                             superView:(UIView*)superView
                    insertAboveSubView:(UIView*)subView
                         animatedBlock:(void (^)(void))animation
                             doneBlock:(void (^)(void))doneBlock
{
    if (subView == nil)
    {
        subView = [CameraOptions sharedInstance].imagePicker.view;
    }
    
    CGRect rect = srcRect;
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imageView.frame = rect;
    //[superView insertSubview:imageView belowSubview:_takingPictureFlashEffectView];
    [superView insertSubview:imageView aboveSubview:subView];
    
    rect.size = destRect.size;
    rect.origin.x = srcRect.origin.x + ((srcRect.size.width - destRect.size.width) * 0.5);
    rect.origin.y = srcRect.origin.y + ((srcRect.size.height - destRect.size.height) * 0.5);
    
    UIView* coverEffectView = _takingPictureFlashEffectView;
    
    void (^takingAnimation)(void) = ^()
    {
        [UIView animateWithDuration:0.2 animations:^(){
            imageView.frame = rect;
            if (animation)
            {
                animation();
            }
        } completion:^(BOOL finshed){
            [UIView animateWithDuration:0.15 animations:^(){
                imageView.frame = destRect;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.15 animations:^(){
                    imageView.alpha = 0.0;
                } completion:^(BOOL finished){
                    [imageView removeFromSuperview];
                    if (doneBlock)
                    {
                        doneBlock();
                    }
                }];
            }];
        }];
    };
    
    if (coverEffectView)
    {
        _takingPictureFlashEffectView = nil;
        CGRect tRect = coverEffectView.frame;
        tRect.origin.x += 2;
        tRect.origin.y += 2;
        tRect.size.width -= 4;
        tRect.size.height -= 4;
        coverEffectView.alpha = 0.65;
        [UIView animateWithDuration:0.25 animations:^(){
            coverEffectView.alpha = 0.25;
        } completion:^(BOOL finished){
            coverEffectView.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^(){
                coverEffectView.frame = tRect;
            } completion:^(BOOL finished){
                takingAnimation();
                [coverEffectView removeFromSuperview];
                [coverEffectView release];
            }];
        }];
    }
    else
    {
        takingAnimation();
    }
}

- (CGRect)getCameraScaledRectWithHeightWidthRatio:(float)ratio
{
    CGRect rect = [CameraOptions sharedInstance].imagePicker.view.frame;
    CGRect tRect = rect;
    float maxWidth = rect.size.height / ratio;
    rect.size.width *= _currentScale;
    rect.size.width = rect.size.width > maxWidth ? maxWidth : rect.size.width;
    rect.size.height = rect.size.width * ratio;
    rect.origin.x = rect.origin.x + ((tRect.size.width - rect.size.width) * 0.5);
    rect.origin.y = rect.origin.y + 0 /*((tRect.size.height - rect.size.height) * 0.5)*/;
    return rect;
}

- (BOOL)shouldSavePhoto:(UIImage*)image
{
    return YES;
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
    //_picutureView.hidden = NO;
    //_picutureView.image = image;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //return;
    
    NSLog(@"OH YEAH!!! Take a Media");
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"OH YEAH!!! Take a pic, size = (%f,%f)",image.size.width, image.size.height);
    
    //[self showPreview:image];
    
    if ([self shouldSavePhoto:image])
    {
        //[self.imageSaveQueue addObject:image];
        //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    if (_takingPictureFlashEffectView)
    {
        [UIView animateWithDuration:1.0 animations:^(){
            _takingPictureFlashEffectView.alpha = 0.0;
        } completion:^(BOOL finished){
            ReleaseAndNilView(_takingPictureFlashEffectView);
        }];
    }
    
    _isTakingPicture = NO;
    
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

#pragma mark - Timer Operations

- (void)startTimer:(int)seconds
{
    setConfigForInt(kTimerInterval,seconds);
    if (_timer)
    {
        [_timer restartTimerWithConfigInterval];
    }
    else
    {
        _timer = [[ShotTimer timerStartWithConfigIntervalForDelegate:self] retain];
    }
}

- (void)startTimer
{
    int second = getConfigForInt(kTimerInterval);
    [self startTimer:second];
}

- (void)cancelTimer
{
    if (_timer)
    {
        [_timer cancelTimer];
    }
    else
    {
        [self onCancelledTimer:_timer];
    }
}

-(void)takePicture
{
    if (_isTakingPicture)
    {
        return;
    }
    UIImage* testImage = [BaseUtilitiesFuncions grabUIView:self.view/*[CameraOptions sharedInstance].imagePicker.view*/];
    [[CameraOptions sharedInstance].imagePicker takePicture];
    _isTakingPicture = YES;
    ReleaseAndNilView(_takingPictureFlashEffectView);
    if (_takingPictureFlashEffectView == nil)
    {
        _takingPictureFlashEffectView = [[UIView alloc] initWithFrame:[self getCameraScaledRectWithHeightWidthRatio:4.0/3.0]];
        _takingPictureFlashEffectView.backgroundColor = [UIColor whiteColor];
        _takingPictureFlashEffectView.alpha = 0.0;
        [self.view insertSubview:_takingPictureFlashEffectView aboveSubview:[CameraOptions sharedInstance].imagePicker.view];
        [UIView animateWithDuration:0.2 animations:^(){_takingPictureFlashEffectView.alpha = 1.0;}];
    }
}

#pragma mark - test code

- (IBAction)OnClickedVolume:(id)sender
{
    [[AudioUtility sharedInstance] setVolumeDetectingDelegate:self];
    [[AudioUtility sharedInstance] startDetectingVolume:0.5];
}

- (IBAction)OnClickedSound:(id)sender
{
    //NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/Resource/Sound/long_low_short_high.caf"];
    NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/Resource/Sound/tweet_sent.caf"];
    [[AudioUtility sharedInstance] playFile:filePath withDelegate:self];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
        //竖屏的时候x,y是反的
        CGPoint pt = [gestureRecognizer locationInView:self.view];
        float t = pt.x;
        pt.x = pt.y;
        pt.y = t;
        NSLog(@"Get a touch ( %f , %f )",pt.x,pt.y);
        CGRect rect = [self getCameraScaledRectWithHeightWidthRatio:4.0/3.0];
        pt.y /= rect.size.width;
        pt.x /= rect.size.height;
        pt.x = pt.x > 1.0 ? 1.0 : (pt.x < 0.0 ? 0.0 : pt.x);
        pt.y = pt.y > 1.0 ? 1.0 : (pt.y < 0.0 ? 0.0 : pt.y);
        NSLog(@"Location touch ( %f , %f )",pt.x,pt.y);
        pt.x /= self.currentScale;
        pt.y /= self.currentScale;
        NSLog(@"Scaled touch ( %f , %f )",pt.x,pt.y);
        
        [[CameraOptions sharedInstance] setValuesForExporePoint:pt focusPoint:pt];
        //[CameraOptions sharedInstance].exporePoint = pt;
        //[CameraOptions sharedInstance].focusPoint = pt;
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

- (void)onDetected:(float)currentVolume
        peakVolume:(float)peakVolume
        higherThan:(float)detectVolume
       forInstance:(AudioUtility*)util
{
    
}

- (void)onUpdate:(float)currentVolume
      peakVolume:(float)peakVolume
     forInstance:(AudioUtility*)util
{
    
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
    NSLog(@"[TIMER LEFT] %0.f sec",leftTimeInterval);
}

- (void)onFinishedTimer:(ShotTimer*)timer
{
    ReleaseAndNil(_timer);
    //[self takePicture];
}

- (void)onCancelledTimer:(ShotTimer*)timer
{
    ReleaseAndNil(_timer);
}

@end
