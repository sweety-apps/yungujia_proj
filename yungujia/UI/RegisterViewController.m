//
//  RegisterViewController.m
//  yungujia
//
//  Created by 波 徐 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"

@interface RegisterViewController (private)

-(void)buildDataSource;
@end

@implementation RegisterViewController
@synthesize txtTel;
@synthesize txtName;
@synthesize txtPassword;
@synthesize lblUserStyle;
@synthesize txtIdentifyCode;
@synthesize txtConfirmPassword;
@synthesize pickUserStyle;
@synthesize arrayUserStyle;

-(void)buildDataSource
{
    self.arrayUserStyle = [[NSMutableArray alloc] initWithObjects:@"网友",@"房地产从业者",@"金融行业从业者", nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"注册";
        [self buildDataSource];
        [self.lblUserStyle setText:[self.arrayUserStyle objectAtIndex:0]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(void)dealloc
{
    [self.arrayUserStyle release];
    [super dealloc];
}

#pragma mark -pickdelegate 
// returns width of column and height of row for each component. 
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 320.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}
// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse. 
// If you return back a different object, the old one will be released. the view will be centered in the row rect  
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.arrayUserStyle objectAtIndex:row];
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d",row);
    [self.lblUserStyle setText:[self.arrayUserStyle objectAtIndex:row]];
    [self.pickUserStyle setHidden:true];
}

#pragma mark -pickdatasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}


-(IBAction)actionSendIdentifyCode:(id)sender
{
    
}

-(IBAction)actionRegist:(id)sender
{
    NSLog(@"actionRegist");
    //账户名姓名+电话号码，以防重复
    NSString* accountname = [NSString stringWithFormat:@"%@+%@",txtName.text,txtTel.text];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] ShowMainView:txtName.text weiboaccount:accountname];
}

-(IBAction)actionClickBtnUserStyle:(id)sender
{
    [self.pickUserStyle setHidden:false];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    if ([[textField text] length] != 0) {
        switch ([textField tag]) {
            case 0://电话
                
                break;
            case 1://验证码
                
                break;
            case 2://姓名
                
                break;
            case 3://密码
                
                break;
            case 4://确认密码
                
                break;
            default:
                break;
        }
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    return YES;
}
@end
