//
//  HaarDetectorParam.h
//  FaceTracker
//
//  Created by lijinxin on 13-4-7.
//
//

#import <UIKit/UIKit.h>
#ifdef __cplusplus
#import <OpenCV/opencv2/opencv.hpp>
#endif

#import "BaseDetectorParam.h"
#import "HumanFeatureDefines.h"

@interface HaarDetectorParam : BaseDetectorParam
{
    
}

@property (nonatomic, assign) HumanFeatureType type;
@property (nonatomic, retain) NSString * cascadeFilePath;
@property (nonatomic, retain) NSString * cascadeFileName;
@property (nonatomic, assign) int haarOptions;
@property (nonatomic, assign) cv::CascadeClassifier featureCascade;
@property (nonatomic, assign, readonly) BOOL canDetect;
@property (nonatomic, assign) cv::Mat imageMat;
@property (nonatomic, assign) float scale;

- (id)initWith:(NSString*)fileName filePath:(NSString*)filePath options:(int)haarOptions;

@end
