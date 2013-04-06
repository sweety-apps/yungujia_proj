//
//  HaarDetectorParam.h
//  FaceTracker
//
//  Created by lijinxin on 13-4-7.
//
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
#import <OpenCV/opencv2/opencv.hpp>
#endif

@interface HaarDetectorParam : NSObject

@property (nonatomic, retain) NSString * cascadeFilePath;
@property (nonatomic, retain) NSString * cascadeFileName;
@property (nonatomic, assign) int haarOptions;
@property (nonatomic, assign) cv::CascadeClassifier featureCascade;
@property (nonatomic, assign, readonly) BOOL canDetect;
@property (nonatomic, assign) cv::Mat rawImageMat;
@property (nonatomic, assign) cv::Mat transformedImageMat;

@end
