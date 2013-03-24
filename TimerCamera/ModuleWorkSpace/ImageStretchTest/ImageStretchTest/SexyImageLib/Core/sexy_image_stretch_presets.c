//
//  sexy_image_stretch_presets.c
//  ImageStretchTest
//
//  Created by Lee Justin on 13-3-19.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#include <math.h>
#include <stdio.h>
#include "sexy_image_stretch_presets.h"

float  Sexy_IS_preset_style_linear(int lineNum, float stretch_percents, int width, int height)
{
    return stretch_percents;
}

float  Sexy_IS_preset_style_linear_curve(int lineNum, float stretch_percents, int width, int height)
{
    float halfHeight = ((float)height) * 0.5;
    float real_stretch = ((halfHeight - (float)(lineNum + 1))) / halfHeight;
    real_stretch *= real_stretch;
    stretch_percents = 1.0 - ((1.0 - stretch_percents) * (1.0 - real_stretch));
    //stretch_percents *= real_stretch;
    return stretch_percents;
}