//
//  MessageBoxView.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-19.
//
//

#import "MessageBoxView.h"

#define CONTENT_START_Y (35.0)

#define BUTTON_TO_BOTTOM_PADDING_DEFAULT (-18.0)
#define TITLE_LEFT_RIGHT_PADDING_DEFAULT (12.0)
#define TITLE_TOP_PADDING_DEFAULT (29.0)
#define CONTENT_TEXT_COLOR_DEFAULT [UIColor whiteColor]
#define TITLE_TEXT_COLOR_DEFAULT [UIColor whiteColor]
#define TITLE_CONTENT_EXTRA_INTERVAL_DEFAULT (5.0)
#define BUTTON_TEXT_COLOR_DEFAULT [UIColor blackColor]
#define BUTTON_LABEL_RECT CGRectMake(17,35,69,30)

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
    
}

- (void)onRestoreTextBtn:(int)index
{
    
}

- (void)onReleaseTextBtn:(int)index
{
    
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

@end
