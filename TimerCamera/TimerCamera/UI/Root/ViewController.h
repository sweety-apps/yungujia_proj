//
//  ViewController.h
//  TimerCamera
//
//  Created by lijinxin on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOptions.h"
#import "AudioUtility.h"
#import "LoadingAnimateImageView.h"
#import "ShotTimer.h"
#import "CameraCoverViewController.h"
#import "AlbumViewController.h"
#import "EditorViewController.h"
#import "QRCodeScannerViewController.h"

@interface ViewController : UIViewController <LoadingAnimateImageViewDelegate>
{
    LoadingAnimateImageView* _laiv;
    CameraCoverViewController* _coverController;
    AlbumViewController* _albumController;
    EditorViewController* _editorController;
    QRCodeScannerViewController* _qrcodeScannerController;
    
    NSMutableArray* _currentControllers;
    
    BOOL _isEnterBackGround;
}

//loading Animation
- (void)PrepareLoadingAnimation;
- (void)ShowLoadingAnimation;

- (void)showCamera;
- (void)removeCamera;
- (void)showCameraAndShowSubviews;

- (void)showQRCodeScannerAndReleaseCaller:(UIViewController*)caller;
- (void)removeQRCodeScanner;

- (void)showAlbum;
- (void)showAlbumAndReleaseCaller:(UIViewController*)caller;
- (void)showAlbumNoAnimationAndReleaseCaller:(UIViewController *)caller;
- (void)removeAlbum;

- (void)showEditor:(UIImage*)originalImage andReleaseCaller:(UIViewController*)caller;
- (void)removeEditor;

- (void)showSetting;
- (void)removeSetting;

- (void)removeController:(UIViewController*)controller;

#pragma mark App Life-Cycle

- (void)onApplicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)onApplicationWillResignActive;
- (void)onApplicationDidEnterBackground;
- (void)onApplicationWillEnterForeground;
- (void)onApplicationDidBecomeActive;
- (void)onApplicationWillTerminate;

@end
