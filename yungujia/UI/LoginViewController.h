//
//  LoginView.h
//  yungujia
//
//  Created by lijinxin on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    
}

@property (nonatomic,retain) IBOutlet UITextField* inputusername;
@property (nonatomic,retain) IBOutlet UITextField* inputpassword;
-(IBAction)actionNormalLogin:(id)sender;
-(IBAction)actionRegist:(id)sender;
@end
