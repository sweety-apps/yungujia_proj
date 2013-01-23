//
//  BaseUtilitiesFuncions.m
//  TimerCamera
//
//  Created by lijinxin on 13-1-23.
//
//

#import "BaseUtilitiesFuncions.h"
#import <QuartzCore/QuartzCore.h>

@implementation BaseUtilitiesFuncions

+(UIImage *)grabUIView:(UIView *)view
{
    UIImage* retImage = nil;
    
    if (view)
    {
        //支持retina高分的关键
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(view.frame.size);
        }
        
        //获取图像
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        retImage = image;
        
        //保存图像
        NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/testGrab.png"];
        if ([UIImagePNGRepresentation(image) writeToFile:path atomically:YES]) {
            NSLog(@"Succeeded! %@",path);
        }
        else {
            NSLog(@"Failed!");
        }
    }
    
    return retImage;
}

@end
