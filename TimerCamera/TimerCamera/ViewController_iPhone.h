//
//  ViewController_iPhone.h
//  TimerCamera
//
//  Created by Lee Justin on 12-9-10.
//
//

#import "ViewController.h"
#import "LoadingAnimateImageView.h"

@interface ViewController_iPhone : ViewController <LoadingAnimateImageViewDelegate>
{
    LoadingAnimateImageView* _laiv;
}

@end
