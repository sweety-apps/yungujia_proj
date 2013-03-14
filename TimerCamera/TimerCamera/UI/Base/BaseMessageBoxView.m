//
//  BaseMessageBoxView.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-19.
//
//

#import "BaseMessageBoxView.h"
#import <QuartzCore/QuartzCore.h>

#define BUTTON_LABEL_TAG (60)
#define NUM_OF_BUTTONS_IN_ROW_IPHONE (3)
#define NUM_OF_BUTTONS_IN_ROW_IPAD (5)
#define BUTTON_EXTENDS_WIDTH (30.)

static int number_of_buttons_in_row = 0;

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
@synthesize buttonRowInterval = _buttonRowInterval;
@synthesize buttonToBoxBottomPadding = _buttonToBoxBottomPadding;
@synthesize customTextButtonLabelRect = _customTextButtonLabelRect;
@synthesize boxBackTopIcon = _boxBackTopIcon;
@synthesize boxBackTopIconTopPadding = _boxBackTopIconTopPadding;

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
    
    ReleaseAndNilView(_boxBackTopIconView);
    ReleaseAndNil(_boxBackTopIcon);
    
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
        if (_textButtons == nil)
        {
            _textButtons = [[NSMutableArray array] retain];
        }
        for (NSString* text in _textButtonTexts)
        {
            CommonAnimationButton* btn = [[CommonAnimationButton
                                          buttonWithPressedImageSizeforNormalImage1:_textImage
                                          forNormalImage2:_textImage
                                          forPressedImage:_textPressedImage
                                          forEnabledImage1:nil
                                          forEnabledImage2:nil] retain];
            
            CGRect rect = btn.frame;
            rect.origin = CGPointZero;
            if (!CGRectIsEmpty(_customTextButtonLabelRect))
            {
                rect = _customTextButtonLabelRect;
            }
            
            UILabel* lbl = [[[UILabel alloc] initWithFrame:rect] autorelease];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = _buttonTextColor;
            lbl.numberOfLines = 1;
            lbl.textAlignment = UITextAlignmentCenter;
            lbl.adjustsFontSizeToFitWidth = YES;
            lbl.font = [UIFont systemFontOfSize:18.0];
            lbl.text = text;
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
            
            [_textButtons addObject:btn];
        }
    }
}

