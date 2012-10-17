//
//  KaishixunjiaViewController.m
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KaishixunjiaViewController.h"
#import "Utils.h"

@interface KaishixunjiaViewController ()

@end

@implementation KaishixunjiaViewController

@synthesize contentView = _contentView;

@synthesize navbar = _navbar;
@synthesize navctrl =_navctrl;

@synthesize loupan = _loupan;
@synthesize loudong = _loudong;
@synthesize louceng = _louceng;
@synthesize fanghao = _fanghao;

@synthesize btn = _btn;

@synthesize jieguoctrl = _jieguoctrl;

@synthesize xunjiaCtrl = _xunjiaCtrl;
@synthesize loudongCtrl = _loudongCtrl;
@synthesize loucengCtrl = _loucengCtrl;
@synthesize fanghaoCtrl = _fanghaoCtrl;

@synthesize disableLoupanXuanze = _disableLoupanXuanze;

#pragma mark - UIViewController

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
    
    UIImage* btn_img = nil;
    
    btn_img = [UIImage imageNamed:@"buttonn"];
    btn_img = [btn_img stretchableImageWithLeftCapWidth:14 topCapHeight:23];
    [self.btn setBackgroundImage:btn_img forState:UIControlStateNormal];
    
    self.loupan = @"万推花园城";
    self.loudong = @"1栋";
    self.louceng = @"6层";
    self.fanghao = @"605";
    _titles0 = [[NSArray arrayWithObjects:@"楼盘名",@"楼栋",@"楼层",@"房号", nil] retain];
    _titles1 = [[NSArray arrayWithObjects:@"面积（平方米）",@"成交价（万元）", nil] retain];
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_titles0 release];
    [_titles1 release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - KaishixunjiaViewController

- (IBAction)push_XunjiaBtn:(id)sender
{
    _jieguoctrl.title = @"询价结果";
    [self.navigationController pushViewController:_jieguoctrl animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 0)
    {
        UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType != UITableViewCellAccessoryNone)
        {
            if (indexPath.row == 0)
            {
                [self.navigationController popToViewController:xjctrl animated:YES];
            }
            if (indexPath.row == 1)
            {
                [self.navigationController popToViewController:ldctrl animated:YES];
            }
            if (indexPath.row == 2)
            {
                [self.navigationController popToViewController:lcctrl animated:YES];
            }
            if (indexPath.row == 3)
            {
                [self.navigationController popToViewController:fhctrl animated:YES];
            }
            //[self.navigationController pushViewController:_kaishixunjiactrl animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0)
    {
        [_values0 release];
        _values0 = [[NSArray arrayWithObjects:_loupan,_loudong,_louceng,_fanghao, nil] retain];
        return 4;
    }
    else
    {
        [_values1 release];
        _values1 = [[NSArray arrayWithObjects:@"",@"", nil]retain];
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    
    if (tableView.tag == 0)
    {
        NSString* reuseID = @"KaishixunjiaLoupanCell";
        
        KaishixunjiaLoupanCell *cell = (KaishixunjiaLoupanCell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
        if (cell == nil)
        {
            // Create a temporary UIViewController to instantiate the custom cell.
            KaishixunjiaLoupanCellViewController* temporaryController = [[KaishixunjiaLoupanCellViewController alloc] initWithNibName:@"KaishixunjiaLoupanCellViewController" bundle:nil];
            // Grab a pointer to the custom cell.
            cell = (KaishixunjiaLoupanCell *)temporaryController.view;
            cell.title.text = [_titles0 objectAtIndex:row];
            cell.value.text = [_values0 objectAtIndex:row];
            [temporaryController release];
        }
        if (row == 0 || _disableLoupanXuanze)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }
    else
    {
        NSString* reuseID = @"KaishixunjiaCell1Cell";
        
        KaishixunjiaCell1Cell *cell = (KaishixunjiaCell1Cell*)[tableView dequeueReusableCellWithIdentifier:reuseID];
        if (cell == nil)
        {
            // Create a temporary UIViewController to instantiate the custom cell.
            KaishixunjiaCell1ViewController* temporaryController = [[KaishixunjiaCell1ViewController alloc] initWithNibName:@"KaishixunjiaCell1ViewController" bundle:nil];
            // Grab a pointer to the custom cell.
            cell = (KaishixunjiaCell1Cell *)temporaryController.view;
            cell.title.text = [_titles1 objectAtIndex:row];
            [temporaryController release];
        }
        
        cell.detail.delegate = self;
        
        switch (row)
        {
            case 0:
                _mianji = cell.detail;
                break;
            case 1:
                _chengjiaojia = cell.detail;
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    
    
    
    //cell.xxhao.text = [NSString stringWithFormat:@"50%d",row + 1];
    //cell.xxhuayuan.text = @"万科金色家园";
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return nil;
}

- (void)doHideKeyBoard
{
    [_mianji resignFirstResponder];
    [_chengjiaojia resignFirstResponder];
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

@end
