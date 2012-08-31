//
//  ViewController.m
//  StringHashTest
//
//  Created by Justin Lee on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* a = [NSString stringWithFormat:@"TTTTT.uuuu.hfdaio"];//@"sexy,xeysadfoiasdf.sxey"
    
    for (int i = 0; i < 20; ++i)
    {
        NSString* b = [a copy];
        NSLog(@"a = %u b = %u\n",[a hash],[b hash]);
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
