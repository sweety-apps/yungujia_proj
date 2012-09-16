//
//  RegisterViewController.h
//  yungujia
//
//  Created by 波 徐 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField* txtTel;
    UITextField* txtIdentifyCode;
    UITextField* txtName;
    UITextField* txtPassword;
    UITextField* txtConfirmPassword;
    UILabel* lblUserStyle;
    UIPickerView* pickUserStyle;
    NSMutableArray* arrayUserStyle;
}

@property (nonatomic,retain) IBOutlet UITextField* txtTel;
@property (nonatomic,retain) IBOutlet UITextField* txtIdentifyCode;
@property (nonatomic,retain) IBOutlet UITextField* txtName;
@property (nonatomic,retain) IBOutlet UITextField* txtPassword;
@property (nonatomic,retain) IBOutlet UITextField* txtConfirmPassword;
@property (nonatomic,retain) IBOutlet UILabel* lblUserStyle;
@property (nonatomic,retain) IBOutlet UIPickerView* pickUserStyle;
@property (nonatomic,retain) NSMutableArray* arrayUserStyle;
@property (nonatomic,retain) IBOutlet UIButton* btn;
@property (nonatomic,retain) IBOutlet UIButton* btnSend;

-(IBAction)actionSendIdentifyCode:(id)sender;
-(IBAction)actionRegist:(id)sender;
-(IBAction)actionClickBtnUserStyle:(id)sender;
@end
