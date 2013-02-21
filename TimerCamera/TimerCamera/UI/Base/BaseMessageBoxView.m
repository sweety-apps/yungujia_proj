//
//  BaseMessageBoxView.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-19.
//
//

#import "BaseMessageBoxView.h"

#define BUTTON_LABEL_TAG (60)

@implementation BaseMessageBoxView

@synthesize textButtonTexts = _textButtonTexts;
@synthesize title = _title;
@synthesize content = _content;
@synthesize extraView = _extraView;
@synthesize titleTextColor = _titleTextColor;
@synthesize contentTextColor = _contentTextColor;
@synthesize buttonTextColor = _buttonTextColor;
@synthesize messageBoxDelegate = _messageBoxDelegate;
@synthesize titleTopPadding = _titleTopPadding;
@synthesize titleLeftRightPadding = _titleLeftRightPadding;
@synthesize titleContentExtraInterval = _titleContentExtraInterval;
@synthesize buttonToBoxBottomPadding = _buttonToBoxBottomPadding;

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
    ReleaseAndNilView(_bgView);
    ReleaseAndNil(_bgColor);
    ReleaseAndNilView(_boxBgImage);
    ReleaseAndNilView(_yesButton);
    ReleaseAndNilView(_noButton);
    ReleaseAndNilView(_titleLbl);
    ReleaseAndNilView(_contentLbl);
    ReleaseAndNilView(_extraView);
    ReleaseAndNil(_textImage);
    ReleaseAndNil(_textPressedImage);
    ReleaseAndNil(_title);
    ReleaseAndNil(_content);
    ReleaseAndNil(_textButtonTexts);
    
    ReleaseAndNil(_titleTextColor);
    ReleaseAndNil(_contentTextColor);
    ReleaseAndNil(_buttonTextColor);
    
    [self destroyTextButtons];
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

#pragma mark Private Methods

