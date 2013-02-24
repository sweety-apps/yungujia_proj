//
//  MessageBoxView.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-19.
//
//

#import "MessageBoxView.h"
#import <QuartzCore/QuartzCore.h>

#define CONTENT_START_Y (35.0)

#define BUTTON_TO_BOTTOM_PADDING_DEFAULT (-18.0)
#define TITLE_LEFT_RIGHT_PADDING_DEFAULT (12.0)
#define TITLE_TOP_PADDING_DEFAULT (29.0)
#define CONTENT_TEXT_COLOR_DEFAULT [UIColor whiteColor]
#define TITLE_TEXT_COLOR_DEFAULT [UIColor whiteColor]
#define TITLE_CONTENT_EXTRA_INTERVAL_DEFAULT (5.0)
#define BUTTON_TEXT_COLOR_DEFAULT [UIColor blackColor]
#define BUTTON_TEXT_COLOR_PRESSED [UIColor redColor]
#define BUTTON_LABEL_RECT CGRectMake(12,12,69,24)
#define BUTTON_TEXT_LEBEL_SHIFT_Y (60.0)
#define BUTTON_TEXT_LEBEL_SHIFT_X (0.0)
#define BUTTON_TEXT_PRESSED_BG_COLOR [UIColor colorWithRed:(252.0/255.0) green:(255.0/255.0) blue:(120.0/255.0) alpha:1.0]


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
    return [[[MessageBoxView alloc] initWithBgView:bgView
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
    MessageBoxView* box = [[[MessageBoxView alloc]
                             initWithBgView:nil
                             orBgColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.38]
                             boxBgImage:[[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:48.0]
                             yesButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_normal"]
                             yesButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_pressed"]
                             noButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_normal"]
                             noButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_pressed"]
                             textButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_normal"]
                             textButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_pressed"]
                             title:title
                             content:content
                             extraView:nil
                             textButtonTexts:nil
                             withDelegate:messageBoxDelegate] autorelease];
    
    box.buttonToBoxBottomPadding = BUTTON_TO_BOTTOM_PADDING_DEFAULT;
    box.titleLeftRightPadding = TITLE_LEFT_RIGHT_PADDING_DEFAULT;
    box.titleTopPadding = TITLE_TOP_PADDING_DEFAULT;
    box.contentTextColor = CONTENT_TEXT_COLOR_DEFAULT;
    box.titleTextColor = TITLE_TEXT_COLOR_DEFAULT;
    box.buttonTextColor = BUTTON_TEXT_COLOR_DEFAULT;
    box.titleContentExtraInterval = TITLE_CONTENT_EXTRA_INTERVAL_DEFAULT;
    box.customTextButtonLabelRect = BUTTON_LABEL_RECT;
    
    [box showOnWindowWithYesButtonShowed:YES noButtonShowed:YES];
    return box;
}

+ (MessageBoxView*)showWithOnlyNoButtonForTitle:(NSString*)title
                                        content:(NSString*)content
                                   withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
{
    MessageBoxView* box = [[[MessageBoxView alloc]
                            initWithBgView:nil
                            orBgColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.38]
                            boxBgImage:[[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:48.0]
                            yesButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_normal"]
                            yesButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_pressed"]
                            noButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_normal"]
                            noButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_pressed"]
                            textButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_normal"]
                            textButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_pressed"]
                            title:title
                            content:content
                            extraView:nil
                            textButtonTexts:nil
                            withDelegate:messageBoxDelegate] autorelease];
    
    //box.buttonToBoxBottomPadding = BUTTON_TO_BOTTOM_PADDING_DEFAULT;
    box.titleLeftRightPadding = TITLE_LEFT_RIGHT_PADDING_DEFAULT;
    box.titleTopPadding = TITLE_TOP_PADDING_DEFAULT;
    box.contentTextColor = CONTENT_TEXT_COLOR_DEFAULT;
    box.titleTextColor = TITLE_TEXT_COLOR_DEFAULT;
    box.buttonTextColor = BUTTON_TEXT_COLOR_DEFAULT;
    box.titleContentExtraInterval = TITLE_CONTENT_EXTRA_INTERVAL_DEFAULT;
    box.customTextButtonLabelRect = BUTTON_LABEL_RECT;
    
    [box showOnWindowWithYesButtonShowed:NO noButtonShowed:YES];
    return box;
}

+ (MessageBoxView*)showWithOnlyYesButtonForTitle:(NSString*)title
                                         content:(NSString*)content
                                    withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
{
    MessageBoxView* box = [[[MessageBoxView alloc]
                            initWithBgView:nil
                            orBgColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.38]
                            boxBgImage:[[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:48.0]
                            yesButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_normal"]
                            yesButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_pressed"]
                            noButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_normal"]
                            noButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_pressed"]
                            textButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_normal"]
                            textButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_pressed"]
                            title:title
                            content:content
                            extraView:nil
                            textButtonTexts:nil
                            withDelegate:messageBoxDelegate] autorelease];
    
    //box.buttonToBoxBottomPadding = BUTTON_TO_BOTTOM_PADDING_DEFAULT;
    box.titleLeftRightPadding = TITLE_LEFT_RIGHT_PADDING_DEFAULT;
    box.titleTopPadding = TITLE_TOP_PADDING_DEFAULT;
    box.contentTextColor = CONTENT_TEXT_COLOR_DEFAULT;
    box.titleTextColor = TITLE_TEXT_COLOR_DEFAULT;
    box.buttonTextColor = BUTTON_TEXT_COLOR_DEFAULT;
    box.titleContentExtraInterval = TITLE_CONTENT_EXTRA_INTERVAL_DEFAULT;
    box.customTextButtonLabelRect = BUTTON_LABEL_RECT;
    
    [box showOnWindowWithYesButtonShowed:YES noButtonShowed:NO];
    return box;
}

+ (MessageBoxView*)showWithYesButtonForTitle:(NSString*)title
                                     content:(NSString*)content
                                withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
                          andTextButtonTexts:(NSString*)first,...
{
    NSMutableArray* argsArray = [NSMutableArray array];
    NSString* arg = nil;
    va_list argList;
    if(first)
    {
        [argsArray addObject:first];
        va_start(argList,first);
        do
        {
            arg = va_arg(argList,NSString*);
            if (arg)
            {
                [argsArray addObject:arg];
            }
        }while (arg);
        va_end(argList);
    }
    MessageBoxView* box = [[[MessageBoxView alloc]
                            initWithBgView:nil
                            orBgColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.38]
                            boxBgImage:[[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:48.0]
                            yesButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_normal"]
                            yesButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_pressed"]
                            noButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_normal"]
                            noButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_pressed"]
                            textButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_normal"]
                            textButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_pressed"]
                            title:title
                            content:content
                            extraView:nil
                            textButtonTexts:argsArray
                            withDelegate:messageBoxDelegate] autorelease];
    
    //box.buttonToBoxBottomPadding = BUTTON_TO_BOTTOM_PADDING_DEFAULT;
    box.titleLeftRightPadding = TITLE_LEFT_RIGHT_PADDING_DEFAULT;
    box.titleTopPadding = TITLE_TOP_PADDING_DEFAULT;
    box.contentTextColor = CONTENT_TEXT_COLOR_DEFAULT;
    box.titleTextColor = TITLE_TEXT_COLOR_DEFAULT;
    box.buttonTextColor = BUTTON_TEXT_COLOR_DEFAULT;
    box.titleContentExtraInterval = TITLE_CONTENT_EXTRA_INTERVAL_DEFAULT;
    box.customTextButtonLabelRect = BUTTON_LABEL_RECT;
    
    [box showOnWindowWithYesButtonShowed:YES noButtonShowed:NO];
    return box;
}

+ (MessageBoxView*)showWithNoButtonForTitle:(NSString*)title
                                    content:(NSString*)content
                               withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
                         andTextButtonTexts:(NSString*)first,...
{
    NSMutableArray* argsArray = [NSMutableArray array];
    NSString* arg = nil;
    va_list argList;
    if(first)
    {
        [argsArray addObject:first];
        va_start(argList,first);
        do
        {
            arg = va_arg(argList,NSString*);
            if (arg)
            {
                [argsArray addObject:arg];
            }
        }while (arg);
        va_end(argList);
    }
    MessageBoxView* box = [[[MessageBoxView alloc]
                            initWithBgView:nil
                            orBgColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.38]
                            boxBgImage:[[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:48.0]
                            yesButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_normal"]
                            yesButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_pressed"]
                            noButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_normal"]
                            noButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_pressed"]
                            textButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_normal"]
                            textButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_pressed"]
                            title:title
                            content:content
                            extraView:nil
                            textButtonTexts:argsArray
                            withDelegate:messageBoxDelegate] autorelease];
    
    //box.buttonToBoxBottomPadding = BUTTON_TO_BOTTOM_PADDING_DEFAULT;
    box.titleLeftRightPadding = TITLE_LEFT_RIGHT_PADDING_DEFAULT;
    box.titleTopPadding = TITLE_TOP_PADDING_DEFAULT;
    box.contentTextColor = CONTENT_TEXT_COLOR_DEFAULT;
    box.titleTextColor = TITLE_TEXT_COLOR_DEFAULT;
    box.buttonTextColor = BUTTON_TEXT_COLOR_DEFAULT;
    box.titleContentExtraInterval = TITLE_CONTENT_EXTRA_INTERVAL_DEFAULT;
    box.customTextButtonLabelRect = BUTTON_LABEL_RECT;
    
    [box showOnWindowWithYesButtonShowed:NO noButtonShowed:YES];
    return box;
}

+ (MessageBoxView*)showWithOnlyTextButtonForTitle:(NSString*)title
                                          content:(NSString*)content
                                     withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
                               andTextButtonTexts:(NSString*)first,...
{
    NSMutableArray* argsArray = [NSMutableArray array];
    NSString* arg = nil;
    va_list argList;
    if(first)
    {
        [argsArray addObject:first];
        va_start(argList,first);
        do
        {
            arg = va_arg(argList,NSString*);
            if (arg)
            {
                [argsArray addObject:arg];
            }
        }while (arg);
        va_end(argList);
    }
    MessageBoxView* box = [[[MessageBoxView alloc]
                            initWithBgView:nil
                            orBgColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.38]
                            boxBgImage:[[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_bg"] stretchableImageWithLeftCapWidth:0 topCapHeight:48.0]
                            yesButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_normal"]
                            yesButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_yes_button_pressed"]
                            noButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_normal"]
                            noButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_no_button_pressed"]
                            textButtonImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_normal"]
                            textButtonPressedImage:[UIImage imageNamed:@"/Resource/Picture/messagebox/message_box_text_button_pressed"]
                            title:title
                            content:content
                            extraView:nil
                            textButtonTexts:argsArray
                            withDelegate:messageBoxDelegate] autorelease];
    
    //box.buttonToBoxBottomPadding = BUTTON_TO_BOTTOM_PADDING_DEFAULT;
    box.titleLeftRightPadding = TITLE_LEFT_RIGHT_PADDING_DEFAULT;
    box.titleTopPadding = TITLE_TOP_PADDING_DEFAULT;
    box.contentTextColor = CONTENT_TEXT_COLOR_DEFAULT;
    box.titleTextColor = TITLE_TEXT_COLOR_DEFAULT;
    box.buttonTextColor = BUTTON_TEXT_COLOR_DEFAULT;
    box.titleContentExtraInterval = TITLE_CONTENT_EXTRA_INTERVAL_DEFAULT;
    box.customTextButtonLabelRect = BUTTON_LABEL_RECT;
    
    [box showOnWindowWithYesButtonShowed:NO noButtonShowed:NO];
    return box;
}


#pragma mark touch event override

- (void)onPressedTextBtn:(int)index
{
    UILabel* lbl = [self getTextButtonLabelAtIndex:index];
    if (lbl)
    {
        CGRect rect = lbl.frame;
        rect.origin.x += (-0.3 * rect.size.width) + BUTTON_TEXT_LEBEL_SHIFT_X;
        rect.origin.y -= (0.3 * rect.size.height) + BUTTON_TEXT_LEBEL_SHIFT_Y;
        rect.size.width *= 1.6;
        rect.size.height *= 1.6;
        lbl.frame = rect;
        
        lbl.textColor = BUTTON_TEXT_COLOR_PRESSED;
        CGAffineTransform trans = lbl.transform;
        trans = CGAffineTransformRotate(trans, -(M_PI * 0.15));
        lbl.font = [lbl.font fontWithSize:(lbl.font.pointSize * 1.6)];
        lbl.transform = trans;
        
        rect = lbl.bounds;
        _textButtonTipBgView = [[UIView alloc] initWithFrame:rect];
        _textButtonTipBgView.layer.cornerRadius = 8.0;
        _textButtonTipBgView.layer.masksToBounds = YES;
        rect = lbl.frame;
        rect.origin.x -= 5.0;
        rect.size.width += 10.0;
        float newHeight = lbl.font.pointSize + 10.0;
        rect.origin.y += (rect.size.height - newHeight) * 0.5;
        rect.size.height = newHeight;
        _textButtonTipBgView.frame = rect;
        trans = CGAffineTransformRotate(_textButtonTipBgView.transform, -(M_PI * 0.15));
        _textButtonTipBgView.transform = trans;
        _textButtonTipBgView.backgroundColor = BUTTON_TEXT_PRESSED_BG_COLOR;
        [lbl.superview insertSubview:_textButtonTipBgView belowSubview:lbl];
    }
}

- (void)onRestoreTextBtn:(int)index
{
    UILabel* lbl = [self getTextButtonLabelAtIndex:index];
    if (lbl)
    {
        lbl.textColor = BUTTON_TEXT_COLOR_DEFAULT;
        CGAffineTransform trans = lbl.transform;
        trans = CGAffineTransformRotate(trans, (M_PI * 0.15));
        lbl.font = [lbl.font fontWithSize:(lbl.font.pointSize * 0.625)];
        lbl.transform = trans;
        CGRect rect = lbl.frame;
        rect.size.width *= 0.625;
        rect.size.height *= 0.625;
        rect.origin.x -= (-0.3 * rect.size.width) + BUTTON_TEXT_LEBEL_SHIFT_X;
        rect.origin.y += (0.3 * rect.size.height) + BUTTON_TEXT_LEBEL_SHIFT_Y;
        lbl.frame = rect;
        lbl.backgroundColor = [UIColor clearColor];
        
        ReleaseAndNilView(_textButtonTipBgView);
    }
}

- (void)onReleaseTextBtn:(int)index
{
    UILabel* lbl = [self getTextButtonLabelAtIndex:index];
    if (lbl)
    {
        lbl.textColor = BUTTON_TEXT_COLOR_DEFAULT;
        CGAffineTransform trans = lbl.transform;
        trans = CGAffineTransformRotate(trans, (M_PI * 0.15));
        lbl.font = [lbl.font fontWithSize:(lbl.font.pointSize * 0.625)];
        lbl.transform = trans;
        CGRect rect = lbl.frame;
        rect.size.width *= 0.625;
        rect.size.height *= 0.625;
        rect.origin.x -= (-0.3 * rect.size.width) + BUTTON_TEXT_LEBEL_SHIFT_X;
        rect.origin.y += (0.3 * rect.size.height) + BUTTON_TEXT_LEBEL_SHIFT_Y;
        lbl.frame = rect;
        lbl.backgroundColor = [UIColor clearColor];
        
        ReleaseAndNilView(_textButtonTipBgView);
    }
}

- (void)onPressedYesNoBtn:(BOOL)isYes
{
    
}

- (void)onRestoreYesNoBtn:(BOOL)isYes
{
    
}

- (void)onReleaseYesNoBtn:(BOOL)isYes
{
    
}

- (void)onFinishedSetUpSubView
{
    [super onFinishedSetUpSubView];
    for (CommonAnimationButton* btn in _btnArray)
    {
        CGRect rect = btn.frame;
        rect.origin = CGPointZero;
        if (btn == _yesButton || btn == _noButton)
        {
            rect.origin.x += 10;
            rect.origin.y += 10;
            rect.size.width -= 20;
            rect.size.height -= 20;
            btn.button.frame = rect;
        }
        else
        {
            rect.origin.x += 5;
            rect.origin.y += 25;
            rect.size.width -= 10;
            rect.size.height -= 60;
            btn.button.frame = rect;
        }
    }
}

@end
