//
//  QRCodeScannerViewController.m
//  TimerCamera
//
//  Created by lijinxin on 13-3-10.
//
//

#import "QRCodeScannerViewController.h"
#import "QRCodeReader.h"
#import "AztecReader.h"
#import "BaseUtilitiesFuncions.h"
#import "AudioUtility.h"
#import "AppDelegate.h"

static CommonAnimationButtonAnimationRecorder* gBackButtonRecorder = nil;
static CommonAnimationButtonAnimationRecorder* gTorchButtonRecorder = nil;

#define CREATE_BUTTON_RECORDER(x) if((x) == nil){(x) = [[CommonAnimationButtonAnimationRecorder alloc] init];}



@interface QRCodeScannerViewController ()

@end

@implementation QRCodeScannerViewController

- (id)init
{
    self = [super initWithDelegate:self showCancel:NO OneDMode:NO showLicense:NO];
    if (self)
    {
        NSMutableSet *readers = [NSMutableSet set];
        
        QRCodeReader* qrcodeReader = [[[QRCodeReader alloc] init] autorelease];
        [readers addObject:qrcodeReader];
        
        AztecReader *aztecReader = [[[AztecReader alloc] init] autorelease];
        [readers addObject:aztecReader];
        
        self.readers = readers;
        
        self.soundToPlay = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    {
        CREATE_BUTTON_RECORDER(gBackButtonRecorder);
        CREATE_BUTTON_RECORDER(gTorchButtonRecorder);
    }
    [self createSubViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    void (^removeCallerController)() = ^(){
        if (_ctrlToReleaseAfterShowed)
        {
            [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController removeController:_ctrlToReleaseAfterShowed];
        }
        _ctrlToReleaseAfterShowed = nil;
        [self initCapture];
    };
    
    if (_shouldShowAfterAppear)
    {
        [self showSubViews:YES beginBlock:nil finishBlock:removeCallerController];
    }
    else
    {
        removeCallerController();
    }
}
    
- (void)viewDidUnload
{
    [self destroySubViews];
    //
    [super viewDidUnload];
}

- (void)dealloc
{
    [self destroySubViews];
    //
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark View Life-Cycle

- (void)createSubViews
{
    //create subviews
    _frameBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/qrcode/qr_code_frame_bg"]];
    
    _frameBackgroundUpFillView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"/Resource/Picture/qrcode/qr_code_frame_bg_fill"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
    
    _frameBackgroundDownFillView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"/Resource/Picture/qrcode/qr_code_frame_bg_fill"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
    
    _bottomGreenView = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomGreenView.backgroundColor = kBGColor();
    
    _frameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/qrcode/qr_code_frame"]];
    
    _backButton = [[ShotButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_empty_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_empty_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_empty_pressed"]
                    forEnabledImage1:nil
                    forEnabledImage2:nil
                    forIcon:nil] retain];
    [_backButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_back"]];
    [_backButton setLabelString:@""];
    
    _torchButton = [[CommonAnimationButton
                     buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_disable1"]
                     forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_disable2"]
                     forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/torch_pressed"]
                     forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable1"]
                     forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable2"]] retain];
    
    _tipsView = [[TipsView tipsViewWithPushHand:[UIImage imageNamed:@"/Resource/Picture/main/tips_cat_hand"]
                                backGroundImage:[[UIImage imageNamed:@"/Resource/Picture/main/tips_fish_bg_strtechable"] stretchableImageWithLeftCapWidth:50 topCapHeight:28] ]
                 retain];
    
    //add recorders
    _backButton.stateAnimationRecorder = gBackButtonRecorder;
    _torchButton.stateAnimationRecorder = gTorchButtonRecorder;
    
    //set bottom first
    CGRect rectBottom = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - (self.view.frame.size.width * 4.0 / 3.0));
    rectBottom.origin.y = self.view.frame.size.height - rectBottom.size.height;
    _bottomGreenView.frame = rectBottom;
    
    //add events
    [_backButton.button addTarget:self action:@selector(onPressedBack:) forControlEvents:UIControlEventTouchUpInside];
    [_torchButton.button addTarget:self action:@selector(onPressedTorch:) forControlEvents:UIControlEventTouchUpInside];
    
    //add subviews
    [self.view addSubview:_frameBackgroundUpFillView];
    [self.view addSubview:_frameBackgroundDownFillView];
    [self.view addSubview:_frameBackgroundView];
    [self.view addSubview:_bottomGreenView];
    [self.view addSubview:_frameImageView];
    [self.view addSubview:_torchButton];
    [self.view addSubview:_backButton];
    
    //hide subViews
    [self hideSubViews:NO finishBlock:nil withLoadingPreloaddingImage:NO];
    
    //setOverView hidden
    self.overlayView.hidden = YES;
}

- (void)destroySubViews
{
    ReleaseAndNilView(_tipsView);
    ReleaseAndNilView(_torchButton);
    ReleaseAndNilView(_backButton);
    ReleaseAndNilView(_frameImageView);
    ReleaseAndNilView(_frameBackgroundView);
    ReleaseAndNilView(_frameBackgroundUpFillView);
    ReleaseAndNilView(_frameBackgroundDownFillView);
    ReleaseAndNilView(_bottomGreenView);
}

#define BOUNCE_OFFSET (3)

- (void)showSubViews:(BOOL)animated beginBlock:(void (^)(void))callStart finishBlock:(void (^)(void))callShowed
{
    //really showing
    CGRect rectView = self.view.frame;
    
    CGRect rectTorchInit = _torchButton.frame;
    rectTorchInit.origin.x = 0;
    rectTorchInit.origin.y = 0 - rectTorchInit.size.height;
    
    CGRect rectTorchShow = rectTorchInit;
    rectTorchShow.origin.x = 0;
    rectTorchShow.origin.y = 0 + BOUNCE_OFFSET;
    
    CGRect rectTorchFinished = rectTorchShow;
    rectTorchFinished.origin.x = 0;
    rectTorchFinished.origin.y = 0;
    
    CGRect rectBackInit = _backButton.frame;
    rectBackInit.origin.x = 126;
    rectBackInit.origin.y = rectView.size.height;
    
    CGRect rectBackShow = rectBackInit;
    rectBackShow.origin.y -= rectBackInit.size.height + BOUNCE_OFFSET;
    
    CGRect rectBackFinished = rectBackShow;
    rectBackFinished.origin.y += BOUNCE_OFFSET;
    
    CGRect rectFrameInit = _frameImageView.frame;
    rectFrameInit.origin.x = 0;
    rectFrameInit.origin.y = rectView.size.height;
    
    CGRect rectFrameShow = rectFrameInit;
    rectFrameShow.origin.y = 86 - BOUNCE_OFFSET;
    
    CGRect rectFrameFinished = rectFrameShow;
    rectFrameFinished.origin.y += BOUNCE_OFFSET;
    
    CGRect rectFrameBgMidInit = rectFrameInit;
    
    CGRect rectFrameBgMidShow = rectFrameShow;
    
    CGRect rectFrameBgMidFinished = rectFrameFinished;
    
    CGRect rectFrameBgUpInit = CGRectZero;
    rectFrameBgUpInit.size.width = rectFrameBgMidInit.size.width;
    rectFrameBgUpInit.size.height = rectFrameBgMidInit.origin.y;
    
    CGRect rectFrameBgUpShow = CGRectZero;
    rectFrameBgUpShow.size.width = rectFrameBgMidShow.size.width;
    rectFrameBgUpShow.size.height = rectFrameBgMidShow.origin.y;
    
    CGRect rectFrameBgUpFinished = CGRectZero;
    rectFrameBgUpFinished.size.width = rectFrameBgMidFinished.size.width;
    rectFrameBgUpFinished.size.height = rectFrameBgMidFinished.origin.y;
    
    CGRect rectFrameBgDownInit = CGRectZero;
    rectFrameBgDownInit.origin.x = rectFrameBgMidInit.origin.x;
    rectFrameBgDownInit.origin.y = CGRectGetMaxY(rectFrameBgMidInit);
    rectFrameBgDownInit.size.width = rectFrameBgMidInit.size.width;
    rectFrameBgDownInit.size.height = self.view.frame.size.height - rectFrameBgDownInit.origin.y;
    rectFrameBgDownInit.size.height = rectFrameBgDownInit.size.height < 0.0 ? 0.0 : rectFrameBgDownInit.size.height;
    
    CGRect rectFrameBgDownShow = CGRectZero;
    rectFrameBgDownShow.origin.x = rectFrameBgMidShow.origin.x;
    rectFrameBgDownShow.origin.y = CGRectGetMaxY(rectFrameBgMidShow);
    rectFrameBgDownShow.size.width = rectFrameBgMidShow.size.width;
    rectFrameBgDownShow.size.height = self.view.frame.size.height - rectFrameBgDownShow.origin.y;
    rectFrameBgDownShow.size.height = rectFrameBgDownShow.size.height < 0.0 ? 0.0 : rectFrameBgDownShow.size.height;
    
    CGRect rectFrameBgDownFinished = CGRectZero;
    rectFrameBgDownFinished.origin.x = rectFrameBgMidFinished.origin.x;
    rectFrameBgDownFinished.origin.y = CGRectGetMaxY(rectFrameBgMidFinished);
    rectFrameBgDownFinished.size.width = rectFrameBgMidFinished.size.width;
    rectFrameBgDownFinished.size.height = self.view.frame.size.height - rectFrameBgDownFinished.origin.y;
    rectFrameBgDownFinished.size.height = rectFrameBgDownFinished.size.height < 0.0 ? 0.0 : rectFrameBgDownInit.size.height;
    
    
    //for cover animations
    CGRect rectQRCodeAnimationBg = self.view.frame;
    rectQRCodeAnimationBg.origin = CGPointZero;
    UIImageView* qrcodeAnimationView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/qrcode/qr_code_animate_code"]] autorelease];
    UIImageView* qrcodeAnimationCoverView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/qrcode/qr_code_animate_cover"]] autorelease];
    UIView* qrcodeAnimationBgView = [[UIView alloc] initWithFrame:rectQRCodeAnimationBg];
    qrcodeAnimationBgView.backgroundColor = _bottomGreenView.backgroundColor;
    
    [self.view insertSubview:qrcodeAnimationBgView belowSubview:_bottomGreenView];
    [self.view insertSubview:qrcodeAnimationView belowSubview:_frameImageView];
    [self.view insertSubview:qrcodeAnimationCoverView aboveSubview:_frameImageView];
    
    CGRect rectQRCodeAnimationStart = rectFrameFinished;
    rectQRCodeAnimationStart.origin.x = self.view.frame.size.width;
    CGRect rectQRCodeAnimationStay = rectFrameFinished;
    CGRect rectQRCodeAnimationFinished = rectFrameFinished;
    rectQRCodeAnimationFinished.origin.x -= rectFrameFinished.size.width;
    
    CGRect rectQRCodeAnimationCoverStart = rectFrameFinished;
    rectQRCodeAnimationCoverStart.origin.y += 20;
    CGRect rectQRCodeAnimationCoverFinished = rectFrameFinished;
    
    void (^initViews)() = ^(){
        
        if (callStart)
        {
            callStart();
        }
        
        _torchButton.hidden = NO;
        _backButton.hidden = NO;
        _frameImageView.hidden = NO;
        _frameBackgroundView.hidden = NO;
        _frameBackgroundUpFillView.hidden = NO;
        _frameBackgroundDownFillView.hidden = NO;
        
        _torchButton.frame = rectTorchInit;
        _backButton.frame = rectBackInit;
        _frameImageView.frame = rectFrameInit;
        _frameBackgroundView.frame = rectFrameBgMidInit;
        _frameBackgroundUpFillView.frame = rectFrameBgUpInit;
        _frameBackgroundDownFillView.frame = rectFrameBgDownInit;
        
        qrcodeAnimationView.frame = rectQRCodeAnimationStart;
        qrcodeAnimationCoverView.frame = rectQRCodeAnimationCoverStart;
        
        _frameBackgroundView.alpha = 0.0;
        _frameBackgroundUpFillView.alpha = 0.0;
        _frameBackgroundDownFillView.alpha = 0.0;
        
        qrcodeAnimationCoverView.alpha = 0.0;
    };
    
    void (^showViews)() = ^(){
        
        _torchButton.frame = rectTorchShow;
        _backButton.frame = rectBackShow;
    };
    
    void (^bounceViews)() = ^(){
        _torchButton.frame = rectTorchFinished;
        _backButton.frame = rectBackFinished;
    };
    
    void (^showQRCodeAnimation)() = ^(){
        qrcodeAnimationView.frame = rectQRCodeAnimationStay;
    };
    
    void (^showFrame)() = ^(){
        _frameImageView.frame = rectFrameFinished;
        _frameBackgroundView.frame = rectFrameBgMidFinished;
        _frameBackgroundUpFillView.frame = rectFrameBgUpFinished;
        _frameBackgroundDownFillView.frame = rectFrameBgDownFinished;
    };
    
    void (^preShowQRCodeCoverAnimation)() = ^(){
        qrcodeAnimationCoverView.alpha = 1.0;
        [_tipsView showTips:LString(@"Place a barcode inside the rectangle") over:self.view autoCaculateLastTime:YES];
    };
    
    void (^showQRCodeCoverAnimation)() = ^(){
        qrcodeAnimationCoverView.frame = rectQRCodeAnimationCoverFinished;
    };
    
    void (^hideQRCodeAnimation)() = ^(){
        qrcodeAnimationCoverView.alpha = 0.0;
        qrcodeAnimationView.frame = rectQRCodeAnimationFinished;
    };
    
    void (^endAnimation)() = ^(){
        qrcodeAnimationBgView.alpha = 0.0;
        _frameBackgroundView.alpha = 1.0;
        _frameBackgroundUpFillView.alpha = 1.0;
        _frameBackgroundDownFillView.alpha = 1.0;
    };
    
    void (^onFinished)() = ^(){
        
        //[_backButton reactiveAlphaAnimations];
        //[_torchButton reactiveAlphaAnimations];
        
        if (callShowed)
        {
            callShowed();
        }
    };
    
    void (^onRemoveQRCodeAnimation)() = ^(){
        _torchButton.button.hidden = NO;
        _backButton.button.hidden = NO;
        [qrcodeAnimationBgView removeFromSuperview];
        [qrcodeAnimationCoverView removeFromSuperview];
        [qrcodeAnimationView removeFromSuperview];
    };
    
    initViews();
    
    if (animated)
    {
        [UIView animateWithDuration:0.2 animations:showViews completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 animations:bounceViews completion:^(BOOL finished){
                [UIView animateWithDuration:0.2 animations:showQRCodeAnimation completion:^(BOOL finished){
                    [UIView animateWithDuration:0.3 animations:showFrame completion:^(BOOL finished){
                        preShowQRCodeCoverAnimation();
                        [UIView animateWithDuration:0.2 animations:showQRCodeCoverAnimation completion:^(BOOL finished){
                            [UIView animateWithDuration:0.3 animations:hideQRCodeAnimation completion:^(BOOL finished){
                                onFinished();
                                [UIView animateWithDuration:0.3 animations:endAnimation completion:^(BOOL finished){
                                    onRemoveQRCodeAnimation();
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }
    else
    {
        showViews();
        bounceViews();
        showQRCodeAnimation();
        showFrame();
        preShowQRCodeCoverAnimation();
        showQRCodeCoverAnimation();
        hideQRCodeAnimation();
        onFinished();
        endAnimation();
        onRemoveQRCodeAnimation();
    }
}

- (void)hideSubViews:(BOOL)animated finishBlock:(void (^)(void))callHidded withLoadingPreloaddingImage:(BOOL)preLoadingImage
{
    CGRect rectView = self.view.frame;
    
    CGRect rectTorchInit = _torchButton.frame;
    rectTorchInit.origin.x = 0;
    rectTorchInit.origin.y = 0 - rectTorchInit.size.height;
    
    CGRect rectBackInit = _backButton.frame;
    rectBackInit.origin.x = 126;
    rectBackInit.origin.y = rectView.size.height;
   
    CGRect rectFrameInit = _frameImageView.frame;
    rectFrameInit.origin.x = 0;
    rectFrameInit.origin.y = rectView.size.height;
   
    CGRect rectFrameBgMidInit = rectFrameInit;
    
    CGRect rectFrameBgUpInit = CGRectZero;
    rectFrameBgUpInit.size.width = rectFrameBgMidInit.size.width;
    rectFrameBgUpInit.size.height = rectFrameBgMidInit.origin.y;
   
    CGRect rectFrameBgDownInit = CGRectZero;
    rectFrameBgDownInit.origin.x = rectFrameBgMidInit.origin.x;
    rectFrameBgDownInit.origin.y = CGRectGetMaxY(rectFrameBgMidInit);
    rectFrameBgDownInit.size.width = rectFrameBgMidInit.size.width;
    rectFrameBgDownInit.size.height = self.view.frame.size.height - rectFrameBgDownInit.origin.y;
    rectFrameBgDownInit.size.height = rectFrameBgDownInit.size.height < 0.0 ? 0.0 : rectFrameBgDownInit.size.height;
    
    UIImageView* preLoadingView = nil;
    
    if (preLoadingImage)
    {
        preLoadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
        CGRect rectPreLoading = CGRectZero;
        rectPreLoading.size = preLoadingView.image.size;
        preLoadingView.frame = rectPreLoading;
        preLoadingView.alpha = 0.0;
        [self.view insertSubview:preLoadingView aboveSubview:_bottomGreenView];
    }
 
    void (^hideViews)() = ^(){
        _torchButton.frame = rectTorchInit;
        _backButton.frame = rectBackInit;
        _frameImageView.frame = rectFrameInit;
        _frameBackgroundView.frame = rectFrameBgMidInit;
        _frameBackgroundUpFillView.frame = rectFrameBgUpInit;
        _frameBackgroundDownFillView.frame = rectFrameBgDownInit;
        
        _frameBackgroundView.alpha = 0.0;
        _frameBackgroundUpFillView.alpha = 0.0;
        _frameBackgroundDownFillView.alpha = 0.0;
        
        if (preLoadingImage)
        {
            preLoadingView.alpha = 1.0;
        }
    };
    
    void (^onFinished)() = ^(){
        _torchButton.hidden = YES;
        _backButton.hidden = YES;
        _frameImageView.hidden = YES;
        _frameBackgroundView.hidden = YES;
        _frameBackgroundUpFillView.hidden = YES;
        _frameBackgroundDownFillView.hidden = YES;
        _torchButton.button.hidden = YES;
        _backButton.button.hidden = YES;
        
        if (preLoadingImage)
        {
            [preLoadingView removeFromSuperview];
            [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController.view addSubview:preLoadingView];
        }
        
        if (callHidded)
        {
            callHidded();
        }
        
        if (preLoadingImage)
        {
            [preLoadingView removeFromSuperview];
            [preLoadingView release];
        }
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.2
                         animations:hideViews
                         completion:^(BOOL finished){
                             onFinished();
                         }];
    }
    else
    {
        hideViews();
        onFinished();
    }
}

#pragma mark <ZXingDelegate>

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)resultString
{
    NSString* check = nil;
    
    {
        //notify sound
        NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/Resource/Sound/beep-beep.caf"];
        [[AudioUtility sharedInstance] playFile:filePath withDelegate:nil];
    }
    
    //Email First
    if (check == nil || [check length] == 0)
    {
        check = [BaseUtilitiesFuncions getFirstEmailSubString:resultString];
        if (check && [check length] > 0)
        {
            _scanResultType = kQRRT_Email;
        }
    }
    
    //Url
    if (check == nil || [check length] == 0)
    {
        check = [BaseUtilitiesFuncions getFirstUrlSubString:resultString];
        if (check && [check length] > 0)
        {
            _scanResultType = kQRRT_Url;
        }
    }
    
    //Other
    if (check == nil || [check length] == 0)
    {
        _scanResultType = kQRRT_NormalText;
    }
    
    
    switch (_scanResultType)
    {
        case kQRRT_Url:
            [MessageBoxView showWithNoButtonForTitle:LString(@"Got URL")
                                             content:resultString
                                        withDelegate:self
                                  andTextButtonTexts:LString(@"Open URL"),LString(@"Copy To Clipboard"),nil];
            break;
            
        case kQRRT_Email:
            [MessageBoxView showWithNoButtonForTitle:LString(@"Got E-Mail")
                                             content:resultString
                                        withDelegate:self
                                  andTextButtonTexts:LString(@"Send Mail"),LString(@"Copy To Clipboard"),nil];
            break;
            
        case kQRRT_NormalText:
            [MessageBoxView showWithNoButtonForTitle:LString(@"Got Text")
                                             content:resultString
                                        withDelegate:self
                                  andTextButtonTexts:LString(@"Copy To Clipboard"),nil];
            break;
            
        default:
            break;
    }
    
    /*
    switch (_scanResultType)
    {
        case kQRRT_Url:
            [MessageBoxView showWithOnlyTextButtonForTitle:LString(@"Got URL")
                                                   content:resultString
                                              withDelegate:self
                                        andTextButtonTexts:LString(@"Open URL"),LString(@"Copy To Clipboard"),LString(@"Cancel"),nil];
            break;
        
        case kQRRT_Email:
            [MessageBoxView showWithOnlyTextButtonForTitle:LString(@"Got E-Mail")
                                                   content:resultString
                                              withDelegate:self
                                        andTextButtonTexts:LString(@"Send Mail"),LString(@"Copy To Clipboard"),LString(@"Cancel"),nil];
            break;
            
        case kQRRT_NormalText:
            [MessageBoxView showWithOnlyTextButtonForTitle:LString(@"Got Text")
                                                   content:resultString
                                              withDelegate:self
                                        andTextButtonTexts:LString(@"Copy To Clipboard"),LString(@"Cancel"),nil];
            break;
            
        default:
            break;
    }
    */
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    
}

#pragma mark <BaseMessageBoxViewDelegate>

- (void)onYesButtonPressedForMessageBox:(BaseMessageBoxView*)messageBox
{
    [messageBox hide];
    self.decodingSwitch = YES;
}

- (void)onNoButtonPressedForMessageBox:(BaseMessageBoxView*)messageBox
{
    [messageBox hide];
    self.decodingSwitch = YES;
}

- (void)onTextButtonPressedAt:(int)index
                forMessageBox:(BaseMessageBoxView*)messageBox
{
    NSString* resultString = messageBox.content;
    NSString* check = nil;
    switch (_scanResultType)
    {
        case kQRRT_Url:
            check = [BaseUtilitiesFuncions getFirstUrlSubString:resultString];
            break;
        case kQRRT_Email:
            check = [BaseUtilitiesFuncions getFirstEmailSubString:resultString];
            break;
        case kQRRT_NormalText:
            check = resultString;
            break;
        default:
            break;
    }
    
    BOOL clipBoardPasted = NO;
    
    switch (index)
    {
        case 0:
            switch (_scanResultType)
            {
                case kQRRT_Url:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:check]];
                    break;
                case kQRRT_Email:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"mailto://",check]]];
                    break;
                case kQRRT_NormalText:
                    [UIPasteboard generalPasteboard].string = resultString;
                    clipBoardPasted = YES;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            
            switch (_scanResultType)
            {
                case kQRRT_Url:
                case kQRRT_Email:
                    [UIPasteboard generalPasteboard].string = resultString;
                    clipBoardPasted = YES;
                    break;
                case kQRRT_NormalText:
                    [messageBox hide];
                    self.decodingSwitch = YES;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            [messageBox hide];
            self.decodingSwitch = YES;
            break;
            
        default:
            break;
    }
    
    if (clipBoardPasted)
    {
        [_tipsView showOverWindowTips:LString(@"Copy Succeed!")];
    }
    
}


#pragma mark Button Events

- (void)onPressedTorch:(id)sender
{
    //[captureSession stopRunning];
    if ([self torchIsOn])
    {
        [self setTorch:NO];
        _torchButton.buttonEnabled = NO;
    }
    else
    {
        [self setTorch:YES];
        _torchButton.buttonEnabled = YES;
    }
    //[captureSession startRunning];
}

- (void)onPressedBack:(id)sender
{
    [self hideControlsWithAnimationAndCallCamera];
}

#pragma mark Public Methods

- (void)showControlsWithAnimationAndReleaseController:(UIViewController*)caller
{
    _ctrlToReleaseAfterShowed = caller;
    _shouldShowAfterAppear = YES;
}

- (void)hideControlsWithAnimationAndCallCamera
{
    [self hideSubViews:YES finishBlock:^(){
        [self stopCapture];
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController removeQRCodeScanner];
        //[((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController showCameraAndShowSubviews];
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController showCamera];
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController PrepareLoadingAnimation];
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController ShowLoadingAnimation];
    } withLoadingPreloaddingImage:YES];
}

@end
