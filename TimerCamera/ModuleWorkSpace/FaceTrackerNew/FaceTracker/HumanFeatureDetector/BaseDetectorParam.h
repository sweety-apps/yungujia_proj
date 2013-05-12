//
//  BaseDetectorParam.h
//  FaceTracker
//
//  Created by lijinxin on 13-4-8.
//
//

#import <Foundation/Foundation.h>
#import "HumanFeatureDefines.h"

@interface BaseDetectorParam : NSObject

@property (nonatomic, assign) HumanFeatureType featureType;
@property (nonatomic, assign) float imageOrientationAngle;
@property (nonatomic,retain) NSOperation* asyncOperation;

@end
