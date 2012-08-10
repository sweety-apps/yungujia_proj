//
//  Utils.h
//  yungujia
//
//  Created by 波 徐 on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utils : NSObject
+(NSString*)getRequestUrlByRequestName:(NSString*)requestName;
+(void)setAtNavigationBar:(UINavigationBar*)navbar
              withBgImage:(UIImage *)backgroundImage;
+(UIImage*)scaleToSize:(CGSize)size image:(UIImage*)image;
@end

