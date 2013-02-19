//
//  MessageBoxView.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-19.
//
//

#import "MessageBoxView.h"

@implementation MessageBoxView

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

#pragma mark - BaseMessageBoxView methods

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
    return [[[MessageBoxView alloc] initWithBgView:bgImg
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


#pragma mark - MessageBoxView methods

+ (MessageBoxView*)showWithYesNoButtonForTitle:(NSString*)title
                                       content:(NSString*)content
                                  withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
{
    return nil;
}

+ (MessageBoxView*)showWithOnlyNoButtonForTitle:(NSString*)title
                                        content:(NSString*)content
                                   withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
{
    return nil;
}

+ (MessageBoxView*)showWithOnlyYesButtonForTitle:(NSString*)title
                                         content:(NSString*)content
                                    withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
{
    return nil;
}

+ (MessageBoxView*)showWithYesButtonForTitle:(NSString*)title
                                     content:(NSString*)content
                                withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
                          andTextButtonTexts:(NSString*)first,...
{
    return nil;
}

+ (MessageBoxView*)showWithNoButtonForTitle:(NSString*)title
                                    content:(NSString*)content
                               withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
                         andTextButtonTexts:(NSString*)first,...
{
    return nil;
}

+ (MessageBoxView*)showWithOnlyTextButtonForTitle:(NSString*)title
                                          content:(NSString*)content
                                     withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
                               andTextButtonTexts:(NSString*)first,...
{
    return nil;
}


@end
