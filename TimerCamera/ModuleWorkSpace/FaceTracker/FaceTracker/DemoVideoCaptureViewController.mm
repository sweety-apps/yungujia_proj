//
//  DemoVideoCaptureViewController.m
//  FaceTracker
//
//  Created by Robin Summerhill on 9/22/11.
//  Copyright 2011 Aptogo Limited. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "UIImage+OpenCV.h"
#import "DemoVideoCaptureViewController.h"
#include <sys/time.h>
#include <unistd.h>

static long long getTimeInMicrosecond()
{
	long long timebysec = 0;
	struct timeval tv;
	if(gettimeofday(&tv,NULL)!=0)
		return 0;
	timebysec +=  (long long)tv.tv_sec * 1000000;
	timebysec += tv.tv_usec ;
	return timebysec;
}

static BOOL gHasDetected = NO;
static int gImageIndex = 0;

#pragma mark - HaarDetectorWarrper

@interface HaarDetectorWarpper : NSObject

@property (nonatomic, retain) NSString * cascadeFilePath;
@property (nonatomic, retain) NSString * cascadeFileName;
@property (nonatomic, assign) int haarOptions;
@property (nonatomic, assign) cv::CascadeClassifier featureCascade;
@property (nonatomic, assign, readonly) BOOL canDetect;
@property (nonatomic, retain) UIColor* markedBorderColor;

@end

@implementation HaarDetectorWarpper

@synthesize cascadeFilePath = _cascadeFilePath;
@synthesize cascadeFileName = _cascadeFileName;
@synthesize haarOptions = _haarOptions;
@synthesize featureCascade = _featureCascade;
@synthesize canDetect = _canDetect;
@synthesize markedBorderColor = _markedBorderColor;

- (id)initWith:(NSString*)fileName filePath:(NSString*)filePath options:(int)haarOptions markedBorderColor:(UIColor*)color
{
    self = [super init];
    if (self)
    {
        self.cascadeFilePath = filePath;
        self.cascadeFileName = fileName;
        self.haarOptions = haarOptions;
        self.markedBorderColor = color;
        
        if (!_featureCascade.load([filePath UTF8String]))
        {
            _canDetect = NO;
        }
        else
        {
            _canDetect = YES;
        }
    }
    return self;
}

- (void)dealloc
{
    self.cascadeFilePath = nil;
    self.cascadeFileName = nil;
    self.markedBorderColor = nil;
    [super dealloc];
}

@end

#pragma mark - DemoVideoCaptureViewController

@interface DemoVideoCaptureViewController ()
- (void)displayFaces:(const std::vector<cv::Rect> &)faces 
       forVideoRect:(CGRect)rect 
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation;
- (void)displayFaces:(const std::vector<cv::Rect> &)features
        forVideoRect:(CGRect)rect
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation
   markedBorderColor:(UIColor*)color
     layerStartIndex:(int)index;
@end

@implementation DemoVideoCaptureViewController

