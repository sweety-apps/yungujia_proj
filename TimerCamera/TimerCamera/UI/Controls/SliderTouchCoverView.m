//
//  SliderTouchCoverView.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-30.
//
//

#import "SliderTouchCoverView.h"

@implementation SliderTouchCoverView

@synthesize sliderDelegate = _sliderDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)isDraging
{
    return _draging;
}

+ (SliderTouchCoverView*)sliderWithFrame:(CGRect)frame
                             andDelegate:(id<SliderTouchCoverViewDelegate>)delegate
{
    SliderTouchCoverView* ret = [[[SliderTouchCoverView alloc] initWithFrame:frame] autorelease];
    ret.sliderDelegate = delegate;
    return ret;
}

#pragma mark Touch Handler

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"<<<BBBB");
    if (!_draging)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        _draging = YES;
        if (_sliderDelegate && [_sliderDelegate respondsToSelector:@selector(onBeginTouch:atPoint:)])
        {
            [_sliderDelegate onBeginTouch:self atPoint:point];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@">>>EEEE");
    if(_draging)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        _draging = NO;
        if (_sliderDelegate && [_sliderDelegate respondsToSelector:@selector(onEndTouch:atPoint:)])
        {
            [_sliderDelegate onEndTouch:self atPoint:point];
        }
    }
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"----MMMM");
    if(_draging)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        if (_sliderDelegate && [_sliderDelegate respondsToSelector:@selector(onMoveTouch:atPoint:)])
        {
            [_sliderDelegate onMoveTouch:self atPoint:point];
        }
    }
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@">>>>CCCC");
    if(_draging)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        _draging = NO;
        if (_sliderDelegate && [_sliderDelegate respondsToSelector:@selector(onCancelTouch:atPoint:)])
        {
            [_sliderDelegate onCancelTouch:self atPoint:point];
        }
    }
    [super touchesCancelled:touches withEvent:event];
}

@end
