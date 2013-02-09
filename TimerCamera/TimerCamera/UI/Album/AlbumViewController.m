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
    _assetPicker = [AlbumImagePickerView
                    albumImagePickerWitWithFrame:self.view.frame
                    andTarget:_target
                    andDelegate:self
                    cameraButton:cameraBtn
                    editorButton:editorBtn
                    menuButton:menuBtn
                    imageBorderImage:[[UIImage imageNamed:@"/Resource/Picture/picker/photo_boder_cover_light"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0]
                    imageBorderSelectedImage:[[UIImage imageNamed:@"/Resource/Picture/picker/photo_boder_cover_unselected"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0]];
    _assetPicker.imageViewSize = kAlbumThumbNailSize;
    _assetPicker.imageViewUseBounds = YES;
    [self.view addSubview:_assetPicker];
    self.view.backgroundColor = [UIColor clearColor];//kBGColor();
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    ReleaseAndNilView(_assetPicker);
    ReleaseAndNil(_target);
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
    [super dealloc];
}

#pragma mark Album Showing Animations

- (void)showAlbumWithAnimation
{
    
}

- (void)hideAlbumWithAnimation
{
    
}

#pragma mark <AssetImagePickerTargetDelegate>

- (void)onLoadAssetSucceed:(AssetImagePickerTarget*)target
{
    if (_assetPicker)
    {
        [_assetPicker reloadData];
    }
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
}

#pragma mark <ImagePickerViewDelegate>

- (void)onPickedImage:(UIImage*)image forView:(ImagePickerView*)pickerView
{
    
}

- (void)onCancelledPick:(ImagePickerView*)pickerView
{
    
}

#pragma mark button Events Handler

- (void)cameraButtonPressed:(id)sender
{
    
}

- (void)editorButtonPressed:(id)sender
{
    
}

- (void)menuButtonPressed:(id)sender
{
    
}

@end