@synthesize imageView = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.captureGrayscale = YES;
        self.qualityPreset = AVCaptureSessionPresetMedium;
    }
    return self;
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _featureLayers = [[NSMutableArray array] retain];
    _cascadeDetectors = [[NSMutableArray array] retain];
    
    // Name of face cascade resource file without xml extension
    NSString* cascadeFilenames[] = {
        //@"haarcascade_fullbody",
        @"haarcascade_lowerbody",
        @"haarcascade_frontalface_alt2",
        @"haarcascade_mcs_upperbody",
        @"haarcascade_lefteye_2splits",
        @"haarcascade_righteye_2splits",
        @"haarcascade_mcs_nose",
        @"haarcascade_mcs_mouth",
    };
    
    // Options for cv::CascadeClassifier::detectMultiScale
    int haarOptions[] = {
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH
    };
    
    //Layer mark border color
    UIColor* colors[] = {
        [UIColor blueColor],
        [UIColor greenColor],
        [UIColor grayColor],
        [UIColor redColor],
        [UIColor yellowColor],
        [UIColor orangeColor],
        [UIColor cyanColor],
        [UIColor purpleColor]
    };
    
    // Load the face Haar cascade from resources
    for (int i = 0; i < sizeof(cascadeFilenames)/sizeof(NSString*); ++i)
    {
        NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:cascadeFilenames[i] ofType:@"xml"];
        HaarDetectorWarpper* warpper = [[[HaarDetectorWarpper alloc] initWith:cascadeFilenames[i] filePath:faceCascadePath options:haarOptions[i] markedBorderColor:colors[i]] autorelease];
        [_cascadeDetectors addObject:warpper];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    self.debugLabel = nil;
    self.changeButton = nil;
    self.imageView = nil;
    [_cascadeDetectors release];
    [_featureLayers release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// MARK: IBActions

// Toggles display of FPS
- (IBAction)toggleFps:(id)sender
{
    self.showDebugInfo = !self.showDebugInfo;
}

// Turn torch on and off
- (IBAction)toggleTorch:(id)sender
{
    self.torchOn = !self.torchOn;
}
  
// Switch between front and back camera
- (IBAction)toggleCamera:(id)sender
{
    if (self.camera == 1) {
        self.camera = 0;
    }
    else
    {
        self.camera = 1;
    }
}

- (IBAction)toggleChange:(id)sender
{
    gImageIndex++;
    gImageIndex %= 14;
    
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fat_%d",gImageIndex]];
    
    gHasDetected = NO;
}

// MARK: VideoCaptureViewController overrides

- (void)processFrame:(cv::Mat &)mat videoRect:(CGRect)rect videoOrientation:(AVCaptureVideoOrientation)videOrientation
{
    if (self.imageView.hidden)
    {
        // Shrink video frame to 320X240
        cv::resize(mat, mat, cv::Size(), 0.5f, 0.5f, CV_INTER_LINEAR);
        rect.size.width /= 2.0f;
        rect.size.height /= 2.0f;
        
        // Rotate video frame by 90deg to portrait by combining a transpose and a flip
        // Note that AVCaptureVideoDataOutput connection does NOT support hardware-accelerated
        // rotation and mirroring via videoOrientation and setVideoMirrored properties so we
        // need to do the rotation in software here.
        cv::transpose(mat, mat);
        CGFloat temp = rect.size.width;
        rect.size.width = rect.size.height;
        rect.size.height = temp;
        
        if (videOrientation == AVCaptureVideoOrientationLandscapeRight)
        {
            // flip around y axis for back camera
            cv::flip(mat, mat, 1);
        }
        else {
            // Front camera output needs to be mirrored to match preview layer so no flip is required here
        }
        
        videOrientation = AVCaptureVideoOrientationPortrait;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self clearFeatureMarkedLayers];
        });
        
        int index = 0;
        
        for (HaarDetectorWarpper* warpper in _cascadeDetectors)
        {
            if (warpper.canDetect)
            {
                // Detect faces
                std::vector<cv::Rect> faces;
                warpper.featureCascade.detectMultiScale(mat, faces, 1.1, 2, warpper.haarOptions, cv::Size(20, 20));
                // Dispatch updating of face markers to main queue
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self displayFaces:faces
                          forVideoRect:rect
                      videoOrientation:videOrientation
                     markedBorderColor:warpper.markedBorderColor
                       layerStartIndex:index];
                });
                index += faces.size();
            }
        }
    }
    else
    {
        if (gHasDetected)
        {
            return;
        }
        
        NSString* debugLog = @"";
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.changeButton.userInteractionEnabled = NO;
            [self.changeButton setTitle:@"Detecting" forState:UIControlStateNormal];
            self.debugLabel.text = debugLog;
        });
        
        // Shrink video frame to 320X240
        cv::Mat imageMat = self.imageView.image.CVMat;
        rect.size = self.imageView.image.size;
        
        CGSize imageViewSize = self.imageView.frame.size;
        imageViewSize.height *= 2.0;
        imageViewSize.width *= 2.0;
        CGSize imageSize = rect.size;
        
        BOOL alignForWidth = YES;
        
        CGFloat imageX = 0.0;
        CGFloat imageY = 0.0;
        CGFloat imageFactor = 1.0;
        
        if (imageViewSize.width / imageViewSize.height > imageSize.width / imageSize.height)
        {
            alignForWidth = NO;
        }
        
        if (alignForWidth)
        {
            imageFactor = imageViewSize.width / imageSize.width;
            imageX = 0.0;
            if (imageSize.height * imageFactor > imageViewSize.height)
            {
                imageY = ((imageSize.height * imageFactor) - imageViewSize.height) * 0.5;
            }
            else
            {
                imageY = (imageViewSize.height - (imageSize.height * imageFactor)) * 0.5;
            }
        }
        else
        {
            imageFactor = imageViewSize.height / imageSize.height;
            if (imageSize.width * imageFactor > imageViewSize.width)
            {
                imageX = ((imageSize.width * imageFactor) - imageViewSize.width) * 0.5;
            }
            else
            {
                imageX = (imageViewSize.width - (imageSize.width * imageFactor)) * 0.5;
            }
            imageY = 0.0;
        }
        
        