- (void)destroyTextButtons
{
    if (_textButtons)
    {
        for (CommonAnimationButton* btn in _textButtons)
        {
            ReleaseAndNilView(btn);
        }
        ReleaseAndNil(_textButtons);
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
    if (_messageBoxDelegate)
    {
        [_messageBoxDelegate onTextButtonPressedAt:index forMessageBox:self];
    }
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
    if (_messageBoxDelegate)
    {
        [_messageBoxDelegate onYesButtonPressedForMessageBox:self];
    }
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
    if (_messageBoxDelegate)
    {
        [_messageBoxDelegate onNoButtonPressedForMessageBox:self];
    }
}

- (void)setTransformsForViews:(UIView**)views
                        trans:(CGAffineTransform*)transforms
                        count:(int)count
{
    for (int i = 0; i < count; ++i)
    {
        views[i].transform = transforms[i];
    }
}

- (void)showBoxWithAnimation:(NSArray*)btnArray
{
    int btnCount = [btnArray count];
    float bgAlpha = _bgView.alpha;
    
    CGAffineTransform boxTrans = _boxBgImage.transform;
    CGAffineTransform boxBounceTrans = CGAffineTransformScale(boxTrans, 1.2, 1.2);
    
    CommonAnimationButton** btnsPtr = malloc(sizeof(CommonAnimationButton*) * btnCount);
    CGAffineTransform* btnZeroTransPtr = malloc(sizeof(CGAffineTransform) * btnCount);
    CGAffineTransform* btnTransPtr = malloc(sizeof(CGAffineTransform) * btnCount);
    CGAffineTransform* btnBounceTransPtr = malloc(sizeof(CGAffineTransform) * btnCount);
    
    CGRect backIconRawRect = _boxBackTopIconView.frame;
    CGRect backIconStartRect = backIconRawRect;
    backIconStartRect.origin.y += backIconRawRect.size.height;
    CGRect backIconBounceRect = backIconRawRect;
    backIconBounceRect.origin.y -= backIconBounceRect.size.height * 0.05;
    
    void (^freeBtnTrans)() = ^(){
        free(btnsPtr);
        free(btnZeroTransPtr);
        free(btnTransPtr);
        free(btnBounceTransPtr);
    };
    
    for (int i = 0; i < [btnArray count]; ++i)
    {
        CommonAnimationButton* btn =  [btnArray objectAtIndex:i];
        btnsPtr[i] = btn;
        btnTransPtr[i] = btn.transform;
        btnZeroTransPtr[i] = CGAffineTransformScale(btnTransPtr[i], 0.00001, 0.00001);
        btnBounceTransPtr[i] = CGAffineTransformScale(btnTransPtr[i], 1.2, 1.2);
    }
    
    void (^initAll)() = ^(){
        _bgView.alpha = 0.0;
        _boxBgImage.transform = CGAffineTransformScale(boxTrans, 0.00001, 0.00001);
        [self setTransformsForViews:btnsPtr trans:btnZeroTransPtr count:btnCount];
        _titleLbl.alpha = 0.0;
        _contentLbl.alpha = 0.0;
        _extraView.alpha = 0.0;
        _boxBackTopIconView.alpha = 0.0;
        _boxBackTopIconView.frame = backIconStartRect;
    };
    
    void (^showBG)() = ^(){
        _bgView.alpha = bgAlpha;
    };
    
    void (^bounceBox)() = ^(){
        _boxBgImage.transform = boxBounceTrans;
    };
    
    void (^endBounceBox)() = ^(){
        _boxBgImage.transform = boxTrans;
    };
    
    void (^bounceBtn)() = ^(){
        _titleLbl.alpha = 1.0;
        _contentLbl.alpha = 1.0;
        _extraView.alpha = 1.0;
        [self setTransformsForViews:btnsPtr trans:btnBounceTransPtr count:btnCount];
    };
    
    void (^endBounceBtn)() = ^(){
        [self setTransformsForViews:btnsPtr trans:btnTransPtr count:btnCount];
        _boxBackTopIconView.alpha = 1.0;
    };
    
    void (^bounceBackIcon)() = ^(){
        _boxBackTopIconView.frame = backIconBounceRect;
    };
    
    void (^endBounceBackIcon)() = ^(){
        _boxBackTopIconView.frame = backIconRawRect;
    };
    
    initAll();
    
    [UIView
     animateWithDuration:0.15
     animations:^(){
         showBG();
         bounceBox();
     }
     completion:^(BOOL finished){
         [UIView
          animateWithDuration:0.05
          animations:endBounceBox
          completion:^(BOOL finished){
              [UIView
               animateWithDuration:0.15
               animations:bounceBtn
               completion:^(BOOL finished){
                   [UIView
                    animateWithDuration:0.05
                    animations:endBounceBtn
                    completion:^(BOOL finished){
                        [UIView
                         animateWithDuration:0.1
                         animations:bounceBackIcon
                         completion:^(BOOL finished){
                             [UIView
                              animateWithDuration:0.05
                              animations:endBounceBackIcon
                              completion:^(BOOL finished){
                                  freeBtnTrans();
                              }];
                         }];
                    }];
               }];
          }];
     }];
}

- (void)hideBoxWithAnimation:(NSArray*)btnArray
{
    int btnCount = [btnArray count];
    CGAffineTransform boxTrans = _boxBgImage.transform;
    
    CommonAnimationButton** btnsPtr = malloc(sizeof(CommonAnimationButton*) * btnCount);
    CGAffineTransform* btnZeroTransPtr = malloc(sizeof(CGAffineTransform) * btnCount);
    CGAffineTransform* btnTransPtr = malloc(sizeof(CGAffineTransform) * btnCount);
    CGAffineTransform* btnBounceTransPtr = malloc(sizeof(CGAffineTransform) * btnCount);
    
    CGRect backIconRawRect = _boxBackTopIconView.frame;
    CGRect backIconStartRect = backIconRawRect;
    backIconStartRect.origin.y += backIconRawRect.size.height;
    
    void (^freeBtnTrans)() = ^(){
        free(btnsPtr);
        free(btnZeroTransPtr);
        free(btnTransPtr);
        free(btnBounceTransPtr);
    };
    
    for (int i = 0; i < [btnArray count]; ++i)
    {
        CommonAnimationButton* btn =  [btnArray objectAtIndex:i];
        btnsPtr[i] = btn;
        btnTransPtr[i] = btn.transform;
        btnZeroTransPtr[i] = CGAffineTransformScale(btnTransPtr[i], 0.00001, 0.00001);
        btnBounceTransPtr[i] = CGAffineTransformScale(btnTransPtr[i], 1.2, 1.2);
    }
    
    void (^hideBtns)() = ^(){
        [self setTransformsForViews:btnsPtr trans:btnZeroTransPtr count:btnCount];
        _titleLbl.alpha = 0.0;
        _contentLbl.alpha = 0.0;
        _extraView.alpha = 0.0;
        _boxBackTopIconView.frame = backIconStartRect;
    };
    
    void (^hideOther)() = ^(){
        _bgView.alpha = 0.0;
        _boxBgImage.transform = CGAffineTransformScale(boxTrans, 0.00001, 0.00001);
    };
    
    [UIView
     animateWithDuration:0.15
     animations:hideBtns
     completion:^(BOOL finished){
         _boxBackTopIconView.alpha = 0.0;
         [UIView
          animateWithDuration:0.15
          animations:hideOther
          completion:^(BOOL finished){
              freeBtnTrans();
              [self removeFromSuperview];
              [_btnArray removeAllObjects];
              ReleaseAndNil(_btnArray);
          }];
     }];
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
        if (number_of_buttons_in_row == 0)
        {
            if (IS_IPAD)
            {
                number_of_buttons_in_row = NUM_OF_BUTTONS_IN_ROW_IPAD;
            }
            else
            {
                number_of_buttons_in_row = NUM_OF_BUTTONS_IN_ROW_IPHONE;
            }
        }
        
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
        _titleLbl.font = [UIFont systemFontOfSize:24.0];
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.backgroundColor = [UIColor clearColor];
        _contentLbl.textColor = _contentTextColor;
        _contentLbl.numberOfLines = 0;
        _contentLbl.textAlignment = UITextAlignmentCenter;
        _contentLbl.font = [UIFont systemFontOfSize:18.0];
        
        _extraView = [extraView retain];
        _messageBoxDelegate = messageBoxDelegate;
        
        _customTextButtonLabelRect = CGRectZero;
        
        _boxBackTopIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
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
    
    self.frame = rect;
    
    //set box
    CGSize boxSize = _boxBgImage.image.size;
    
    //caculate Title
    CGRect titleRect = CGRectZero;
    if (_title.length > 0)
    {
        CGSize titleSize = CGSizeMake(boxSize.width - (2.0 * _titleLeftRightPadding), 100000);
        titleSize = [_title sizeWithFont:_titleLbl.font constrainedToSize:titleSize];
        
        titleRect = CGRectMake(((boxSize.width - titleSize.width) * 0.5),
                               _titleTopPadding,
                               titleSize.width,
                               titleSize.height);
        
        _titleLbl.text = _title;
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
        
        _contentLbl.text = _content;
    }
    
    //caculate Buttons
    _btnArray = [[NSMutableArray array] retain];
    
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
    if (buttonsAllCount <= number_of_buttons_in_row)
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
    }
    
    //caculate button start Y
    float lastY = 0.;
    float y[4] = {0};
    y[0] = CGRectGetMaxY(contentRect);
    y[1] = CGRectGetMaxY(titleRect);
    y[2] = CGRectGetMaxY(extraRect);
    y[3] = _titleTopPadding;
    for (int i = 0; i < 4; ++ i)
    {
        if (y[i] > lastY)
        {
            lastY = y[i];
        }
    }
    
    //set buttons frame
    int step = 0;
    float btnAll_width = boxSize.width + BUTTON_EXTENDS_WIDTH;
    
    for (int i = 0; i < [_btnArray count]; i += step)
    {
        NSMutableArray* rowBtn = [NSMutableArray array];
        step = number_of_buttons_in_row;
        int restCount = [_btnArray count] - i;
        if (!onlyOneRow)
        {
            if (showYes && showNO)
            {
                if (restCount > 2 && (restCount - number_of_buttons_in_row) < 2)
                {
                    step = restCount - 2;
                }
            }
        }
        
        for (int j = 0; j < step; ++j)
        {
            if (i + j < [_btnArray count])
            {
                [rowBtn addObject:[_btnArray objectAtIndex:i + j]];
            }
        }
        
        float buttonMaxHeight = 0.0;
        for (int j = 0; j < [rowBtn count]; ++j)
        {
            CommonAnimationButton* btn = [rowBtn objectAtIndex:j];
            
            if (btn.frame.size.height > buttonMaxHeight)
            {
                buttonMaxHeight = btn.frame.size.height;
            }
        }
        
        if (i != 0)
        {
            lastY += _buttonRowInterval;
        }
        
        float cellWidth = btnAll_width/[rowBtn count];
        for (int j = 0; j < [rowBtn count]; ++j)
        {
            CGPoint btnCenter = CGPointMake(cellWidth * (((float)j) + 0.5)- (BUTTON_EXTENDS_WIDTH * 0.5), lastY + (0.5 * buttonMaxHeight));
            
            CommonAnimationButton* btn = [rowBtn objectAtIndex:j];
            
            CGRect btnRect = btn.frame;
            btnRect.origin.x = btnCenter.x - (btnRect.size.width * 0.5);
            btnRect.origin.y = btnCenter.y - (btnRect.size.height * 0.5);
            btn.frame = btnRect;
        }
        
        [rowBtn removeAllObjects];
        lastY += buttonMaxHeight;
    }
    
    boxSize.height = lastY + _buttonToBoxBottomPadding;
    
    CGRect boxRect = CGRectZero;
    boxRect.origin.x = (rect.size.width - boxSize.width) * 0.5;
    boxRect.origin.y = (rect.size.height - boxSize.height) * 0.5;
    boxRect.size = boxSize;
    _boxBgImage.frame = boxRect;
    
    titleRect.origin.x += boxRect.origin.x;
    titleRect.origin.y += boxRect.origin.y;
    _titleLbl.frame = titleRect;
    
    contentRect.origin.x += boxRect.origin.x;
    contentRect.origin.y += boxRect.origin.y;
    _contentLbl.frame = contentRect;
    
    extraRect.origin.x += boxRect.origin.x;
    extraRect.origin.y += boxRect.origin.y;
    _extraView.frame = extraRect;
    
    if (_boxBackTopIcon)
    {
        CGRect backIconRect = CGRectZero;
        backIconRect.size = _boxBackTopIcon.size;
        backIconRect.origin.x = (float)((int)boxRect.origin.x + ((boxRect.size.width - _boxBackTopIcon.size.width) * 0.5));
        backIconRect.origin.y = boxRect.origin.y + _boxBackTopIconTopPadding;
        _boxBackTopIconView.frame = backIconRect;
        _boxBackTopIconView.image = _boxBackTopIcon;
    }
    
    //show Logic
    [self addSubview:_bgView];
    [self addSubview:_boxBackTopIconView];
    [self addSubview:_boxBgImage];
    [self addSubview:_titleLbl];
    
    if (_extraView)
    {
        [self addSubview:_extraView];
    }
    [self addSubview:_contentLbl];
    
    for (CommonAnimationButton* btn in _btnArray)
    {
        CGRect btnRect = btn.frame;
        btnRect.origin.x += boxRect.origin.x;
        btnRect.origin.y += boxRect.origin.y;
        btn.frame = btnRect;
        [self addSubview:btn];
    }
    
    [self onFinishedSetUpSubView];
    
    [self showBoxWithAnimation:_btnArray];
}

- (void)hide
{
    [self hideBoxWithAnimation:_btnArray];
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

- (void)onFinishedSetUpSubView
{
    
}

- (UILabel*)getTextButtonLabelAtIndex:(int)index
{
    CommonAnimationButton* btn = [_textButtons objectAtIndex:index];
    for (UIView* view in btn.button.subviews)
    {
        if ([view isKindOfClass:[UILabel class]] && view.tag == BUTTON_LABEL_TAG)
        {
            return (UILabel*)view;
        }
    }
    return nil;
}

@end
