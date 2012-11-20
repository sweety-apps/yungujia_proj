//
//  UIStateAnimationView.h
//  TimerCamera
//
//  Created by Lee Justin on 12-11-20.
//
//

#import <UIKit/UIKit.h>

@protocol UIStateAnimation <NSObject>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state;
- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state;

@end

@interface UIStateAnimationView : UIView
{
    NSMutableDictionary* _stateDict;
    NSString* _currentState;
}

- (void)setAnimation:(id<UIStateAnimation>)animation andView:(UIView*)view forState:(NSString*)state;
- (UIView*)getViewForState:(NSString*)state;
- (id<UIStateAnimation>)getAnimationForState:(NSString*)state;

@property (nonatomic, retain) NSString* currentState;

@end
