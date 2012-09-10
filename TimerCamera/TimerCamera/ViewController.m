//
//  ViewController.m
//  TimerCamera
//
//  Created by lijinxin on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize containerView = _containerView;
@synthesize picutureView = _picutureView;
@synthesize shotBtn = _shotBtn;
@synthesize flashBtn = _flashBtn;
@synthesize positionBtn = _positionBtn;
@synthesize optionBtn = _optionBtn;
@synthesize bottomBar = _bottomBar;

@synthesize imageSaveQueue = _imageSaveQueue;

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _picutureView.hidden = YES;
    
    self.imageSaveQueue = [NSMutableArray array];
    
    [CameraOptions sharedInstance].imagePicker.delegate = self;
    [self.view addSubview:[CameraOptions sharedInstance].imagePicker.view];
    [_containerView retain];
    [_containerView removeFromSuperview];
    [CameraOptions sharedInstance].imagePicker.cameraOverlayView = _containerView;
    [_containerView release];
    [CameraOptions sharedInstance].imagePicker.view.frame = self.view.frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.imageSaveQueue = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"Picture Saved!");
    [self.imageSaveQueue removeObject:image];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"OH YEAH!!! Take a pic, size = (%f,%f)",image.size.width, image.size.height);
    _picutureView.hidden = NO;
    _picutureView.image = image;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"OH YEAH!!! Take a Media");
    UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"OH YEAH!!! Take a pic, size = (%f,%f)",image.size.width, image.size.height);
    _picutureView.hidden = NO;
    _picutureView.image = image;
    
    [self.imageSaveQueue addObject:image];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //save jpeg photo
    if (0)
    {
        NSData* jpg = UIImageJPEGRepresentation(image, 1.0);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"OH NO!!! Picture Take Cancelled");
}

#pragma mark - UINavigationControllerDelegate

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

#pragma mark - UI Event Handle

- (IBAction)OnClickedShot:(id)sender
{
    [[CameraOptions sharedInstance].imagePicker takePicture];
}

#pragma mark - test code

- (void)test
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum/*UIImagePickerControllerSourceTypePhotoLibrary*/]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//UIImagePickerControllerSourceTypeSavedPhotosAlbum;//
        imagePicker.delegate = self;
        [imagePicker setAllowsEditing:YES];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        //self.popoverController = popover;
        [popover presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[popover release];
        [imagePicker release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Error accessing photo library!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)onTest:(id)sender
{
    [self test];
    return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//UIImagePickerControllerSourceTypeCamera;//UIImagePickerControllerSourceTypePhotoLibrary;//
    
    ipc.delegate = self;
    
    ipc.allowsEditing = YES;
    
    ipc.videoQuality = UIImagePickerControllerQualityTypeMedium;
    
    ipc.videoMaximumDuration = 30.0f; // 30 seconds
    
    ///ipc.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    
    //主要是下边的两能数，@"public.movie", @"public.image"  一个是录像，一个是拍照
    
    ipc.mediaTypes = [NSArray arrayWithObjects:@"public.movie", @"public.image", nil];
    
    //ipc.showsCameraControls = NO;
    
    [self presentModalViewController:ipc animated:NO];
    
}

@end
