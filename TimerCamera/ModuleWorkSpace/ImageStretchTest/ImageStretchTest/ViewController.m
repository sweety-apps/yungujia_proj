//
//  ViewController.m
//  ImageStretchTest
//
//  Created by Lee Justin on 13-3-19.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+SexyImageOperation.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView = _imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPressed:(id)sender
{
    self.imageView.image = [_imageView.image testStretchedImage];
}

@end
