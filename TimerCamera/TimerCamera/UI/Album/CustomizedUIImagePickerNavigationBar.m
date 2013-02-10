//
//  CustomizedUIImagePickerNavigationBar.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-11.
//
//

#import "CustomizedUIImagePickerNavigationBar.h"

#define kBGColor()  [UIColor colorWithRed:(140.0/255.0) green:(200.0/255.0) blue:(0.0/255.0) alpha:1.0]

@implementation CustomizedUIImagePickerNavigationBar

@synthesize backBtn = _backBtn;
@synthesize cancelBtn = _cancelBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _backBtn = [[CommonAnimationButton
                     buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/picker/navigation_bar_back_btn_normal"]
                     forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/picker/navigation_bar_back_btn_normal"]
                     forPressedImage:[UIImage imageNamed:@"/Resource/Picture/picker/navigation_bar_back_btn_pressed"]
                     forEnabledImage1:nil
                     forEnabledImage2:nil] retain];
        
        _cancelBtn = [[CommonAnimationButton
                       buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/picker/navigation_bar_cancel_btn_normal"]
                       forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/picker/navigation_bar_cancel_btn_normal"]
                       forPressedImage:[UIImage imageNamed:@"/Resource/Picture/picker/navigation_bar_cancel_btn_pressed"]
                       forEnabledImage1:nil
                       forEnabledImage2:nil] retain];
        
        
        
        _blackCat = [[NavigationBarBlackCat navigationBlackCatWithCatImage:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_with_eye"]
                                                       forCatCloseEyeImage:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]
                                                               forEyeImage:[UIImage imageNamed:@"/Resource/Picture/main/eye"]]
                     retain];
        
        _catContainer = [[UIView alloc] initWithFrame:frame];
        _catContainer.backgroundColor = [UIColor clearColor];
        _catContainer.clipsToBounds = YES;
        
        [_catContainer addSubview:_blackCat];
        [self addSubview:_catContainer];
        [self addSubview:_backBtn];
        [self addSubview:_cancelBtn];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = kBGColor();
        self.clipsToBounds = NO;
        
        [self resetSubViews];
        
        [_blackCat startBlackCatAnimation];
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
    ReleaseAndNilView(_cancelBtn);
    ReleaseAndNilView(_backBtn);
    ReleaseAndNilView(_catContainer);
    ReleaseAndNilView(_blackCat);
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetSubViews];
}

- (void)resetSubViews
{
    CGRect rect = self.frame;
    rect.origin = CGPointZero;
    
    CGRect tRect = _backBtn.frame;
    tRect.origin.x = 0;
    tRect.origin.y = 0;
    _backBtn.frame = tRect;
    
    tRect = _cancelBtn.frame;
    tRect.origin.x = rect.size.width - tRect.size.width;
    tRect.origin.y = 0;
    _cancelBtn.frame = tRect;
    
    tRect = _blackCat.frame;
    tRect.origin.x = 0;
    tRect.origin.y = -2.0;
    _blackCat.frame = tRect;
    
    tRect.origin.x = (rect.size.width - tRect.size.width) * 0.5;
    tRect.origin.y = 0;
    tRect.size.height = rect.size.height;
    _catContainer.frame = tRect;
}

@end
