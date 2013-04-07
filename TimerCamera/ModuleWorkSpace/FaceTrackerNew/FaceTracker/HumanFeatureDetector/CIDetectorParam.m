//
//  CIDetectorParam.m
//  FaceTracker
//
//  Created by lijinxin on 13-4-8.
//
//

#import "CIDetectorParam.h"

@implementation CIDetectorParam

@synthesize image = _image;

- (id)initWithImage:(UIImage*)image
{
    self = [self init];
    if (self)
    {
        self.image = image;
    }
    return self;
}

- (void)dealloc
{
    self.image = nil;
    [super dealloc];
}

@end
