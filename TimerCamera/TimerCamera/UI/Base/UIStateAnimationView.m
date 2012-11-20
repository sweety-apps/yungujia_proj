//
//  UIStateAnimationView.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-20.
//
//

#import "UIStateAnimationView.h"

#pragma mark - UIStateAnimationViewStateObject

@interface UIStateAnimationViewStateObject : NSObject
{
    UIView* _view;
    id<UIStateAnimation> _animation;
    BOOL _loop;
}

@property (nonatomic,retain) UIView* view;
@property (nonatomic,retain) id<UIStateAnimation> animation;
@property (nonatomic,assign) BOOL loop;

@end

@implementation UIStateAnimationViewStateObject

@synthesize view = _view;
@synthesize animation = _animation;
@synthesize loop = _loop;

- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNil(_view);
    [super dealloc];
}

@end



#pragma mark - UIStateAnimationView

@implementation UIStateAnimationView

@synthesize currentState = _currentState;

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


#pragma mark UIStateAnimationView Methods

- (void)setView:(UIView*)view forState:(NSString*)state
{
    
}

- (void)setAnimation:(id<UIStateAnimation>)animation forState:(NSString*)state;
{
    
}

- (UIView*)getViewForState:(NSString*)state
{
    return nil;
}

- (void)setCurrentState:(NSString*)state
{
    
}

- (NSString*)getCurrentState
{
    return _currentState;
}

@end
