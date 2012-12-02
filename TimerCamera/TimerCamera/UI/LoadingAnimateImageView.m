//
//  LoadingAnimateImageView.m
//  TimerCamera
//
//  Created by lijinxin on 12-11-5.
//
//

#import "LoadingAnimateImageView.h"

#define DefaultAnimation_Offset_Y_iPhone 200.0
#define DefaultAnimationScale_iPhone 10.0


#define DefaultAnimation_Offset_Y_iPad 200.0
#define DefaultAnimationScale_iPad 20.0

@implementation LoadingAnimateImageView

@synthesize loadingDelegate = _loadingDelegate;
@synthesize animateInterval = _animateInterval;
@synthesize animateScale = _animateScale;
@synthesize preloadAnimateInterval = _preloadAnimateInterval;

- (UIImageView *)preloadView
{
    return _preloadView;
}

- (void)setPreloadView:(UIImageView *)preloadView
{
    [preloadView retain];
    ReleaseAndNilView(_preloadView);
    _preloadView = preloadView;
    [self addSubview:_preloadView];
}

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
    ReleaseAndNil(_preloadView);
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

+ (LoadingAnimateImageView*)viewWithDelegate:(id<LoadingAnimateImageViewDelegate>)del
                                       image:(UIImage*)img
                             forTimeInterval:(float)seconds
                                preLoadImage:(UIImage*)pimg
                   forPreloadAnimateInterval:(float)pSeconds
{
    LoadingAnimateImageView* ret = [[[LoadingAnimateImageView alloc] initWithImage:img] autorelease];
    ret.loadingDelegate = del;
    ret.animateInterval = seconds;
    [ret setPreloadView:[[[UIImageView alloc] initWithImage:pimg] autorelease]];
    ret.preloadAnimateInterval = pSeconds;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        ret.animateScale = DefaultAnimationScale_iPhone;
    } else {
        ret.animateScale = DefaultAnimationScale_iPad;
    }
    
    return ret;
}

-(void)setFrame:(CGRect)frame
{
    _rawFrame = frame;
    super.frame = frame;
}

- (void)startPreloadingAnimation
{
    _preloadView.alpha = 1.0;
    CGRect rct = _rawFrame;
    rct.origin = CGPointMake(0, 0);
    _preloadView.frame = rct;
    [UIView animateWithDuration:_preloadAnimateInterval animations:^{
        _preloadView.alpha = 0.0;
    } completion:^(BOOL finished){
    }];
}

- (void)startLoadingAnimation
{
    self.alpha = 1.0;
    self.frame = _rawFrame;
    [UIView animateWithDuration:_animateInterval animations:^{
        CGRect newFrame = _rawFrame;
        CGPoint center;
        center.x = (_rawFrame.origin.x + _rawFrame.size.width) / 2;
        center.y = (_rawFrame.origin.y + _rawFrame.size.height) / 2;
        CGSize newSize;
        newSize.width = _rawFrame.size.width * _animateScale;
        newSize.height = _rawFrame.size.height * _animateScale;
        newFrame.origin.x = center.x - (newSize.width / 2);
        newFrame.origin.y = center.y - (newSize.height / 2);
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            newFrame.origin.y += DefaultAnimation_Offset_Y_iPhone;
        } else {
            newFrame.origin.y += DefaultAnimation_Offset_Y_iPad;
        }
        
        newFrame.size = newSize;
        self.frame = newFrame;
        self.alpha = 0.4;
        
        CGRect preNewFrame = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
        _preloadView.frame = preNewFrame;
        
    } completion:^(BOOL finished){
        if (finished)
        {
            self.alpha = 0.0;
            if(_loadingDelegate && [_loadingDelegate respondsToSelector:@selector(onFinishedLoadingAnimation:)])
            {
                [_loadingDelegate onFinishedLoadingAnimation:self];
            }
        }
    }];
}

@end
