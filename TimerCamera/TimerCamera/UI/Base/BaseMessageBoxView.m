//
//  BaseMessageBoxView.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-19.
//
//

#import "BaseMessageBoxView.h"

@implementation BaseMessageBoxView

@synthesize textButtonTexts = _textButtonTexts;
@synthesize title = _title;
@synthesize content = _content;
@synthesize extraView = _extraView;
@synthesize messageBoxDelegate = _messageBoxDelegate;

#pragma mark life-cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    //
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark Properties Override

-(void)setTextButtonTexts:(NSArray *)textButtonTexts
{
    
    
    NSArray* ta = _textButtonTexts;
    _textButtonTexts = [textButtonTexts retain];
    [ta release];
}

#pragma mark BaseMessageBoxView methods

- (id)      initWithBgView:(UIView*)bgView
                 orBgColor:(UIColor*)bgColor
                boxBgImage:(UIImage*)boxBgImage
            yesButtonImage:(UIImage*)yesImage
     yesButtonPressedImage:(UIImage*)yesPressed
             noButtonImage:(UIImage*)noImage
      noButtonPressedImage:(UIImage*)noPressed
           textButtonImage:(UIImage*)textImage
    textButtonPressedImage:(UIImage*)textPressed
                     title:(NSString*)title
                   content:(NSString*)content
                 extraView:(UIView*)extraView
           textButtonTexts:(NSArray*)textBtnTexts
              withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        _bgView = [bgView retain];
        _bgColor = [bgColor retain];
        
        if (boxBgImage)
        {
            _boxBgImage = [[UIImageView alloc] initWithImage:boxBgImage];
        }
        
        if (yesPressed == nil)
        {
            yesPressed = yesImage;
        }
        
        if (yesImage)
        {
            _yesButton = [[CommonAnimationButton
                           buttonWithPressedImageSizeforNormalImage1:yesImage
                           forNormalImage2:yesImage
                           forPressedImage:yesPressed
                           forEnabledImage1:nil
                           forEnabledImage2:nil] retain];
        }
        
        if (noPressed == nil)
        {
            noPressed = noImage;
        }
        
        if (noImage)
        {
            _noButton = [[CommonAnimationButton
                          buttonWithPressedImageSizeforNormalImage1:noImage
                          forNormalImage2:noImage
                          forPressedImage:noPressed
                          forEnabledImage1:nil
                          forEnabledImage2:nil] retain];
        }
        
        _textImage = [textImage retain];
        
        self.textButtonTexts = textBtnTexts;
        
        self.title = title;
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.numberOfLines = 0;
        _titleLbl.textAlignment = UITextAlignmentCenter;
        _titleLbl.font = [UIFont systemFontOfSize:72.0];
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.backgroundColor = [UIColor clearColor];
        _contentLbl.textColor = [UIColor whiteColor];
        _contentLbl.numberOfLines = 0;
        _contentLbl.textAlignment = UITextAlignmentCenter;
        _contentLbl.font = [UIFont systemFontOfSize:72.0];
        
        
        _contentLbl;
        _content;
        _extraView;
        id<BaseMessageBoxViewDelegate> _messageBoxDelegate;
    }
    return self;
}

+ (BaseMessageBoxView*)baseMessageBoxWithBgView:(UIView*)bgView
                                      orBgColor:(UIColor*)bgColor
                                     boxBgImage:(UIImage*)boxBgImage
                                 yesButtonImage:(UIImage*)yesImage
                          yesButtonPressedImage:(UIImage*)yesPressed
                                  noButtonImage:(UIImage*)noImage
                           noButtonPressedImage:(UIImage*)noPressed
                                textButtonImage:(UIImage*)textImage
                         textButtonPressedImage:(UIImage*)textPressed
                                          title:(NSString*)title
                                        content:(NSString*)content
                                      extraView:(UIView*)extraView
                                textButtonTexts:(NSArray*)textBtnTexts
                                   withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
{
    return [[[BaseMessageBoxView alloc] initWithBgView:bgView
                                             orBgColor:bgColor
                                            boxBgImage:boxBgImage
                                        yesButtonImage:yesImage
                                 yesButtonPressedImage:yesPressed
                                         noButtonImage:noImage
                                  noButtonPressedImage:noPressed
                                       textButtonImage:textImage
                                textButtonPressedImage:textPressed
                                                 title:title
                                               content:content
                                             extraView:extraView
                                       textButtonTexts:textBtnTexts
                                          withDelegate:messageBoxDelegate]
            autorelease];
}


- (void)showOnWindowWithYesButtonShowed:(BOOL)showYes
                         noButtonShowed:(BOOL)showNO
{
    
}

- (void)showOnView:(UIView*)view
   yesButtonShowed:(BOOL)showYes
    noButtonShowed:(BOOL)showNO
{
    
}

@end
