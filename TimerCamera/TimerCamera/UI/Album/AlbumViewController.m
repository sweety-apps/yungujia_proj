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
    _target = [[AssetImagePickerTarget alloc] initWithDelegate:self];
    _assetPicker = [ImagePickerView imagePickerWitWithFrame:self.view.frame
                                                  andTarget:_target
                                                andDelegate:self];
    _assetPicker.imageViewSize = kAlbumThumbNailSize;
    _assetPicker.imageViewUseBounds = YES;
    [self.view addSubview:_assetPicker];
    self.view.backgroundColor = kBGColor();
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

@end