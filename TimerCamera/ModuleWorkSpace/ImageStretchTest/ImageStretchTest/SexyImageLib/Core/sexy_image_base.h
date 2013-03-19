//
//  sexy_image_base.h
//  ImageStretchTest
//
//  Created by lijinxin on 13-3-20.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#ifndef ImageStretchTest_sexy_image_base_h
#define ImageStretchTest_sexy_image_base_h

typedef struct tagSexy_Raw_Image{
    unsigned char* bmpBuffer;
    int width;
    int lineSize;
    int height;
    char isCopied;
}Sexy_Raw_Image;

Sexy_Raw_Image* Sexy_Raw_create_by_copy(unsigned char* bmpBuffer, int width, int lineSize, int height);
Sexy_Raw_Image* Sexy_Raw_create_no_copy(unsigned char* bmpBuffer, int width, int lineSize, int height);
void Sexy_Raw_destory(Sexy_Raw_Image* raw);

#endif
