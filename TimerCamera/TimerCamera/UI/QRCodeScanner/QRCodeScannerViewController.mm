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
        
        self.soundToPlay = [NSURL fileURLWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/Resource/Sound/sms-beep-beep.caf"] isDirectory:NO];
        
        _resultIsURL = NO;
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
    };
    
    if (_shouldShowAfterAppear)
    {
        [self showSubViews:animated finishBlock:removeCallerController];
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
    
    //hide subViews
    [self hideSubViews:NO finishBlock:nil];
    
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

- (void)showSubViews:(BOOL)animated finishBlock:(void (^)(void))callShowed
{
    //add subviews
    [_frameBackgroundUpFillView removeFromSuperview];
    [_frameBackgroundDownFillView removeFromSuperview];
    [_bottomGreenView removeFromSuperview];
    [_frameBackgroundView removeFromSuperview];
    [_frameImageView removeFromSuperview];
    [_torchButton removeFromSuperview];
    [_backButton removeFromSuperview];
    
    [self.view addSubview:_frameBackgroundUpFillView];
    [self.view addSubview:_frameBackgroundDownFillView];
    [self.view addSubview:_frameBackgroundView];
    [self.view addSubview:_bottomGreenView];
    [self.view addSubview:_frameImageView];
    [self.view addSubview:_torchButton];
    [self.view addSubview:_backButton];
    
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
    
    void (^initViews)() = ^(){
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
        
        _frameBackgroundView.alpha = 0.0;
        _frameBackgroundUpFillView.alpha = 0.0;
        _frameBackgroundDownFillView.alpha = 0.0;
    };
    
    void (^showViews)() = ^(){
        
        _torchButton.frame = rectTorchShow;
        _backButton.frame = rectBackShow;
        
        _frameBackgroundView.alpha = 0.5;
        _frameBackgroundUpFillView.alpha = 0.5;
        _frameBackgroundDownFillView.alpha = 0.5;
    };
    
    void (^bounceViews)() = ^(){
        
        _torchButton.frame = rectTorchFinished;
        _backButton.frame = rectBackFinished;
        
        _frameImageView.frame = rectFrameFinished;
        _frameBackgroundView.frame = rectFrameBgMidFinished;
        _frameBackgroundUpFillView.frame = rectFrameBgUpFinished;
        _frameBackgroundDownFillView.frame = rectFrameBgDownFinished;
        
        _frameBackgroundView.alpha = 1.0;
        _frameBackgroundUpFillView.alpha = 1.0;
        _frameBackgroundDownFillView.alpha = 1.0;
    };
    
    void (^onFinished)() = ^(){
        if (callShowed)
        {
            callShowed();
        }
    };
    
    initViews();
    
    if (animated)
    {
        [UIView animateWithDuration:0.2
                         animations:showViews
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.15
                                              animations:bounceViews
                                              completion:^(BOOL finished){
                                                  onFinished();
                                              }];
                         }];
    }
    else
    {
        showViews();
        bounceViews();
        onFinished();
    }
}

- (void)hideSubViews:(BOOL)animated finishBlock:(void (^)(void))callHidded
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
    };
    
    void (^onFinished)() = ^(){
        _torchButton.hidden = YES;
        _backButton.hidden = YES;
        _frameImageView.hidden = YES;
        _frameBackgroundView.hidden = YES;
        _frameBackgroundUpFillView.hidden = YES;
        _frameBackgroundDownFillView.hidden = YES;
        
        if (callHidded)
        {
            callHidded();
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

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result
{
    _resultIsURL = YES;
    [MessageBoxView showWithYesButtonForTitle:LString(@"Got Code")
                                      content:result
                                 withDelegate:self
                           andTextButtonTexts:LString(@"Copy To Clipboard"),LString(@"Open URL"),LString(@"Cancel"),nil];
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
{
    
}

#pragma mark <BaseMessageBoxViewDelegate>

- (void)onYesButtonPressedForMessageBox:(BaseMessageBoxView*)messageBox
{
    
}

- (void)onNoButtonPressedForMessageBox:(BaseMessageBoxView*)messageBox
{
    
}

- (void)onTextButtonPressedAt:(int)index
                forMessageBox:(BaseMessageBoxView*)messageBox
{
    if (_resultIsURL)
    {
        switch (index)
        {
            case 0:
                //
                break;
            case 1:
                //
                break;
            case 2:
                [messageBox hide];
                break;
                
            default:
                break;
        }
    }
    else
    {
        
    }
}


#pragma mark Button Events

- (void)onPressedTorch:(id)sender
{
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
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController removeQRCodeScanner];
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController showCameraAndShowSubviews];
    }];
}

@end
