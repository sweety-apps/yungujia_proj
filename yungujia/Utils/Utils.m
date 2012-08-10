//
//  Utils.m
//  yungujia
//
//  Created by 波 徐 on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

#define REQUESTPLISTNAME @"RequestUrl"

@implementation Utils
+(NSString*)getRequestUrlByRequestName:(NSString*)requestName
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:REQUESTPLISTNAME ofType:@"plist"];
    NSDictionary *urlList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return [urlList objectForKey:requestName];
}

+(void)setAtNavigationBar:(UINavigationBar*)navbar
              withBgImage:(UIImage *)backgroundImage
{  
    if ([navbar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {  
        [navbar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];  
        return;  
    }  
    navbar.layer.contents = (id)backgroundImage.CGImage;  
}

+(UIImage*)scaleToSize:(CGSize)size image:(UIImage*)image
{
	// 创建一个bitmap的context
	// 并把它设置成为当前正在使用的context
	UIGraphicsBeginImageContext(size);
	
	// 绘制改变大小的图片
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	// 从当前context中创建一个改变大小后的图片
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// 使当前的context出堆栈
	UIGraphicsEndImageContext();
	
	// 返回新的改变大小后的图片
	return scaledImage;
}
@end
