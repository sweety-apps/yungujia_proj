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
        [_queue setMaxConcurrentOperationCount:1];
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
    if (!_isDetecting || _isCancelled)
    {
        return;
    }
    _isCancelled = YES;
    [_queue cancelAllOperations];
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
    [self performSelector:@selector(onHandledOperation:)
                 onThread:_callerThread
               withObject:_humanFeatures
            waitUntilDone:YES];
    
    [self taskInitHaarcascades];
    
    _detectStatus = kHFDStatusTaskInited;
    
    [self detectFirstHumanFeature];
}

- (void)taskInitHaarcascades
{
    ReleaseAndNil(_paramDict);
    _paramDict = [[NSMutableDictionary dictionary] retain];
    
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
        param.imageOrientation = kBodyHeadUp;
        [_paramDict setObject:param forKey:kFeatureKey(types[i])];
    }
    _humanFeatures.bodyOrientation = kBodyHeadUp;
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
        
        for (int i = 0; i < faces.size(); i++)
        {
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
        
        rect.origin.x /= _imageScale;
        rect.origin.y /= _imageScale;
        rect.size.width /= _imageScale;
        rect.size.height /= _imageScale;
        
        feature.rectToRawImageHeadUp = rect;
    }
    
    [_humanFeatures setFeature:feature forType:param.type];
    
    [self taskHandleDetectedResult];
}

- (void)taskHandleDetectedResult
{
    BOOL checked = NO;
    SEL sels[] = {@selector(checkFaceFeature),@selector(checkUpperBodyFeature),@selector(checkWholeBodyFeature),@selector(checkFeatureIsEnd)};
    for (int i = 0; i < (sizeof(sels)/sizeof(sels[0])); ++i)
    {
        checked = [((NSNumber*)[self performSelector:sels[i] withObject:nil]) boolValue];
        if (checked)
        {
            break;
        }
    }
    
    if (!checked)
    {
        _detectStatus = kHFDStatusStopping;
    }
    
    [self performSelector:@selector(onHandledOperation:)
                 onThread:_callerThread
               withObject:_humanFeatures
            waitUntilDone:YES];
}

- (void)taskDoCIDetectorDetection:(CIDetectorParam*)param
{
    //TODO
    [self taskHandleDetectedResult];
}

- (void)taskFinishedDetection
{
    _detectStatus = kHFDStatusStopping;
    [self performSelector:@selector(onHandledOperation:)
                 onThread:_callerThread
               withObject:_humanFeatures
            waitUntilDone:YES];
    _detectStatus = kHFDStatusStopped;
    _isDetecting = NO;
}

#pragma mark Handle Async Result

- (void)onHandledOperation:(DetectedHumanFeatures*)result
{
    if (_isCancelled)
    {
        _detectStatus = kHFDStatusStopping;
        [_queue waitUntilAllOperationsAreFinished];
        _isCancelled = NO;
        _isDetecting = NO;
        _detectStatus = kHFDStatusStopped;
        if (_notifyDelegate && [_notifyDelegate respondsToSelector:@selector(onCancelledWithFeature:forDetector:)])
        {
            [_notifyDelegate onCancelledWithFeature:_humanFeatures forDetector:self];
        }
        [self releaseAllResources];
        return;
    }
    
    
    if (_detectStatus == kHFDStatusStarting)
    {
        if (_notifyDelegate && [_notifyDelegate respondsToSelector:@selector(onStarted:)])
        {
            [_notifyDelegate onStarted:self];
        }
        return;
    }
    
    if (result.currentDetectedFeature && result.currentDetectedFeature.detected)
    {
        if (_notifyDelegate && [_notifyDelegate respondsToSelector:@selector(onDetectedFeature:forDetector:)])
        {
            [_notifyDelegate onDetectedFeature:result forDetector:self];
        }
    }
    
    if (_detectStatus == kHFDStatusStopping)
    {
        if (_notifyDelegate && [_notifyDelegate respondsToSelector:@selector(onFinishedWithFeature:forDetector:)])
        {
            [_notifyDelegate onFinishedWithFeature:_humanFeatures forDetector:self];
        }
        [self releaseAllResources];
    }
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
    ReleaseAndNil(_callerThread);
}

