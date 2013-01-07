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
    [[CameraOptions sharedInstance].imagePicker.view addGestureRecognizer:_tapGesture];
    [self.view addGestureRecognizer:_pinchGesture];
    _tapGesture.cancelsTouchesInView = NO;
    [CameraOptions sharedInstance].imagePicker.view.frame = self.view.frame;
    
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
{
    CGRect rect = srcRect;
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imageView.frame = rect;
    [superView insertSubview:imageView aboveSubview:subView];
    
    rect.size = destRect.size;
    rect.origin.x = srcRect.origin.x + ((srcRect.size.width - destRect.size.width) * 0.5);
    rect.origin.y = srcRect.origin.y + ((srcRect.size.height - destRect.size.height) * 0.5);
    
    [UIView animateWithDuration:0.8 animations:^(){
        imageView.frame = rect;
    } completion:^(BOOL finshed){
        [UIView animateWithDuration:0.3 animations:^(){
            imageView.frame = destRect;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 animations:^(){
                imageView.alpha = 0.0;
            } completion:^(BOOL finished){
                [imageView removeFromSuperview];
            }];
        }];
    }];
    
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
        [self.imageSaveQueue addObject:image];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
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
    [[CameraOptions sharedInstance].imagePicker takePicture];
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
        CGPoint pt = [gestureRecognizer locationInView:self.view];
        NSLog(@"Get a touch ( %f , %f )",pt.x,pt.y);
        pt.x /= self.view.frame.size.width;
        pt.y /= self.view.frame.size.height;
        NSLog(@"Location touch ( %f , %f )",pt.x,pt.y);
        pt.x /= self.currentScale;
        pt.y /= self.currentScale;
        NSLog(@"Scaled touch ( %f , %f )",pt.x,pt.y);
        
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
