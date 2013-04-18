//
//  HumanFeatureDetector.m
//  FaceTracker
//
//  Created by lijinxin on 13-4-5.
//
//

#import <CoreImage/CoreImage.h>
#import "HumanFeatureDetector.h"
#import "UIImage+OpenCV.h"
#import "HaarDetectorParam.h"
#import "CIDetectorParam.h"
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


#define kHumanFeatureDetectionQueue @"HumanFeatureDetectionQueue"
#define kFeatureKey(x) [NSString stringWithFormat:@"%d",(x)]
#define kScaleToWidth (-1)

@interface HumanFeatureDetector (Tasks)

- (void)taskStart;
- (void)taskInitHaarcascades;
- (void)taskDoHaarDetection:(HaarDetectorParam*)param;
- (void)taskDoCIDetectorDetection:(CIDetectorParam*)param;
- (void)taskFinishedDetection;

@end

@interface HumanFeatureDetector (InnerMethods)

- (BOOL)detectHumanFeature:(UIImage*)image
               forDelegate:(id<HumanFeatureDetectorDelegate>)delegate
               shouldAsync:(BOOL)async;

- (void)doDetectOneHumanFeature;

@end

#pragma mark - HumanFeatureDetecor

static HumanFeatureDetector* gDetector = nil;

@implementation HumanFeatureDetector

#pragma mark Public Methods

+ (HumanFeatureDetector*)sharedInstance
{
    if (gDetector == nil)
    {
        gDetector = [[HumanFeatureDetector alloc] initWithCascadeXmlsDir:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/"]];
    }
    return gDetector;
}

- (id)initWithCascadeXmlsDir:(NSString*)dir
{
    self = [self init];
    if (self)
    {
        //
        _queue = [[NSOperationQueue alloc] init];
        [_queue setName:kHumanFeatureDetectionQueue];
        _xmlDir = [dir retain];
        _detectStatus = kHFDStatusStopped;
    }
    return self;
}

- (void)dealloc
{
    //
    [self cancelAsyncDetection];
    [self releaseAllResources];
    ReleaseAndNil(_queue);
    [super dealloc];
}

- (BOOL)startAsyncDetection:(UIImage*)image forDelegate:(id<HumanFeatureDetectorDelegate>)delegate
{
    return [self detectHumanFeature:image
                        forDelegate:delegate
                        shouldAsync:YES];
}

- (void)cancelAsyncDetection
{
    if (!_isDetecting)
    {
        return;
    }
    [_queue cancelAllOperations];
    _isDetecting = NO;
}

- (BOOL)isAsyncDetecting
{
    return _isDetecting;
}

- (BOOL)syncDetect:(UIImage*)image forDelegate:(id<HumanFeatureDetectorDelegate>)delegate
{
    return [self detectHumanFeature:image
                        forDelegate:delegate
                        shouldAsync:NO];
}

#pragma mark Async Task Methods

- (void)taskStart
{
    [self taskInitHaarcascades];
    
    _detectStatus = kHFDStatusTaskInited;
    
    [self doDetectOneHumanFeature];
}

- (void)taskInitHaarcascades
{
    ReleaseAndNil(_paramDict);
    _paramDict = [NSMutableDictionary dictionary];
    
    cv::Mat imageMat = [_scaledImage CVMat];
    
    HumanFeatureType types[kHumanFeatureTypeCount] = {
        kHumanFeatureFace,
        kHumanFeatureLeftEye,
        kHumanFeatureRightEye,
        kHumanFeatureEyePair,
        kHumanFeatureNose,
        kHumanFeatureMouth,
        kHumanFeatureUpperBody,
        kHumanFeatureLowerBody
    };
    
    // Name of face cascade resource file without xml extension
    NSString* cascadeFilenames[kHumanFeatureTypeCount] = {
        @"haarcascade_frontalface_alt2",
        @"haarcascade_lefteye_2splits",
        @"haarcascade_righteye_2splits",
        @"haarcascade_mcs_eyepair_big",
        @"haarcascade_mcs_nose",
        @"haarcascade_mcs_mouth",
        @"haarcascade_mcs_upperbody",
        @"haarcascade_lowerbody"
    };
    
    // Options for cv::CascadeClassifier::detectMultiScale
    int haarOptions[kHumanFeatureTypeCount] = {
        CV_HAAR_SCALE_IMAGE | CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_SCALE_IMAGE | CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_SCALE_IMAGE | CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_SCALE_IMAGE | CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_SCALE_IMAGE | CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_SCALE_IMAGE | CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_SCALE_IMAGE | CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_SCALE_IMAGE | CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH
    };
    
    // Load the face Haar cascade from resources
    for (int i = 0; i < sizeof(cascadeFilenames)/sizeof(NSString*); ++i)
    {
        NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:cascadeFilenames[i] ofType:@"xml"];
        HaarDetectorParam* param = [[[HaarDetectorParam alloc] initWith:cascadeFilenames[i] filePath:faceCascadePath options:haarOptions[i]] autorelease];
        param.imageMat = imageMat;
        [_paramDict setObject:param forKey:kFeatureKey(types[i])];
    }
}

