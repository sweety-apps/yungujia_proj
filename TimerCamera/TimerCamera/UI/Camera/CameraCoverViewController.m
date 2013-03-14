//
//  CameraCoverViewController.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-24.
//
//

#import "AppDelegate.h"
#import "CameraCoverViewController.h"
#import "CameraOptions.h"

#define VOLUME_INIT_VAL (0.1)
#define kAlbumSlideOffsetPercent (0.35)

#define ALBUM_PUNCH_TRIGER_STEP (3)

#pragma mark - ButtonAnimationStateRecorders

static CommonAnimationButtonAnimationRecorder* gShotButtonRecorder = nil;
static CommonAnimationButtonAnimationRecorder* gTimerButtonRecorder = nil;
static CommonAnimationButtonAnimationRecorder*  gVolMonitorBarRecorder = nil;
static CommonAnimationButtonAnimationRecorder* gConfigButtonRecorder = nil;
static CommonAnimationButtonAnimationRecorder* gTorchButtonRecorder = nil;
static CommonAnimationButtonAnimationRecorder* gFrontButtonRecorder = nil;
static CommonAnimationButtonAnimationRecorder* gAlbumButtonRecorder = nil;

#define CREATE_BUTTON_RECORDER(x) if((x) == nil){(x) = [[CommonAnimationButtonAnimationRecorder alloc] init];}

static int gAlbumPunchedTriger = 0;

#pragma mark - CameraCoverViewController

@interface CameraCoverViewController ()

@end

@implementation CameraCoverViewController

