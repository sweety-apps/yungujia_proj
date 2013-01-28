//
//  BlackCat.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import "BlackCat.h"

#define LEFT_EYE_NORMAL_ORIGIN CGPointMake(17,15)
#define RIGHT_EYE_NORMAL_ORIGIN CGPointMake(41,23)
#define LEFT_EYE_MID_ORIGIN CGPointMake(17,19)
#define RIGHT_EYE_MID_ORIGIN CGPointMake(41,19)
#define LEFT_EYE_LEFT_ORIGIN CGPointMake(12,19)
#define RIGHT_EYE_LEFT_ORIGIN CGPointMake(36,19)
#define LEFT_EYE_RIGHT_ORIGIN CGPointMake(21,19)
#define RIGHT_EYE_RIGHT_ORIGIN CGPointMake(45,19)
#define LEFT_EYE_UP_ORIGIN CGPointMake(17,15)
#define RIGHT_EYE_UP_ORIGIN CGPointMake(41,15)
#define LEFT_EYE_DOWN_ORIGIN CGPointMake(17,23)
#define RIGHT_EYE_DOWN_ORIGIN CGPointMake(41,23)

#define BUTTON_RECT CGRectMake(0,0,61,48)


@implementation BlackCat

@synthesize button = _button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rect = frame;
        rect.origin = CGPointZero;
        _button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _button.frame = rect;
        _button.backgroundColor = [UIColor clearColor];
        _catView = [[UIImageView alloc] initWithFrame:rect];
        _leftEyeView = [[UIImageView alloc] initWithFrame:rect];
        _rightEyeView = [[UIImageView alloc] initWithFrame:rect];
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
    ReleaseAndNilView(_button);
    ReleaseAndNilView(_catView);
    ReleaseAndNilView(_leftEyeView);
    ReleaseAndNilView(_rightEyeView);
    ReleaseAndNil(_catCloseEyeImage);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
        forCatImage:(UIImage*)cat
forCatCloseEyeImage:(UIImage*)cc
        forEyeImage:(UIImage*)eye
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        CGRect rect = CGRectZero;
        rect.size = eye.size;
        rect.origin = LEFT_EYE_NORMAL_ORIGIN;
        _leftEyeView.frame = rect;
        rect.origin = RIGHT_EYE_NORMAL_ORIGIN;
        _rightEyeView.frame = rect;
        
        _catView.image = cat;
        _leftEyeView.image = eye;
        _rightEyeView.image = eye;
        _catCloseEyeImage = [cc retain];
        
        [_catView addSubview:_leftEyeView];
        [_catView addSubview:_rightEyeView];
        
        [self setAnimation:self andView:_catView forState:@"normal"];
        [self setAnimation:self andView:_catView forState:@"animate1"];
        [self setAnimation:self andView:_catView forState:@"animate2"];
        [self setAnimation:self andView:_catView forState:@"animate3"];
        [self addSubview:_button];
        
        [_button addTarget:self action:@selector(onPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(onPressed:) forControlEvents:UIControlEventTouchUpOutside];
        
        [self setCurrentState:@"normal"];
        
        [self bringSubviewToFront:_button];
        
        self.button.frame = BUTTON_RECT;
    }
    return self;
}

+ (BlackCat*)catWithCatImage:(UIImage*)cat
         forCatCloseEyeImage:(UIImage*)cc
                 forEyeImage:(UIImage*)eye
{
    CGRect rect = CGRectMake(0, 0, cat.size.width, cat.size.height);
    return [[[BlackCat alloc] initWithFrame:rect
                                forCatImage:cat
                        forCatCloseEyeImage:cc
                                forEyeImage:eye] autorelease];
}


- (void)onPressed:(id)sender
{
    srand(time(NULL));
    int i = rand()%2;
    ++i;
    //i = 2;
    switch (i)
    {
        case 1:
            [self setCurrentState:@"animate1"];
            break;
        case 2:
            [self setCurrentState:@"animate2"];
            break;
        case 3:
            [self setCurrentState:@"animate3"];
            break;
        default:
            break;
    }
}

#pragma mark Animation Selectors

- (void)normalAnimateSelector
{
    CGRect lf = _leftEyeView.frame;
    lf.origin = LEFT_EYE_NORMAL_ORIGIN;
    CGRect rf = _rightEyeView.frame;
    rf.origin = RIGHT_EYE_NORMAL_ORIGIN;
    
    [UIView animateWithDuration:0.4 animations:^(){
        _leftEyeView.frame = lf;
        _rightEyeView.frame = rf;
    } completion:^(BOOL finished){
        //do Nothing
    }];
}

