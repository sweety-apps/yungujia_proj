//
//  sexy_image_grab_sub_presets.c
//  ImageStretchTest
//
//  Created by lijinxin on 13-3-25.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#include <stdio.h>
#include "sexy_image_grab_sub_presets.h"

float  Sexy_GS_preset_function_linear(Sexy_Img_Grab_Sub* grab, int lineNum)
{
    float heightPercent = ((float)(lineNum + 1)) / ((float)grab->grab.height);
    return grab->grab.x_offset_percents * heightPercent;
}

float  Sexy_GS_preset_function_linear_curve(Sexy_Img_Grab_Sub* grab, int lineNum)
{
    float heightPercent = ((float)(lineNum + 1)) / ((float)grab->grab.height);
    return grab->grab.x_offset_percents * heightPercent;
}
