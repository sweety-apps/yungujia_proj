//
//  sexy_image_rotate.c
//  ImageStretchTest
//
//  Created by Lee Justin on 13-3-19.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include "sexy_image_rotate.h"

Sexy_Sub_Img_Rect_With_Rotation* Sexy_RT_create_rotated_sub_image(Sexy_Raw_Image* rawBmp, int x, int y, int width, int height, double rotation)
{
    Sexy_Sub_Img_Rect_With_Rotation* ret = (Sexy_Sub_Img_Rect_With_Rotation*)calloc(sizeof(Sexy_Sub_Img_Rect_With_Rotation),1);
    ret->rawImage = rawBmp;
    ret->rect.x = x;
    ret->rect.y = y;
    ret->rect.width = width;
    ret->rect.height = height;
    ret->rotation = rotation;
    ret->copiedNormalRectSubBmpBuffer = (unsigned char*)calloc(width * height, 4);
    //TODO: do grab and copy to a new buffer
    
    ////////////////////
    return ret;
}

void Sexy_RT_replace_rotated_sub_image_at_raw_image(Sexy_Sub_Img_Rect_With_Rotation* rotated)
{
    
}

void Sexy_RT_destroy_rotated_sub_image(Sexy_Sub_Img_Rect_With_Rotation* rotated)
{
    if (rotated)
    {
        if (rotated->copiedNormalRectSubBmpBuffer)
        {
            free(rotated->copiedNormalRectSubBmpBuffer);
        }
        free(rotated);
    }
}