//        // Rotate video frame by 90deg to portrait by combining a transpose and a flip
//        // Note that AVCaptureVideoDataOutput connection does NOT support hardware-accelerated
//        // rotation and mirroring via videoOrientation and setVideoMirrored properties so we
//        // need to do the rotation in software here.
//        cv::transpose(imageMat, imageMat);
//        CGFloat temp = rect.size.width;
//        rect.size.width = rect.size.height;
//        rect.size.height = temp;
//
//        if (videOrientation == AVCaptureVideoOrientationLandscapeRight)
//        {
//            // flip around y axis for back camera
//            cv::flip(imageMat, imageMat, 1);
//        }
//        else {
//            // Front camera output needs to be mirrored to match preview layer so no flip is required here
//        }
        
        videOrientation = AVCaptureVideoOrientationPortrait;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self clearFeatureMarkedLayers];
        });
        
        long long debugTotalTs = getTimeInMicrosecond();
        
        int index = 0;
        
        for (HaarDetectorWarpper* warpper in _cascadeDetectors)
        {
            if (warpper.canDetect)
            {
                long long debugStepTs = getTimeInMicrosecond();
                
                // Detect faces
                std::vector<cv::Rect> faces;
                warpper.featureCascade.detectMultiScale(imageMat, faces, 1.1, 2,warpper.haarOptions,cv::Size(6, 6));
                
                debugLog = [debugLog stringByAppendingFormat:@"[step] %@ used %llu ms\n",warpper.cascadeFileName, (getTimeInMicrosecond() - debugStepTs)/1000];
                
                // Dispatch updating of face markers to main queue
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self displayFaces:faces
                          forVideoRect:rect
                      videoOrientation:videOrientation
                     markedBorderColor:warpper.markedBorderColor
                       layerStartIndex:index
                          resizeFactor:imageFactor*0.5
               shouldTransFormForVideo:NO
                                startX:imageX*0.5
                                startY:imageY*0.5];
                    self.debugLabel.text = debugLog;
                });
                index += faces.size();
            }
        }
        
        debugLog = [debugLog stringByAppendingFormat:@"{{total}} all used %llu ms\n", (getTimeInMicrosecond() - debugTotalTs)/1000];
        
        gHasDetected = YES;
        dispatch_sync(dispatch_get_main_queue(), ^{
            //self.imageView.image = [UIImage imageWithCVMat:imageMat];
            self.changeButton.userInteractionEnabled = YES;
            [self.changeButton setTitle:@"Change" forState:UIControlStateNormal];
            self.debugLabel.text = debugLog;
        });
    }
    
}

