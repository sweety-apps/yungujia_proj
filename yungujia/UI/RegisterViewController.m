//
//  RegisterViewController.m
//  yungujia
//
//  Created by 波 徐 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"


@implementation UITextField (HideKeyBoard)
- (void) hideKeyBoard:(UIView*)view{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(doHideKeyBoard)];
    
    tap.numberOfTapsRequired = 1;
    for (int i = 0; i<[[view subviews] count]; i++) {
        if (![view isKindOfClass:[UITextField class]]) {
            [view  addGestureRecognizer: tap];
        }
    }
    [tap setCancelsTouchesInView:NO];
    [tap release];
}
//- (void)doHideKeyBoard{
//    [txtTel resignFirstResponder];
//}
@end

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
@synthesize btn;
@synthesize btnSend;

-(void)buildDataSource
{
    self.arrayUserStyle = [[NSMutableArray alloc] initWithObjects:@"网友",@"房地产从业者",@"金融行业从业者", nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"新用户注册";
        [self buildDataSource];
        [self.lblUserStyle setText:[self.arrayUserStyle objectAtIndex:0]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect rect = self.navigationController.navigationBar.frame;
    UIImage* navBgImg = [UIImage imageNamed:@"naviBarBg.png"];
    navBgImg = [navBgImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [Utils setAtNavigationBar:self.navigationController.navigationBar withBgImage:navBgImg];
    self.navigationController.navigationBar.frame = rect;
    
    UIImage* btn_img = nil;
    
    btn_img = [UIImage imageNamed:@"buttonn"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btn setBackgroundImage:btn_img forState:UIControlStateNormal];
    
    btn_img = [UIImage imageNamed:@"btnGray"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btnSend setBackgroundImage:btn_img forState:UIControlStateNormal];

//    [self.txtTel hideKeyBoard:self.view];
//    
//    [self.txtName hideKeyBoard:self.view];
//    [self.txtPassword hideKeyBoard:self.view];
//    [self.txtIdentifyCode hideKeyBoard:self.view];
//    [self.txtConfirmPassword hideKeyBoard:self.view];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)doHideKeyBoard{
    [self.txtTel resignFirstResponder];
    [self.txtName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtIdentifyCode resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
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

#pragma mark UIPickerWithToolBarViewDelegate
-(void)onPushedToolBarDoneButton:(UIPickerWithToolBarView*)pickerView
{
    [self.lblUserStyle setText:[self.arrayUserStyle objectAtIndex:[pickerView selectedRowInComponent:0]]];
    [self.pickUserStyle setHidden:true];
}

#pragma mark actions

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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGPoint center = CGPointMake(160.0,208.0);
    self.view.center = center;
    [UIView commitAnimations];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing
{
    CGPoint center = CGPointMake(160.0,208.0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    switch ([textField tag]) {
        case 0://电话
            self.view.center = center;
            break;
        case 1://验证码
            self.view.center = center;
            break;
        case 2://姓名
            self.view.center = CGPointMake(center.x, center.y - 70);
            break;
        case 3://密码
            self.view.center = CGPointMake(center.x, center.y - 190);
            break;
        case 4://确认密码
            self.view.center = CGPointMake(center.x, center.y - 190);
            break;
        default:
            break;
    }
    [UIView commitAnimations];
    [textField resignFirstResponder];
    [self.pickUserStyle setHidden:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* dequeueIdentifer = @"UITableViewCell";
    UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeueIdentifer] autorelease];
        if (indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    return cell;
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
//    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
//    if (self.view.frame.origin.y == 0) {
//        [self moveviewsup:-128];
//    }
//    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    //    self.view.center=CGPointMake(self.view.center.x,80);
//    [self moveviewsup:128];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGPoint center = CGPointMake(160.0,208.0);
    [self.view setCenter:center];
    [UIView commitAnimations];
    
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
}

-(void)moveviewsup:(int)distance
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    //    for (int i = 0; i<[self.view.subviews count]; i++) {
    UIView* view = self.view;//[self.view.subviews objectAtIndex:i];
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + distance, view.frame.size.width, view.frame.size.height);
    //    }
    [UIView commitAnimations];
}

@end
