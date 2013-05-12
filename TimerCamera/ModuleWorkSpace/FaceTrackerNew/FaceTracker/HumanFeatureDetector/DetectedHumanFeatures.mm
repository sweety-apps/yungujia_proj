//
//  DetectedHumanFeatures.m
//  FaceTracker
//
//  Created by lijinxin on 13-4-5.
//
//

#import "DetectedHumanFeatures.h"
#import "HaarDetectorParam.h"

#pragma mark - HumanFeature

@implementation HumanFeature

@synthesize detected = _detected;
@synthesize rect = _rect;
@synthesize type = _type;
@synthesize rawImageSize = _rawImageSize;
@synthesize rectToRawImageHeadUp = _rectToRawImageHeadUp;

- (void)dealloc
{
    [super dealloc];
}

@end

#pragma mark - DetectedHumanFeatures

@implementation DetectedHumanFeatures

@synthesize currentDetectedFeature = _currentDetectedFeature;
@synthesize isDetectionFinished = _isDetectionFinished;
@synthesize bodyHeadOrientationAngle = _bodyHeadOrientationAngle;
@synthesize currentDetectedFeatureType = _currentDetectedFeatureType;

- (id)init
{
    self = [super init];
    if (self) {
        _featureDict = [[NSMutableDictionary dictionary] retain];
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNil(_featureDict);
    [super dealloc];
}

- (void)setFeature:(HumanFeature*)result forType:(HumanFeatureType)feature
{
    if (result)
    {
        [_featureDict setObject:result forKey:[NSString stringWithFormat:@"%i",feature]];
    }
    else
    {
        [_featureDict removeObjectForKey:[NSString stringWithFormat:@"%i",feature]];
    }
    _currentDetectedFeature = result;
    _currentDetectedFeatureType = feature;
}

- (HumanFeature*)getFeatureByType:(HumanFeatureType)feature
{
    return [_featureDict objectForKey:[NSString stringWithFormat:@"%i",feature]];
}

- (int)detectedFeatureCount
{
    return [[_featureDict allValues] count];
}

@end
