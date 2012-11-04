//
//  ViewController_iPhone.m
//  TimerCamera
//
//  Created by Lee Justin on 12-9-10.
//
//

#import "ViewController_iPhone.h"

@interface ViewController_iPhone ()

@end

@implementation ViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _laiv = [[LoadingAnimateImageView viewWithDelegate:self image:[UIImage imageNamed:@"/Resource/Picture/camera_open"] forTimeInterval:5.0] retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_laiv)
    {
        [self.view addSubview:_laiv];
        [self.view bringSubviewToFront:_laiv];
        [_laiv startLoadingAnimation];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark LoadingAnimateImageViewDelegate

- (void)onFinishedLoadingAnimation
{
    [_laiv removeFromSuperview];
    ReleaseAndNil(_laiv);
}


@end