- (id)init
{
    self = [super init];
    if (self) {
        _autoShowSubViews = NO;
        _autoShowSubViewsWithAnimation = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _autoShowSubViews = NO;
        _autoShowSubViewsWithAnimation = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_autoShowSubViews)
    {
        [self showSubViews:_autoShowSubViewsWithAnimation];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    {
        CREATE_BUTTON_RECORDER(gShotButtonRecorder);
        CREATE_BUTTON_RECORDER(gTimerButtonRecorder);
        CREATE_BUTTON_RECORDER(gVolMonitorBarRecorder);
        CREATE_BUTTON_RECORDER(gConfigButtonRecorder);
        CREATE_BUTTON_RECORDER(gTorchButtonRecorder);
        CREATE_BUTTON_RECORDER(gFrontButtonRecorder);
        CREATE_BUTTON_RECORDER(gAlbumButtonRecorder);
    }
    [self createSubViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self destorySubViews];
    [super viewDidUnload];
}

- (void)dealloc
{
    [self destorySubViews];
    [super dealloc];
}

#pragma mark - Animation Views

- (void)setAutoShowSubViews:(BOOL)autoShow withAnimation:(BOOL)animated
{
    _autoShowSubViews = autoShow;
    _autoShowSubViewsWithAnimation = animated;
}

- (void)showSubViews:(BOOL)animated delayed:(float)seconds
{
#define BOUNCE_OFFSET (3)
    [self hideSubViews:NO];
    _animationCatButton.hidden = NO;
    _shotButton.hidden = NO;
    _timerButton.hidden = NO;
    _configButton.hidden = NO;
    _torchButton.hidden = NO;
    _frontButton.hidden = NO;
    _volMonitor.hidden = NO;
    _albumButton.hidden = NO;
    _QRCodeButton.hidden = NO;
    [self hideOrShowButtons];
    
    void (^doMoveSubViews)(void) = ^(void){
        CGRect rect = CGRectZero;
        
        ////
        rect = _animationCatButton.frame;
        rect.origin.y -= rect.size.height + BOUNCE_OFFSET;
        _animationCatButton.frame = rect;
        
        ////
        rect = _shotButton.frame;
        rect.origin.y -= rect.size.height + BOUNCE_OFFSET;
        _shotButton.frame = rect;
        
        ////
        rect = _timerButton.frame;
        rect.origin.x += rect.size.width + BOUNCE_OFFSET;
        _timerButton.frame = rect;
        
        
        ////
        rect = _configButton.frame;
        rect.origin.x += rect.size.width + BOUNCE_OFFSET;
        _configButton.frame = rect;
        
        
        ////
        rect = _torchButton.frame;
        rect.origin.y += rect.size.height + BOUNCE_OFFSET;
        _torchButton.frame = rect;
        
        
        ////
        rect = _frontButton.frame;
        rect.origin.y += rect.size.height + BOUNCE_OFFSET;
        _frontButton.frame = rect;
        
        ////
        rect = _volMonitor.frame;
        rect.origin.x -= rect.size.width + BOUNCE_OFFSET;
        _volMonitor.frame = rect;
        
        ////
        rect = _albumButton.frame;
        rect.origin.x -= rect.size.width + BOUNCE_OFFSET;
        _albumButton.frame = rect;
        
        
        ////
        rect = _QRCodeButton.frame;
        rect.origin.y -= rect.size.height + BOUNCE_OFFSET;
        _QRCodeButton.frame = rect;
        
    };
    
    void (^doSetSubViewFramesAndBounce)(void) = ^(void){
        CGRect rect = CGRectZero;
        
        ////
        rect = _animationCatButton.frame;
        rect.origin.y -= 0 - BOUNCE_OFFSET;
        _animationCatButton.frame = rect;
        
        ////
        rect = _shotButton.frame;
        rect.origin.y -= 0 - BOUNCE_OFFSET;
        _shotButton.frame = rect;
        
        
        ////
        rect = _timerButton.frame;
        rect.origin.x += 0 - BOUNCE_OFFSET;
        _timerButton.frame = rect;
        
        
        ////
        rect = _configButton.frame;
        rect.origin.x += 0 - BOUNCE_OFFSET;
        _configButton.frame = rect;
        
        
        ////
        rect = _torchButton.frame;
        rect.origin.y += 0 - BOUNCE_OFFSET;
        _torchButton.frame = rect;
        
        ////
        rect = _frontButton.frame;
        rect.origin.y += 0 - BOUNCE_OFFSET;
        _frontButton.frame = rect;
        
        ////
        rect = _volMonitor.frame;
        rect.origin.x -= 0 - BOUNCE_OFFSET;
        _volMonitor.frame = rect;
        
        ////
        rect = _albumButton.frame;
        rect.origin.x -= 0 - BOUNCE_OFFSET;
        _albumButton.frame = rect;
        _albumRawRect = rect;
        
        
        ////
        rect = _QRCodeButton.frame;
        rect.origin.y -= 0 - BOUNCE_OFFSET;
        _QRCodeButton.frame = rect;
    };
    
    void (^setAlbumSlideTracker)() = ^(){
        [AlbumViewController startTrackTouchSlideForView:self.view
                                               startRect:_albumButton.frame
                                              acceptRect:CGRectMake(0, 0, self.view.frame.size.width * (1.0 - kAlbumSlideOffsetPercent), self.view.frame.size.height)
                                      onSlideBeginTarget:self
                                         onSlideBeginSel:@selector(onBeginSlideAlbum)
                                  onSlideCancelledTarget:self
                                     onSlideCancelledSel:@selector(onCancelledSlideAlbum)
                                      onWillAcceptTarget:self
                                         onWillAcceptSel:@selector(onWillAcceptSlideAlbum)
                                     onAcceptTrackTarget:self
                                        onAcceptTrackSel:@selector(onAcceptSlideAlbum)];
    };
    
    void (^setSubViewDone)(void) = ^(void){
        _configButton.enableRotation = YES;
        setAlbumSlideTracker();
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.4
                              delay:seconds
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:doMoveSubViews
                         completion:^(BOOL finished)
         {
             //doSetSubViewFramesAndBounce();
             [UIView animateWithDuration:0.15
                              animations:doSetSubViewFramesAndBounce
                              completion:^(BOOL finished){
                                  setSubViewDone();
                              }];
         }];
    }
    else
    {
        if (seconds > 0.0f)
        {
            [UIView animateWithDuration:0.0
                                  delay:seconds
                                options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionNone
                             animations:^(){
                                 //Do nothing
                             }
                             completion:^(BOOL finished)
             {
                 doMoveSubViews();
                 doSetSubViewFramesAndBounce();
                 setSubViewDone();
             }];
        }
        else
        {
            doMoveSubViews();
            doSetSubViewFramesAndBounce();
            setSubViewDone();
        }
    }
}

- (void)showSubViews:(BOOL)animated
{
    [self showSubViews:animated delayed:0.0f];
}

