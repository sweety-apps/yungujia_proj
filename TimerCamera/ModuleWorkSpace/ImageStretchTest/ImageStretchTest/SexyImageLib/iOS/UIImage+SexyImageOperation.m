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
    
    
    ////////do stretch test
    Sexy_Raw_Image* raw = NULL;
    Sexy_Img_Grab_Sub* subLeg = NULL;
    Sexy_Img_Grab_Sub* subBreast = NULL;
    Sexy_Img_Grab_Sub* subMid = NULL;
    Sexy_Img_Grab_Sub* subBack = NULL;
    Sexy_Img_Grab_Sub* subRotateUp = NULL;
    Sexy_Img_Grab_Sub* subRotateDown = NULL;
    Sexy_Img_Stretch* stretchLeg = NULL;
    Sexy_Img_Stretch* stretchBreast = NULL;
    Sexy_Img_Stretch* stretchMid = NULL;
    Sexy_Img_Stretch* stretchBack = NULL;
    Sexy_Img_Stretch* stretchBody = NULL;
    Sexy_Img_Stretch* stretchUp = NULL;
    Sexy_Img_Stretch* stretchDown = NULL;
    
    
    Sexy_init_all();
    
    //
    raw = Sexy_Raw_create_no_copy(buf, width, width * RGBA, height);
    
    
#if 1
    // leg stretch
    subLeg = Sexy_GS_create_and_grab_sub_image(raw, 0, height * 0.5, width, height * 0.5, Sexy_GS_get_preset_grab_function(SEXY_GS_GRAB_FUNCTION_LINEAR), 0.0);
    
    stretchLeg = Sexy_IS_create_no_copy(subLeg->grab.grabbedBmpBuffer, subLeg->grab.width, subLeg->grab.height);
    
    Sexy_IS_set_stretch_style(stretchLeg, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR_CURVE), 0.85, kSexy_Stretch_Both_Side);
    //Sexy_IS_set_stretch_style(stretchLeg, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 0.8);
    
    Sexy_IS_do_stretch(stretchLeg);
    
    Sexy_IS_destory(stretchLeg);
    
    Sexy_GS_replace_grabbed_sub_image_to_raw_image(subLeg);
    
    Sexy_GS_destroy_grabbed_sub_image(subLeg);
    
    
    // breast stretch
    subBreast = Sexy_GS_create_and_grab_sub_image(raw, 0, height * 0.15, width, height * 0.35, Sexy_GS_get_preset_grab_function(SEXY_GS_GRAB_FUNCTION_LINEAR), 0.0);
    
    stretchBreast = Sexy_IS_create_no_copy(subBreast->grab.grabbedBmpBuffer, subBreast->grab.width, subBreast->grab.height);
    
    Sexy_IS_set_stretch_style(stretchBreast, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR_CURVE), 1.2, kSexy_Stretch_Only_Left_Side);
    //Sexy_IS_set_stretch_style(stretchLeg, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 0.8);
    
    Sexy_IS_do_stretch(stretchBreast);
    
    Sexy_IS_destory(stretchBreast);
    
    Sexy_GS_replace_grabbed_sub_image_to_raw_image(subBreast);
    
    Sexy_GS_destroy_grabbed_sub_image(subBreast);
    
    
    // middle stretch
    subMid = Sexy_GS_create_and_grab_sub_image(raw, 0, height * 0.32, width, height * 0.15, Sexy_GS_get_preset_grab_function(SEXY_GS_GRAB_FUNCTION_LINEAR), 0.32);
    
    stretchMid = Sexy_IS_create_no_copy(subMid->grab.grabbedBmpBuffer, subMid->grab.width, subMid->grab.height);
    
    Sexy_IS_set_stretch_style(stretchMid, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR_CURVE), 0.9, kSexy_Stretch_Only_Left_Side);
    //Sexy_IS_set_stretch_style(stretchLeg, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 0.8);
    
    Sexy_IS_do_stretch(stretchMid);
    
    Sexy_IS_destory(stretchMid);
    
    Sexy_GS_replace_grabbed_sub_image_to_raw_image(subMid);
    
    Sexy_GS_destroy_grabbed_sub_image(subMid);
    
    
    // back stretch
    subBack = Sexy_GS_create_and_grab_sub_image(raw, 155, 137, 44, 90, Sexy_GS_get_preset_grab_function(SEXY_GS_GRAB_FUNCTION_LINEAR), 0.45);
    
    //Sexy_GS_do_test_mark_at_sub_image(subBack);
    
    stretchBack = Sexy_IS_create_no_copy(subBack->grab.grabbedBmpBuffer, subBack->grab.width, subBack->grab.height);
    
    Sexy_IS_set_stretch_style(stretchBack, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR_CURVE), 1.25, kSexy_Stretch_Both_Side);
    //Sexy_IS_set_stretch_style(stretchLeg, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 0.8);
    
    Sexy_IS_do_stretch(stretchBack);
    
    Sexy_IS_destory(stretchBack);
    
    Sexy_GS_replace_grabbed_sub_image_to_raw_image(subBack);
    
    Sexy_GS_destroy_grabbed_sub_image(subBack);
    
    
    
    // body stretch
    stretchBody = Sexy_IS_create_no_copy(raw->bmpBuffer, raw->width, raw->height);
    
    Sexy_IS_set_stretch_style(stretchBody, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 0.7, kSexy_Stretch_Both_Side);
    
    Sexy_IS_do_stretch(stretchBody);
    
    Sexy_IS_destory(stretchBody);
    
