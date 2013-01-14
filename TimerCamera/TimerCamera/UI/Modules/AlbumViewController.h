//
//  AlbumViewController.h
//  TimerCamera
//
//  Created by lijinxin on 13-1-14.
//
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController
{
    UIImagePickerController* _albumPickerController;
}

- (void)showAlbumWithAnimation;
- (void)hideAlbumWithAnimation;

@end