- (void)hideSubViews:(BOOL)animated
{
    void (^doMoveOutSubViews)(void) = ^(void){
        CGRect rect = CGRectZero;
        
        ////
        rect = _animationCatButton.frame;
        rect.origin.x = 78;
        rect.origin.y = self.view.frame.size.height - 60;
        rect.origin.y += rect.size.height;
        _animationCatButton.frame = rect;
        
        ////
        rect = _shotButton.frame;
        rect.origin.x = 126;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        rect.origin.y += rect.size.height;
        _shotButton.frame = rect;
        
        ////
        rect = _timerButton.frame;
        rect.origin.x = 0;
        rect.origin.y = self.view.frame.size.height - rect.size.height;
        rect.origin.x -= rect.size.width;
        _timerButton.frame = rect;
        
        
        ////
        rect = _configButton.frame;
        rect.origin.x = -15;
        rect.origin.y = 82;
        rect.origin.x -= rect.size.width;
        _configButton.frame = rect;
        
        
        ////
        rect = _torchButton.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.origin.y -= rect.size.height;
        _torchButton.frame = rect;
        
        
        ////
        rect = _frontButton.frame;
        rect.origin.x = self.view.frame.size.width - rect.size.width;
        rect.origin.y = 0;
        rect.origin.y -= rect.size.height;
        _frontButton.frame = rect;
        
        
        ////
        rect = _volMonitor.frame;
        rect.origin.x = self.view.frame.size.width;
        rect.origin.y = self.view.frame.size.height - _shotButton.frame.size.height - rect.size.height;
        _volMonitor.frame = rect;
        
        
        ////
        rect = _albumButton.frame;
        rect.origin.x = self.view.frame.size.width + 51;
        rect.origin.y = _volMonitor.frame.origin.y - rect.size.height - 40;
        _albumButton.frame = rect;
        
        
        ////
        rect = _QRCodeButton.frame;
        rect.origin.x = 215;
        rect.origin.y = self.view.frame.size.height;
        _QRCodeButton.frame = rect;
        
        
        ////
        rect = _countView.frame;
        rect.origin.x = self.view.frame.size.width - rect.size.width - 1;
        rect.origin.y = self.view.frame.size.height - 161;
        _countView.frame = rect;
    };
    
    void (^doHideSubViews)(BOOL) = ^(BOOL finished){
        _animationCatButton.hidden = YES;
        _shotButton.hidden = YES;
        _timerButton.hidden = YES;
        _configButton.hidden = YES;
        _torchButton.hidden = YES;
        _frontButton.hidden = YES;
        _volMonitor.hidden = YES;
        _albumButton.hidden = YES;
        _QRCodeButton.hidden = YES;
        _configButton.enableRotation = NO;
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.7 animations:doMoveOutSubViews completion:doHideSubViews];
    }
    else
    {
        doMoveOutSubViews();
        doHideSubViews(YES);
    }
}

#pragma mark Views' Lifecycle

