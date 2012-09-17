//
//  FeedBackViewController.m
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@end
#define MAX_CHARACTER_NUMBER 140

@implementation FeedBackViewController
@synthesize textEdit;
@synthesize wordLeftLabel;

-(void) createTopBar
{
//    self.tmNavigationBar.leftBarItem = [TXNavigationBarItem itemWithTitle:TCLocalizedString(@"str_close", @"关闭") style:TXNavigationBarItemStyleRound
//                                                                   target:self action:@selector(onClickClose:)];
//    
//    
//    self.tmNavigationBar.rightBarItem = [TXNavigationBarItem itemWithTitle:TCLocalizedString(@"str_send", @"发送") style:TXNavigationBarItemStyleRound
//                                                                    target:self action:@selector(onClickSend:)];
//    
//    [self initTitle];
    UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc] init];
    rightbtn.title = @"确定";
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"意见反馈";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [textEdit becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil]; 
    [self textViewDidChange:textEdit];
    [self createTopBar];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
	NSString *str = [NSString stringWithFormat:@"%d",MAX_CHARACTER_NUMBER- textEdit.text.length];
	wordLeftLabel.text = str;
	int n=MAX_CHARACTER_NUMBER - self.textEdit.text.length;
	if(n>=0)
	{
		wordLeftLabel.textColor = [UIColor lightGrayColor];
	}
	else
	{
		wordLeftLabel.textColor = [UIColor redColor];
	}
}


- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"%f %f",kbSize.width,kbSize.height);
    [self.textEdit setFrame:CGRectMake(0, 0, 320, 416-kbSize.height-26)];
    
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{

}

-(void)rightclick
{
    NSLog(@"onClickOK");
    [(UINavigationController*)self.parentViewController popViewControllerAnimated:YES];
}

@end
