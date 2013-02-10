//
//  CustomizedUIImagePickerController.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-11.
//
//

#import "CustomizedUIImagePickerController.h"
#import "CustomizedUIImagePickerNavigationBar.h"

@interface CustomizedUIImagePickerController ()

@end

@implementation CustomizedUIImagePickerController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)setUpNavBar
{
    CGRect rect = self.navigationBar.frame;
    rect.origin = CGPointZero;
    CustomizedUIImagePickerNavigationBar* bar = [[[CustomizedUIImagePickerNavigationBar alloc] initWithFrame:rect] autorelease];
    [bar.cancelBtn.button addTarget:self action:@selector(onPushedCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [bar.backBtn.button addTarget:self action:@selector(onPushedBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self viewControllers].count <= 1)
    {
        bar.backBtn.hidden = YES;
    }
    
    [self.view addSubview:bar];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setUpNavBar];
    //self.navigationBar.alpha = 0.0;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)onPushedBackBtn
{
    [self popViewControllerAnimated:YES];
}

- (void)onPushedCancelBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
    {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

@end
