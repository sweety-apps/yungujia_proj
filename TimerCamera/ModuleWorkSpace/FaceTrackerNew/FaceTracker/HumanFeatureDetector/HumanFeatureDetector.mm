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
- (void)taskHandleDetectedResult;
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
        param.type = types[i];
        param.imageMat = imageMat;
        param.scale = _imageScale;
        [_paramDict setObject:param forKey:kFeatureKey(types[i])];
    }
}

- (void)taskDoHaarDetection:(HaarDetectorParam*)param
{
    NSString* debugLog = @"";
    
    // Shrink video frame to 320X240
    cv::Mat imageMat = param.imageMat;
    
    long long debugTotalTs = getTimeInMicrosecond();
    
    // Detect faces
    std::vector<cv::Rect> faces;
    param.featureCascade.detectMultiScale(imageMat, faces, 1.1, 2, param.haarOptions,cv::Size(6, 6));
    
    debugLog = [debugLog stringByAppendingFormat:@"{{total}} all used %llu ms\n", (getTimeInMicrosecond() - debugTotalTs)/1000];
    
    NSLog(@"%@",debugLog);
    
    HumanFeature* feature = nil;
    
    if (faces.size() > 0)
    {
        feature = [[[HumanFeature alloc] init] autorelease];
        
        CGRect rect = CGRectZero;
        
        for (int i = 0; i < faces.size(); i++) {
            
            CGRect faceRect;
            faceRect.origin.x = faces[i].x;
            faceRect.origin.y = faces[i].y;
            faceRect.size.width = faces[i].width;
            faceRect.size.height = faces[i].height;
            
            if (!CGSizeEqualToSize(faceRect.size,CGSizeZero))
            {
                rect = faceRect;
                break;
            }
        }
        
        feature.rect = rect;
        feature.detected = CGSizeEqualToSize(rect.size,CGSizeZero) ? NO : YES;
        feature.type = param.type;
        feature.rawImageSize = _rawImage.size;
    }
    
    [_humanFeatures setFeature:feature forType:param.type];
    
    [self taskHandleDetectedResult];
}

- (void)taskHandleDetectedResult
{
    HumanFeature* feature = _humanFeatures.currentDetectedFeature;
    
    if (_humanFeatures.currentDetectedFeatureType == kHumanFeatureFace && _detectStatus == kHFDStatusTaskInited)
    {
        if (feature && feature.detected)
        {
            HaarDetectorParam* param = [_paramDict objectForKey:kFeatureKey(kHumanFeatureEyePair)];
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
        else
        {
            
        }
    }
    
    if (feature.type == kHumanFeatureFace && _detectStatus == kHFDStatusTaskInited)
    {
        HaarDetectorParam* param = [_paramDict objectForKey:kFeatureKey(kHumanFeatureEyePair)];
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
}

- (void)taskDoCIDetectorDetection:(CIDetectorParam*)param
{
    //TODO
    [self taskHandleDetectedResult];
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
    
    _imageScale = scale;
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
        case kHFDStatusUnConfirmOriginal:
        {
            
        }
            break;
        case kHFDStatusUnConfirmRotated:
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