#endif
    int movedUpPix = (int)(0.4 * 0.5 * 0.1 * (float)height + 0.5);
    
    // rotate and stretch Up part
    subRotateUp = Sexy_GS_create_and_grab_sub_image(raw, 0, 0, width, height * 0.4, Sexy_GS_get_preset_grab_function(SEXY_GS_GRAB_FUNCTION_LINEAR), 0.0);
    
    Sexy_GS_switch_width_height_for_sub_image(subRotateUp);
    
    stretchUp = Sexy_IS_create_no_copy(subRotateUp->grab.grabbedBmpBuffer, subRotateUp->grab.width, subRotateUp->grab.height);
    
    Sexy_IS_set_stretch_style(stretchUp, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 0.9, kSexy_Stretch_Only_Left_Side);
    //Sexy_IS_set_stretch_style(stretchLeg, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 0.8);
    
    Sexy_IS_do_stretch(stretchUp);
    
    Sexy_IS_destory(stretchUp);
    
    Sexy_GS_switch_width_height_for_sub_image(subRotateUp);
    
    subRotateUp->grab.y -= movedUpPix;
    
    Sexy_GS_replace_grabbed_sub_image_to_raw_image(subRotateUp);
    
    Sexy_GS_destroy_grabbed_sub_image(subRotateUp);
    
    //move up down part
    subRotateDown = Sexy_GS_create_and_grab_sub_image(raw, 0, height * 0.4, width, height * 0.6, Sexy_GS_get_preset_grab_function(SEXY_GS_GRAB_FUNCTION_LINEAR), 0.0);
    
    subRotateDown->grab.y -= movedUpPix;
    
    Sexy_GS_replace_grabbed_sub_image_to_raw_image(subRotateDown);
    
    Sexy_GS_destroy_grabbed_sub_image(subRotateDown);
    
#if 1
    // rotate and stretch Down part
    subRotateDown = Sexy_GS_create_and_grab_sub_image(raw, 0, 0, width, height, Sexy_GS_get_preset_grab_function(SEXY_GS_GRAB_FUNCTION_LINEAR), 0.0);
    
    Sexy_GS_switch_width_height_for_sub_image(subRotateDown);
    
    stretchDown = Sexy_IS_create_no_copy(subRotateDown->grab.grabbedBmpBuffer, subRotateDown->grab.width, subRotateDown->grab.height);
    
    Sexy_IS_set_stretch_style(stretchDown, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 1.0 + (2.0 * ((float)movedUpPix + 2.0)/((float)height)), kSexy_Stretch_Only_Right_Side);
    //Sexy_IS_set_stretch_style(stretchLeg, Sexy_IS_get_preset_stretch_style(SEXY_IS_STRETCH_STYLE_LINEAR), 0.8);
    
    Sexy_IS_do_stretch(stretchDown);
    
    Sexy_IS_destory(stretchDown);
    
    Sexy_GS_switch_width_height_for_sub_image(subRotateDown);
    
    Sexy_GS_replace_grabbed_sub_image_to_raw_image(subRotateDown);
    
    Sexy_GS_destroy_grabbed_sub_image(subRotateDown);
#endif
    
    
    
    //
    Sexy_Raw_destory(raw);
    
    Sexy_uninit_all();
    ////////end of do stretch test
    
    
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
