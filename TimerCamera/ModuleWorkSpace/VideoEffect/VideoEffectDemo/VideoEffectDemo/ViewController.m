//
//  ViewController.m
//  VideoEffectDemo
//
//  Created by lijinxin on 13-6-1.
//  Copyright (c) 2013年 lijinxin. All rights reserved.
//

#import "ViewController.h"

#pragma mark - EffectUIWarpper

@interface EffectUIWarpper : NSObject

@property (nonatomic, retain) UIView* view;
@property (nonatomic, retain) GPUImageUIElement *uiElementInput;

@end

@implementation EffectUIWarpper

@synthesize view = _view;
@synthesize uiElementInput = _uiElementInput;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.view = nil;
    self.uiElementInput = nil;
    [super dealloc];
}

@end

#pragma mark - ViewController

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initGPUEffect];
    
    //[(GPUImageAlphaBlendFilter *)filter setMix:0.5f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initGPUEffect
{
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    
    videoCamera.outputImageOrientation = UIDeviceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    overlayImageFilter = [[[GPUImageOverlayBlendFilter alloc] init] autorelease];
    
    UIImage *inputImage = [UIImage imageNamed:@"xiangkuang.png"];
    GPUImagePicture *overlayPicture = [[GPUImagePicture alloc] initWithImage:inputImage];
    [overlayPicture addTarget:overlayImageFilter];
    [overlayPicture processImage];
    
    motionDetectorFilter = [[[GPUImageMotionDetector alloc] init] autorelease];
    [(GPUImageMotionDetector*)motionDetectorFilter setLowPassFilterStrength:0.28];
    
    [videoCamera addTarget:motionDetectorFilter];//add target directly to camera
    [videoCamera addTarget:overlayImageFilter];
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    GPUImageView *filterView = [[[GPUImageView alloc] initWithFrame:rect] autorelease];
    filterView.autoresizesSubviews = YES;
    
    filterView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview:filterView];
    
    [self setupUIElementEffect:filterView];
    effectHandlingIndex = 0;
    
    [self setupMotionDetectorHandlerForView:filterView];
    [videoCamera rotateCamera];
    
    //    filterView.fillMode = kGPUImageFillModeStretch;
    //    filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    // Record a movie for 10 s and store it in /Documents, visible via iTunes file sharing
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    
    GPUImageOutput<GPUImageInput> *lastOutputFilter = effectUIFilter;//overlayImageFilter;//
    
    [lastOutputFilter addTarget:filterView];
    
#if ENABLE_VIDEO_RECORDING
    
    [lastOutputFilter addTarget:movieWriter];
#endif
    
    [videoCamera startCameraCapture];
    
#if ENABLE_VIDEO_RECORDING
    
    double delayToStartRecording = 2.0;
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, delayToStartRecording * NSEC_PER_SEC);
    dispatch_after(startTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"Start recording");
        
        videoCamera.audioEncodingTarget = movieWriter;
        [movieWriter startRecording];
        
        //        NSError *error = nil;
        //        if (![videoCamera.inputCamera lockForConfiguration:&error])
        //        {
        //            NSLog(@"Error locking for configuration: %@", error);
        //        }
        //        [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
        //        [videoCamera.inputCamera unlockForConfiguration];
        
        double delayInSeconds = 12.0;
        dispatch_time_t stopTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(stopTime, dispatch_get_main_queue(), ^(void){
            
            [lastOutputFilter removeTarget:movieWriter];
            videoCamera.audioEncodingTarget = nil;
            [movieWriter finishRecording];
            NSLog(@"Movie completed");
            
            //            [videoCamera.inputCamera lockForConfiguration:nil];
            //            [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
            //            [videoCamera.inputCamera unlockForConfiguration];
        });
    });
#endif
}

- (void)setupMotionDetectorHandlerForView:(UIView*)view
{
    [(GPUImageMotionDetector *) motionDetectorFilter setMotionDetectionBlock:^(CGPoint motionCentroid, CGFloat motionIntensity, CMTime frameTime) {
        if (motionIntensity > 0.01)
        {
            CGFloat motionBoxWidth = 1500.0 * motionIntensity;
            CGSize viewBounds = self.view.bounds.size;
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect rect = CGRectMake(round(viewBounds.width * motionCentroid.x - motionBoxWidth / 2.0), round(viewBounds.height * motionCentroid.y - motionBoxWidth / 2.0), motionBoxWidth, motionBoxWidth);
                EffectUIWarpper* eui = [effectUIArray objectAtIndex:effectHandlingIndex];
                //eui.view.frame = rect;
                //eui.view.alpha = 1.0;
                effectHandlingIndex ++;
                effectHandlingIndex %= [effectUIArray count];
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //faceView.hidden = YES;
            });
        }
        
    }];
}

- (void)setupUIElementEffect:(GPUImageView*)filterView
{
    blendFilter = [[[GPUImageAlphaBlendFilter alloc] init] autorelease];
    blendFilter.mix = 1.0;
    
    [effectUIArray release];
    effectUIArray = [[NSMutableArray array] retain];

    for (int i = 0; i < 1; ++i)
    {
        EffectUIWarpper* eui = [[[EffectUIWarpper alloc] init] autorelease];
        
        /*
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sprite_heart"]] autorelease];
        //imageView.alpha = 1.0f;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        eui.view = imageView;
        */
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 320)];
        label.contentMode = UIViewContentModeScaleAspectFit;
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor purpleColor];
        label.textColor = [UIColor yellowColor];
        label.textAlignment = UITextAlignmentCenter;
        label.text = @"OH!!!";
        eui.view = label;
        
        GPUImageUIElement* uiElementInput = [[[GPUImageUIElement alloc] initWithView:eui.view] autorelease];
        [uiElementInput addTarget:blendFilter];
        
        eui.uiElementInput = uiElementInput;
        [effectUIArray addObject:eui];
    }
    
    [blendFilter addTarget:filterView];
    
    [overlayImageFilter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
        for (EffectUIWarpper* eui in effectUIArray)
        {
            UILabel* label = (UILabel*)eui.view;
            label.text = @"WUHAHAHAHAHA";
            
            [eui.uiElementInput update];
        }
    }];
    
    effectUIFilter = blendFilter;
    [overlayImageFilter addTarget:effectUIFilter];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Map UIDeviceOrientation to UIInterfaceOrientation.
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
            orient = UIInterfaceOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orient = UIInterfaceOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationPortrait:
            orient = UIInterfaceOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            orient = UIInterfaceOrientationPortraitUpsideDown;
            break;
            
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            // When in doubt, stay the same.
            orient = fromInterfaceOrientation;
            break;
    }
    videoCamera.outputImageOrientation = orient;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; // Support all orientations.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
