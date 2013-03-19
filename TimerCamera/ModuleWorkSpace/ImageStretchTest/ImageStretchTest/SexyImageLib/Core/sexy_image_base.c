//
//  sexy_image_base.c
//  ImageStretchTest
//
//  Created by lijinxin on 13-3-20.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include "sexy_image_base.h"

Sexy_Raw_Image* Sexy_Raw_create_by_copy(unsigned char* bmpBuffer, int width, int lineSize, int height)
{
    Sexy_Raw_Image* ret = NULL;
    int len = height * lineSize;
    unsigned char* buf = (unsigned char*)malloc(len);
    memcpy(buf, bmpBuffer, len);
    ret = Sexy_Raw_create_no_copy(buf, width, lineSize, height);
    ret->isCopied = 1;
    return ret;
}

Sexy_Raw_Image* Sexy_Raw_create_no_copy(unsigned char* bmpBuffer, int width, int lineSize, int height)
{
    Sexy_Raw_Image* ret = (Sexy_Raw_Image*)calloc(sizeof(Sexy_Raw_Image),1);
    ret->bmpBuffer = bmpBuffer;
    ret->width = width;
    ret->lineSize = lineSize;
    ret->height = height;
    ret->isCopied = 0;
    return ret;
}

void Sexy_Raw_destory(Sexy_Raw_Image* raw)
{
    if (raw)
    {
        if (raw->isCopied)
        {
            free(raw->bmpBuffer);
        }
        free(raw);
    }
}