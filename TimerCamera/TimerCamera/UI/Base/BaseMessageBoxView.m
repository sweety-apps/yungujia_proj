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

#pragma mark BaseMessageBoxView methods

- (id)      initWithBgView:(UIView*)bgImg
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
        //
    }
    return self;
}

+ (BaseMessageBoxView*)baseMessageBoxWithBgView:(UIView*)bgImg
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
    return [[[BaseMessageBoxView alloc] initWithBgView:bgImg
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
