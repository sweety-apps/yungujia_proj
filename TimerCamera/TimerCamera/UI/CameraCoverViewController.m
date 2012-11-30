//
//  CameraCoverViewController.m
//  TimerCamera
//
//  Created by Lee Justin on 12-11-24.
//
//

#import "CameraCoverViewController.h"

@interface CameraCoverViewController ()

@end

@implementation CameraCoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
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

- (void)showSubViews:(BOOL)animated delayed:(float)seconds
{
#define BOUNCE_OFFSET (3)
    [self hideSubViews:NO];
    _animationCatButton.hidden = NO;
    _shotButton.hidden = NO;
    _timerButton.hidden = NO;
    _configButton.hidden = NO;
    _torchButton.hidden = NO;
    _HDRButton.hidden = NO;
    _frontButton.hidden = NO;
    _volMonitor.hidden = NO;
    
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
        rect.origin.x -= rect.size.width + BOUNCE_OFFSET;
        _torchButton.frame = rect;
        
        
        ////
        rect = _HDRButton.frame;
        rect.origin.y += rect.size.height + BOUNCE_OFFSET;
        _HDRButton.frame = rect;
        
        ////
        rect = _frontButton.frame;
        rect.origin.y += rect.size.height + BOUNCE_OFFSET;
        _frontButton.frame = rect;
        
        ////
        rect = _volMonitor.frame;
        rect.origin.x -= rect.size.width + BOUNCE_OFFSET;
        _volMonitor.frame = rect;
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
        rect.origin.x -= 0 - BOUNCE_OFFSET;
        _torchButton.frame = rect;
        
        
        ////
        rect = _HDRButton.frame;
        rect.origin.y += 0 - BOUNCE_OFFSET;
        _HDRButton.frame = rect;
        
        ////
        rect = _frontButton.frame;
        rect.origin.y += 0 - BOUNCE_OFFSET;
        _frontButton.frame = rect;
        
        ////
        rect = _volMonitor.frame;
        rect.origin.x -= 0 - BOUNCE_OFFSET;
        _volMonitor.frame = rect;
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
             [UIView animateWithDuration:0.15 animations:doSetSubViewFramesAndBounce];
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
             }];
        }
        else
        {
            doMoveSubViews();
            doSetSubViewFramesAndBounce();
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
        rect.origin.x = 122;
        rect.origin.y = self.view.frame.size.height - 82;
        rect.origin.y += rect.size.height;
        _animationCatButton.frame = rect;
        
        ////
        rect = _shotButton.frame;
        rect.origin.x = self.view.frame.size.width - rect.size.width;
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
        rect.origin.x = 0;
        rect.origin.y = 50;
        rect.origin.x -= rect.size.width;
        _configButton.frame = rect;
        
        
        ////
        rect = _torchButton.frame;
        rect.origin.x = self.view.frame.size.width - rect.size.width;
        rect.origin.y = 49;
        rect.origin.x += rect.size.width;
        _torchButton.frame = rect;
        
        
        ////
        rect = _HDRButton.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.origin.y -= rect.size.height;
        _HDRButton.frame = rect;
        
        
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
    };
    
    void (^doHideSubViews)(BOOL) = ^(BOOL finished){
        _animationCatButton.hidden = YES;
        _shotButton.hidden = YES;
        _timerButton.hidden = YES;
        _configButton.hidden = YES;
        _torchButton.hidden = YES;
        _HDRButton.hidden = YES;
        _frontButton.hidden = YES;
        _volMonitor.hidden = YES;
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

- (void)createSubViews
{
    _animationCatButton = [CommonAnimationButton
                           buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_with_eye"]
                           forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_with_eye"]
                           forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]
                           forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]
                           forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]];
    [self.view addSubview:_animationCatButton];
    
    
    _shotButton = [CommonAnimationButton
                   buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal1"]
                   forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal2"]
                   forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_pressed"]
                   forEnabledImage1:nil
                   forEnabledImage2:nil];
    [self.view addSubview:_shotButton];
    
    
    _timerButton = [TimerButton buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_normal1"]
                                                          forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_normal2"]
                                                         forPressedImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_pressed"]
                                                         forPressedImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_enable1"]
                                                         forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_enable1"]
                                                         forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_enable2"]];
    [self.view addSubview:_timerButton];
    
    
    _configButton = [CommonAnimationButton
                     buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal1"]
                     forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal2"]
                     forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_pressed"]
                     forEnabledImage1:nil
                     forEnabledImage2:nil];
    [self.view addSubview:_configButton];
    
    
    _torchButton = [CommonAnimationButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/torch_pressed"]
                    forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable1"]
                    forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable2"]];
    [self.view addSubview:_torchButton];
    
    
    _HDRButton = [CommonAnimationButton
                  buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/HDR_normal1"]
                  forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/HDR_normal2"]
                  forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/HDR_pressed"]
                  forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/HDR_enable1"]
                  forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/HDR_enable2"]];
    [self.view addSubview:_HDRButton];
    
    
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
    
    CommonAnimationButton* stop = [CommonAnimationButton
                                   buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_normal1"]
                                   forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_normal2"]
                                   forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_pressed"]
                                   forEnabledImage1:nil
                                   forEnabledImage2:nil];
    
    _volMonitor = [VolumeMonitor monitorWithBarButton:bar
                                       withStopButton:stop
                                      backGroundImage:[UIImage imageNamed:@"/Resource/Picture/main/volume_bg"]
                                          volumeImage:[UIImage imageNamed:@"/Resource/Picture/main/fist"]
                                     reachedPeakImage:[UIImage imageNamed:@"/Resource/Picture/main/vol_point_punched"]];
    _volMonitor.minPeakVolume = 0.4;
    _volMonitor.peakVolume = 0.7;
    
    [self.view addSubview:_volMonitor];
    
    //add events
    [_timerButton.button addTarget:self
                            action:@selector(onPressedTimer:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self hideSubViews:NO];
}

- (void)destorySubViews
{
    [_shotButton removeFromSuperview];
    _shotButton = nil;
    [_timerButton removeFromSuperview];
    _timerButton = nil;
    [_configButton removeFromSuperview];
    _configButton = nil;
    [_torchButton removeFromSuperview];
    _torchButton = nil;
    [_HDRButton removeFromSuperview];
    _HDRButton = nil;
    [_frontButton removeFromSuperview];
    _frontButton = nil;
    [_animationCatButton removeFromSuperview];
    _animationCatButton = nil;
    [_volMonitor removeFromSuperview];
    _volMonitor = nil;
}

#pragma mark Event Handlers

- (void)onPressedTimer:(id)sender
{
    if (_timerButton.timerEnabled)
    {
        //[_volMonitor hideMonitor:NO];
        [_volMonitor showMonitor:YES];
        _volMonitor.currentVolume = 0.5;
    }
    else
    {
        [_volMonitor hideMonitor:YES];
    }
}

@end
