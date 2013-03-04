//
//  AlbumViewController.m
//  TimerCamera
//
//  Created by lijinxin on 13-1-14.
//
//

#import "AppDelegate.h"
#import "AlbumViewController.h"

#define kBGColor()  [UIColor colorWithRed:(140.0/255.0) green:(200.0/255.0) blue:(0.0/255.0) alpha:1.0]

#define kAlbumThumbNailSize CGSizeMake(180, 180)

static BOOL gTipsHasShown = NO;

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

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
    CommonAnimationButton* menuBtn = [CommonAnimationButton
                                      buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/picker/menu_button_normal"]
                                      forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/picker/menu_button_normal"]
                                      forPressedImage:[UIImage imageNamed:@"/Resource/Picture/picker/menu_button_pressed"]
                                      forEnabledImage1:nil
                                      forEnabledImage2:nil];
    
    [menuBtn.button addTarget:self
                       action:@selector(menuButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    CommonAnimationButton* cameraBtn = [CommonAnimationButton
                                      buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/picker/camera_button_normal"]
                                      forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/picker/camera_button_normal"]
                                      forPressedImage:[UIImage imageNamed:@"/Resource/Picture/picker/camera_button_pressed"]
                                      forEnabledImage1:nil
                                      forEnabledImage2:nil];
    
    [cameraBtn.button addTarget:self
                       action:@selector(cameraButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    CommonAnimationButton* editorBtn = [CommonAnimationButton
                                      buttonWithPressedImageSizeforNormalImage1:[UIImage imageNamed:@"/Resource/Picture/picker/editor_button_normal"]
                                      forNormalImage2:[UIImage imageNamed:@"/Resource/Picture/picker/editor_button_normal"]
                                      forPressedImage:[UIImage imageNamed:@"/Resource/Picture/picker/editor_button_pressed"]
                                      forEnabledImage1:nil
                                      forEnabledImage2:nil];
    
    [editorBtn.button addTarget:self
                       action:@selector(editorButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    _target = [[AssetImagePickerTarget alloc] initWithDelegate:self];
    _assetPicker = [[AlbumImagePickerView
                    albumImagePickerWitWithFrame:self.view.frame
                    andTarget:_target
                    andDelegate:self
                    cameraButton:cameraBtn
                    editorButton:editorBtn
                    menuButton:menuBtn
                    imageBorderImage:[[UIImage imageNamed:@"/Resource/Picture/picker/photo_boder_cover_light"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0]
                    imageBorderSelectedImage:[[UIImage imageNamed:@"/Resource/Picture/picker/photo_boder_cover_unselected"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0]]
                    retain];
    _assetPicker.imageViewSize = kAlbumThumbNailSize;
    _assetPicker.imageViewUseBounds = YES;
    [self.view addSubview:_assetPicker];
    self.view.backgroundColor = [UIColor clearColor];//kBGColor();
    
    _assetPicker.hidden = YES;
    
    _tipsView = [[TipsView tipsViewWithPushHand:[UIImage imageNamed:@"/Resource/Picture/main/tips_cat_hand"]
                                backGroundImage:[[UIImage imageNamed:@"/Resource/Picture/main/tips_fish_bg_strtechable"] stretchableImageWithLeftCapWidth:50 topCapHeight:28] ]
                 retain];
    
    _imagePickerController = [[CustomizedUIImagePickerController alloc] init];
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePickerController.allowsEditing = NO;
    _imagePickerController.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    ReleaseAndNilView(_assetPicker);
    ReleaseAndNil(_target);
    ReleaseAndNilView(_albumCoverImageView);
    ReleaseAndNilView(_tipsView);
    [_imagePickerController.view removeFromSuperview];
    ReleaseAndNil(_imagePickerController);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    ReleaseAndNilView(_assetPicker);
    ReleaseAndNil(_target);
    ReleaseAndNilView(_albumCoverImageView);
    ReleaseAndNilView(_tipsView);
    [_imagePickerController.view removeFromSuperview];
    ReleaseAndNil(_imagePickerController);
    [super dealloc];
}

#pragma mark Album Showing Animations

- (void)showCover:(BOOL)animated finishedBlock:(void (^)(void))callFinshed showedBlock:(void (^)(void))callShowed
{
    if (_albumCoverImageView)
    {
        ReleaseAndNilView(_albumCoverImageView);
    }
    _albumCoverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/main/album_cover"]];
    
    CGRect rect = self.view.frame;
    rect.origin.x = rect.size.width;
    rect.origin.y = (rect.size.height - _albumCoverImageView.frame.size.height) * 0.5;
    rect.size = _albumCoverImageView.frame.size;
    _albumCoverImageView.userInteractionEnabled = YES;
    
    _albumCoverImageView.frame = rect;
    [self.view addSubview:_albumCoverImageView];
    
    rect.origin.x = (self.view.frame.size.width - rect.size.width) * 0.5;
    
    void (^showCover)() = ^(){
        _albumCoverImageView.frame = rect;
        if (callShowed)
        {
            callShowed();
        }
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.3
                         animations:showCover
                         completion:^(BOOL finished){
                             if (callFinshed)
                             {
                                 callFinshed();
                             }
        }];
    }
    else
    {
        showCover();
        if (callFinshed)
        {
            callFinshed();
        }
    }
}

- (void)hideCover:(BOOL)animated finishedBlock:(void (^)(void))callFinshed
{
    CGRect rect = _albumCoverImageView.frame;
    //rect.size = _albumCoverImageView.frame.size;
    
    UIImage* image = [_albumCoverImageView.image stretchableImageWithLeftCapWidth:(rect.size.width - 1) topCapHeight:0.0];
    _albumCoverImageView.image = image;
    rect.size.width = rect.size.width * 2.0;
    _albumCoverImageView.frame = rect;
    
    void (^hideCover)() = ^(){
        //_albumCoverImageView.frame = rect;
        _albumCoverImageView.hidden = YES;
    };
    
    void (^finishedHide)() = ^(){
        ReleaseAndNilView(_albumCoverImageView);
        if (callFinshed)
        {
            callFinshed();
        }
    };
    
    if (animated)
    {
        [UIView transitionWithView:_albumCoverImageView
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationOptionShowHideTransitionViews
                        animations:hideCover
                        completion:^(BOOL finished){
                            finishedHide();
                        }];
//        [UIView animateWithDuration:0.25
//                         animations:hideCover
//                         completion:^(BOOL finished){
//                             finishedHide();
//                         }];
    }
    else
    {
        hideCover();
        finishedHide();
    }
}

- (void)showAlbumWithAnimation
{
    [self showAlbumWithAnimationAndReleaseCaller:nil];
}

- (void)hideAlbumWithAnimation
{
    [self hideAlbumWithAnimationAndDoBlock:nil withFinishBlock:nil];
}

- (void)showAlbumWithAnimationAndReleaseCaller:(UIViewController*)caller
{
    [self showCover:YES finishedBlock:nil showedBlock:nil];
    _callerController = caller;
}

- (void)hideAlbumWithAnimationAndDoBlock:(void (^)(void))block
                         withFinishBlock:(void (^)(void))finishBlock
{
    void (^transFinishBlock)() = ^(){
        if (finishBlock)
        {
            finishBlock();
        }
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController removeAlbum];
    };
    
    void (^transBlock)() = ^(){
        if (block)
        {
            block();
        }
        [self hideCover:YES finishedBlock:transFinishBlock];
    };
    [self showCover:YES finishedBlock:transBlock showedBlock:nil];
}

+ (void)startTrackTouchSlideForView:(UIView*)view
                          startRect:(CGRect)sRect
                         acceptRect:(CGRect)aRect
                 onAcceptTrackBlock:(void (^)(void))block
{
    //UISwipeGestureRecognizer
}

+ (void)stopTrackTouchSlide
{
    
}

- (void)assetFailedDelayHideCover
{
    void (^finishedHideCover)() = ^()
    {
        if (_callerController)
        {
            [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController removeController:_callerController];
            _callerController = nil;
        }
    };
    
    [self hideCover:YES finishedBlock:finishedHideCover];
}

#pragma mark <AssetImagePickerTargetDelegate>

- (void)onLoadAssetSucceed:(AssetImagePickerTarget*)target
{
    if (_assetPicker)
    {
        [_assetPicker reloadData];
    }
    
    void (^finishedHideCover)() = ^()
    {
        if (_callerController)
        {
            [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController removeController:_callerController];
            _callerController = nil;
        }
        
        if (!gTipsHasShown && [_target getImageCount] > 0)
        {
            [_tipsView showTips:LString(@"Operate photos by slide and tap.") over:self.view autoCaculateLastTime:YES];
            gTipsHasShown = YES;
        }
    };
    
    _assetPicker.hidden = NO;
    _assetFailed = NO;
    [self hideCover:YES finishedBlock:finishedHideCover];
}

- (void)onLoadAssetFailed:(AssetImagePickerTarget*)target
                   reason:(AssetFailedType)reasonType
{
    if (reasonType == kAssetFiled_LocationOff)
    {
        //pop up msg box to notify turn on location
        [[[UIAlertView alloc] initWithTitle:LString(@"Notify")
                                    message:LString(@"Pelease turn on Location in System Settings!")
                                   delegate:nil
                          cancelButtonTitle:LString(@"I've known.")
                          otherButtonTitles:nil] autorelease];
    }
    
    //use UIImagePickerController
    _assetFailed = YES;
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    _imagePickerController.view.frame = rect;
    [self.view insertSubview:_imagePickerController.view
                belowSubview:_albumCoverImageView];
    
    [self assetFailedDelayHideCover];
    /*
    [self performSelector:@selector(assetFailedDelayHideCover)
               withObject:nil
               afterDelay:0.35];*/
}

#pragma mark <ImagePickerViewDelegate>

- (void)onPickedImageAtIndex:(int)index
              forView:(ImagePickerView *)pickerView
{
    [self.view bringSubviewToFront:_assetPicker];
    [_assetPicker doSelectedCellAnimation:index
                             catHandImage:[UIImage imageNamed:@"/Resource/Picture/picker/picking_cat_hand"]
                                 endBlock:^(){
                                     [self handleRawImage:[_target getRawImageAtIndex:index]];
                                 }];
}

- (void)onCancelledPick:(ImagePickerView*)pickerView
{
    
}

#pragma mark button Events Handler

- (void)cameraButtonPressed:(id)sender
{
    [self hideAlbumWithAnimationAndDoBlock:^(){
        _assetPicker.hidden = YES;
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController showCamera];
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController PrepareLoadingAnimation];
    } withFinishBlock:^(){
        [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController ShowLoadingAnimation];
    }];
}

- (void)editorButtonPressed:(id)sender
{
    
}

- (void)menuButtonPressed:(id)sender
{
    [self presentModalViewController: _imagePickerController
                            animated: YES];
}

#pragma mark - UIImagePickerController part


#pragma mark <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (!_assetFailed)
    {
        [_imagePickerController dismissModalViewControllerAnimated:YES];
    }
    
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    [self handleRawImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (!_assetFailed)
    {
        [_imagePickerController dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self hideAlbumWithAnimationAndDoBlock:^(){
            [_imagePickerController.view removeFromSuperview];
            [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController showCamera];
            [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController PrepareLoadingAnimation];
        } withFinishBlock:^(){
            [((AppDelegate*)([UIApplication sharedApplication].delegate)).viewController ShowLoadingAnimation];
        }];
    }
}

#pragma mark <UINavigationControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [_imagePickerController navigationController:navigationController willShowViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [_imagePickerController navigationController:navigationController didShowViewController:viewController animated:animated];
}

#pragma mark Raw Image Handler

- (void)handleRawImage:(UIImage*)image
{
    
}

@end