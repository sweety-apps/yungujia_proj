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

@interface ViewController : UIViewController <LoadingAnimateImageViewDelegate>
{
    LoadingAnimateImageView* _laiv;
    CameraCoverViewController* _coverController;
    AlbumViewController* _albumController;
}

//loading Animation
- (void)PrepareLoadingAnimation;
- (void)ShowLoadingAnimation;

- (void)showAlbum;

@end