- (BOOL)detectHumanFeature:(UIImage*)image
               forDelegate:(id<HumanFeatureDetectorDelegate>)delegate
               shouldAsync:(BOOL)async
{
    if (_isDetecting)
    {
        return NO;
    }
    
    [self releaseAllResources];
    
    _isCancelled = NO;
    _detectStatus = kHFDStatusStarting;
    
    _notifyDelegate = [delegate retain];
    _rawImage = [image retain];
    _humanFeatures = [[DetectedHumanFeatures alloc] init];
    _callerThread = [[NSThread currentThread] retain];
    
    float scale = 1.0;
    if (kScaleToWidth > 0.0)
    {
        scale = ((float)kScaleToWidth) / _rawImage.size.width;
    }
    
    _imageScale = scale;
    _scaledImage = [[UIImage imageWithCGImage:_rawImage.CGImage scale:scale orientation:UIImageOrientationUp] retain];
    
    _isDetecting = YES;
    _isAsync = async;
    _lastOrientation = kBodyHeadUp;
    
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

#pragma mark result checkouts

- (void)setUnconfirmed
{
    switch (_lastOrientation)
    {
        case kBodyHeadUp:
        {
            _detectStatus = kHFDStatusUnConfirmOriginal;
        }
            break;
        case kBodyHeadLeft:
        {
            _detectStatus = kHFDStatusUnConfirmRotated;
        }
            break;
        case kBodyHeadDown:
        {
            _detectStatus = kHFDStatusUnConfirmFliped;
        }
            break;
        case kBodyHeadRight:
        {
            _detectStatus = kHFDStatusUnConfirmFlipedRotated;
        }
            break;
        default:
            break;
    }
}

- (BOOL)checkAndDoFlipAndRotation
{
    BOOL ret = YES;
    BOOL shouldRotate90Degree = NO;
    
    switch (_lastOrientation)
    {
        case kBodyHeadUp:
        {
            if (_detectStatus == kHFDStatusUnConfirmOriginal)
            {
                shouldRotate90Degree = YES;
                _lastOrientation = kBodyHeadLeft;
            }
        }
            break;
        case kBodyHeadLeft:
        {
            if (_detectStatus == kHFDStatusUnConfirmRotated)
            {
                shouldRotate90Degree = YES;
                _lastOrientation = kBodyHeadDown;
            }
        }
            break;
        case kBodyHeadDown:
        {
            if (_detectStatus == kHFDStatusUnConfirmFliped)
            {
                shouldRotate90Degree = YES;
                _lastOrientation = kBodyHeadRight;
            }
        }
            break;
        default:
        {
            ret = NO;
        }
            break;
    }
    
    if (shouldRotate90Degree)
    {
        cv::Mat imageMat = [_scaledImage CVMat];
        cv::transpose(imageMat, imageMat);
        for (HaarDetectorParam* param in _paramDict)
        {
            param.imageMat = imageMat;
            param.imageOrientation = _lastOrientation;
        }
        _humanFeatures.bodyOrientation = _lastOrientation;
    }
    
    return ret;
}

- (BOOL)hasNeverDetectedFace
{
    if (_detectStatus == kHFDStatusTaskInited || _detectStatus == kHFDStatusUnConfirmOriginal || _detectStatus == kHFDStatusUnConfirmRotated || _detectStatus == kHFDStatusUnConfirmFliped)
    {
        return YES;
    }
    return NO;
}

- (BOOL)checkDetectedFeatureFaceDetailHaar
{
    BOOL ret = NO;
    
    HumanFeature* face = [_humanFeatures getFeatureByType:kHumanFeatureFace];
    HumanFeature* eyePair = [_humanFeatures getFeatureByType:kHumanFeatureEyePair];
    HumanFeature* nose = [_humanFeatures getFeatureByType:kHumanFeatureNose];
    HumanFeature* mouth = [_humanFeatures getFeatureByType:kHumanFeatureMouth];
    
    if (face && face.detected)
    {
        BOOL eyesIsInside = NO;
        BOOL noseIsInside = NO;
        BOOL mouthIsInside = NO;
        
        if (eyePair && eyePair.detected)
        {
            if (CGRectContainsRect(face.rect,eyePair.rect) || CGRectIntersectsRect(face.rect,eyePair.rect))
            {
                eyesIsInside = YES;
            }
        }
        
        if (nose && nose.detected)
        {
            if (CGRectContainsRect(face.rect,nose.rect) || CGRectIntersectsRect(face.rect,nose.rect))
            {
                noseIsInside = YES;
            }
        }
        
        if (mouth && mouth.detected)
        {
            if (CGRectContainsRect(face.rect,mouth.rect) || CGRectIntersectsRect(face.rect,mouth.rect))
            {
                mouthIsInside = YES;
            }
        }
        
        if ((eyesIsInside && noseIsInside) || (eyesIsInside && noseIsInside) || (eyesIsInside && mouthIsInside) || (noseIsInside && mouthIsInside))
        {
            ret = YES;
        }
        
    }
    
    return ret;
}

- (NSNumber*)checkFaceFeature
{
    BOOL ret = NO;
    
    if ([self hasNeverDetectedFace])
    {
        HaarDetectorParam* param = nil;
        
        if (_humanFeatures.currentDetectedFeatureType == kHumanFeatureFace)
        {
            HumanFeature* feature = _humanFeatures.currentDetectedFeature;
            if (feature && feature.detected)
            {
                param = [_paramDict objectForKey:kFeatureKey(kHumanFeatureEyePair)];
            }
            else
            {
                [self setUnconfirmed];
            }
        }
        
        if (_humanFeatures.currentDetectedFeatureType == kHumanFeatureEyePair)
        {
            param = [_paramDict objectForKey:kFeatureKey(kHumanFeatureNose)];
        }
        
        if (_humanFeatures.currentDetectedFeatureType == kHumanFeatureNose)
        {
            param = [_paramDict objectForKey:kFeatureKey(kHumanFeatureMouth)];
        }
        
        if (_humanFeatures.currentDetectedFeatureType == kHumanFeatureMouth)
        {
            if ([self checkDetectedFeatureFaceDetailHaar])
            {
                param = [_paramDict objectForKey:kFeatureKey(kHumanFeatureUpperBody)];
                _detectStatus = kHFDStatusConfirmedFace;
            }
            else
            {
                [self setUnconfirmed];
            }
        }
        
        if (param)
        {
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
        
        ret = YES;
    }
    
    return [NSNumber numberWithBool:ret];
}

- (NSNumber*)checkUpperBodyFeature
{
    BOOL ret = NO;
    
    if (_detectStatus == kHFDStatusConfirmedFace)
    {
        HaarDetectorParam* param = nil;
        
        if (_humanFeatures.currentDetectedFeatureType == kHumanFeatureUpperBody)
        {
            HumanFeature* upperBody = [_humanFeatures getFeatureByType:kHumanFeatureUpperBody];
            HumanFeature* face = [_humanFeatures getFeatureByType:kHumanFeatureFace];
            if (upperBody && upperBody.detected &&
                (CGRectContainsRect(upperBody.rect,face.rect) || CGRectIntersectsRect(upperBody.rect,face.rect)))
            {
                param = [_paramDict objectForKey:kFeatureKey(kHumanFeatureLowerBody)];
                _detectStatus = kHFDStatusConfirmedUpperBody;
            }
            else
            {
                [self setUnconfirmed];
            }
        }
        
        if (param)
        {
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
        
        ret = YES;
    }
    
    return [NSNumber numberWithBool:ret];
}

- (NSNumber*)checkWholeBodyFeature
{
    BOOL ret = NO;
    
    if (_detectStatus == kHFDStatusConfirmedUpperBody)
    {
        HaarDetectorParam* param = nil;
        
        /*
        if (_humanFeatures.currentDetectedFeatureType == kHumanFeatureUpperBody)
        {
            HumanFeature* upperBody = [_humanFeatures getFeatureByType:kHumanFeatureUpperBody];
            HumanFeature* face = [_humanFeatures getFeatureByType:kHumanFeatureFace];
            if (upperBody && upperBody.detected &&
                (CGRectContainsRect(upperBody.rect,face.rect) || CGRectIntersectsRect(upperBody.rect,face.rect)))
            {
                param = [_paramDict objectForKey:kFeatureKey(kHumanFeatureLowerBody)];
                _detectStatus = kHFDStatusConfirmedUpperBody;
            }
            else
            {
                [self setUnconfirmed];
            }
        }
         */
        
        if (param)
        {
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
        
        ret = YES;
    }
    
    return [NSNumber numberWithBool:ret];
}

- (NSNumber*)checkFeatureIsEnd
{
    return [NSNumber numberWithBool:[self checkAndDoFlipAndRotation]];
}

- (void)detectFirstHumanFeature
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


@end
