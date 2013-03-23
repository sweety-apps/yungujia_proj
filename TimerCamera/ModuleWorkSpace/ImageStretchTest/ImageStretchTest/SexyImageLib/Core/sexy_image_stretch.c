//
//  sexy_image_stretch.c
//  ImageStretchTest
//
//  Created by Lee Justin on 13-3-19.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include "sexy_image_stretch_presets.h"
#include "sexy_image_stretch.h"

typedef struct tagSexy_Stretch_Pixel_Convert{
    int x;
    int y;
    struct tagLine{
        int start_x;
        int count;
        float* percents;
    } line_convert;
    struct tagRow{
        int up_x;
        float up_percent;
        int down_x;
        float down_percent;
    } row_convert;
}Sexy_Stretch_Pixel_Convert;

//preset stretch styles

SEXY_STRECTCH_FUNCTION_RETUREN_WIDTH_STRETCH_PERCENT Sexy_IS_get_preset_stretch_style(char* style_name)
{
    if (strcmp(style_name, SEXY_IS_STRETCH_STYLE_LINEAR) == 0)
    {
        return Sexy_IS_preset_style_linear;
    }
    else if (strcmp(style_name, SEXY_IS_STRETCH_STYLE_LINEAR_CURVE) == 0)
    {
        return Sexy_IS_preset_style_linear_curve;
    }
    return NULL;
}


//module life-cycle

static char gIsInited = 0;

void Sexy_IS_init()
{
    gIsInited = 1;
}

void Sexy_IS_uninit()
{
    gIsInited = 0;
}

char Sexy_IS_is_inited()
{
    return gIsInited;
}

//stretch image life-cycle

Sexy_Img_Stretch* Sexy_IS_create_no_copy(unsigned char* bmpBuffer, int width, int height)
{
    Sexy_Img_Stretch* ret = (Sexy_Img_Stretch*)calloc(sizeof(Sexy_Img_Stretch), 1);
    ret->bmpBuffer = bmpBuffer;
    ret->width = width;
    ret->height = height;
    return ret;
}

Sexy_Img_Stretch* Sexy_IS_create_copy(unsigned char* bmpBuffer, int width, int height)
{
    Sexy_Img_Stretch* ret = NULL;
    ret = Sexy_IS_create_no_copy(bmpBuffer, width, height);
    ret->bmpBuffer = (unsigned char*)calloc(width * height, 4);
    ret->isCopyied = 1;
    return ret;
}

void Sexy_IS_destory(Sexy_Img_Stretch* obj)
{
    if (obj)
    {
        if (obj->isCopyied)
        {
            free(obj->bmpBuffer);
        }
        free(obj);
    }
}

//stretch working functions

void Sexy_IS_set_stretch_style(Sexy_Img_Stretch* obj, SEXY_STRECTCH_FUNCTION_RETUREN_WIDTH_STRETCH_PERCENT style, float stretch_percents)
{
    if (obj)
    {
        obj->stretch.style = style;
        stretch_percents = stretch_percents <= 0.0 ? 0.000000000001 : stretch_percents;
        obj->stretch.stretch_percents = stretch_percents;
    }
}

static void doStretchPixel(Sexy_Img_Stretch* obj, unsigned char* rawBuffer, unsigned char* destPixel, Sexy_Stretch_Pixel_Convert* pStretch)
{
    destPixel[0] = 0;//red
    destPixel[1] = 0;//green
    destPixel[2] = 0;//blue
    
    //compute same line effectors
    int index = 4 * (obj->width * pStretch->y + pStretch->line_convert.start_x);
    for (int i = 0; i < pStretch->line_convert.count; ++i)
    {
        destPixel[0] += rawBuffer[index] * pStretch->line_convert.percents[i];
        destPixel[1] += rawBuffer[index+1] * pStretch->line_convert.percents[i];
        destPixel[2] += rawBuffer[index+2] * pStretch->line_convert.percents[i];
        index += 4;
    }
    
    //compute up line effectors
    if (pStretch->y > 0)
    {
        index = 4 * (obj->width * (pStretch->y - 1) + pStretch->row_convert.up_x);
        destPixel[0] += rawBuffer[index] * pStretch->row_convert.up_percent;
        destPixel[1] += rawBuffer[index+1] * pStretch->row_convert.up_percent;
        destPixel[2] += rawBuffer[index+2] * pStretch->row_convert.up_percent;
    }
    
    //compute down line effectors
    if (pStretch->y < (obj->height - 1))
    {
        index = 4 * (obj->width * (pStretch->y + 1) + pStretch->row_convert.down_x);
        destPixel[0] += rawBuffer[index] * pStretch->row_convert.down_percent;
        destPixel[1] += rawBuffer[index+1] * pStretch->row_convert.down_percent;
        destPixel[2] += rawBuffer[index+2] * pStretch->row_convert.down_percent;
    }
    
    //destPixel[0] = 0;//red
    //destPixel[1] = 0;//green
    //destPixel[2] = 0;//blue
    destPixel[3] = 255;
}

