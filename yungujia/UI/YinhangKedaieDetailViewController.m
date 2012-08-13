//
//  YinhangKedaieDetailViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "YinhangKedaieDetailViewController.h"

@interface YinhangKedaieDetailViewController ()

@end

@implementation YinhangKedaieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)dealloc
{
    [_daikuanchengshuarray release];
    [_section0Dict release];
    [_section1Dict release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _section0Dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"1可贷金额",@"2评估价",@"3净值",@"4税费",@"5贷款成数",nil] forKeys:[NSArray arrayWithObjects:@"234万",@"320万",@"298万",@"23万",@"七成",nil]];
    
    _section1Dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"还款方式",@"贷款年限",@"年利率",@"月供",nil] forKeys:[NSArray arrayWithObjects:@"等额",@"20年",@"2012/5/21基准6.80%",@"7.633.40",nil]];
    
    _daikuanchengshuarray = [[NSArray alloc] initWithObjects:@"9成",@"8成",@"7成",nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString* dequeueIdentifer = @"section0cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] init]autorelease];
            cell.textLabel.text = [[_section0Dict allValues] objectAtIndex:indexPath.row];
            NSLog(@"%@",[[_section0Dict allValues] objectAtIndex:indexPath.row]);
            UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 120, 20)];
            lbl.text = [[_section0Dict allKeys] objectAtIndex:indexPath.row];
            lbl.textAlignment = UITextAlignmentRight;
            [cell addSubview:lbl];
            [lbl release];
            [cell setBackgroundColor:[UIColor clearColor]];
            if (indexPath.row == 4) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else {
            
        }
        return cell;
    }
    else {
        static NSString* dequeueIdentifer = @"section1cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] init]autorelease];
            cell.textLabel.text = [[_section1Dict allValues] objectAtIndex:indexPath.row];
            UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 120, 10)];
            lbl.text = [[_section1Dict allKeys] objectAtIndex:indexPath.row];
            [cell addSubview:lbl];
            [lbl release];
            [cell setBackgroundColor:[UIColor clearColor]];
            if (indexPath.row == 3 || indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else {
            
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    return [_daikuanchengshuarray objectAtIndex:row];
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d",row);
//    [self.lblUserStyle setText:[self.arrayUserStyle objectAtIndex:row]];
//    [self.pickUserStyle setHidden:true];
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

@end
