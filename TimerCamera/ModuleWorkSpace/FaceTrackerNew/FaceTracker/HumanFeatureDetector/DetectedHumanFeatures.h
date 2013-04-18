//
//  DetectedHumanFeatures.h
//  FaceTracker
//
//  Created by lijinxin on 13-4-5.
//
//

#import <Foundation/Foundation.h>
#import "HumanFeatureDefines.h"

@interface HumanFeature : NSObject
{
    
}

@property (nonatomic,assign) BOOL detected;
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,assign) HumanFeatureType type;
@property (nonatomic,assign) CGSize rawImageSize;

- (CGRect)scaledRectToUIImageView:(UIImageView*)imageView;

@end

@interface DetectedHumanFeatures : NSObject
{
    NSMutableDictionary* _featureDict;
}

- (void)setFeature:(HumanFeature*)feature forType:(HumanFeatureType)feature;
- (HumanFeature*)getFeatureByType:(HumanFeatureType)feature;
- (int)detectedFeatureCount;

@property (nonatomic,assign,readonly) HumanFeature* currentDetectedFeature;
@property (nonatomic,assign,readonly) HumanFeatureType currentDetectedFeatureType;
@property (nonatomic,assign) BOOL isDetectionFinished;
@property (nonatomic,assign) HumanBodyOrientation bodyOrientation;

@end
