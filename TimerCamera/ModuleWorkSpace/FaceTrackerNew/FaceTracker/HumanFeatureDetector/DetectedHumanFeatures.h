//
//  DetectedHumanFeatures.h
//  FaceTracker
//
//  Created by lijinxin on 13-4-5.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    kHumanFeatureFace = 0,
    kHumanFeatureLeftEye,
    kHumanFeatureRightEye,
    kHumanFeatureEyePair,
    kHumanFeatureNose,
    kHumanFeatureMouth,
    kHumanFeatureUpperBody,
    kHumanFeatureLowerBody,
    kHumanFeatureTypeCount
} HumanFeatureType;

typedef enum {
    kBodyHeadUp = 0,
    kBodyHeadLeft,
    kBodyHeadRight,
    kBodyHeadDown,
    kBodyOrientationCount
} HumanBodyOrientation;

@interface HumanFeature : NSObject
{
    
}

@property (nonatomic,assign) BOOL detected;
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,assign) HumanFeatureType type;

@end

@interface DetectedHumanFeatures : NSObject
{
    NSMutableDictionary* _featureDict;
}

- (HumanFeature*)getFeatureByType:(HumanFeatureType)feature;
- (int)detectedFeatureCount;

@property (nonatomic,assign) HumanFeature* currentDetectedFeature;
@property (nonatomic,assign) BOOL isDetectionFinished;
@property (nonatomic,assign) HumanBodyOrientation bodyOrientation;

@end
