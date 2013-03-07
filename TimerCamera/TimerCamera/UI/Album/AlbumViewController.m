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
#define kAlbumToTouchPointOffset (30.0);

#pragma mark - AlbumPunchAnimationData

@interface AlbumPunchAnimationData : NSObject
{
    UIView* _view;
    CGRect _punchRect;
}

@property (nonatomic,assign) UIView* view;
@property (nonatomic,assign) CGRect punchRect;

@end

@implementation AlbumPunchAnimationData

@synthesize view = _view;
@synthesize punchRect = _punchRect;

@end

static AlbumPunchAnimationData* gPunchData = nil;


#pragma mark - AlbumSwipeHandler

@interface AlbumSwipeHandler : NSObject
{
    UIImageView* _albumView;
    UIPanGestureRecognizer* _panRecognizer;
    UIView* _view;
    CGRect _startRect;
    CGRect _acceptRect;
    id _slideTarget;
    SEL _slideSel;
    id _cancelTarget;
    SEL _cancelSel;
    id _willTarget;
    SEL _willSel;
    id _acceptTarget;
    SEL _acceptSel;
    BOOL _isPanning;
}

- (id)      initWithView:(UIView*)view
               startRect:(CGRect)sRect
              acceptRect:(CGRect)aRect
      onSlideBeginTarget:(id)slideTarget
         onSlideBeginSel:(SEL)slideSel
  onSlideCancelledTarget:(id)cancelledTarget
     onSlideCancelledSel:(SEL)cancelledSel
      onWillAcceptTarget:(id)willTarget
         onWillAcceptSel:(SEL)willSel
     onAcceptTrackTarget:(id)target
        onAcceptTrackSel:(SEL)sel;

- (void)handleSwipe:(UIPanGestureRecognizer*)recognizer;
- (BOOL)isSliderCoverredPunchedRect;

@end

@implementation AlbumSwipeHandler

- (id)      initWithView:(UIView*)view
               startRect:(CGRect)sRect
              acceptRect:(CGRect)aRect
      onSlideBeginTarget:(id)slideTarget
         onSlideBeginSel:(SEL)slideSel
  onSlideCancelledTarget:(id)cancelledTarget
     onSlideCancelledSel:(SEL)cancelledSel
      onWillAcceptTarget:(id)willTarget
         onWillAcceptSel:(SEL)willSel
     onAcceptTrackTarget:(id)target
        onAcceptTrackSel:(SEL)sel
{
    self = [super init];
    if (self)
    {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        _panRecognizer.maximumNumberOfTouches = 1;
        _panRecognizer.cancelsTouchesInView = NO;
        
        _startRect = sRect;
        _acceptRect = aRect;
        _slideTarget = slideTarget;
        _slideSel = slideSel;
        _cancelTarget = cancelledTarget;
        _cancelSel = cancelledSel;
        _willTarget = willTarget;
        _willSel = willSel;
        _acceptTarget = target;
        _acceptSel = sel;
        _view = [view retain];
        
        CGRect rect = _view.frame;
        rect.origin.x = rect.size.width;
        
        [_view addGestureRecognizer:_panRecognizer];
        _albumView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/main/album_cover"]];
        rect.origin.y = (_view.frame.size.height - _albumView.frame.size.height) * 0.5;
        rect.size = _albumView.frame.size;
        _albumView.frame = rect;
        [_view addSubview:_albumView];
        _albumView.hidden = YES;
        _isPanning = NO;
    }
    return self;
}

