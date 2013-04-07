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

- (CGRect)scaledRectToUIImageView:(UIImageView*)imageView
{
    
}

@end

#pragma mark - DetectedHumanFeatures

@implementation DetectedHumanFeatures

@synthesize currentDetectedFeature = _currentDetectedFeature;
@synthesize isDetectionFinished = _isDetectionFinished;
@synthesize bodyOrientation = _bodyOrientation;

- (HumanFeature*)getFeatureByType:(HumanFeatureType)feature
{
    
}

- (int)detectedFeatureCount
{
    
}

@end
