//
//  BaseUtilitiesFuncions.m
//  TimerCamera
//
//  Created by lijinxin on 13-1-23.
//
//

#include <sys/time.h>
#include <unistd.h>
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

+ (long long)getCurrentTimeInMicroSeconds
{
    long long timebysec = 0;
	struct timeval tv;
	if(gettimeofday(&tv,NULL)!=0)
		return 0;
	timebysec +=  (long long)tv.tv_sec * 1000000;
	timebysec += tv.tv_usec ;
	return timebysec;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)targetSize
{
    //If scaleFactor is not touched, no scaling will occur
    CGFloat scaleFactor = 1.0;
    
    //Deciding which factor to use to scale the image (factor = targetSize / imageSize)
    if (image.size.width > targetSize.width || image.size.height > targetSize.height)
        if (!((scaleFactor = (targetSize.width / image.size.width)) > (targetSize.height / image.size.height))) //scale to fit width, or
            scaleFactor = targetSize.height / image.size.height; // scale to fit heigth.
    
    UIGraphicsBeginImageContext(targetSize);
    
    //Creating the rect where the scaled image is drawn in
    CGRect rect = CGRectMake((targetSize.width - image.size.width * scaleFactor) / 2,
                             (targetSize.height -  image.size.height * scaleFactor) / 2,
                             image.size.width * scaleFactor, image.size.height * scaleFactor);
    
    //Draw the image into the rect
    [image drawInRect:rect];
    
    //Saving the image, ending image context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
