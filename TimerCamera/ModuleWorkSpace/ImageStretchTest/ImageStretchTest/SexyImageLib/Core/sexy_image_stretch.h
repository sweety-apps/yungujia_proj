//
//  sexy_image_stretch.h
//  ImageStretchTest
//
//  Created by Lee Justin on 13-3-19.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#ifndef ImageStretchTest_sexy_image_stretch_h
#define ImageStretchTest_sexy_image_stretch_h

//availiable for RGBA format with 32-bits pixels

//structure defines

typedef float (*SEXY_STRECTCH_FUNCTION_RETUREN_WIDTH_STRETCH_PERCENT) (int lineNum, float stretch_percents, int width, int height);

typedef struct tagSexy_Img_Stretch{
    unsigned char* bmpBuffer;
    int width;
    int height;
    char isCopyied;
    struct tagStretch {
        SEXY_STRECTCH_FUNCTION_RETUREN_WIDTH_STRETCH_PERCENT style;
        float stretch_percents;
    } stretch;
} Sexy_Img_Stretch;

//preset stretch styles

#define SEXY_IS_STRETCH_STYLE_LINEAR "sexy_is_style_linear"
#define SEXY_IS_STRETCH_STYLE_LINEAR_CURVE "sexy_is_style_linear_curve"

SEXY_STRECTCH_FUNCTION_RETUREN_WIDTH_STRETCH_PERCENT Sexy_IS_get_preset_stretch_style(char* style_name);

//module life-cycle

void Sexy_IS_init();
void Sexy_IS_uninit();
char Sexy_IS_is_inited();

//stretch image life-cycle

Sexy_Img_Stretch* Sexy_IS_create_no_copy(unsigned char* bmpBuffer, int width, int height);
Sexy_Img_Stretch* Sexy_IS_create_copy(unsigned char* bmpBuffer, int width, int height);
void Sexy_IS_destory(Sexy_Img_Stretch* obj);

//stretch working functions

void Sexy_IS_set_stretch_style(Sexy_Img_Stretch* obj, SEXY_STRECTCH_FUNCTION_RETUREN_WIDTH_STRETCH_PERCENT style, float stretch_percents);

void Sexy_IS_do_stretch(Sexy_Img_Stretch* obj);

#endif
