//
//  SousuoloupanViewController.m
//  yungujia
//
//  Created by lijinxin on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SousuoloupanViewController.h"

@interface SousuoloupanViewController ()

@end

@implementation SousuoloupanViewController

@synthesize searchbar = _searchbar;
@synthesize navbar = _navbar;
@synthesize navctrl = _navctrl;
@synthesize loupanctrl = _loupanctrl;

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
    [self.view addSubview:_loupanctrl.view];
    CGRect rect = _loupanctrl.view.frame;
    rect.origin.y = _searchbar.frame.size.height;
    rect.origin.x = 0.f;
    _loupanctrl.view.frame = rect;
    _loupanctrl.headinfo = @"搜索结果3条";
    _loupanctrl.navbar = self.navbar;
    _loupanctrl.navctrl = self.navctrl;
    _loupanctrl.hideXXminei = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(doHideKeyBoard)];
    
    tap.numberOfTapsRequired = 1;
    for (int i = 0; i<[[self.view subviews] count]; i++) {
        if (![self.view isKindOfClass:[UITextField class]]) {
            [self.view  addGestureRecognizer: tap];
        }
    }
    [tap setCancelsTouchesInView:NO];
    [tap release];
}

- (void)viewDidUnload
{
    [_loupanctrl.view removeFromSuperview];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark SousuoloupanViewController

- (void)doHideKeyBoard
{
    [_searchbar resignFirstResponder];
}

#pragma mark UISearchBarDelegate

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
}

@end