- (void)createSubViews
{
    _focusView = [FocusAimer focusAimerWithFocusImage:[UIImage imageNamed:@"/Resource/Picture/main/focus_camera_point_normal2"]
                                       andAimingImage:[UIImage imageNamed:@"/Resource/Picture/main/focus_camera_point_normal1"]];
    
    [self.view addSubview:_focusView];
    
    _countView = [CountView countViewWithBgImage:[UIImage imageNamed:@"/Resource/Picture/main/timer_count_bg"]];
    
    [self.view addSubview:_countView];
    
    //Emitter Is Only supported higher than iOS 5.0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        _flipEmitterCover = [EmiterCoverView
                             emiterCoverViewWithElementImage:[UIImage imageNamed:@"/Resource/Picture/sprites/sprite_heart"]
                             andCoverColor:kBGColor()];
        
        [self.view addSubview:_flipEmitterCover];
    }
    
    _animationCatButton = [BlackCat
                           catWithCatImage:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_with_eye"]
                           forCatCloseEyeImage:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]
                           forEyeImage:[UIImage imageNamed:@"/Resource/Picture/main/eye"]];
    [self.view addSubview:_animationCatButton];
    
    
    _shotButton = [ShotButton
                   buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_empty_normal1"]
                   forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_empty_normal2"]
                   forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_empty_pressed"]
                   forEnabledImage1:nil
                   forEnabledImage2:nil
                   forIcon:nil];
    [_shotButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_camera"]];
    [_shotButton setLabelString:@""];
    [self.view addSubview:_shotButton];
    
    
    _timerButton = [TimerButton
                    timerButtonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_disable1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_disable2"]
                    forNormalPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_disable_pressed"]
                    forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_voice1"]
                    forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_voice2"]
                    forEnabledPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_voice_pressed"]
                    forExtendImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_timer1"]
                    forExtendImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_timer2"]
                    forExtendPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_timer_pressed"]];
    
    [_timerButton setHittedNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_hitten_disable1"]
                     hittedNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_hitten_disable2"]
               hittedNormalPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_hitten_disable_pressed"]];
    
    [self.view addSubview:_timerButton];
    
    
    _configButton = [ConfigButton
                     configButtonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal1"]
                     forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal2"]
                     forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_pressed"]];
    
    [self.view addSubview:_configButton];
    
    
    _torchButton = [CommonAnimationTripleStateButton
                    tripleButtonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_disable1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_disable2"]
                    forNormalPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/torch_pressed"]
                    forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_normal1"]
                    forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_normal2"]
                    forEnabledPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/torch_pressed"]
                    forExtendImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable1"]
                    forExtendImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable2"]
                    forExtendPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/torch_pressed"]];
    
    [self.view addSubview:_torchButton];
    
    
    _frontButton = [CommonAnimationButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/front_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/front_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/front_pressed"]
                    forEnabledImage1:nil
                    forEnabledImage2:nil];
    [self.view addSubview:_frontButton];
    

    CommonAnimationButton* bar = [CommonAnimationButton
                                  buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_normal1"]
                                  forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_normal2"]
                                  forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_pressed"]
                                  forEnabledImage1:nil
                                  forEnabledImage2:nil];
    
    /*
    CommonAnimationButton* stop = [CommonAnimationButton
                                   buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_stop_normal1"]
                                   forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_stop_normal2"]
                                   forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_stop_pressed"]
                                   forEnabledImage1:nil
                                   forEnabledImage2:nil];
     */
    
    _volMonitor = [VolumeMonitor monitorWithBarButton:bar
                                       withStopButton:nil
                                      backGroundImage:[UIImage imageNamed:@"/Resource/Picture/main/volume_bg"]
                                          volumeImage:[UIImage imageNamed:@"/Resource/Picture/main/fist"]
                                     reachedPeakImage:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_punched"]
                                    punchedPointImage:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_punched_point"]
                                           mouthImage:[UIImage imageNamed:@"/Resource/Picture/main/mouth"]];
    _volMonitor.minPeakVolume = 0.1;
    _volMonitor.peakVolume = 0.7;
    
    [self.view addSubview:_volMonitor];
    
    _albumButton = [CommonAnimationButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/album_small_open_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/album_small_open_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/album_small_open_pressed"]
                    forEnabledImage1:nil
                    forEnabledImage2:nil];
    
    [self.view addSubview:_albumButton];
    
    _QRCodeButton = [QRCodeButton
                     QRCodebuttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/QRCode_icon_normal"]
                     forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/QRCode_icon_red_face"]
                     forWaterImage:[UIImage imageNamed:@"/Resource/Picture/main/QRCode_icon_water"]
                     forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/QRCode_icon_pressed"]];
    
    [self.view addSubview:_QRCodeButton];
    
    _tipsView = [[TipsView tipsViewWithPushHand:[UIImage imageNamed:@"/Resource/Picture/main/tips_cat_hand"]
                                backGroundImage:[[UIImage imageNamed:@"/Resource/Picture/main/tips_fish_bg_strtechable"] stretchableImageWithLeftCapWidth:50 topCapHeight:28] ]
                 retain];
    
    //add recorders
    _timerButton.stateAnimationRecorder = gTimerButtonRecorder;
    _shotButton.stateAnimationRecorder = gShotButtonRecorder;
    _configButton.stateAnimationRecorder = gConfigButtonRecorder;
    _frontButton.stateAnimationRecorder = gFrontButtonRecorder;
    _torchButton.stateAnimationRecorder = gTorchButtonRecorder;
    _albumButton.stateAnimationRecorder = gAlbumButtonRecorder;
    bar.stateAnimationRecorder = gVolMonitorBarRecorder;
    
    //add events
    [_animationCatButton.button addTarget:self
                                   action:@selector(onPressedBlackCat:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [_timerButton.button addTarget:self
                            action:@selector(onPressedTimer:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [_shotButton.button addTarget:self
                           action:@selector(onPressedShot:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [_configButton.button addTarget:self
                            action:@selector(onConfigPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    
    [_frontButton.button addTarget:self
                            action:@selector(onFrontPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [_torchButton.button addTarget:self
                            action:@selector(onTorchPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    /*
    [_volMonitor.stopButton.button addTarget:self
                                      action:@selector(onStopTimerPressed:)
                            forControlEvents:UIControlEventTouchUpInside];
     */
    
    [_albumButton.button addTarget:self
                            action:@selector(onAlbumPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [_QRCodeButton.button addTarget:self
                             action:@selector(onQRCodePressed:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    
    [self resetStatus];
    
    [self hideSubViews:NO];
    [self hideOrShowButtons];
}

- (void)destorySubViews
{
    //remove event handlers
    [_shotButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    [_timerButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    [_configButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    [_torchButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    [_frontButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    [_animationCatButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    [_volMonitor.barButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    [_volMonitor.stopButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    [_albumButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    [_QRCodeButton.button removeTarget:self action:nil forControlEvents:UIControlEventAllTouchEvents];
    
    [_shotButton removeFromSuperview];
    _shotButton = nil;
    [_timerButton removeFromSuperview];
    _timerButton = nil;
    [_configButton removeFromSuperview];
    _configButton = nil;
    [_torchButton removeFromSuperview];
    _torchButton = nil;
    [_frontButton removeFromSuperview];
    _frontButton = nil;
    [_animationCatButton removeFromSuperview];
    _animationCatButton = nil;
    [_volMonitor removeFromSuperview];
    _volMonitor = nil;
    [_focusView removeFromSuperview];
    _focusView = nil;
    [_albumButton removeFromSuperview];
    _albumButton = nil;
    [_QRCodeButton removeFromSuperview];
    _QRCodeButton = nil;
    [_flipEmitterCover removeFromSuperview];
    _flipEmitterCover = nil;
    [_countView removeFromSuperview];
    _countView = nil;
    ReleaseAndNilView(_tipsView);
    
    [AlbumViewController removeAlbumPunchAnimation];
}

- (void)resetStatus
{
    [CameraOptions sharedInstance].light = AVCaptureTorchModeOff;
    [CameraOptions sharedInstance].flash = AVCaptureFlashModeOff;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [_torchButton setCurrentButtonState:kNormalButtonState];
    /*
    if ([CameraOptions sharedInstance].flash == AVCaptureFlashModeOn)
    {
        [_torchButton setCurrentButtonState:kEnableButtonState];
    }
    if ([CameraOptions sharedInstance].flash == AVCaptureFlashModeOff)
    {
        [_torchButton setCurrentButtonState:kNormalButtonState];
    }
     */
}

#pragma mark Event Handlers

- (void)onPressedBlackCat:(id)sender
{
    srand(time(NULL));
    int i = rand()%10;
    NSString* catTips = [NSString stringWithFormat:@"Black Cat %d",i];
    [_tipsView showTips:LString(catTips) over:self.view];
}

- (void)onPressedTimer:(id)sender
{
    if (_timerButton.currentButtonState == kNormalButtonState)
    {
        //[_volMonitor hideMonitor:NO];
        [_volMonitor showMonitor:YES];
        [[AudioUtility sharedInstance] setVolumeDetectingDelegate:self];
        [[AudioUtility sharedInstance] startDetectingVolume:1.0];
        _volMonitor.currentVolume = VOLUME_INIT_VAL;//1.0;
        _volMonitor.peakVolume = 1.0;
        [_timerButton setCurrentButtonState:kEnableButtonState withAnimation:YES];
        [_shotButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_timer"] withAnimation:YES];
        [_tipsView showTips:LString(@"Shout aloud to mic, camera timer will fired by the volume.") over:self.view autoCaculateLastTime:YES];
    }
    else if (_timerButton.currentButtonState == kEnableButtonState)
    {
        if ([_volMonitor isMonitorState] || [_volMonitor isHoldingState])
        {
            if (![_volMonitor isMonitorState])
            {
                [_volMonitor transToMonitorState];
            }
            [self cancelTimer];
            [_volMonitor hideMonitor:YES];
            [[AudioUtility sharedInstance] setVolumeDetectingDelegate:nil];
            [[AudioUtility sharedInstance] stopDectingVolume];
            _volMonitor.currentVolume = VOLUME_INIT_VAL;
            [_timerButton setCurrentButtonState:kExtendButtonState withAnimation:YES];
            [_shotButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_timer"] withAnimation:NO];
            [_tipsView showTips:LString(@"Voice control disabled.") over:self.view];
        }
    }
    else
    {
        [self cancelTimer];
        [_timerButton setCurrentButtonState:kNormalButtonState withAnimation:YES];
        [_shotButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_camera"] withAnimation:YES];
        [_tipsView showTips:LString(@"Normal Camera Mode") over:self.view];
    }
}

- (void)onPressedShot:(id)sender
{
    ////Test code
    //[self onUpdate:1.0 peakVolume:1.0 forInstance:[AudioUtility sharedInstance]];
    ////end of Test code
    
    if (_timerButton.currentButtonState == kNormalButtonState)
    {
        [self takePicture];
    }
    else if(_timerButton.currentButtonState == kEnableButtonState)
    {
        if ([_volMonitor isMonitorState])
        {
            [self onUpdate:1.0 peakVolume:1.0 forInstance:[AudioUtility sharedInstance]];
        }
        else
        {
            [self onStopTimerPressed:sender];
        }
    }
    else
    {
        if (!_preStartTimingTimer && !_timer)
        {
            [self startTimerOnly];
        }
        else
        {
            [self cancelTimer];
        }
    }
}

- (void)onStopTimerPressed:(id)sender
{
    if (![_volMonitor isMonitorState])
    {
        [self cancelTimer];
        [_volMonitor transToMonitorState];
        [[AudioUtility sharedInstance] setVolumeDetectingDelegate:self];
        [[AudioUtility sharedInstance] startDetectingVolume:1.0];
        _volMonitor.currentVolume = VOLUME_INIT_VAL;
        [_tipsView showTips:LString(@"Camera Timer Is Cancelled o(>_<)o") over:self.view];
    }
}

- (void)onTorchPressed:(id)sender
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if ([CameraOptions sharedInstance].light == AVCaptureTorchModeOn)
    {
        [CameraOptions sharedInstance].flash = AVCaptureFlashModeOff;
        [CameraOptions sharedInstance].light = AVCaptureTorchModeOff;
        [_torchButton setCurrentButtonState:kNormalButtonState];
        [_tipsView showTips:LString(@"All Lights Off") over:self.view];
    }
    else
    {
        if ([CameraOptions sharedInstance].flash == AVCaptureFlashModeOff)
        {
            [CameraOptions sharedInstance].flash = AVCaptureFlashModeOn;
            [CameraOptions sharedInstance].light = AVCaptureTorchModeOff;
            [_torchButton setCurrentButtonState:kEnableButtonState];
            [_tipsView showTips:LString(@"Flash On") over:self.view];
        }
        else
        {
            [CameraOptions sharedInstance].flash = AVCaptureFlashModeOff;
            [CameraOptions sharedInstance].light = AVCaptureTorchModeOn;
            [UIApplication sharedApplication].idleTimerDisabled = YES; 
            [_torchButton setCurrentButtonState:kExtendButtonState];
            [_tipsView showTips:LString(@"Torch Light On") over:self.view];
        }
    }
}

- (void)onFrontPressed:(id)sender
{
    if (_isFlipingCamera)
    {
        return;
    }
    
    if(_timerButton.currentButtonState == kEnableButtonState)
    {
        if (![_volMonitor isMonitorState])
        {
            [self onStopTimerPressed:sender];
        }
    }
    else if(_timerButton.currentButtonState == kExtendButtonState)
    {
        [self cancelTimer];
    }
    
    if ([CameraOptions sharedInstance].imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        [CameraOptions sharedInstance].imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self doCameraFilpAnimation];
        [self hideOrShowButtons];
    }
    else
    {
        [CameraOptions sharedInstance].imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self doCameraFilpAnimation];
        [self hideOrShowButtons];
    }
}

- (void)onConfigPressed:(id)sender
{
    
}

- (void)onAlbumPressed:(id)sender
{
    if (!_isSlidingAlbum)
    {
        if (gAlbumPunchedTriger == 0 && _timerButton.currentButtonState == kNormalButtonState)
        {
            [AlbumViewController enableAlbumPunchAnimationForView:self.view
                                                          catRect:_timerButton.frame];
            _timerButton.hidden = YES;
        }
        gAlbumPunchedTriger++;
        gAlbumPunchedTriger %= ALBUM_PUNCH_TRIGER_STEP;
        
        [self hideSubViews:YES];
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController showAlbumAndReleaseCaller:self];
    }
}

- (void)onQRCodePressed:(id)sender
{
    [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController removeCamera];
    [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController showQRCodeScannerAndReleaseCaller:nil];
}

#pragma mark - AudioUtilityVolumeDetectDelegate

- (void)onDetected:(float)currentVolume
        peakVolume:(float)peakVolume
        higherThan:(float)detectVolume
       forInstance:(AudioUtility*)util
{
    //NSLog(@"[PEAK] Reached Peak!");
}

- (void)onUpdate:(float)currentVolume
      peakVolume:(float)peakVolume
     forInstance:(AudioUtility*)util
{
#define LOUDER_SCALE (3.0)
    NSLog(@"DetectCurrentVol = %.2f",currentVolume);
    currentVolume *= LOUDER_SCALE;
    [_volMonitor setCurrentVolume:currentVolume];
    if ([_volMonitor isMonitorState] && currentVolume >= _volMonitor.peakVolume)
    {
        [_volMonitor transToHoldingState];
        [[AudioUtility sharedInstance] stopDectingVolume];
        
        [_timerButton setHittedOnce];
        [self startTimerOnly];
        
        //[self performSelector:@selector(startTimer) withObject:nil afterDelay:2.0];
        //[self startTimer];
    }
    //[[AudioUtility sharedInstance] ];
}

#pragma mark <BaseMessageBoxViewDelegate>

- (void)onYesButtonPressedForMessageBox:(BaseMessageBoxView*)messageBox
{
    [messageBox hide];
}
- (void)onNoButtonPressedForMessageBox:(BaseMessageBoxView*)messageBox
{
    [messageBox hide];
}

- (void)onTextButtonPressedAt:(int)index
                forMessageBox:(BaseMessageBoxView*)messageBox
{
    
}

#pragma mark Other

- (void)onBeginSlideAlbum
{
    _isSlidingAlbum = YES;
}

- (void)onCancelledSlideAlbum
{
    _isSlidingAlbum = NO;
}

- (void)onWillAcceptSlideAlbum
{
    [AlbumViewController enableAlbumPunchAnimationForView:self.view
                                                  catRect:_timerButton.frame];
    if ([AlbumViewController canPerformPunchAnimation] && _timerButton.currentButtonState == kNormalButtonState)
    {
        _timerButton.hidden = YES;
    }
    else
    {
        [AlbumViewController removeAlbumPunchAnimation];
    }
}

- (void)onAcceptSlideAlbum
{
    _isSlidingAlbum = NO;
    [self hideSubViews:YES];
    [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController showAlbumNoAnimationAndReleaseCaller:self];
    [AlbumViewController stopTrackTouchSlide];
}

- (void)startTimerOnly
{
    {
        //notify sound
        NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/Resource/Sound/sms-received4.caf"];
        [[AudioUtility sharedInstance] playFile:filePath withDelegate:self];
    }
    _preStartTimingTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                            target:self
                                                          selector:@selector(startTimer)
                                                          userInfo:nil
                                                           repeats:NO];
    [_tipsView showTips:LString(@"Camera Timer Fired! \\(^o^)/") over:self.view];
    [_shotButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_cancel"]
           withAnimation:YES];
}

- (void)hideOrShowButtons
{
    if (![CameraOptions sharedInstance].isFlashAndLightAvailible)
    {
        _torchButton.hidden = YES;
        return;
    }
    if ([CameraOptions sharedInstance].imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        [UIView animateWithDuration:0.3 animations:^(){
            _torchButton.alpha = 0.0;
        } completion:^(BOOL finished){
            _torchButton.hidden = YES;
        }];
    }
    else
    {
        [_torchButton setButtonEnabled:NO];
        _torchButton.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^(){
            _torchButton.alpha = 1.0;
        } completion:^(BOOL finished){
        }];
    }
}

- (void)onFinishedFlipAnimation
{
    _isFlipingCamera = NO;
}

- (void)doCameraFilpAnimation
{
    _isFlipingCamera = YES;
    CGRect rect = [CameraOptions sharedInstance].imagePicker.view.frame;
    rect.origin = CGPointZero;
    
    UIImageView* coverView = [[[UIImageView alloc] initWithFrame:rect] autorelease];
    /*
    coverView.backgroundColor = [UIColor colorWithRed:(97.0/255.0)
                                                green:(61.0/255.0)
                                                 blue:(30.0/255.0)
                                                alpha:1.0];
     */
    [[CameraOptions sharedInstance].imagePicker.view addSubview:coverView];
    coverView.clipsToBounds = YES;
    coverView.image = [UIImage imageNamed:@"/Resource/Picture/main/flip_back_ground"];
    [UIView transitionWithView:[CameraOptions sharedInstance].imagePicker.view
                      duration:1.5
                       options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionShowHideTransitionViews
                    animations:^(){
                        //[CameraOptions sharedInstance].imagePicker.view.alpha = 0.0;
                        //[CameraOptions sharedInstance].imagePicker.view.hidden = NO;
                        //coverView.alpha = 0.8;
                    }
                    completion:^(BOOL finished){
                        [UIView animateWithDuration:0.4
                                        animations:^(){
                         
                                             [CameraOptions sharedInstance].imagePicker.view.alpha = 1.0;
                                             //[CameraOptions sharedInstance].imagePicker.view.hidden = NO;
                                            coverView.alpha = 0.0;
                         
                                         }
                                         completion:^(BOOL finished){
                                             [coverView removeFromSuperview];
                                             [self onFinishedFlipAnimation];
                                         }];
                         
                        
                    }];
    /*
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^(){[CameraOptions sharedInstance].imagePicker.view.alpha = 0.6;}
                     completion:^(BOOL finished){
                         [CameraOptions sharedInstance].imagePicker.view.alpha = 1.0;
                     }];
    */
    if (_flipEmitterCover)
    {
        if (CGRectIsEmpty(rect))
        {
            rect = self.view.frame;
            rect.origin = CGPointZero;
        }
        _flipEmitterCover.frame = rect;
        [_flipEmitterCover performEmitterOverViewWithCompletionForTarget:self
                                                     andCompletionMethod:@selector(onFinishedFlipAnimation)];
        //return;
    }
}

- (BOOL)point:(CGPoint)point isInRect:(CGRect)rect
{
    if (point.x >= rect.origin.x && point.y >= rect.origin.y
        && point.x <= (rect.origin.x + rect.size.width)
        && point.y <= (rect.origin.y + rect.size.height))
    {
        return YES;
    }
    return NO;
}

- (BOOL)isPointLocatedOnCameraView:(CGPoint)point
{
    CGRect rctCamera = [self getCameraScaledRectWithHeightWidthRatio:4.0/3.0];
    
    if (![self point:point isInRect:rctCamera])
    {
        return NO;
    }
    
    for (int i = 0; i < self.view.subviews.count; ++i)
    {
        UIView* view = [self.view.subviews objectAtIndex:i];
        if (view != [CameraOptions sharedInstance].imagePicker.view
            && view != _focusView
            && view != _countView
            && view != _flipEmitterCover
            && !view.hidden)
        {
            if (view != _volMonitor || [_volMonitor isShowNow])
            {
                CGRect rect = view.frame;
                if ([self point:point isInRect:rect])
                {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark - ShotTimerDelegate

- (void)onInterval:(float)leftTimeInterval forTimer:(ShotTimer*)timer
{
    [_countView show];
    [_countView refreshText:[NSString stringWithFormat:@"%i",(int)leftTimeInterval]];
    [super onInterval:leftTimeInterval forTimer:timer];
}

- (void)onFinishedTimer:(ShotTimer*)timer
{
    [_countView refreshText:@""];
    [_countView hide];
    if(_timerButton.currentButtonState == kExtendButtonState)
    {
        [_shotButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_timer"] withAnimation:NO];
    }
    [super onFinishedTimer:timer];
    [self takePicture];
}

- (void)onCancelledTimer:(ShotTimer*)timer
{
    [_shotButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_timer"] withAnimation:YES];
    [super onCancelledTimer:timer];
}

#pragma mark - Override BaseCameraLogicViewController

- (void)startTimer:(int)seconds
{
    _preStartTimingTimer = nil;
    [super startTimer:seconds];
}

- (void)startTimer
{
    _preStartTimingTimer = nil;
    [super startTimer];
}

- (void)cancelTimer
{
    [_countView refreshText:@""];
    [_countView hide];
    if (_preStartTimingTimer)
    {
        [_preStartTimingTimer invalidate];
        _preStartTimingTimer = nil;
        [_shotButton setIcon:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_icon_timer"] withAnimation:YES];
        [_countView hide];
    }
    else
    {
        [super cancelTimer];
    }
}

- (IBAction)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer
{
    if (![[CameraOptions sharedInstance] currentDevice].isAdjustingFocus
        && ![[CameraOptions sharedInstance] currentDevice].isAdjustingExposure)
    {
        CGPoint pt = [gestureRecognizer locationInView:self.view];
        if (!_isFlipingCamera && [self isPointLocatedOnCameraView:pt])
        {
            [super handleTapGesture:gestureRecognizer];
            if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
            {
                [_focusView focusAndAimAtPoint:pt];
            }
        }
    }
}

- (BOOL)shouldSavePhoto:(UIImage*)image
{
    CGRect rect = [self getCameraScaledRectWithHeightWidthRatio:image.size.height / image.size.width];
    
    CGRect rectAlbumRaw = _albumRawRect;
    CGRect rectAlbumNew = _albumRawRect;
    rectAlbumNew.origin.x -= 51;
    
    CGRect dstRect = CGRectMake(0, 0, 40, 40 * image.size.height / image.size.width);
    dstRect.origin.x = rectAlbumNew.origin.x + ((rectAlbumNew.size.width - dstRect.size.width) * 0.5);
    dstRect.origin.y = rectAlbumNew.origin.y + ((rectAlbumNew.size.height - dstRect.size.height) * 0.5);
    
    void (^pushAlbumAnimation)(void)  = ^(void){
        _albumButton.frame = rectAlbumNew;
    };
    
    void (^restoreAlbumFrame)(void)  = ^(void){
        [UIView animateWithDuration:0.2 animations:^(){
            _albumButton.frame = rectAlbumRaw;
        }];
    };
    
    BOOL shouldFlip = NO;
    
    if ([CameraOptions sharedInstance].imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        shouldFlip = YES;
    }
    
    [self doImageCollectionAnimationFrom:rect
                                      to:dstRect
                               withImage:image
                               superView:self.view
                      insertAboveSubView:nil
                           animatedBlock:pushAlbumAnimation
                               doneBlock:restoreAlbumFrame
                   shouldFlipRightToLeft:shouldFlip
                               useBorder:YES];
    
    return YES;
}

@end
