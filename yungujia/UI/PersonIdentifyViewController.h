//
//  PersonIdentifyViewController.h
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonIdentifyViewController : UIViewController
<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView* imageview;
    UIImagePickerController *imagePickerController;
}
@property (nonatomic,retain) IBOutlet UIImageView* imageview;
@property (nonatomic, retain) 	UIImagePickerController *imagePickerController;
-(IBAction)onClickCamera:(id)sender;
@end
