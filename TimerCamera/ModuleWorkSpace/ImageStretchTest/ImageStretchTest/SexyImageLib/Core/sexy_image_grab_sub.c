//
//  sexy_image_grab_sub.c
//  ImageStretchTest
//
//  Created by lijinxin on 13-3-24.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include "sexy_image_grab_sub.h"
#include "sexy_image_grab_sub_presets.h"

//preset grab styles

SEXY_GRAB_FUNCTION_RETUREN_X_OFFSET_PERCENT Sexy_GS_get_preset_grab_function(char* preset_name)
{
    if (strcmp(preset_name, SEXY_GS_GRAB_FUNCTION_LINEAR) == 0)
    {
        return Sexy_GS_preset_function_linear;
    }
    else if (strcmp(preset_name, SEXY_GS_GRAB_FUNCTION_LINEAR_CURVE) == 0)
    {
        return Sexy_GS_preset_function_linear_curve;
    }
    return NULL;
}

//grab image life-cycle

Sexy_Img_Grab_Sub* Sexy_GS_create_and_grab_sub_image(Sexy_Raw_Image* rawBmp, int x, int y, int width, int height, SEXY_GRAB_FUNCTION_RETUREN_X_OFFSET_PERCENT grabFunc, float grab_x_offset_percents)
{
    //alloc objects
    Sexy_Img_Grab_Sub* ret = (Sexy_Img_Grab_Sub*)calloc(sizeof(Sexy_Img_Grab_Sub), 1);
    
    if (grabFunc == NULL)
    {
        grabFunc = Sexy_GS_get_preset_grab_function(SEXY_GS_GRAB_FUNCTION_LINEAR);
    }
    
    ret->rawImage = rawBmp;
    ret->grab.x = x;
    ret->grab.y = y;
    ret->grab.width = width;
    ret->grab.height = height;
    ret->grab.grabFunc = grabFunc;
    ret->grab.x_offset_percents = grab_x_offset_percents;
    ret->grab.grabbedBmpBuffer = (unsigned char*)calloc(width * height, 4);
    
    //do grab
    int x_off = 0;
    int raw_off = 0;
    int dst_off = 0;
    int len = 0;
    for (int l = 0; l < height; ++ l)
    {
        x_off = (int)(((float)width) * grabFunc(ret, l) + 0.5);
        raw_off = (((y + l) * ret->rawImage->width) + x + x_off) * 4;
        len = width;
        if (x_off + len > ret->rawImage->width)
        {
            len = ret->rawImage->width - x_off;
        }
        dst_off = (l * width) * 4;
        memcpy(&ret->grab.grabbedBmpBuffer[dst_off], &ret->rawImage->bmpBuffer[raw_off], len * 4);
    }
    
    //end
    return ret;
}

void Sexy_GS_replace_grabbed_sub_image_to_raw_image(Sexy_Img_Grab_Sub* grab)
{
    if (grab)
    {
        Sexy_Img_Grab_Sub* ret = grab;
        int width = grab->grab.width;
        int height = grab->grab.height;
        int y = grab->grab.y;
        int x = grab->grab.x;
        SEXY_GRAB_FUNCTION_RETUREN_X_OFFSET_PERCENT grabFunc = grab->grab.grabFunc;
        int x_off = 0;
        int raw_off = 0;
        int dst_off = 0;
        int len = 0;
        for (int l = 0; l < height; ++ l)
        {
            x_off = (int)(((float)width) * grabFunc(ret, l) + 0.5);
            raw_off = (((y + l) * ret->rawImage->width) + x + x_off) * 4;
            len = width;
            if (x_off + len > ret->rawImage->width)
            {
                len = ret->rawImage->width - x_off;
            }
            dst_off = (l * width) * 4;
            if (raw_off >= 0)
            {
                memcpy(&ret->rawImage->bmpBuffer[raw_off], &ret->grab.grabbedBmpBuffer[dst_off], len * 4);
            }
        }
    }
}

void Sexy_GS_destroy_grabbed_sub_image(Sexy_Img_Grab_Sub* grab)
{
    if (grab)
    {
        if (grab->grab.grabbedBmpBuffer)
        {
            free(grab->grab.grabbedBmpBuffer);
        }
        free(grab);
    }
}

void Sexy_GS_switch_width_height_for_sub_image(Sexy_Img_Grab_Sub* grab)
{
    if (grab)
    {
        int width = grab->grab.width;
        int height = grab->grab.height;
        unsigned char* srcBuffer = grab->grab.grabbedBmpBuffer;
        unsigned char* tmpBuffer = (unsigned char*)calloc(width * height, 4);
        int dstOff = 0;
        int srcOff = 0;
        for (int y = 0; y < height; ++y)
        {
            for (int x = 0; x < width; ++x)
            {
                dstOff = ((x * height) + y) * 4;
                srcOff = ((y * width) + x) * 4;
                tmpBuffer[dstOff + 0] = srcBuffer[srcOff + 0];
                tmpBuffer[dstOff + 1] = srcBuffer[srcOff + 1];
                tmpBuffer[dstOff + 2] = srcBuffer[srcOff + 2];
                tmpBuffer[dstOff + 3] = srcBuffer[srcOff + 3];
            }
        }
        memcpy(srcBuffer, tmpBuffer, width * height * 4);
        grab->grab.height = width;
        grab->grab.width = height;
        free(tmpBuffer);
    }
}

void Sexy_GS_do_test_mark_at_sub_image(Sexy_Img_Grab_Sub* grab)
{
    if (grab)
    {
        int width = grab->grab.width;
        int height = grab->grab.height;
        unsigned char* srcBuffer = grab->grab.grabbedBmpBuffer;
        int srcOff = 0;
        for (int y = 0; y < height; ++y)
        {
            for (int x = 0; x < width; ++x)
            {
                srcOff = ((y * width) + x) * 4;
                srcBuffer[srcOff + 0] = 255 - srcBuffer[srcOff + 0];
                srcBuffer[srcOff + 1] = 255 - srcBuffer[srcOff + 1];
                srcBuffer[srcOff + 2] = 255 - srcBuffer[srcOff + 2];
            }
        }
    }
}