//
//  CustomizedUIImagePickerController.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-11.
//
//

#import <UIKit/UIKit.h>

@interface CustomizedUIImagePickerController : UIImagePickerController <UINavigationControllerDelegate>
{
    
}

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
