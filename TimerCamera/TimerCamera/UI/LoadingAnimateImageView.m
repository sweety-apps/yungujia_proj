//
//  LoadingAnimateImageView.m
//  TimerCamera
//
//  Created by lijinxin on 12-11-5.
//
//

#import "LoadingAnimateImageView.h"

@implementation LoadingAnimateImageView

@synthesize loadingDelegate = _loadingDelegate;
@synthesize animateInterval = _animateInterval;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc
{
    _loadingDelegate = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (LoadingAnimateImageView*)viewWithDelegate:(id<LoadingAnimateImageViewDelegate>)del image:(UIImage*)img forTimeInterval:(float)seconds
{
    LoadingAnimateImageView* ret = [[LoadingAnimateImageView alloc] initWithImage:img];
    ret.loadingDelegate = del;
    ret.animateInterval = seconds;
    return ret;
}

- (void)startLoadingAnimation
{
}

@end
