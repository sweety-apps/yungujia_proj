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

- (void)setView:(UIView*)view forState:(NSString*)state;
- (void)setAnimation:(id<UIStateAnimation>)animation forState:(NSString*)state;
- (UIView*)getViewForState:(NSString*)state;

@property (nonatomic, retain) NSString* currentState;

@end
