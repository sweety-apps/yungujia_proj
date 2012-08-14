//
//  PersonIdentifyViewController.m
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonIdentifyViewController.h"
#import "Utils.h"

@interface PersonIdentifyViewController ()

@end

@implementation PersonIdentifyViewController
@synthesize imageview;
@synthesize imagePickerController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个人验证";
    }
    return self;
}

-(void)dealloc
{
    self.imagePickerController  = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc] init];
    rightbtn.title = @"确定";
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)takePicture:(UIImagePickerControllerSourceType)sourceType
{
    
	NSArray* availabeMediaTypes = nil;
	BOOL isAvailable = [UIImagePickerController isSourceTypeAvailable:sourceType];
	if(isAvailable==FALSE)
	{
		NSLog(@"sorry ,you dont support the device");
		return;
	}else {
		
		availabeMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
	}
	UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
	imgPickerController.sourceType = sourceType;
	imgPickerController.mediaTypes = availabeMediaTypes;
	//imgPickerController.allowsEditing = TRUE;
	//imgPickerController.showsCameraControls = NO;
	imgPickerController.delegate = self;
	
	self.imagePickerController = imgPickerController;
	[self presentModalViewController:imgPickerController animated:TRUE];
	[imgPickerController release];
	
}

-(IBAction)onClickCamera:(id)sender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==FALSE)
    {
        //没有摄像头
        UIImagePickerControllerSourceType type =UIImagePickerControllerSourceTypePhotoLibrary;
        [self takePicture:type];
        return;
    }
    
    NSLog(@"onClickCamera");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"str_upload_pic_video",@"上传图片") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if(actionSheet!=nil)
    {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"str_upload_camera",@"拍照上传")];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"str_upload_library",@"上传本地图片")];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"str_cancel",@"取消")];
        actionSheet.cancelButtonIndex = 2;
        [actionSheet showInView:self.view];
        [actionSheet release];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//
    UIImagePickerControllerSourceType type =UIImagePickerControllerSourceTypeCamera;
    if(buttonIndex==0)
    {
        //拍照
        type =UIImagePickerControllerSourceTypeCamera;
    }else if(buttonIndex==1)
    {
        //上传图片
        type =UIImagePickerControllerSourceTypePhotoLibrary;
    }else {
        return;
    }
    
    [self takePicture:type];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	NSLog(@"User cancel pick");
	[picker dismissModalViewControllerAnimated:TRUE];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	if([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
	{
        UIImage *uiImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        if(uiImage==nil)
        {
            [self.imagePickerController dismissModalViewControllerAnimated:TRUE];
            self.imagePickerController = nil;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"加载图片失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        double MAX_PIXEL = 800.0;
        
        double wr = uiImage.size.width/MAX_PIXEL ;
        double hr = uiImage.size.height/MAX_PIXEL;
        
        double scaleRate = wr>hr?wr:hr;
        if (scaleRate < 1.0) {
            scaleRate = 1.0;
        }
        //LOGA(@"scaleRate: %f", scaleRate);
        
        UIImage *scaledImage = [Utils scaleToSize:CGSizeMake(uiImage.size.width/scaleRate, uiImage.size.height/scaleRate) image:uiImage];
        
        [self.imageview setImage:scaledImage];

        
        [self.imagePickerController dismissModalViewControllerAnimated:TRUE];
        self.imagePickerController = nil;
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(uiImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }	
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
       NSLog(@"保存原图失败");
    }
    else
    {
        NSLog(@"已保存到手机相册");
    }
}

-(void)rightclick
{
    NSLog(@"onClickOK");
    [(UINavigationController*)self.parentViewController popViewControllerAnimated:YES];
}

@end
