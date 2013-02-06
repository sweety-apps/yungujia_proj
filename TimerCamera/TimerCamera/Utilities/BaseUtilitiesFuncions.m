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
    //if (image.size.width > targetSize.width || image.size.height > targetSize.height)
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

// get sub image
+ (UIImage*) getSubImageFrom: (UIImage*) img WithRect: (CGRect) rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
    
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    // draw image
    [img drawInRect:drawRect];
    
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return subImage;
}

+ (UIImage*)scaleAndCropImage:(UIImage*)img CropSize:(CGSize)size
{
    float rawRatio = img.size.width / img.size.height;
    float newRatio = size.width / size.height;
    BOOL scaleFitToWidth = rawRatio > newRatio ? NO : YES;
    CGSize scaleSize = size;
    if (scaleFitToWidth)
    {
        scaleSize.height = size.width / rawRatio;
    }
    else
    {
        scaleSize.width = size.height * rawRatio;
    }
    //scale
    img = [BaseUtilitiesFuncions scaleImage:img toSize:scaleSize];
    CGRect subRect = CGRectZero;
    subRect.size = size;
    subRect.origin.x = (scaleSize.width - size.width) * 0.5;
    subRect.origin.y = (scaleSize.height - size.height) * 0.5;
    //grab sub image
    img = [BaseUtilitiesFuncions getSubImageFrom:img WithRect:subRect];
    return img;
}

@end