static void caculateStretch(Sexy_Img_Stretch* obj, Sexy_Stretch_Pixel_Convert* pStretch, float linePercent, float upLinePercent, float downLinePercent, float dest_start_x, float dest_end_x, float dest_width, int x, int y)
{
    pStretch->x = x;
    pStretch->y = y;
    
    if (x < dest_start_x)
    {
        //before dest
        pStretch->line_convert.count = 1;
        pStretch->line_convert.start_x = 0;
        pStretch->line_convert.percents[0] = 1.0;
        pStretch->row_convert.up_percent = 0.f;
        pStretch->row_convert.down_percent = 0.f;
        pStretch->row_convert.up_x = 0;
        pStretch->row_convert.down_x = 0;
    }
    else if (x >= dest_end_x)
    {
        //after dest
        pStretch->line_convert.count = 1;
        pStretch->line_convert.start_x = obj->width - 2;
        pStretch->line_convert.percents[0] = 1.0;
        pStretch->row_convert.up_percent = 0.f;
        pStretch->row_convert.down_percent = 0.f;
        pStretch->row_convert.up_x = obj->width - 2;
        pStretch->row_convert.down_x = obj->width - 2;
    }
    else
    {
        // in dest
        float rowLeft = 1.0;
        
        //caculate row
        pStretch->row_convert.up_percent = 0.f;
        pStretch->row_convert.down_percent = 0.f;
        pStretch->row_convert.up_x = 0;
        pStretch->row_convert.down_x = 0;
        
        //caculate line
        float count = 1.0 / linePercent;
        float start_x = (x - dest_start_x) * count;
        float end_x = start_x + count;
        if (end_x > ((float)obj->width))
        {
            count = ((float)obj->width) - start_x;
            if (count < 1.f)
            {
                count = 1.f;
                start_x = ((float)obj->width) - 1.0;
            }
            end_x = ((float)obj->width);
        }
        
        int real_count = 0;
        
        float idx = (int)start_x;
        float current_width_effect = start_x;
        float next_idx = idx + 1.0;
        float real_left = rowLeft;
        
        while (idx < end_x)
        {
            next_idx = next_idx > end_x ? end_x : next_idx;
            current_width_effect = current_width_effect > start_x ? current_width_effect : start_x;
            current_width_effect = next_idx - current_width_effect;
            pStretch->line_convert.percents[real_count] = rowLeft * current_width_effect / count;
            real_left -= pStretch->line_convert.percents[real_count];
            current_width_effect = next_idx;
            next_idx += 1.0;
            ++idx;
            ++real_count;
        }
        
        pStretch->line_convert.count = real_count;
        pStretch->line_convert.start_x = (int)start_x;
        if (real_count > 0)
        {
            pStretch->line_convert.percents[real_count - 1] += real_left;
        }
        else
        {
            pStretch->line_convert.percents[0] = real_left;
        }
    }
}

static void doStretchLine(Sexy_Img_Stretch* obj, Sexy_Stretch_Pixel_Convert* pStretch, int line, float linePercent, float upLinePercent, float downLinePercent, unsigned char* changedBuff)
{
    int offset = 4 * (obj->width * line);
    
    float dest_width = (((float)obj->width) * linePercent);
    float dest_start_x = ((((float)obj->width) * (1.f - linePercent) * 0.5));
    float dest_end_x = dest_start_x + dest_width;
    
    for (int x = 0; x < obj->width; ++x)
    {
        caculateStretch(obj, pStretch, linePercent, upLinePercent, downLinePercent, dest_start_x, dest_end_x, dest_width, x, line);
        doStretchPixel(obj, obj->bmpBuffer, &changedBuff[offset], pStretch);
        offset += 4;
    }
}

void Sexy_IS_do_stretch(Sexy_Img_Stretch* obj)
{
    if (obj->stretch.style)
    {
        //alloc tmp buffer
        int bufflen = obj->width*obj->height*4;
        unsigned char* changedBuff = (unsigned char*)malloc(bufflen);
        
        //do stretch for every pixels
        float linePercent = 0.f;
        float upLinePercent = 0.f;
        float downLinePercent = 0.f;
        Sexy_Stretch_Pixel_Convert stretch = {0};
        stretch.line_convert.percents = malloc(obj->width * sizeof(float));
        
        for (int y = 0; y < obj->height; ++y)
        {
            if (y > 0)
            {
                linePercent = downLinePercent;
            }
            else
            {
                linePercent = obj->stretch.style(y,obj->stretch.stretch_percents,obj->width,obj->height);
            }
            
            if (y + 1 < obj->height)
            {
                downLinePercent = obj->stretch.style(y + 1,obj->stretch.stretch_percents,obj->width,obj->height);
            }
            
            doStretchLine(obj, &stretch, y, linePercent, upLinePercent, downLinePercent, changedBuff);
            
            upLinePercent = linePercent;
        }
        
        free(stretch.line_convert.percents);
        
        //replace buffer by changed buffer
        memcpy(obj->bmpBuffer,changedBuff,bufflen);
        free(changedBuff);
    }
}