//
//  LoadingAnimateImageView.h
//  TimerCamera
//
//  Created by lijinxin on 12-11-5.
//
//

#import <UIKit/UIKit.h>

@protocol LoadingAnimateImageViewDelegate <NSObject>

- (void)onFinishedLoadingAnimation;

@end

@interface LoadingAnimateImageView : UIImageView
{
    id<LoadingAnimateImageViewDelegate> _loadingDelegate;
    float _animateInterval;
}

@property (nonatomic,assign) id<LoadingAnimateImageViewDelegate> loadingDelegate;
@property (nonatomic,assign) float animateInterval;

+ (LoadingAnimateImageView*)viewWithDelegate:(id<LoadingAnimateImageViewDelegate>)del image:(UIImage*)img forTimeInterval:(float)seconds;

- (void)startLoadingAnimation;


@end
