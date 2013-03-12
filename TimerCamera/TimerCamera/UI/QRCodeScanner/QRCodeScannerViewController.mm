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
    [self.view addSubview:_frameBackgroundView];
    
    UIColor* _frameBgColor = [BaseUtilitiesFuncions getColorFromImage:_frameBackgroundView.image atPoint:CGPointMake(4,4)];
    
    _frameBackgroundUpFillView = [[UIView alloc] initWithFrame:CGRectZero];
    _frameBackgroundUpFillView.backgroundColor = _frameBgColor;
    
    _frameBackgroundDownFillView = [[UIView alloc] initWithFrame:CGRectZero];
    _frameBackgroundDownFillView.backgroundColor = _frameBgColor;
    
    _bottomGreenView = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomGreenView.backgroundColor = kBGColor();
    
    _frameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/qrcode/qr_code_frame"]];
    [self.view addSubview:_frameImageView];
    
    _backButton = [[ShotButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_empty_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_empty_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_empty_pressed"]
                    forEnabledImage1:nil
                    forEnabledImage2:nil
                    forIcon:nil] retain];
    [_backButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_camera"]];
    [_backButton setLabelString:@""];
    [self.view addSubview:_backButton];
    
    _torchButton = [[CommonAnimationButton
                     buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_disable1"]
                     forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_disable2"]
                     forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/torch_pressed"]
                     forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable1"]
                     forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable2"]] retain];
    [self.view addSubview:_torchButton];
    
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
    
    //hide subViews
    [self hideSubViews:NO];
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

- (void)showSubViews:(BOOL)animated
{
#define BOUNCE_OFFSET (3)
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
    rectBackShow.origin.y -= rectTorchInit.size.height + BOUNCE_OFFSET;
    
    CGRect rectBackFinished = rectBackShow;
    rectBackFinished.origin.y += BOUNCE_OFFSET;
    
    CGRect rectFrameInit = _frameImageView.frame;
    rectFrameInit.origin.x = 0;
    rectFrameInit.origin.y = rectView.size.height;
    
    CGRect rectFrameShow = rectFrameInit;
    rectFrameShow.origin.y = 86 - BOUNCE_OFFSET;
    
    CGRect rectFrameFinished = rectFrameShow;
    rectFrameFinished.origin.y += BOUNCE_OFFSET;
    
    CGRect rectFrameBgMidInit = _torchButton.frame;
    rectFrameBgMidInit.origin.x = 0;
    rectFrameBgMidInit.origin.y = 0 - rectTorchInit.size.height;
    
    CGRect rectFrameBgMidShow = _torchButton.frame;
    rectFrameBgMidShow.origin.x = 0;
    rectFrameBgMidShow.origin.y = 0 + BOUNCE_OFFSET;
    
    CGRect rectFrameBgMidFinished = _torchButton.frame;
    rectFrameBgMidFinished.origin.x = 0;
    rectFrameBgMidFinished.origin.y = 0;
    
    CGRect rectFrameBgUpInit = _torchButton.frame;
    rectFrameBgUpInit.origin.x = 0;
    rectFrameBgUpInit.origin.y = 0 - rectTorchInit.size.height;
    
    CGRect rectFrameBgUpShow = _torchButton.frame;
    rectFrameBgUpShow.origin.x = 0;
    rectFrameBgUpShow.origin.y = 0 + BOUNCE_OFFSET;
    
    CGRect rectFrameBgUpFinished = _torchButton.frame;
    rectFrameBgUpFinished.origin.x = 0;
    rectFrameBgUpFinished.origin.y = 0;
    
    CGRect rectFrameBgDownInit = _torchButton.frame;
    rectFrameBgDownInit.origin.x = 0;
    rectFrameBgDownInit.origin.y = 0 - rectTorchInit.size.height;
    
    CGRect rectFrameBgDownShow = _torchButton.frame;
    rectFrameBgDownShow.origin.x = 0;
    rectFrameBgDownShow.origin.y = 0 + BOUNCE_OFFSET;
    
    CGRect rectFrameBgDownFinished = _torchButton.frame;
    rectFrameBgDownFinished.origin.x = 0;
    rectFrameBgDownFinished.origin.y = 0;
    
    void (^initViews)() = ^(){
        
    };
    
    void (^showViews)() = ^(){
        
    };
    
    void (^bounceViews)() = ^(){
        
    };
    
    void (^onFinished)() = ^(){
        
    };
    
    if (animated)
    {
        
    }
    else
    {
        initViews();
        showViews();
        bounceViews();
        onFinished();
    }
}

- (void)hideSubViews:(BOOL)animated
{
    void (^hideViews)() = ^(){
        
    };
    
    void (^onFinished)() = ^(){
        
    };
    
    if (animated)
    {
        
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
    
}

@end
