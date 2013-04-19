//
//  HumanFeatureDetecor.h
//  FaceTracker
//
//  Created by lijinxin on 13-4-5.
//
//

#import <UIKit/UIKit.h>
#import "DetectedHumanFeatures.h"

@class HumanFeatureDetector;

@protocol HumanFeatureDetectorDelegate <NSObject>

- (void)onDetectedFeature:(DetectedHumanFeatures*)feature
              forDetector:(HumanFeatureDetector*)detector;
- (void)onStarted:(HumanFeatureDetector*)detector;
- (void)onCancelledWithFeature:(DetectedHumanFeatures*)feature
                   forDetector:(HumanFeatureDetector*)detector;
- (void)onFinishedWithFeature:(DetectedHumanFeatures*)feature
                  forDetector:(HumanFeatureDetector*)detector ;

@end

typedef enum enumHumanFeatureDetectorStateType {
    kHFDStatusStopped = 0,
    kHFDStatusStarting,
    kHFDStatusTaskInited,
    kHFDStatusUnConfirmOriginal,
    kHFDStatusUnConfirmRotated,
    kHFDStatusUnConfirmFliped,
    kHFDStatusUnConfirmFlipedRotated,
    kHFDStatusConfirmedFace,
    kHFDStatusConfirmedUpperBody,
    kHFDStatusConfirmedWholeBody,
    kHFDStatusStopping,
    kHFDStatusCount
}HumanFeatureDetectorStateType;

@interface HumanFeatureDetector : NSObject
{
    NSOperationQueue* _queue;
    BOOL _isDetecting;
    NSString* _xmlDir;
    
    id<HumanFeatureDetectorDelegate> _notifyDelegate;
    UIImage* _rawImage;
    BOOL _isAsync;
    BOOL _isCancelled;
    
    NSMutableDictionary* _paramDict;
    UIImage* _scaledImage;
    float _imageScale;
    NSThread* _callerThread;
    HumanBodyOrientation _lastOrientation;
    
    DetectedHumanFeatures* _humanFeatures;
    
    HumanFeatureDetectorStateType _detectStatus;
}

+ (HumanFeatureDetector*)sharedInstance;
- (id)initWithCascadeXmlsDir:(NSString*)dir;
- (BOOL)startAsyncDetection:(UIImage*)image forDelegate:(id<HumanFeatureDetectorDelegate>)delegate;
- (void)cancelAsyncDetection;
- (BOOL)isAsyncDetecting;
- (BOOL)syncDetect:(UIImage*)image forDelegate:(id<HumanFeatureDetectorDelegate>)delegate;

@end
