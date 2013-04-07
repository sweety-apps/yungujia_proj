//
//  CIDetectorParam.h
//  FaceTracker
//
//  Created by lijinxin on 13-4-8.
//
//

#import <Foundation/Foundation.h>
#import "HumanFeatureDefines.h"
#import "BaseDetectorParam.h"

@interface CIDetectorParam : BaseDetectorParam

@property (nonatomic, retain) UIImage* image;

- (id)initWithImage:(UIImage*)image;

@end
