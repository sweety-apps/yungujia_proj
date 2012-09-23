//
//  GengduoWarpperViewController.m
//  yungujia
//
//  Created by lijinxin on 12-9-24.
//
//

#import "GengduoWarpperViewController.h"

@interface GengduoWarpperViewController ()

@end

@implementation GengduoWarpperViewController

@synthesize navbar;
@synthesize rootCtrl;
@synthesize navctrl = _navctrl;
@synthesize gengduoCtrl;

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
    // Do any additional setup after loading the view from its nib.
    rootCtrl.title = @"更多";
    [self.view addSubview:_navctrl.view];
    gengduoCtrl = [[GengDuoViewController alloc] initWithNibName:@"GengDuoViewController" bundle:nil];
    
    gengduoCtrl.navctrl = _navctrl;
    gengduoCtrl.navbar = navbar;
    [rootCtrl.view addSubview:gengduoCtrl.view];
}

- (void)viewDidUnload
{
    //
    [super viewDidUnload];
    //
    [gengduoCtrl release];
    gengduoCtrl = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
