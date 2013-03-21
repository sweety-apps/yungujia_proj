//
//  UIImage+SexyImageOperation.m
//  ImageStretchTest
//
//  Created by Lee Justin on 13-3-19.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#import "UIImage+SexyImageOperation.h"
#import "sexy_image_lib_core.h"

#define RGBA        4
#define RGBA_8_BIT  8

@implementation UIImage (SexyImageOperation)


- (UIImage*) testStretchedImage
{
    CGContextRef context = [self createBitmapContext];
    unsigned char* buf = CGBitmapContextGetData(context);
    int width = self.size.width;
    int height = self.size.height;
    
    Sexy_Img_Stretch* stretch = NULL;
    
    Sexy_init_all();
    
    stretch = Sexy_IS_create_no_copy(buf, width, height);
    
    Sexy_IS_set_stretch_style(stretch, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 0.25);
    
    Sexy_IS_do_stretch(stretch);
    
    Sexy_IS_destory(stretch);
    
    Sexy_uninit_all();
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    return [UIImage imageWithCGImage:cgImage];
}


- (CGImageRef) blerg
{
    CGFloat imageScale = (CGFloat)1.0;
    CGFloat width = (CGFloat)180.0;
    CGFloat height = (CGFloat)180.0;
    
    imageScale = (CGFloat)2.0;
    
    // Create a bitmap graphics context of the given size
    //
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width * imageScale, height * imageScale, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    
    // Draw ...
    //
    CGContextSetRGBFillColor(context, (CGFloat)0.0, (CGFloat)0.0, (CGFloat)0.0, (CGFloat)1.0 );
    // …
    
    
    // Get your image
    //
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return cgImage;
}


- (CGContextRef) createBitmapContext {
    
    size_t bytesPerRow;
    size_t byteCount;
    size_t pixelCount;
    
    CGContextRef context;
    CGColorSpaceRef colorSpace;
    
    UInt8 *pixelByteData;
    // A pointer to an array of RGBA bytes in memory
    void* pixelData;
    
    NSLog( @"Returning bitmap representation of UIImage." );
    // 8 bits each of red, green, blue, and alpha.
    bytesPerRow = self.size.width * RGBA;
    byteCount = bytesPerRow * self.size.height;
    pixelCount = self.size.width * self.size.height;
    
    // Create RGB color space
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (!colorSpace)
    {
        NSLog(@"Error allocating color space.");
        return nil;
    }
    
    pixelByteData = malloc(byteCount);
    
    if (!pixelByteData)
    {
        NSLog(@"Error allocating bitmap memory. Releasing color space.");
        CGColorSpaceRelease(colorSpace);
        
        return nil;
    }
    
    // Create the bitmap context.
    // Pre-multiplied RGBA, 8-bits per component.
    // The source image format will be converted to the format specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate(
                                           (void*)pixelByteData,
                                           self.size.width,
                                           self.size.height,
                                           RGBA_8_BIT,
                                           bytesPerRow,
                                           colorSpace,
                                           kCGImageAlphaPremultipliedLast
                                           );
    
    // Make sure we have our context
    if (!context)   {
        free(pixelByteData);
        NSLog(@"Context not created!");
    }
    
    // Draw the image to the bitmap context.
    // The memory allocated for the context for rendering will then contain the raw image pixelData in the specified color space.
    CGRect rect = { { 0 , 0 }, { self.size.width, self.size.height } };
    
    CGContextDrawImage( context, rect, self.CGImage );
    
    // Now we can get a pointer to the image pixelData associated with the bitmap context.
    pixelData = CGBitmapContextGetData(context);
    
    
    
    return context;
}

- (void)releaseBitmapContext:(CGContextRef)context
{
    //need to release more memory
    CGContextRelease(context);
}

@end
