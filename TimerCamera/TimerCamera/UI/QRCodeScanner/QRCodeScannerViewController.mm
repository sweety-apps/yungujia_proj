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