- (void)createTextButtons
{
    if (_textButtonTexts)
    {
        int i = 0;
        for (NSString* text in _textButtonTexts)
        {
            CommonAnimationButton* btn = [CommonAnimationButton
                                          buttonWithPressedImageSizeforNormalImage1:_textImage
                                          forNormalImage2:_textImage
                                          forPressedImage:_textPressedImage
                                          forEnabledImage1:nil
                                          forEnabledImage2:nil];
            
            CGRect rect = btn.frame;
            rect.origin = CGPointZero;
            
            UILabel* lbl = [[[UILabel alloc] initWithFrame:rect] autorelease];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = _buttonTextColor;
            lbl.numberOfLines = 0;
            lbl.textAlignment = UITextAlignmentCenter;
            lbl.font = [UIFont systemFontOfSize:36.0];
            lbl.tag = BUTTON_LABEL_TAG;
            
            [btn.button addSubview:lbl];
            
            btn.button.tag = i;
            [btn.button addTarget:self
                           action:@selector(onTouchDownInsideBtn:)
                 forControlEvents:UIControlEventTouchDown];
            [btn.button addTarget:self
                           action:@selector(onTouchUpOutsideBtn:)
                 forControlEvents:UIControlEventTouchUpOutside];
            [btn.button addTarget:self
                           action:@selector(onTouchUpInsideBtn:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            ++i;
        }
    }
}

- (void)destroyTextButtons
{
    for (CommonAnimationButton* btn in _textButtons)
    {
        ReleaseAndNilView(btn);
    }
}

- (void)onTouchDownInsideBtn:(id)sender
{
    UIButton* btn = sender;
    int index = btn.tag;
    [self onPressedTextBtn:index];
}

- (void)onTouchUpOutsideBtn:(id)sender
{
    UIButton* btn = sender;
    int index = btn.tag;
    [self onRestoreTextBtn:index];
}

- (void)onTouchUpInsideBtn:(id)sender
{
    UIButton* btn = sender;
    int index = btn.tag;
    [self onReleaseTextBtn:index];
}

- (void)onTouchDownInsideYesBtn:(id)sender
{
    [self onPressedYesNoBtn:YES];
}

- (void)onTouchUpOutsideYesBtn:(id)sender
{
    [self onRestoreYesNoBtn:YES];
}

- (void)onTouchUpInsideYesBtn:(id)sender
{
    [self onReleaseYesNoBtn:YES];
}

- (void)onTouchDownInsideNoBtn:(id)sender
{
    [self onPressedYesNoBtn:NO];
}

- (void)onTouchUpOutsideNoBtn:(id)sender
{
    [self onRestoreYesNoBtn:NO];
}

- (void)onTouchUpInsideNoBtn:(id)sender
{
    [self onReleaseYesNoBtn:NO];
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
        _titleTextColor = [[UIColor whiteColor] retain];
        _contentTextColor = [[UIColor whiteColor] retain];
        _buttonTextColor = [[UIColor blackColor] retain];
        
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
            
            [_yesButton.button addTarget:self
                           action:@selector(onTouchDownInsideYesBtn:)
                 forControlEvents:UIControlEventTouchDown];
            [_yesButton.button addTarget:self
                           action:@selector(onTouchUpOutsideYesBtn:)
                 forControlEvents:UIControlEventTouchUpOutside];
            [_yesButton.button addTarget:self
                           action:@selector(onTouchUpInsideYesBtn:)
                 forControlEvents:UIControlEventTouchUpInside];
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
            
            [_noButton.button addTarget:self
                                  action:@selector(onTouchDownInsideNoBtn:)
                        forControlEvents:UIControlEventTouchDown];
            [_noButton.button addTarget:self
                                  action:@selector(onTouchUpOutsideNoBtn:)
                        forControlEvents:UIControlEventTouchUpOutside];
            [_noButton.button addTarget:self
                                  action:@selector(onTouchUpInsideNoBtn:)
                        forControlEvents:UIControlEventTouchUpInside];
        }
        
        _textImage = [textImage retain];
        _textPressedImage = [textPressed retain];
        
        self.textButtonTexts = textBtnTexts;
        
        self.title = title;
        self.content = content;
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = _titleTextColor;
        _titleLbl.numberOfLines = 0;
        _titleLbl.textAlignment = UITextAlignmentCenter;
        _titleLbl.font = [UIFont systemFontOfSize:48.0];
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.backgroundColor = [UIColor clearColor];
        _contentLbl.textColor = _contentTextColor;
        _contentLbl.numberOfLines = 0;
        _contentLbl.textAlignment = UITextAlignmentCenter;
        _contentLbl.font = [UIFont systemFontOfSize:36.0];
        
        _extraView = [extraView retain];
        _messageBoxDelegate = messageBoxDelegate;
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
    [self showOnView:[UIApplication sharedApplication].delegate.window
     yesButtonShowed:showYes
      noButtonShowed:showNO];
}

- (void)showOnView:(UIView*)view
   yesButtonShowed:(BOOL)showYes
    noButtonShowed:(BOOL)showNO
{
    if (view == nil)
    {
        return;
    }
    
    [view addSubview:self];
    
    [self destroyTextButtons];
    [_titleLbl removeFromSuperview];
    [_extraView removeFromSuperview];
    [_contentLbl removeFromSuperview];
    [_yesButton removeFromSuperview];
    [_noButton removeFromSuperview];
    [_boxBgImage removeFromSuperview];
    
    [self createTextButtons];
    
    CGRect rect = view.frame;
    rect.origin = CGPointZero;
    
    if (_bgView == nil)
    {
        _bgView = [[UIView alloc] initWithFrame:rect];
        _bgView.backgroundColor = _bgColor;
    }
    
    //set box
    CGSize boxSize = _boxBgImage.image.size;
    
    //caculate Title
    CGRect titleRect = CGRectZero;
    if (_title.length > 0)
    {
        CGSize titleSize = CGSizeMake(boxSize.width - (2.0 * _titleLeftRightPadding), 100000);
        titleSize = [_title sizeWithFont:_titleLbl.font constrainedToSize:titleSize];
        
        titleRect = CGRectMake((boxSize.width - titleSize.width) * 0.5,
                               _titleTopPadding,
                               titleSize.width,
                               titleSize.height);
        
        _titleLbl.frame = titleRect;
        _titleLbl.text = _title;
        [_boxBgImage addSubview:_titleLbl];
    }
    
    //caculate extra view
    CGRect extraRect = CGRectZero;
    if (_extraView)
    {
        extraRect = _extraView.frame;
        extraRect.origin.x = (boxSize.width - extraRect.size.width) * 0.5;
        
        if (CGRectIsEmpty(titleRect))
        {
            extraRect.origin.y = _titleTopPadding;
        }
        else
        {
            extraRect.origin.y = CGRectGetMaxY(titleRect) + _titleContentExtraInterval;
        }
        
        [_boxBgImage addSubview:_extraView];
    }
    
    //caculate Content
    CGRect contentRect = CGRectZero;
    if (_content.length > 0)
    {
        CGSize contentSize = CGSizeMake(boxSize.width - (2.0 * _titleLeftRightPadding), 100000);
        contentSize = [_content sizeWithFont:_contentLbl.font constrainedToSize:contentSize];
        
        contentRect = CGRectMake((boxSize.width - contentSize.width) * 0.5,
                               0,
                               contentSize.width,
                               contentSize.height);
        
        if (CGRectIsEmpty(extraRect))
        {
            contentRect.origin.y = CGRectGetMaxY(titleRect) + _titleContentExtraInterval;
        }
        else
        {
            contentRect.origin.y = CGRectGetMaxY(extraRect) + _titleContentExtraInterval;
        }
        
        _contentLbl.frame = contentRect;
        _contentLbl.text = _content;
        [_boxBgImage addSubview:_contentLbl];
    }
    
    //caculate Buttons
    NSMutableArray* _btnArray = [NSMutableArray array];
    
    BOOL onlyOneRow = NO;
    
    int buttonsAllCount = [_textButtons count];
    if (showYes && _yesButton)
    {
        buttonsAllCount ++;
    }
    if (showNO && _noButton)
    {
        buttonsAllCount ++;
    }
    if (buttonsAllCount > 3)
    {
        onlyOneRow = YES;
    }
    
    if (onlyOneRow)
    {
        if (showYes && _yesButton)
        {
            [_btnArray addObject:_yesButton];
        }
        if ([_textButtons count] > 0)
        {
            for (CommonAnimationButton* btn in _textButtons)
            {
                [_btnArray addObject:btn];
            }
        }
        if (showNO && _noButton)
        {
            [_btnArray addObject:_noButton];
        }
        
        for (CommonAnimationButton* btn in _btnArray)
        {
            
        }
    }
    else
    {
        if ([_textButtons count] > 0)
        {
            for (CommonAnimationButton* btn in _textButtons)
            {
                [_btnArray addObject:btn];
            }
        }
        if (showYes && _yesButton)
        {
            [_btnArray addObject:_yesButton];
        }
        if (showNO && _noButton)
        {
            [_btnArray addObject:_noButton];
        }
        
        for (CommonAnimationButton* btn in _btnArray)
        {
            
        }
    }
    
    [self addSubview:_bgView];
}

- (void)hide
{
    [self removeFromSuperview];
}

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
