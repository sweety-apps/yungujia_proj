//
//  ViewController.m
//  TimerCamera
//
//  Created by lijinxin on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

static BOOL gIsFirstLoading = YES;

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _currentControllers = [[NSMutableArray array] retain];
    
    [self showCamera];
}

- (void)dealloc
{
    [self removeCurrentControllers];
    
    ReleaseAndNil(_currentControllers);
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [self removeCurrentControllers];
    ReleaseAndNil(_currentControllers);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self showQRCodeScannerAndReleaseCaller:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Animations

- (void)PrepareLoadingAnimation
{
    [self onFinishedLoadingAnimation:_laiv];
    _laiv = [[LoadingAnimateImageView viewWithDelegate:self image:[UIImage imageNamed:@"/Resource/Picture/camera_open"] forTimeInterval:0.8 preLoadImage:[UIImage imageNamed:@"Default"] forPreloadAnimateInterval:0.2] retain];
    if (_laiv)
    {
        UIView* viewToInsertAbove = nil;
        NSArray* subViews = self.view.subviews;
        if (subViews && [subViews indexOfObject:_coverController.view] != NSNotFound)
        {
            viewToInsertAbove = _coverController.view;
            
        }
        
        if (viewToInsertAbove)
        {
            [self.view insertSubview:_laiv aboveSubview:viewToInsertAbove];
        }
    }
    
    if (_coverController)
    {
        CGRect rect = CGRectZero;
        rect.size = self.view.frame.size;
        _coverController.view.frame = rect;
        [_coverController hideSubViews:NO];
        
        [_coverController resetStatus];
    }
}

- (void)ShowLoadingAnimation
{
    if (_laiv)
    {
        UIView* viewToInsertAbove = nil;
        NSArray* subViews = self.view.subviews;
        if (subViews && [subViews indexOfObject:_coverController.view] != NSNotFound)
        {
            viewToInsertAbove = _coverController.view;
        }
        
        if (viewToInsertAbove)
        {
            [self.view insertSubview:_laiv aboveSubview:viewToInsertAbove];
        }
        
        [_laiv startPreloadingAnimation];
        [_laiv startLoadingAnimation];
    }
    
    if (_coverController)
    {
        [_coverController showSubViews:YES delayed:0.7];
    }
}

#pragma mark LoadingAnimateImageViewDelegate

- (void)onFinishedLoadingAnimation:(LoadingAnimateImageView*)view
{
    ReleaseAndNilView(_laiv);
    
    //[_coverController showSubViews:YES];
}


#pragma mark private Methods

- (void)removeCurrentControllers
{
    UIViewController* controller = nil;
    
    for (int i = [_currentControllers count] - 1; i >= 0; --i)
    {
        controller = [_currentControllers objectAtIndex:i];
        [controller.view removeFromSuperview];
        ReleaseAndNil(controller);
    }
    
    [_currentControllers removeAllObjects];
    
    _coverController = nil;
    _albumController = nil;
    _editorController = nil;
}

#pragma mark Controller Caller

- (void)showCamera
{
    if (_coverController == nil)
    {
        _coverController = [[CameraCoverViewController alloc] init];
    }
    
    UIView* belowView = nil;
    
    if (_albumController)
    {
        belowView = _albumController.view;
    }
    if (_qrcodeScannerController)
    {
        belowView = _qrcodeScannerController.view;
    }
    
    if (belowView)
    {
        [self.view insertSubview:_coverController.view belowSubview:belowView];
    }
    else
    {
        [self.view addSubview:_coverController.view];
    }
    
    [_currentControllers addObject:_coverController];
}

- (void)removeCamera
{
    [_currentControllers removeObject:_coverController];
    [_coverController.view removeFromSuperview];
    ReleaseAndNil(_coverController);
    [CameraOptions resetSharedInstance];
}

- (void)showCameraAndShowSubviews
{
    [self showCamera];
    if (_coverController)
    {
        [_coverController setAutoShowSubViews:YES withAnimation:YES];
    }
}

- (void)showQRCodeScannerAndReleaseCaller:(UIViewController*)caller
{
    if (_qrcodeScannerController == nil)
    {
        _qrcodeScannerController = [[QRCodeScannerViewController alloc] init];
    }
    
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    _qrcodeScannerController.view.frame = rect;
    
    [self.view addSubview:_qrcodeScannerController.view];
    [_qrcodeScannerController showControlsWithAnimationAndReleaseController:caller];
}

- (void)removeQRCodeScanner
{
    [_currentControllers removeObject:_qrcodeScannerController];
    [_qrcodeScannerController.view removeFromSuperview];
    ReleaseAndNil(_qrcodeScannerController);
}


- (void)showAlbum
{
    [self showAlbumAndReleaseCaller:nil];
}

- (void)showAlbumAndReleaseCaller:(UIViewController*)caller withAnimation:(BOOL)animated
{
    if (!_albumController)
    {
        _albumController = [[AlbumViewController alloc] init];
    }
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    _albumController.view.frame = rect;
    [self.view addSubview:_albumController.view];
    
    if (animated)
    {
        [_albumController showAlbumWithAnimationAndReleaseCaller:caller];
    }
    else
    {
        [_albumController showAlbumWithoutAnimationAndReleaseCaller:caller];
    }
    
    [_currentControllers addObject:_albumController];
}

- (void)showAlbumAndReleaseCaller:(UIViewController*)caller
{
    [self showAlbumAndReleaseCaller:caller withAnimation:YES];
}

- (void)showAlbumNoAnimationAndReleaseCaller:(UIViewController *)caller
{
    [self showAlbumAndReleaseCaller:caller withAnimation:NO];
}

- (void)removeAlbum
{
    [_currentControllers removeObject:_albumController];
    [_albumController.view removeFromSuperview];
    ReleaseAndNil(_albumController);
}

- (void)showEditor:(UIImage*)originalImage andReleaseCaller:(UIViewController*)caller
{
    if (_editorController == nil)
    {
        _editorController = [[EditorViewController alloc] init];
    }
    
    if (_albumController)
    {
        [self.view insertSubview:_editorController.view belowSubview:_albumController.view];
    }
    else
    {
        [self.view addSubview:_editorController.view];
    }
    
    [_currentControllers addObject:_editorController];
}

- (void)removeEditor
{
    [_currentControllers removeObject:_editorController];
    [_editorController.view removeFromSuperview];
    ReleaseAndNil(_editorController);
}

- (void)showSetting
{
    
}

- (void)removeSetting
{
    
}

- (void)removeController:(UIViewController*)controller
{
    if (controller == _qrcodeScannerController)
    {
        [self removeQRCodeScanner];
    }
    if (controller == _coverController)
    {
        [self removeCamera];
    }
    if (controller == _albumController)
    {
        [self removeAlbum];
    }
    if (controller == _editorController)
    {
        [self removeEditor];
    }
}

#pragma mark other logic

- (void)conditionalShowLoadingAnimation
{
    if (gIsFirstLoading)
    {
        gIsFirstLoading = NO;
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(conditionalShowLoadingAnimation) userInfo:nil repeats:NO];
    }
    else
    {
        [self ShowLoadingAnimation];
    }
}

#pragma mark App Life-Cycle

- (void)onApplicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _isEnterBackGround = YES;
    [self PrepareLoadingAnimation];
}

- (void)onApplicationWillResignActive
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)onApplicationDidEnterBackground
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self onFinishedLoadingAnimation:nil];
    [self PrepareLoadingAnimation];
    
}

- (void)onApplicationWillEnterForeground
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self PrepareLoadingAnimation];
    _isEnterBackGround = YES;
}


- (void)onApplicationDidBecomeActive
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (_isEnterBackGround)
    {
        [self conditionalShowLoadingAnimation];
        _isEnterBackGround = NO;
    }
}

- (void)onApplicationWillTerminate
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
