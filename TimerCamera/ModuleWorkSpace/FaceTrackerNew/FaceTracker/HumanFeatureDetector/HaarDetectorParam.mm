//
//  HaarDetectorParam.m
//  FaceTracker
//
//  Created by lijinxin on 13-4-7.
//
//

#import "HaarDetectorParam.hpp"

@implementation HaarDetectorParam

@synthesize cascadeFilePath = _cascadeFilePath;
@synthesize cascadeFileName = _cascadeFileName;
@synthesize haarOptions = _haarOptions;
@synthesize featureCascade = _featureCascade;
@synthesize canDetect = _canDetect;
@synthesize rawImageMat = _rawImageMat;
@synthesize transformedImageMat = _transformedImageMat;

- (id)initWith:(NSString*)fileName filePath:(NSString*)filePath options:(int)haarOptions
{
    self = [super init];
    if (self)
    {
        self.cascadeFilePath = filePath;
        self.cascadeFileName = fileName;
        self.haarOptions = haarOptions;
        
        if (!_featureCascade.load([filePath UTF8String]))
        {
            _canDetect = NO;
        }
        else
        {
            _canDetect = YES;
        }
    }
    return self;
}

- (void)dealloc
{
    self.cascadeFilePath = nil;
    self.cascadeFileName = nil;
    [super dealloc];
}

@end