- (void)handleSwipe:(UIPanGestureRecognizer*)recognizer
{
    if (_panRecognizer == recognizer)
    {
        CGPoint point = [recognizer locationInView:_view];
        if(recognizer.state == UIGestureRecognizerStateBegan)
        {
            CGPoint offsetPoint = [recognizer translationInView:_view];
            point.x = point.x - offsetPoint.x;
            point.y = point.y - offsetPoint.y;
            if (CGRectContainsPoint(_startRect, point))
            {
                [_view bringSubviewToFront:_albumView];
                _albumView.hidden = NO;
                CGRect rect = _albumView.frame;
                rect.origin.x = point.x;
                rect.origin.x -= kAlbumToTouchPointOffset;
                _albumView.frame = rect;
                _isPanning = YES;
                if (_slideTarget && _slideSel)
                {
                    [_slideTarget performSelector:_slideSel];
                }
            }
        }
        if (recognizer.state == UIGestureRecognizerStateChanged)
        {
            if (_isPanning)
            {
                [_view bringSubviewToFront:_albumView];
                _albumView.hidden = NO;
                CGRect rect = _albumView.frame;
                rect.origin.x = point.x;
                rect.origin.x -= kAlbumToTouchPointOffset;
                _albumView.frame = rect;
            }
        }
        if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
        {
            if (_isPanning)
            {
                _isPanning = NO;
                if(CGRectContainsPoint(_acceptRect, point))
                {
                    if (_willTarget && _willSel)
                    {
                        [_willTarget performSelector:_willSel];
                    }
                    [_view bringSubviewToFront:_albumView];
                    _albumView.hidden = NO;
                    CGRect rect = _albumView.frame;
                    rect.origin.x = (_view.frame.size.width - rect.size.width) * 0.5;
                    [UIView animateWithDuration:0.3 animations:^(){
                        _albumView.frame = rect;
                    } completion:^(BOOL finished){
                        if(_acceptTarget && _acceptSel)
                        {
                            [_acceptTarget performSelector:_acceptSel];
                        }
                    }];
                }
                else
                {
                    CGRect rect = _albumView.frame;
                    rect.origin.x = _view.frame.size.width;
                    [UIView animateWithDuration:0.3 animations:^(){
                        _albumView.frame = rect;
                    } completion:^(BOOL finished){
                        _albumView.hidden = YES;
                        if (_cancelSel && _cancelTarget)
                        {
                            [_cancelTarget performSelector:_cancelSel];
                        }
                    }];
                }
            }
        }
        
    }
}

