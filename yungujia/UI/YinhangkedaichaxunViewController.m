//
//  YinhangkedaichaxunViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YinhangkedaichaxunViewController.h"
#import "Utils.h"

@interface YinhangkedaichaxunViewController ()

@end

@implementation YinhangkedaichaxunViewController

@synthesize btn = _btn;

@synthesize contentView = _contentView;
@synthesize textField = _textField;

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;

@synthesize goumainianxianSeg = _goumainianxianSeg;
@synthesize wuyeleixingSeg = _wuyeleixingSeg;
@synthesize chanquanguishuSeg = _chanquanguishuSeg;

@synthesize pickerContents = _pickerContents;
@synthesize pickerView = _pickerView;

@synthesize gyhkdectrl = _gyhkdectrl;

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
    
    ((UIScrollView*)(self.view)).contentSize = _contentView.frame.size;
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _pickerContents = [[NSMutableArray arrayWithObjects:@"421809123元(世联评估)",@"1809123元(自动评估)",@"409123元(同致城)", nil] retain];
    
    UIImage* btn_img = nil;
    
    btn_img = [UIImage imageNamed:@"buttonn"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btn setBackgroundImage:btn_img forState:UIControlStateNormal];
    
    
    CGRect rect = _goumainianxianSeg.frame;
    rect.size.height = 34;
    _goumainianxianSeg.frame = rect;
    UISegmentedControl* seg = _goumainianxianSeg;
    for (int i = 0; i < [seg numberOfSegments]; ++i)
    {
        [seg setWidth:0 forSegmentAtIndex:i];
    }
    
    rect = _wuyeleixingSeg.frame;
    rect.size.height = 34;
    _wuyeleixingSeg.frame = rect;
    seg = _goumainianxianSeg;
    for (int i = 0; i < [seg numberOfSegments]; ++i)
    {
        [seg setWidth:0 forSegmentAtIndex:i];
    }
    
    rect = _chanquanguishuSeg.frame;
    rect.size.height = 34;
    _chanquanguishuSeg.frame = rect;
    seg = _goumainianxianSeg;
    for (int i = 0; i < [seg numberOfSegments]; ++i)
    {
        [seg setWidth:0 forSegmentAtIndex:i];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [_pickerContents release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIResponder

//自动隐藏输入键盘

#pragma mark - YinhangkedaichaxunViewController

- (IBAction)push_Kaishijisuan:(id)sender
{
    _gyhkdectrl.title = @"各银行可贷额";
    [self.navigationController pushViewController:_gyhkdectrl animated:YES];
}

- (IBAction)push_Pinggujia:(id)sender
{
    ((UIScrollView*)self.view).scrollEnabled = NO;
    _pickerView.hidden = NO;
}

#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerContents count];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row < 0 || row > [_pickerContents count])
    {
        return @"";
    }
    return (NSString*)[_pickerContents objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

#pragma mark UIPickerWithToolBarViewDelegate
-(void)onPushedToolBarDoneButton:(UIPickerWithToolBarView*)pickerView
{
    //[self.lblUserStyle setText:[self.arrayUserStyle objectAtIndex:[pickerView selectedRowInComponent:0]]];
    _pickerView.hidden = YES;
    ((UIScrollView*)self.view).scrollEnabled = YES;
}

-(void)moveviewsup:(int)distance
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    for (int i = 0; i<[self.view.subviews count]; i++) {
        UIView* view = [self.view.subviews objectAtIndex:i];
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + distance, view.frame.size.width, view.frame.size.height);
    }
    [UIView commitAnimations];
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    [self moveviewsup:-200];
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    
    [Utils enableKeyboardAutoHideFor:_contentView forTextField:_textField];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    [self moveviewsup:200];
    NSLog(@"%f %f",self.view.center.x,self.view.center.y);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    //    self.view.center=CGPointMake(160,208); 
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseID = @"UITableViewCell";
    
    int row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID] autorelease];
    }
    
    return cell;
}

@end
