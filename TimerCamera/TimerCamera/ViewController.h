//
//  ViewController.h
//  TimerCamera
//
//  Created by lijinxin on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOptions.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIGestureRecognizerDelegate>
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
    
    UITapGestureRecognizer* _tapGesture;
    UIPinchGestureRecognizer* _pinchGesture;
    
    CGFloat _lastScale;
    
    CGFloat _currentScale;
}

@property (nonatomic,retain) IBOutlet UIView* containerView;
@property (nonatomic,retain) IBOutlet UIImageView* picutureView;
@property (nonatomic,retain) IBOutlet UIButton* shotBtn;
@property (nonatomic,retain) IBOutlet UIButton* flashBtn;
@property (nonatomic,retain) IBOutlet UIButton* positionBtn;
@property (nonatomic,retain) IBOutlet UIButton* optionBtn;
@property (nonatomic,retain) IBOutlet UIImageView* bottomBar;
@property (nonatomic,retain) IBOutlet UITapGestureRecognizer* tapGesture;
@property (nonatomic,retain) IBOutlet UIPinchGestureRecognizer* pinchGesture;

@property (nonatomic,retain) NSMutableArray* imageSaveQueue;
@property (nonatomic,assign) CGFloat currentScale;


- (IBAction)OnClickedShot:(id)sender;
- (IBAction)OnClickedLight:(id)sender;
- (IBAction)OnClickedTorch:(id)sender;
- (IBAction)OnClickedHDR:(id)sender;
- (IBAction)OnClickedFront:(id)sender;

-(IBAction)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer;
-(IBAction)handlePinchGesture:(UIPinchGestureRecognizer*)gestureRecognizer;

//test Button
- (IBAction)OnClickedVolume:(id)sender;
- (IBAction)OnClickedSound:(id)sender;

@end
