//
//  ViewController.h
//  TimerCamera
//
//  Created by lijinxin on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOptions.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSTimer* timer;
    
    UIView* _containerView;
    UIImageView* _picutureView;
    UIButton* _shotBtn;
    UIButton* _flashBtn;
    UIButton* _positionBtn;
    UIButton* _optionBtn;
    UIImageView* _bottomBar;
    
    NSMutableArray* _imageSaveQueue;
}

@property (nonatomic,retain) IBOutlet UIView* containerView;
@property (nonatomic,retain) IBOutlet UIImageView* picutureView;
@property (nonatomic,retain) IBOutlet UIButton* shotBtn;
@property (nonatomic,retain) IBOutlet UIButton* flashBtn;
@property (nonatomic,retain) IBOutlet UIButton* positionBtn;
@property (nonatomic,retain) IBOutlet UIButton* optionBtn;
@property (nonatomic,retain) IBOutlet UIImageView* bottomBar;

@property (nonatomic,retain) NSMutableArray* imageSaveQueue;


- (IBAction)OnClickedShot:(id)sender;

@end
