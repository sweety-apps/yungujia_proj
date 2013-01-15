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

@property (nonatomic,assign) UIView* view;
@property (nonatomic,assign) id<UIStateAnimation> animation;

@end

@implementation UIStateAnimationViewStateObject

@synthesize view = _view;
@synthesize animation = _animation;

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
        _stateDict = [[NSMutableDictionary dictionary] retain];
    }
    return self;
}

- (void)dealloc
{
    [self setCurrentState:@""];
    [_stateDict removeAllObjects];
    ReleaseAndNil(_stateDict);
    ReleaseAndNil(_currentState);
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

- (void)setAnimation:(id<UIStateAnimation>)animation andView:(UIView*)view forState:(NSString*)state;
{
    UIStateAnimationViewStateObject* o = [[[UIStateAnimationViewStateObject alloc] init] autorelease];
    o.view = view;
    o.animation = animation;
    [_stateDict setObject:o forKey:state];
}

- (UIView*)getViewForState:(NSString*)state
{
    UIStateAnimationViewStateObject* o = [_stateDict objectForKey:state];
    if (o)
    {
        return o.view;
    }
    return nil;
}

- (id<UIStateAnimation>)getAnimationForState:(NSString*)state
{
    UIStateAnimationViewStateObject* o = [_stateDict objectForKey:state];
    if (o)
    {
        return o.animation;
    }
    return nil;
}

- (void)setCurrentState:(NSString *)currentState
{
    BOOL needRemoveView = YES;
    int viewIndex = -1;
    UIStateAnimationViewStateObject* oldO = [_stateDict objectForKey:_currentState];
    UIStateAnimationViewStateObject* newO = [_stateDict objectForKey:currentState];
    
    if (oldO && newO && oldO.view == newO.view)
    {
        needRemoveView = NO;
    }
    
    UIStateAnimationViewStateObject* o = oldO;
    if (o)
    {
        if (o.animation && [o.animation respondsToSelector:@selector(stopStateAnimationForView:forState:)])
        {
            [o.animation stopStateAnimationForView:o.view forState:_currentState];
        }
        if (needRemoveView)
        {
            if (o.view)
            {
                viewIndex = [[[o.view superview] subviews] indexOfObject:o.view];
            }
            [o.view removeFromSuperview];
        }
    }
    
    o = newO;
    if (o)
    {
        if (needRemoveView)
        {
            if (viewIndex >= 0)
            {
                [self insertSubview:o.view atIndex:viewIndex];
            }
            else
            {
                [self addSubview:o.view];
            }
        }
        
        [currentState retain];
        [_currentState release];
        _currentState = currentState;
        
        if (o.animation && [o.animation respondsToSelector:@selector(startStateAnimationForView:forState:)])
        {
            [o.animation startStateAnimationForView:o.view forState:_currentState];
        }
    }
}

@end
