//
//  CountView.h
//  TimerCamera
//
//  Created by lijinxin on 13-1-27.
//
//

#import <UIKit/UIKit.h>

@interface CountView : UIImageView
{
    UILabel* _label;
    UIView* _clipView;
}

@property (nonatomic, retain, readonly) UILabel* label;

- (id)initWithFrame:(CGRect)frame andBgImage:(UIImage*)bgImage;
+ (CountView*)countViewWithBgImage:(UIImage*)bgImage;

- (void)show;
- (void)hide;
- (void)refreshText:(NSString*)text;

@end
