//
//  sexy_image_stretch.c
//  ImageStretchTest
//
//  Created by Lee Justin on 13-3-19.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#include <stdio.h>
#include "sexy_image_stretch_presets.h"
#include "sexy_image_stretch.h"

//preset stretch styles

SEXY_STRECTCH_FUNCTION_RETUREN_WIDTH_STRETCH_PERCENT Sexy_IS_get_preset_stretch_style(char* style_name, float stretch_percents);

//module life-cycle

void Sexy_IS_init()
{
    
}

void Sexy_IS_uninit()
{
    
}

char Sexy_IS_is_inited()
{
    return 0;
}

//stretch image life-cycle

Sexy_Img_Stretch* Sexy_IS_create_no_copy(unsigned char* bmpBuffer, int width, int height)
{
    return NULL;
}

void Sexy_IS_destory(Sexy_Img_Stretch* obj)
{
    
}

//stretch working functions

void Sexy_IS_set_stretch_style(Sexy_Img_Stretch* obj, SEXY_STRECTCH_FUNCTION_RETUREN_WIDTH_STRETCH_PERCENT style)
{
    
}

void Sexy_IS_do_stretch(Sexy_Img_Stretch* obj)
{
    
}