- (void)animate1AnimateSelector
{
#define CLOSE_SEC 0.2
#define OPEN_SEC 0.4
    //wink
    UIImage* img = [_catView.image retain];
    
    [UIView animateWithDuration:0.4 animations:^(){
        CGRect lf = _leftEyeView.frame;
        CGRect rf = _rightEyeView.frame;
        lf.origin = LEFT_EYE_MID_ORIGIN;
        rf.origin = RIGHT_EYE_MID_ORIGIN;
        _leftEyeView.frame = lf;
        _rightEyeView.frame = rf;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:OPEN_SEC
                         animations:^(){
                         }
                         completion:^(BOOL finished){
                             _catView.image = _catCloseEyeImage;
                             [UIView animateWithDuration:CLOSE_SEC
                                              animations:^(){
                                                  CGRect lf = _leftEyeView.frame;
                                                  CGRect rf = _rightEyeView.frame;
                                                  lf.origin.y += 1.0;
                                                  rf.origin.y += 1.0;
                                                  _leftEyeView.frame = lf;
                                                  _rightEyeView.frame = rf;
                                              }
                                              completion:^(BOOL finished){
                                                  _catView.image = img;
                                                  [UIView animateWithDuration:OPEN_SEC
                                                                   animations:^(){
                                                                       CGRect lf = _leftEyeView.frame;
                                                                       CGRect rf = _rightEyeView.frame;
                                                                       lf.origin.y -= 1.0;
                                                                       rf.origin.y -= 1.0;
                                                                       _leftEyeView.frame = lf;
                                                                       _rightEyeView.frame = rf;
                                                                   }
                                                                   completion:^(BOOL finished){
                                                                       _catView.image = _catCloseEyeImage;
                                                                       [UIView animateWithDuration:CLOSE_SEC
                                                                                        animations:^(){
                                                                                            CGRect lf = _leftEyeView.frame;
                                                                                            CGRect rf = _rightEyeView.frame;
                                                                                            lf.origin.y += 1.0;
                                                                                            rf.origin.y += 1.0;
                                                                                            _leftEyeView.frame = lf;
                                                                                            _rightEyeView.frame = rf;
                                                                                        }
                                                                                        completion:^(BOOL finished){
                                                                                            _catView.image = img;
                                                                                            [UIView animateWithDuration:OPEN_SEC
                                                                                                             animations:^(){
                                                                                                                 CGRect lf = _leftEyeView.frame;
                                                                                                                 CGRect rf = _rightEyeView.frame;
                                                                                                                 lf.origin.y -= 1.0;
                                                                                                                 rf.origin.y -= 1.0;
                                                                                                                 _leftEyeView.frame = lf;
                                                                                                                 _rightEyeView.frame = rf;
                                                                                                             }
                                                                                                             completion:^(BOOL finished){
                                                                                                                 [img release];
                                                                                                                 [self setCurrentState:@"normal"];
                                                                                                             }];
                                                                                        }];
                                                                   }];
                                              }];
                         }];
    }];
    
    
}

- (void)doRound:(int)times
{
#define ROUND_SEC 0.1
    if (times <= 0)
    {
        [self setCurrentState:@"normal"];
    }
    else
    {
        [UIView animateWithDuration:ROUND_SEC animations:^(){
            CGRect lf = _leftEyeView.frame;
            CGRect rf = _rightEyeView.frame;
            lf.origin = LEFT_EYE_LEFT_ORIGIN;
            rf.origin = RIGHT_EYE_RIGHT_ORIGIN;
            _leftEyeView.frame = lf;
            _rightEyeView.frame = rf;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:ROUND_SEC animations:^(){
                CGRect lf = _leftEyeView.frame;
                CGRect rf = _rightEyeView.frame;
                lf.origin = LEFT_EYE_UP_ORIGIN;
                rf.origin = RIGHT_EYE_DOWN_ORIGIN;
                _leftEyeView.frame = lf;
                _rightEyeView.frame = rf;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:ROUND_SEC animations:^(){
                    CGRect lf = _leftEyeView.frame;
                    CGRect rf = _rightEyeView.frame;
                    lf.origin = LEFT_EYE_RIGHT_ORIGIN;
                    rf.origin = RIGHT_EYE_LEFT_ORIGIN;
                    _leftEyeView.frame = lf;
                    _rightEyeView.frame = rf;
                } completion:^(BOOL finished){
                    [UIView animateWithDuration:ROUND_SEC animations:^(){
                        CGRect lf = _leftEyeView.frame;
                        CGRect rf = _rightEyeView.frame;
                        lf.origin = LEFT_EYE_DOWN_ORIGIN;
                        rf.origin = RIGHT_EYE_UP_ORIGIN;
                        _leftEyeView.frame = lf;
                        _rightEyeView.frame = rf;
                    } completion:^(BOOL finished){
                        if (times > 0)
                        {
                            [self doRound:times - 1];
                        }
                    }];
                }];
            }];
        }];
    }
    
}

- (void)animate2AnimateSelector
{
    //round
    [UIView animateWithDuration:ROUND_SEC animations:^(){
        CGRect lf = _leftEyeView.frame;
        CGRect rf = _rightEyeView.frame;
        lf.origin = LEFT_EYE_LEFT_ORIGIN;
        rf.origin = RIGHT_EYE_RIGHT_ORIGIN;
        _leftEyeView.frame = lf;
        _rightEyeView.frame = rf;
    } completion:^(BOOL finished){
        [self doRound:5];
    }];
}

- (void)animate3AnimateSelector
{
    [self setCurrentState:@"normal"];
}

#pragma mark <UIStateAnimation>

- (void)startStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if ([state isEqualToString:@"normal"])
    {
        _button.hidden = NO;
        [self normalAnimateSelector];
    }
    else if([state isEqualToString:@"animate1"])
    {
        _button.hidden = YES;
        [self animate1AnimateSelector];
    }
    else if([state isEqualToString:@"animate2"])
    {
        _button.hidden = YES;
        [self animate2AnimateSelector];
    }
    else if([state isEqualToString:@"animate3"])
    {
        _button.hidden = YES;
        [self animate3AnimateSelector];
    }
}

- (void)stopStateAnimationForView:(UIView*)view forState:(NSString*)state
{
    if ([state isEqualToString:@"normal"])
    {
    }
    else if([state isEqualToString:@"animate1"])
    {
    }
    else if([state isEqualToString:@"animate2"])
    {
    }
    else if([state isEqualToString:@"animate3"])
    {
    }
}

@end
