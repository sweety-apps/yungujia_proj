//
//  ViewController.m
//  VideoEffectDemo
//
//  Created by lijinxin on 13-6-1.
//  Copyright (c) 2013年 lijinxin. All rights reserved.
//

#include <sys/time.h>
#include <unistd.h>
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

static long long getCurrentTimeInMicroSeconds()
{
    long long timebysec = 0;
	struct timeval tv;
	if(gettimeofday(&tv,NULL)!=0)
		return 0;
	timebysec +=  (long long)tv.tv_sec * 1000000;
	timebysec += tv.tv_usec ;
	return timebysec;
}

#pragma mark - EffectUIWarpper

@interface EffectUIWarpper : NSObject
{
    CAEmitterLayer* _emitter;
    NSMutableArray* _hearts;
    long long _lastUpdateTime;
    int _currentHeart;
    int _currentLabel;
    UILabel* _label;
}

@property (nonatomic, retain) UIView* view;
@property (nonatomic, retain) GPUImageUIElement *uiElementInput;

- (void)createSubviews;
- (void)updateViewAtRect:(CGRect)rect;
- (void)checkAndCleanViews;

@end

@implementation EffectUIWarpper

@synthesize view = _view;
@synthesize uiElementInput = _uiElementInput;

- (id)init
{
    self = [super init];
    if (self)
    {
        srand(time(NULL));
    }
    return self;
}

- (void)dealloc
{
    [_hearts release];
    self.view = nil;
    self.uiElementInput = nil;
    [super dealloc];
}

static NSString* labelStrings[] = {@"呆呆",@"萌",@"YEAH",@"困"};

- (void)createSubviews
{
    CGRect rect = _view.frame;
    rect.origin = CGPointZero;
    UIImageView* bgImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangkuang"]] autorelease];
    bgImageView.frame = rect;
    [_view addSubview:bgImageView];
    
    _hearts = [[NSMutableArray array] retain];
    
    for (int i = 0; i < 9; ++i)
    {
        UIImageView* heartImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sprite_heart"]] autorelease];
        
        heartImg.contentMode = UIViewContentModeScaleAspectFit;
        heartImg.frame = CGRectZero;
        
        [_hearts addObject:heartImg];
        [_view addSubview:heartImg];
    }
    _currentHeart = 0;
    _currentLabel = 0;
    
    _label = [[[UILabel alloc] init] autorelease];
    _label.frame = CGRectMake(5, 5, 50, 50);
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor yellowColor];
    _label.adjustsFontSizeToFitWidth = YES;
    _label.text = labelStrings[0];
    [_view addSubview:_label];
    
    //[self initEmiter:_view.frame emitterImage:[UIImage imageNamed:@"sprite_heart"]];
    
}

- (void)updateViewAtRect:(CGRect)rect
{
    //[self doAnimations:rect];
    CGPoint pt = rect.origin;
    pt.x += rect.size.width * 0.5 - 20;
    pt.y += rect.size.height * 0.5;
    if (rect.size.width > 40 || rect.size.height > 40)
    {
        rect.size.width = 40;
        rect.size.height = 40;
    }
    if (rect.size.width < 4 || rect.size.height < 4)
    {
        rect.size.width = 4;
        rect.size.height = 4;
    }
    
    rect.origin.x = pt.x - (rect.size.width * 0.5);
    rect.origin.y = pt.y - (rect.size.height * 0.5);
    
    UIImageView* heartImg = [_hearts objectAtIndex:_currentHeart];
    heartImg.frame = rect;
    
    heartImg.transform = CGAffineTransformMakeRotation(0.2 * (float) (rand() % 10) * M_PI);
    
    _currentHeart ++;
    _currentHeart %= [_hearts count];
    
    _lastUpdateTime = getCurrentTimeInMicroSeconds();
}

- (void)checkAndCleanViews
{
    if (getCurrentTimeInMicroSeconds() - _lastUpdateTime > 1000000)
    {
        for (UIImageView* heartImg in _hearts)
        {
            heartImg.frame = CGRectZero;
        }
        _currentLabel ++;
        _currentLabel %= (sizeof(labelStrings)/sizeof(labelStrings[0]));
        
        _label.text = labelStrings[_currentLabel];
        
        _lastUpdateTime = getCurrentTimeInMicroSeconds();
    }
}


#define PurpleColor() [UIColor colorWithRed:(77.0/255.0) green:(0.0) blue:(126.0/255.0) alpha:1.0]
#define AllColor() [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]

