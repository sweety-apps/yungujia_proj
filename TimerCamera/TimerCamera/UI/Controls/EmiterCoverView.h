//
//  EmiterCoverView.h
//  TimerCamera
//
//  Created by lijinxin on 13-1-26.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface EmiterCoverView : UIView
{
    CAEmitterLayer* _emitter;
    CALayer* _coverLayer;
    
    id _completionTarget;
    SEL _completionSel;
}

-     (id)initWithFrame:(CGRect)frame
 forEmitterElementImage:(UIImage*)image
          andCoverColor:(UIColor*)color;

+ (EmiterCoverView*)emiterCoverViewWithElementImage:(UIImage*)image
                                      andCoverColor:(UIColor*)color;

- (void)performEmitterOverViewWithCompletionForTarget:(id)target
                                  andCompletionMethod:(SEL)sel;

@end
