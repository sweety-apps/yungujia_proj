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

- (void)createSubViews
{
    CGRect rect = CGRectZero;
    
    _animationCatButton = [CommonAnimationButton
                           buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_with_eye"]
                           forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_with_eye"]
                           forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]
                           forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]
                           forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/animation_cat_bg_no_eye"]];
    rect = _animationCatButton.frame;
    rect.origin.x = 122;
    rect.origin.y = self.view.frame.size.height - 82;
    _animationCatButton.frame = rect;
    [self.view addSubview:_animationCatButton];
    
    
    _shotButton = [CommonAnimationButton
                   buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal1"]
                   forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal2"]
                   forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_pressed"]
                   forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal1"]
                   forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/shot_btn_normal2"]];
    rect = _shotButton.frame;
    rect.origin.x = self.view.frame.size.width - rect.size.width;
    rect.origin.y = self.view.frame.size.height - rect.size.height;
    _shotButton.frame = rect;
    [self.view addSubview:_shotButton];
    
    
    _timerButton = [CommonAnimationButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_pressed"]
                    forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_enable1"]
                    forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/timer_btn_enable2"]];
    rect = _timerButton.frame;
    rect.origin.x = 0;
    rect.origin.y = self.view.frame.size.height - rect.size.height;
    _timerButton.frame = rect;
    [self.view addSubview:_timerButton];
    
    
    _configButton = [CommonAnimationButton
                     buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal1"]
                     forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal2"]
                     forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_pressed"]
                     forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal1"]
                     forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/config_btn_normal2"]];
    rect = _configButton.frame;
    rect.origin.x = 0;
    rect.origin.y = 50;
    _configButton.frame = rect;
    [self.view addSubview:_configButton];
    
    
    _torchButton = [CommonAnimationButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/torch_pressed"]
                    forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable1"]
                    forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/torch_enable2"]];
    rect = _torchButton.frame;
    rect.origin.x = self.view.frame.size.width - rect.size.width;
    rect.origin.y = 49;
    _torchButton.frame = rect;
    [self.view addSubview:_torchButton];
    
    
    _HDRButton = [CommonAnimationButton
                  buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/HDR_normal1"]
                  forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/HDR_normal2"]
                  forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/HDR_pressed"]
                  forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/HDR_enable1"]
                  forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/HDR_enable2"]];
    rect = _HDRButton.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    _HDRButton.frame = rect;
    [self.view addSubview:_HDRButton];
    
    
    _frontButton = [CommonAnimationButton
                    buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/main/front_normal1"]
                    forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/main/front_normal2"]
                    forPressedImage:[UIImage imageNamed:@"/Resource/Picture/main/front_pressed"]
                    forEnabledImage1:[UIImage imageNamed:@"/Resource/Picture/main/front_normal1"]
                    forEnabledImage2:[UIImage imageNamed:@"/Resource/Picture/main/front_normal2"]];
    rect = _frontButton.frame;
    rect.origin.x = self.view.frame.size.width - rect.size.width;
    rect.origin.y = 0;
    _frontButton.frame = rect;
    [self.view addSubview:_frontButton];
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
}

@end
