//
//  SliderTouchCoverView.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-30.
//
//

#import <UIKit/UIKit.h>

@class SliderTouchCoverView;

@protocol SliderTouchCoverViewDelegate <NSObject>

- (void) onBeginTouch:(SliderTouchCoverView*)view atPoint:(CGPoint)point;
- (void) onEndTouch:(SliderTouchCoverView*)view atPoint:(CGPoint)point;
- (void) onMoveTouch:(SliderTouchCoverView*)view atPoint:(CGPoint)point;
- (void) onCancelTouch:(SliderTouchCoverView*)view atPoint:(CGPoint)point;

@end

@interface SliderTouchCoverView : UIView
{
    BOOL _draging;
    id<SliderTouchCoverViewDelegate> _sliderDelegate;
}

@property (nonatomic,assign) id<SliderTouchCoverViewDelegate> sliderDelegate;

- (BOOL)isDraging;
+ (SliderTouchCoverView*)sliderWithFrame:(CGRect)frame
                             andDelegate:(id<SliderTouchCoverViewDelegate>)delegate;

@end
