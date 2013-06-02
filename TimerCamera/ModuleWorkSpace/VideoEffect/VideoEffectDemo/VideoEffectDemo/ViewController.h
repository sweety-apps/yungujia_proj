//
//  ViewController.h
//  VideoEffectDemo
//
//  Created by lijinxin on 13-6-1.
//  Copyright (c) 2013年 lijinxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

#define ENABLE_VIDEO_RECORDING 0

@interface ViewController : UIViewController
{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *overlayImageFilter;
    GPUImageOutput<GPUImageInput> *motionDetectorFilter;
    GPUImageOutput<GPUImageInput> *effectUIFilter;
    GPUImageAlphaBlendFilter *blendFilter;
    NSMutableArray * effectUIArray;
    NSUInteger effectHandlingIndex;
    GPUImageMovieWriter *movieWriter;
}

@end
