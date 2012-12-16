//
//  ShotButton.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-27.
//
//

#import "ShotButton.h"

#define SHOT_BTN_LABEL_RECT CGRectMake(24,48,86,86)

@implementation ShotButton

@synthesize coverIconView = _coverIconView;
@synthesize coverLabel = _coverLabel;

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

- (id)initWithFrame:(CGRect)frame
    forNormalImage1:(UIImage*)ni1
    forNormalImage2:(UIImage*)ni2
    forPressedImage:(UIImage*)pi
   forEnabledImage1:(UIImage*)ei1
   forEnabledImage2:(UIImage*)ei2
            forIcon:(UIImage*)ic
{
    self = [super initWithFrame:frame
                forNormalImage1:ni1
                forNormalImage2:ni2
                forPressedImage:pi
               forEnabledImage1:ei1
               forEnabledImage2:ei2];
    if (self)
    {
        //
        _coverIconView = [[UIImageView alloc] initWithFrame:_normalView.frame];
        _coverIconView.backgroundColor = [UIColor clearColor];
        _coverIconView.image = ic;
        
        _coverLabel = [[UILabel alloc] initWithFrame:SHOT_BTN_LABEL_RECT];
        _coverLabel.backgroundColor = [UIColor clearColor];
        _coverLabel.numberOfLines = 1;
        _coverLabel.adjustsFontSizeToFitWidth = YES;
        _coverLabel.textColor = [UIColor colorWithRed:(77.0/255.0)
                                                green:(0.0/255.0)
                                                 blue:(126.0/255.0)
                                                alpha:1.0];
        _coverLabel.font = [UIFont systemFontOfSize:60.0];
        _coverLabel.textAlignment = UITextAlignmentCenter;
        _coverLabel.text = @"";
        
        [self addSubview:_coverIconView];
        [self addSubview:_coverLabel];
        
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNilView(_coverIconView);
    ReleaseAndNilView(_coverLabel);
    [super dealloc];
}

+ (ShotButton*)buttonWithPressedImageSizeforNormalImage1:(UIImage*)ni1
                                         forNormalImage2:(UIImage*)ni2
                                         forPressedImage:(UIImage*)pi
                                        forEnabledImage1:(UIImage*)ei1
                                        forEnabledImage2:(UIImage*)ei2
                                                 forIcon:(UIImage*)ic
{
    CGRect rect = CGRectMake(0, 0, pi.size.width, pi.size.height);
    return [[[ShotButton alloc] initWithFrame:rect
                              forNormalImage1:ni1
                              forNormalImage2:ni2
                              forPressedImage:pi
                             forEnabledImage1:ei1
                             forEnabledImage2:ei2
                                      forIcon:ic] autorelease];
}


- (void)setIcon:(UIImage*)icon
{
    [self setIcon:icon withAnimation:NO];
}

- (void)setIcon:(UIImage*)icon withAnimation:(BOOL)animated
{
    if (icon == _lastCoverIcon)
    {
        return;
    }
    [icon retain];
    [_lastCoverIcon release];
    _lastCoverIcon = icon;
    if (animated)
    {
        void (^fadeOld)(void) = ^(){
            _coverIconView.alpha = 0.0;
        };
        void (^appearNew)(void) = ^(){
            _coverIconView.alpha = 1.0;
        };
        
        if (_coverIconView.image)
        {
            [UIView animateWithDuration:0.3
                             animations:fadeOld
                             completion:^(BOOL finished){
                                 _coverIconView.image = _lastCoverIcon;
                                 [UIView animateWithDuration:0.3
                                                  animations:appearNew];
                             }];
        }
        else
        {
            fadeOld();
            _coverIconView.image = _lastCoverIcon;
            [UIView animateWithDuration:0.4
                             animations:appearNew];
        }
        
    }
    else
    {
        _coverIconView.image = _lastCoverIcon;
    }
}

- (void)setLabelString:(NSString*)string
{
    _coverLabel.text = string;
}

@end
