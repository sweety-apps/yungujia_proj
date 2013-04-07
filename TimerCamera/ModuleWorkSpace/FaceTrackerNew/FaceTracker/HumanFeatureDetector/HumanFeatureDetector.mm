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

#define kHumanFeatureDetectionQueue @"HumanFeatureDetectionQueue"
#define kFeatureKey(x) [NSString stringWithFormat:@"%d",(x)]
#define kScaleToWidth (-1)

@interface HumanFeatureDetector (Tasks)

- (void)taskStart;
- (void)taskInitHaarcascades;
- (void)taskDoHaarDetection:(HaarDetectorParam*)param;
- (void)taskDoCIDetectorDetection:(CIDetectorParam*)param;

@end

@interface HumanFeatureDetector (InnerMethods)

- (BOOL)detectHumanFeature:(UIImage*)image
               forDelegate:(id<HumanFeatureDetectorDelegate>)delegate
               shouldAsync:(BOOL)async;

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
    }
    return self;
}

- (void)dealloc
{
    //
    [self cancelAsyncDetection];
    ReleaseAndNil(_paramDict);
    ReleaseAndNil(_notifyDelegate);
    ReleaseAndNil(_rawImage);
    ReleaseAndNil(_scaledImage);
    ReleaseAndNil(_queue);
    ReleaseAndNil(_xmlDir);
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
    
}

- (void)taskDoCIDetectorDetection:(CIDetectorParam*)param
{
    
}

#pragma mark Inner Methods

- (BOOL)detectHumanFeature:(UIImage*)image
               forDelegate:(id<HumanFeatureDetectorDelegate>)delegate
               shouldAsync:(BOOL)async
{
    if (_isDetecting)
    {
        return NO;
    }
    ReleaseAndNil(_notifyDelegate);
    ReleaseAndNil(_rawImage);
    ReleaseAndNil(_scaledImage);
    _notifyDelegate = [delegate retain];
    _rawImage = [image retain];
    
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

#pragma mark Handle Async Result

- (void)onHandledOperation:(DetectedHumanFeatures*)result
{
    
}

@end