// Update face markers given vector of face rectangles
- (void)displayFaces:(const std::vector<cv::Rect> &)faces 
       forVideoRect:(CGRect)rect 
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation
{
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	// hide all the face layers
	for (CALayer *layer in _featureLayers)
    {
        [layer setHidden:YES];
	}	
    
    // Create transform to convert from vide frame coordinate space to view coordinate space
    CGAffineTransform t = [self affineTransformForVideoFrame:rect orientation:videoOrientation];

    for (int i = 0; i < faces.size(); i++) {
  
        CGRect faceRect;
        faceRect.origin.x = faces[i].x;
        faceRect.origin.y = faces[i].y;
        faceRect.size.width = faces[i].width;
        faceRect.size.height = faces[i].height;
    
        faceRect = CGRectApplyAffineTransform(faceRect, t);
        
        CALayer *featureLayer = nil;
        
        if ([_featureLayers count] <= i)
        {
            // Create a new feature marker layer
			featureLayer = [[CALayer alloc] init];
            featureLayer.name = @"FaceLayer";
            featureLayer.borderColor = [[UIColor redColor] CGColor];
            featureLayer.borderWidth = 10.0f;
            [_featureLayers addObject:featureLayer];
			[self.view.layer addSublayer:featureLayer];
			[featureLayer release];
        }
        
        featureLayer = [_featureLayers objectAtIndex:i];
        
        [featureLayer setHidden:NO];
        
        featureLayer.frame = faceRect;
    }
    
    [CATransaction commit];
}

- (void)clearFeatureMarkedLayers
{
    // hide all the face layers
	for (CALayer *layer in _featureLayers)
    {
        [layer setHidden:YES];
	}
}

// Update face markers given vector of face rectangles
- (void)displayFaces:(const std::vector<cv::Rect> &)features
        forVideoRect:(CGRect)rect
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation
   markedBorderColor:(UIColor*)color
     layerStartIndex:(int)index
{
    [self displayFaces:features
          forVideoRect:rect
      videoOrientation:videoOrientation
     markedBorderColor:color
       layerStartIndex:index
          resizeFactor:1.0
shouldTransFormForVideo:YES
                startX:0.0
                startY:0.0];
}

// Update face markers given vector of face rectangles
- (void)displayFaces:(const std::vector<cv::Rect> &)features
        forVideoRect:(CGRect)rect
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation
   markedBorderColor:(UIColor*)color
     layerStartIndex:(int)index
        resizeFactor:(float)resizeFactor
shouldTransFormForVideo:(BOOL)trans
              startX:(CGFloat)startX
              startY:(CGFloat)startY;
{
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    // Create transform to convert from vide frame coordinate space to view coordinate space
    CGAffineTransform t = [self affineTransformForVideoFrame:rect orientation:videoOrientation];
    
    for (int i = 0; i < features.size(); i++) {
        
        CGRect faceRect;
        faceRect.origin.x = features[i].x * resizeFactor + startX;
        faceRect.origin.y = features[i].y * resizeFactor + startY;
        faceRect.size.width = features[i].width * resizeFactor;
        faceRect.size.height = features[i].height * resizeFactor;
        
        if (trans)
        {
            faceRect = CGRectApplyAffineTransform(faceRect, t);
        }
        
        CALayer *featureLayer = nil;
        
        if ([_featureLayers count] <= index + i)
        {
            // Create a new feature marker layer
			featureLayer = [[CALayer alloc] init];
            featureLayer.borderWidth = 3.0f;
            [_featureLayers addObject:featureLayer];
			[self.view.layer addSublayer:featureLayer];
			[featureLayer release];
        }
        
        featureLayer = [_featureLayers objectAtIndex:index + i];
        
        [featureLayer setHidden:NO];
        
        featureLayer.borderColor = [color CGColor];
        featureLayer.frame = faceRect;
    }
    
    [CATransaction commit];
}

@end
