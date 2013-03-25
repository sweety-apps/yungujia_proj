//
//  sexy_image_grab_sub.h
//  ImageStretchTest
//
//  Created by lijinxin on 13-3-24.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#ifndef ImageStretchTest_sexy_image_grab_sub_h
#define ImageStretchTest_sexy_image_grab_sub_h

#include "sexy_image_base.h"

//availiable for RGBA format with 32-bits pixels

//structure defines

typedef struct tagSexy_Img_Grab_Sub Sexy_Img_Grab_Sub;

typedef float (*SEXY_GRAB_FUNCTION_RETUREN_X_OFFSET_PERCENT) (Sexy_Img_Grab_Sub* grab, int lineNum);

struct tagSexy_Img_Grab_Sub{
    Sexy_Raw_Image* rawImage;
    struct tagGrabParam {
        SEXY_GRAB_FUNCTION_RETUREN_X_OFFSET_PERCENT grabFunc;
        float x_offset_percents;
        int x;
        int y;
        int width;
        int height;
        unsigned char* grabbedBmpBuffer;
    } grab;
};

//preset grab styles

#define SEXY_GS_GRAB_FUNCTION_LINEAR "sexy_gs_grab_linear"
#define SEXY_GS_GRAB_FUNCTION_LINEAR_CURVE "sexy_gs_grab_linear_curve"

SEXY_GRAB_FUNCTION_RETUREN_X_OFFSET_PERCENT Sexy_GS_get_preset_grab_function(char* preset_name);

//grab image life-cycle

Sexy_Img_Grab_Sub* Sexy_GS_create_and_grab_sub_image(Sexy_Raw_Image* rawBmp, int x, int y, int width, int height, SEXY_GRAB_FUNCTION_RETUREN_X_OFFSET_PERCENT grabFunc, float grab_x_offset_percents);

void Sexy_GS_replace_grabbed_sub_image_to_raw_image(Sexy_Img_Grab_Sub* grab);

void Sexy_GS_destroy_grabbed_sub_image(Sexy_Img_Grab_Sub* grab);

void Sexy_GS_switch_width_height_for_sub_image(Sexy_Img_Grab_Sub* grab);

void Sexy_GS_do_test_mark_at_sub_image(Sexy_Img_Grab_Sub* grab);

#endif
