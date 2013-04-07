//
//  HumanFeatureDetector.m
//  FaceTracker
//
//  Created by lijinxin on 13-4-5.
//
//

#import "HumanFeatureDetector.h"
#import "UIImage+OpenCV.h"
#import "HaarDetectorParam.h"

#define kHumanFeatureDetectionQueue @"HumanFeatureDetectionQueue"

@interface HumanFeatureDetector (Tasks)

- (void)taskStart;
- (void)taskInitHaarcascades;
- (void)taskDoDetection;

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
        gDetector = [[HumanFeatureDetector alloc] initWithCascadeXmlsDir:@""];
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
    ReleaseAndNil(_paramDict);
    ReleaseAndNil(_notifyDelegate);
    ReleaseAndNil(_rawImage);
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
    if (_isAsync)
    {
        
    }
    else
    {
        
    }
}

- (void)taskInitHaarcascades
{
    ReleaseAndNil(_paramDict);
    _paramDict = [NSMutableDictionary dictionary];
    
    HumanFeatureType types[kHumanFeatureTypeCount] = {
        kHumanFeatureFace,
        kHumanFeatureLeftEye,
        kHumanFeatureRightEye,
        kHumanFeatureEyePair,
        kHumanFeatureNose,
        kHumanFeatureMouth,
        kHumanFeatureUpperBody,
        kHumanFeatureLowerBody,
    };
    
    // Name of face cascade resource file without xml extension
    NSString* cascadeFilenames[kHumanFeatureTypeCount] = {
        @"haarcascade_mcs_eyepair_small",
        @"haarcascade_mcs_eyepair_big",
        @"haarcascade_frontalface_alt2",
        @"haarcascade_mcs_upperbody",
        //@"haarcascade_lefteye_2splits",
        //@"haarcascade_righteye_2splits",
        @"haarcascade_mcs_nose",
        @"haarcascade_mcs_mouth",
    };
    
    // Options for cv::CascadeClassifier::detectMultiScale
    int haarOptions[kHumanFeatureTypeCount] = {
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH,
        CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH
    };
    
    // Load the face Haar cascade from resources
    for (int i = 0; i < sizeof(cascadeFilenames)/sizeof(NSString*); ++i)
    {
        NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:cascadeFilenames[i] ofType:@"xml"];
        HaarDetectorParam* param = [[[HaarDetectorParam alloc] initWith:cascadeFilenames[i] filePath:faceCascadePath options:haarOptions[i]] autorelease];
        [_paramDict setObject:param forKey:[NSString stringWithFormat:@"%d",types[i]]];
    }
}

- (void)taskDoDetection
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
    _notifyDelegate = [delegate retain];
    _rawImage = [image retain];
    
    _isDetecting = YES;
    _isAsync = async;
    
    if (async)
    {
        NSInvocationOperation* op = [[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(taskStart)
                                                                           object:nil];
        
        [_queue addOperation:op];
    }
    else
    {
        [self taskStart];
    }
    
    return YES;
}

#pragma mark Handle Async Result

- (void)onHandledOperation
{
    
}

@end
