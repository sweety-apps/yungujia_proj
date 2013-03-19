//
//  sexy_image_rotate.h
//  ImageStretchTest
//
//  Created by Lee Justin on 13-3-19.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#ifndef ImageStretchTest_sexy_image_rotate_h
#define ImageStretchTest_sexy_image_rotate_h

#include "sexy_image_base.h"

typedef struct tagSexy_Sub_Img_Rect_With_Rotation{
    Sexy_Raw_Image* rawImage;
    struct tagRect{
        int x;
        int y;
        int width;
        int height;
    } rect;
    double rotation;// compared X.X% to M_PI
    unsigned char* copiedNormalRectSubBmpBuffer;
}Sexy_Sub_Img_Rect_With_Rotation;

Sexy_Sub_Img_Rect_With_Rotation* Sexy_RT_create_rotated_sub_image(Sexy_Raw_Image* rawBmp, int x, int y, int width, int height, double rotation);

void Sexy_RT_replace_rotated_sub_image_at_raw_image(Sexy_Sub_Img_Rect_With_Rotation* rotated);

void Sexy_RT_destroy_rotated_sub_image(Sexy_Sub_Img_Rect_With_Rotation* rotated);

#endif