- (BOOL)isSliderCoverredPunchedRect
{
    if (gPunchData == nil)
    {
        return NO;
    }
    CGRect albumRect = _albumView.frame;
    if (albumRect.origin.x <= CGRectGetMaxX(gPunchData.punchRect))
    {
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    [_view removeGestureRecognizer:_panRecognizer];
    ReleaseAndNil(_view);
    ReleaseAndNilView(_albumView);
    ReleaseAndNil(_panRecognizer);
    [super dealloc];
}

@end

#pragma mark - AlbumViewController

static BOOL gTipsHasShown = NO;

static AlbumSwipeHandler* gSwipeHandler = nil;

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

- (void)createSubViews
{
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
    if (_viewToInsertBelow == nil)
    {
        [self.view addSubview:_assetPicker];
    }
    else
    {
        [self.view insertSubview:_assetPicker belowSubview:_viewToInsertBelow];
    }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _waitForPunchAnimation = gPunchData ? YES : NO;
	// Do any additional setup after loading the view.
    if (!_waitForPunchAnimation)
    {
        [self createSubViews];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _viewToInsertBelow = nil;
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
    _viewToInsertBelow = nil;
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
    
    _viewToInsertBelow = _albumCoverImageView;
    
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
        if (gPunchData)
        {
            //Punch Animation
            UIImageView* catStartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/main/album_slide_punch_cat_start"]];
            UIImageView* punchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/main/album_slide_punch_point"]];
            UIImageView* catEndView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/main/album_slide_punch_cat_end"]];
            UIImageView* microphoneView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/Resource/Picture/main/album_slide_punch_microphone"]];
            
            [self.view addSubview:punchView];
            [self.view addSubview:catStartView];
            [self.view addSubview:catEndView];
            [self.view addSubview:microphoneView];
            
            CGRect rawRect = punchView.frame;
            rawRect.origin.x = gPunchData.punchRect.origin.x;
            rawRect.origin.y = CGRectGetMaxY(gPunchData.punchRect) - rawRect.size.height;
            
            CGRect fadeRect = rawRect;
            fadeRect.origin.x -= fadeRect.size.width;
            
            CGRect stayRect = rawRect;
            stayRect.origin.x -= 1.0;
            
            CGRect microPhoneFlayToRect = rawRect;
            microPhoneFlayToRect.origin.x = CGRectGetMaxX(gPunchData.punchRect);
            microPhoneFlayToRect.origin.y = CGRectGetMaxY(gPunchData.punchRect);
            
            catStartView.frame = rawRect;
            catEndView.frame = fadeRect;
            punchView.frame = rawRect;
            microphoneView.frame = fadeRect;
            
            catEndView.hidden = NO;
            punchView.hidden = NO;
            microphoneView.hidden = NO;
            catStartView.hidden = NO;
            
            CGAffineTransform punchTrans = punchView.transform;
            CGAffineTransform punchStartTrans = CGAffineTransformScale(punchTrans, 0.001, 0.001);
            CGAffineTransform punchEndTrans = CGAffineTransformScale(punchTrans, 0.001, 0.001);
            
            punchView.transform = punchStartTrans;
            
            void (^bouncePunchPointStart)() = ^()
            {
                punchView.transform = punchTrans;
            };
            
            void (^bouncePunchPointEnd)() = ^()
            {
                punchView.transform = punchEndTrans;
            };
            
            void (^slideOutCat)() = ^()
            {
                catStartView.frame = fadeRect;
            };
            
            void (^throwMicroPhone)() = ^()
            {
                microphoneView.frame = microPhoneFlayToRect;
            };
            
            void (^catReAppear)() = ^()
            {
                catEndView.frame = stayRect;
            };
            
            void (^catReStay)() = ^()
            {
                catEndView.frame = rawRect;
            };
            
            void (^catReDispear)() = ^()
            {
                catEndView.frame = fadeRect;
            };
            
            void (^endAndRelease)() = ^()
            {
                [catStartView removeFromSuperview];
                [catStartView release];
                [punchView removeFromSuperview];
                [punchView release];
                [catEndView removeFromSuperview];
                [catEndView release];
                [microphoneView removeFromSuperview];
                [microphoneView release];
            };
            
            CGRect coverPunchRect = rect;
            coverPunchRect.origin.x = CGRectGetMaxX(gPunchData.punchRect);
            
            [UIView animateWithDuration:0.15 animations:^(){
                _albumCoverImageView.frame = coverPunchRect;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.1 animations:bouncePunchPointStart
                completion:^(BOOL finished){
                    [UIView animateWithDuration:0.2 animations:^(){
                        bouncePunchPointEnd();
                        slideOutCat();
                        _albumCoverImageView.frame = rect;
                    } completion:^(BOOL finished){
                        [UIView animateWithDuration:0.6 animations:throwMicroPhone
                        completion:^(BOOL finished){
                            [UIView animateWithDuration:0.05 animations:catReAppear
                            completion:^(BOOL finished){
                                [UIView animateWithDuration:0.35 animations:catReStay
                                completion:^(BOOL finished){
                                    [UIView animateWithDuration:0.05 animations:catReDispear
                                    completion:^(BOOL finished){
                                        endAndRelease();
                                        if (callFinshed)
                                        {
                                            callFinshed();
                                        }
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
            //normal animation
            [UIView animateWithDuration:0.3
                             animations:showCover
                             completion:^(BOOL finished){
                                 if (callFinshed)
                                 {
                                     callFinshed();
                                 }
                             }];
        }
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
    [self showCover:YES finishedBlock:^(){
        if (_waitForPunchAnimation)
        {
            [self createSubViews];
        }
    } showedBlock:nil];
    _callerController = caller;
}

- (void)showAlbumWithoutAnimationAndReleaseCaller:(UIViewController*)caller
{
    [self showCover:NO finishedBlock:^(){
        if (_waitForPunchAnimation)
        {
            [self createSubViews];
        }
    } showedBlock:nil];
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
                 onSlideBeginTarget:(id)slideTarget
                    onSlideBeginSel:(SEL)slideSel
             onSlideCancelledTarget:(id)cancelledTarget
                onSlideCancelledSel:(SEL)cancelledSel
                 onWillAcceptTarget:(id)willTarget
                    onWillAcceptSel:(SEL)willSel
                onAcceptTrackTarget:(id)target
                   onAcceptTrackSel:(SEL)sel
{
    ReleaseAndNil(gSwipeHandler);
    gSwipeHandler = [[AlbumSwipeHandler alloc] initWithView:view
                                                  startRect:sRect
                                                 acceptRect:aRect
                                         onSlideBeginTarget:slideTarget
                                            onSlideBeginSel:slideSel
                                     onSlideCancelledTarget:cancelledTarget
                                        onSlideCancelledSel:cancelledSel
                                         onWillAcceptTarget:willTarget
                                            onWillAcceptSel:willSel
                                        onAcceptTrackTarget:target
                                           onAcceptTrackSel:sel];
}

+ (void)stopTrackTouchSlide
{
    ReleaseAndNil(gSwipeHandler);
}

+ (void)enableAlbumPunchAnimationForView:(UIView*)view
                                 catRect:(CGRect)rect
{
    ReleaseAndNil(gPunchData);
    gPunchData = [[AlbumPunchAnimationData alloc] init];
    gPunchData.view = view;
    gPunchData.punchRect = rect;
}

+ (void)removeAlbumPunchAnimation
{
    ReleaseAndNil(gPunchData);
}

+ (BOOL)canPerformPunchAnimation
{
    if (gPunchData)
    {
        if (gSwipeHandler)
        {
            if (![gSwipeHandler isSliderCoverredPunchedRect])
            {
                return YES;
            }
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (BOOL)isAlbumPunchAnimationEnabled
{
    if (gPunchData)
    {
        return YES;
    }
    return NO;
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