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

#pragma mark - Animations

- (void)PrepareLoadingAnimation
{
    [self onFinishedLoadingAnimation:_laiv];
    _laiv = [[LoadingAnimateImageView viewWithDelegate:self image:[UIImage imageNamed:@"/Resource/Picture/camera_open"] forTimeInterval:0.8 preLoadImage:[UIImage imageNamed:@"Default"] forPreloadAnimateInterval:0.2] retain];
    if (_laiv)
    {
        if (_albumController)
        {
            [self.view insertSubview:_laiv belowSubview:_albumController.view];
        }
        else
        {
            [self.view addSubview:_laiv];
            [self.view bringSubviewToFront:_laiv];
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
        if (_albumController)
        {
            [self.view insertSubview:_laiv belowSubview:_albumController.view];
        }
        else
        {
            [self.view bringSubviewToFront:_laiv];
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
    for (int i = [_currentControllers count] - 1; i >= 0; --i)
    {
        UIViewController* controller = [_currentControllers objectAtIndex:i];
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
    
    if (_albumController)
    {
        [self.view insertSubview:_coverController.view belowSubview:_albumController.view];
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
}

- (void)showAlbum
{
    [self showAlbumAndReleaseCaller:nil];
}

- (void)showAlbumAndReleaseCaller:(UIViewController*)caller
{
    if (!_albumController)
    {
        _albumController = [[AlbumViewController alloc] init];
    }
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    _albumController.view.frame = rect;
    [self.view addSubview:_albumController.view];
    [_albumController showAlbumWithAnimationAndReleaseCaller:caller];
    
    [_currentControllers addObject:_albumController];
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

@end