- (void)taskDoHaarDetection:(HaarDetectorParam*)param
{
    NSString* debugLog = @"";
    
    CGRect rect;
    
    // Shrink video frame to 320X240
    cv::Mat imageMat = param.;
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

- (void)taskDoCIDetectorDetection:(CIDetectorParam*)param
{
    
}

- (void)taskFinishedDetection
{
    [self releaseAllResources];
    _detectStatus = kHFDStatusStopped;
}

#pragma mark Inner Methods

- (void)releaseAllResources
{
    ReleaseAndNil(_paramDict);
    ReleaseAndNil(_notifyDelegate);
    ReleaseAndNil(_rawImage);
    ReleaseAndNil(_scaledImage);
    ReleaseAndNil(_xmlDir);
    ReleaseAndNil(_humanFeatures);
}

- (BOOL)detectHumanFeature:(UIImage*)image
               forDelegate:(id<HumanFeatureDetectorDelegate>)delegate
               shouldAsync:(BOOL)async
{
    if (_isDetecting)
    {
        return NO;
    }
    
    [_queue waitUntilAllOperationsAreFinished];
    [self taskFinishedDetection];
    
    _detectStatus = kHFDStatusStarting;
    
    _notifyDelegate = [delegate retain];
    _rawImage = [image retain];
    _humanFeatures = [[DetectedHumanFeatures alloc] init];
    
    float scale = 1.0;
    if (kScaleToWidth > 0.0)
    {
        scale = ((float)kScaleToWidth) / _rawImage.size.width;
    }
    _scaledImage = [[UIImage imageWithCGImage:_rawImage.CGImage scale:scale orientation:UIImageOrientationUp] retain];
    
    _isDetecting = YES;
    _isAsync = async;
    
    if (async)
    {
        NSInvocationOperation* op = [[[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(taskStart)
                                                                           object:nil] autorelease];
        
        [_queue addOperation:op];
    }
    else
    {
        [self taskStart];
    }
    
    return YES;
}

- (void)doDetectOneHumanFeature
{
    switch (_detectStatus)
    {
        case kHFDStatusTaskInited:
        {
            HaarDetectorParam* param = [_paramDict objectForKey:kFeatureKey(kHumanFeatureFace)];
            if (_isAsync)
            {
                NSInvocationOperation* op = [[[NSInvocationOperation alloc] initWithTarget:self
                                                                                  selector:@selector(taskDoHaarDetection:)
                                                                                    object:param] autorelease];
                param.asyncOperation = op;
                [_queue addOperation:op];
            }
            else
            {
                [self taskDoHaarDetection:param];
            }
        }
            break;
        case kHFDStatusConfirmedFace:
        {
            
        }
            break;
        case kHFDStatusConfirmedUpperBody:
        {
            
        }
            break;
        case kHFDStatusConfirmedWholeBody:
        {
            
        }
            break;
        case kHFDStatusStopping:
        {
            
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark Handle Async Result

- (void)onHandledOperation:(DetectedHumanFeatures*)result
{
    
}

@end