- (void)initEmiter:(CGRect)rect emitterImage:(UIImage*)image
{
    _emitter = [[CAEmitterLayer layer] retain];
    
    //_emitter.position = CGPointMake(rect.size.width,0);
    CGSize tsize = rect.size;
    tsize.width *= 0.2;
    tsize.height *= 0.8;
    _emitter.emitterPosition = CGPointMake(rect.origin.x + rect.size.width * 0.5,
                                           rect.origin.y + rect.size.height * 0.5);
    _emitter.emitterSize = tsize;
    
    // Spawn points for the hearts are within the area defined by the button frame
    _emitter.emitterMode = kCAEmitterLayerVolume;
    _emitter.emitterShape = kCAEmitterLayerRectangle;
    _emitter.renderMode = kCAEmitterLayerAdditive;
    
    // Configure the emitter cell
    CAEmitterCell *heart = [CAEmitterCell emitterCell];
    heart.name = @"heart";
    
    //heart.emissionLongitude = 0;//M_PI * 7.0 / 4.0;//M_PI * 3.0 /2.0; // up
    heart.emissionRange = 2.0 * M_PI;  // in a wide spread
    heart.birthRate		= 0.0;			// emitter is deactivated for now
    heart.lifetime		= 0.3;			// hearts vanish after 10 seconds
    
    heart.velocity		= 100;			// particles get fired up fast
    heart.velocityRange = 2.0 * M_PI;			// with some variation
    heart.yAcceleration = -200;			// but fall eventually
    //heart.xAcceleration = 20;
    
    heart.contents		= (id) [image CGImage];
    heart.color			= [AllColor() CGColor];
    heart.redRange		= 1.0;			// some variation in the color
    heart.blueRange		= 1.0;
    heart.greenRange    = 1.0;
    heart.alphaSpeed	= -1.0 / heart.lifetime;  // fade over the lifetime
    
    heart.scale			= 0.1;			// let them start small
    heart.scaleSpeed	= 0.04 / heart.lifetime;    // but then 'explode' in size
    heart.spin			= 2.0 * M_PI;
    heart.spinRange		= 2.0 * M_PI;	// and send them spinning from -180 to +180 deg/s
    
    // Add everything to our backing layer
    _emitter.emitterCells = [NSArray arrayWithObject:heart];
    
    [_view.layer addSublayer:_emitter];
}

- (void)doAnimations:(CGRect)rect
{
    CGSize tsize = rect.size;
    tsize.width *= 0.3;
    tsize.height *= 0.3;
    _emitter.emitterPosition = CGPointMake(rect.origin.x + rect.size.width * 0.5,
                                           rect.origin.y + rect.size.height * 0.5);
    _emitter.emitterSize = tsize;
    
    CABasicAnimation *heartsBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.heart.birthRate"];
	heartsBurst.fromValue		= [NSNumber numberWithFloat: 5.0];
	heartsBurst.toValue			= [NSNumber numberWithFloat: 0.0];
	heartsBurst.duration		= 0.4;
	heartsBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [_emitter addAnimation:heartsBurst forKey:@"heartsBurst"];
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
    
    /*
    overlayImageFilter = [[[GPUImageOverlayBlendFilter alloc] init] autorelease];
    
    UIImage *inputImage = [UIImage imageNamed:@"xiangkuang.png"];
    GPUImagePicture *overlayPicture = [[GPUImagePicture alloc] initWithImage:inputImage];
    [overlayPicture addTarget:overlayImageFilter];
    [overlayPicture processImage];
     */
    
    startImageFilter = [[[GPUImageFilter alloc] init] autorelease];
    
    
    motionDetectorFilter = [[[GPUImageMotionDetector alloc] init] autorelease];
    [(GPUImageMotionDetector*)motionDetectorFilter setLowPassFilterStrength:0.35];
    
    [videoCamera addTarget:motionDetectorFilter];//add target directly to camera
    
    
    //[videoCamera addTarget:overlayImageFilter];
    [videoCamera addTarget:startImageFilter];
    
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
    
    [self setupUIElementEffect:filterView source:startImageFilter];
    
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
    
    double delayToStartRecording = 3.0;
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
        
        double delayInSeconds = 18.0;
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
                [effectUIWarpper updateViewAtRect:rect];
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

- (void)setupUIElementEffect:(GPUImageView*)filterView source:(GPUImageOutput*)source
{
    blendFilter = [[[GPUImageAlphaBlendFilter alloc] init] autorelease];
    blendFilter.mix = 1.0;
    
    effectUIFilter = blendFilter;
    [source addTarget:effectUIFilter];//!!!!! must add target First !!!!!!
    
    UIView* containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)] autorelease];
    containerView.backgroundColor = [UIColor clearColor];
    
    UIView* blankView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)] autorelease];
    containerView.backgroundColor = [UIColor clearColor];
    
    effectUIWarpper = [[EffectUIWarpper alloc] init];
    effectUIWarpper.view = containerView;
    [effectUIWarpper createSubviews];
    
    //[filterView addSubview:containerView];
    
    uiElementInput = [[GPUImageUIElement alloc] initWithView:containerView];
    [uiElementInput addTarget:blendFilter];
    
    [blendFilter addTarget:filterView];
    
    [source setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
        [effectUIWarpper checkAndCleanViews];
        [uiElementInput update];
    }];
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
