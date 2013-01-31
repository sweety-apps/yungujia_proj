//
//  CountView.m
//  TimerCamera
//
//  Created by lijinxin on 13-1-27.
//
//

#import <QuartzCore/QuartzCore.h>
#import "CountView.h"

#define CLIP_RECT() CGRectMake(0,12,96,72)

@implementation CountView

@synthesize label = _label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)dealloc
{
    ReleaseAndNilView(_label);
    ReleaseAndNilView(_clipView);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame andBgImage:(UIImage*)bgImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect rect = CGRectZero;
        rect.size = frame.size;
        self.image = bgImage;
        _label = [[UILabel alloc] initWithFrame:rect];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor colorWithRed:(77.0/255.0) green:0.0 blue:(126.0/255.0) alpha:1.0];
        _label.text = @"";
        _label.textAlignment = UITextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:72.0];
        _label.clipsToBounds = YES;
        _label.adjustsFontSizeToFitWidth = NO;
        _clipView = [[UIView alloc] initWithFrame:CLIP_RECT()];
        rect = CLIP_RECT();
        rect.origin = CGPointZero;
        _clipView.clipsToBounds = YES;
        _clipView.backgroundColor = [UIColor clearColor];
        _label.frame = rect;
        [_clipView addSubview:_label];
        [self addSubview:_clipView];
        self.hidden = YES;
    }
    return self;
}

+ (CountView*)countViewWithBgImage:(UIImage*)bgImage
{
    CGRect rect = CGRectZero;
    rect.size = bgImage.size;
    return [[[CountView alloc] initWithFrame:rect andBgImage:bgImage] autorelease];
}

- (void)show
{
    if (self.hidden == NO)
    {
        return;
    }
    self.hidden = NO;
    self.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^(){
        self.alpha = 1.0;
    } completion:^(BOOL finished){
        self.alpha = 1.0;
    }];
}

- (void)hide
{
    if (self.hidden == YES)
    {
        return;
    }
    self.alpha = 1.0;
    [UIView animateWithDuration:0.4 animations:^(){
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        self.hidden = YES;
        self.alpha = 1.0;
    }];
}

- (void)alphaRefreshText:(NSString*)text
{
    _label.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^(){
        _label.alpha = 0.0;
    } completion:^(BOOL finished){
        _label.text = text;
        [UIView animateWithDuration:0.2 animations:^(){
            _label.alpha = 1.0;
        } completion:^(BOOL finished){
            _label.alpha = 1.0;
        }];
    }];
}

- (void)pushRefreshText:(NSString*)text
{
    // set up an animation for the transition between the views
    _label.text = text;
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[_label layer] addAnimation:animation forKey:@"SwitchToView"];
}

- (void)refreshText:(NSString*)text
{
    [self pushRefreshText:text];
}

@end
