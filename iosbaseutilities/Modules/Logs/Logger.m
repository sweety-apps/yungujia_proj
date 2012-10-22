//
//  Logger.c
//  base_utilities
//
//  Created by lijinxin on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#import <UIKit/UIKit.h>
#include "Logger.h"

#define BU_LOG_PATH_LEN (1024);

#define BU_ERROR_COMMON (-1)
#define BU_ERROR_INVALID_PARAM (-2)
#define BU_ERROR_NOT_IMPLEMENTED (-3)

#ifndef DEFAULT_LOG_TARGET
#define DEFAULT_LOG_TARGET (LOG_TG_NONE)
#endif

#ifndef DEFAULT_SHOW_LOG_MODULE
#define DEFAULT_SHOW_LOG_MODULE (LOG_MD_ALL)
#endif

#ifndef DEFAULT_LOG_DIR
#define DEFAULT_LOG_DIR @"/Documents/"
#endif

#ifndef DEFAULT_LOG_FILENAME
#define DEFAULT_LOG_FILENAME @"Debug.log"
#endif

#ifndef UI_LOG_FILENAME
#define UI_LOG_FILENAME @"UI_Debug.log"
#endif

#ifndef NET_LOG_FILENAME
#define NET_LOG_FILENAME @"Net_Debug.log"
#endif

#ifndef LOGIC_LOG_FILENAME
#define LOGIC_LOG_FILENAME @"Logic_Debug.log"
#endif

#ifndef DEFAULT_LOG_LEVEL
#define DEFAULT_LOG_LEVEL (LOG_LV_ALL)
#endif

#define LOG_INIT_INFO_FMT @"=====================  BU_Log New At %@ ==========================\n"
#define LOG_WARNING_TAG @"|[<W>]|"
#define LOG_WARNING_TAG_C "|[<W>]|"
#define LOG_ERROR_TAG @"!!<E>!!"
#define LOG_ERROR_TAG_C "!!<E>!!"

static char gLogHasInited = 0;
static NSString* gLogDir = nil;
static eLOG_TARGET gLogTarget = LOG_TG_CONCOLE;
//static FILE* gLogFileHandle = NULL;
static FILE* gLogFileHandleTable[LOG_MD_COUNT] = {0};
static eLOG_LEVEL gLogLevel = LOG_LV_ALL;
static NSString* gLogModulePathTable[LOG_MD_COUNT] = {0};
static eLOG_MODULE gShowedModule = LOG_MD_ALL;

const unsigned long DEFAULT_LOG_STACK_SIZE = 512 * 1024;

#define CHECK_INITED() if(!gLogHasInited){BU_Log_Init(DEFAULT_LOG_TARGET,DEFAULT_LOG_LEVEL,DEFAULT_LOG_DIR);}

static void resetFilePath(eLOG_MODULE module, NSString* path)
{
    FILE* hf = NULL;
    //ensure is exist
    hf = fopen([path cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    if (hf == NULL)
    {
        hf = fopen([path cStringUsingEncoding:NSUTF8StringEncoding], "wb");
    }
    if (hf)
    {
        fclose(hf);
    }
    //open file
    hf = fopen([path cStringUsingEncoding:NSUTF8StringEncoding], "ab+");
    if (hf)
    {
        if (gLogFileHandleTable[module])
        {
            fclose(gLogFileHandleTable[module]);
            gLogFileHandleTable[module] = NULL;
        }
        gLogFileHandleTable[module] = hf;
        
        //add divider
        NSString* div = [NSString stringWithFormat:LOG_INIT_INFO_FMT,BU_Log_getDateTimeTag()];
        fwrite([div cStringUsingEncoding:NSUTF8StringEncoding], 1, [div length], hf);
        fflush(hf);
    }
}

NSString* BU_Log_getDateTimeTag()
{
    char buffer[64] = {0};
    int len = 0;
    len = BU_Log_getDateTimeTag_C(buffer,64);
    NSString* ret = @"";
    if (len > 0)
    {
        ret = [NSString stringWithUTF8String:buffer];
    }
    return ret;
}

int BU_Log_getDateTimeTag_C(char* buffer, int buffer_size)
{
    int c_year = 0, c_mon = 0, c_day = 0, c_hour = 0, c_min = 0, c_sec = 0;
    time_t t;
    struct tm *tm_t;
    time(&t);
    tm_t = localtime(&t);
    c_year = tm_t->tm_year + 1900;
    c_mon = tm_t->tm_mon + 1;
    c_day = tm_t->tm_mday;
    c_hour = tm_t->tm_hour;
    c_min = tm_t->tm_min;
    c_sec = tm_t->tm_sec;
    
    return snprintf(buffer, buffer_size, "[%04d/%02d/%02d | %02d:%02d:%02d]",c_year,c_mon,c_day,c_hour,c_min,c_sec);
}

void BU_Log_Init(eLOG_TARGET log_type, eLOG_LEVEL which_level_should_be_shown, NSString* dir)
{
    BU_Log_Init_C(log_type, which_level_should_be_shown, (char*)[dir cStringUsingEncoding:NSUTF8StringEncoding]);
}

void BU_Log_Init_C(eLOG_TARGET log_type, eLOG_LEVEL which_level_should_be_shown, char* dir)
{
    if (gLogDir)
    {
        [gLogDir release];
        gLogDir = nil;
    }
    
    //set up directories
    if (dir == NULL)
    {
        dir = (char*)[DEFAULT_LOG_DIR cStringUsingEncoding:NSUTF8StringEncoding];
    }
    NSString* lp = [NSString stringWithFormat:@"%@%@",
                    NSHomeDirectory(),
                    [NSString stringWithCString:dir
                                       encoding:NSUTF8StringEncoding]
                    ];
    gLogDir = [lp retain];
    
    switch (log_type)
    {
        case LOG_TG_FILE:
        {
            BU_Log_setModuleWithName(LOG_MD_ALL, DEFAULT_LOG_FILENAME);
            BU_Log_setModuleWithName(LOG_MD_UI, UI_LOG_FILENAME);
            BU_Log_setModuleWithName(LOG_MD_NET, NET_LOG_FILENAME);
            BU_Log_setModuleWithName(LOG_MD_LOGIC, LOGIC_LOG_FILENAME);
        }
            break;
        case LOG_TG_CONCOLE:
            for (int i = 0; i < LOG_MD_COUNT; ++i)
            {
                if (gLogFileHandleTable[i])
                {
                    fclose(gLogFileHandleTable[i]);
                    gLogFileHandleTable[i] = NULL;
                }
            }
            break;
        default:
            break;
    }
    gLogTarget = log_type;
    gLogLevel = which_level_should_be_shown;
    gLogHasInited = 1;
}


void BU_Log_M_Printf(eLOG_LEVEL log_level, eLOG_MODULE module, NSString* log_format,...)
{
    CHECK_INITED();
    
    va_list vl;
    va_start(vl, log_format);
    BU_Log_M_Vprintf(log_level, module, log_format, vl);
    va_end(vl);
}

void BU_Log_M_Vprintf(eLOG_LEVEL log_level, eLOG_MODULE module, NSString* log_format, va_list log_content_va)
{
    CHECK_INITED();
    if (gLogLevel <= log_level)
    {
        {
            NSString* str = nil;
            NSString* utf8fmt = [NSString stringWithCString:[log_format UTF8String] encoding:NSUTF8StringEncoding];
            NSString* content = [[NSString alloc] initWithFormat:utf8fmt arguments:log_content_va];
            if (log_level == LOG_LV_WARNING)
            {
                str = [NSString stringWithFormat:@"%@%@",LOG_WARNING_TAG,content];
            }
            else if(log_level == LOG_LV_ERROR)
            {
                str = [NSString stringWithFormat:@"%@%@",LOG_ERROR_TAG,content];
            }
            else
            {
                str = content;
            }
            switch (gLogTarget)
            {
                case LOG_TG_NET_REPORT:
                case LOG_TG_DB:
                case LOG_TG_FILE:
                    if (gLogFileHandleTable[module])
                    {
                        char* c_str = (char*)[str cStringUsingEncoding:NSUTF8StringEncoding];
                        int c_len = strlen(c_str);
                        fwrite(c_str, 1, c_len, gLogFileHandleTable[module]);
                        fflush(gLogFileHandleTable[module]);
                    }
                case LOG_TG_CONCOLE:
                    if (gShowedModule == module)
                    {
                        printf("%s",[str cStringUsingEncoding:NSUTF8StringEncoding]);
                    }
                    break;
                default:
                    break;
            }
            [content release];
        }
    }
}

void BU_Log_M_Printf_C(eLOG_LEVEL log_level, eLOG_MODULE module, char* log_format,...)
{
    CHECK_INITED();
    
    va_list vl;
    va_start(vl, log_format);
    BU_Log_M_Vprintf_C(log_level, module, log_format, vl);
    va_end(vl);
}

void BU_Log_M_Vprintf_C(eLOG_LEVEL log_level, eLOG_MODULE module, char* log_format, va_list log_content_va)
{
    CHECK_INITED();
    if (gLogLevel <= log_level)
    {
        {
            char buffer[DEFAULT_LOG_STACK_SIZE] = {0};
            int len = 0;
            char* content = buffer;
            if (log_level == LOG_LV_WARNING)
            {
                strcat(buffer, LOG_WARNING_TAG_C);
                len += strlen(LOG_WARNING_TAG_C);
                content = &buffer[len];
            }
            else if(log_level == LOG_LV_ERROR)
            {
                strcat(buffer, LOG_ERROR_TAG_C);
                len += strlen(LOG_ERROR_TAG_C);
                content = &buffer[len];
            }
            len += vsnprintf(content, sizeof(buffer) - len, log_format, log_content_va);
            switch (gLogTarget)
            {
                case LOG_TG_NET_REPORT:
                case LOG_TG_DB:
                case LOG_TG_FILE:
                    if (gLogFileHandleTable[module])
                    {
                        fwrite(buffer, 1, len, gLogFileHandleTable[module]);
                        fflush(gLogFileHandleTable[module]);
                    }
                case LOG_TG_CONCOLE:
                    if (gShowedModule == module)
                    {
                        printf("%s",buffer);
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

void BU_Log_Printf(eLOG_LEVEL log_level, NSString* log_format,...)
{
    CHECK_INITED();
    
    va_list vl;
    va_start(vl, log_format);
    BU_Log_M_Vprintf(log_level, LOG_MD_ALL, log_format, vl);
    va_end(vl);
}

void BU_Log_Vprintf(eLOG_LEVEL log_level, NSString* log_format, va_list log_content_va)
{
    CHECK_INITED();
    BU_Log_M_Vprintf(log_level, LOG_MD_ALL, log_format, log_content_va);
}

void BU_Log_Printf_C(eLOG_LEVEL log_level, char* log_format,...)
{
    CHECK_INITED();
    
    va_list vl;
    va_start(vl, log_format);
    BU_Log_M_Vprintf_C(log_level, LOG_MD_ALL, log_format, vl);
    va_end(vl);
}

void BU_Log_Vprintf_C(eLOG_LEVEL log_level, char* log_format, va_list log_content_va)
{
    CHECK_INITED();
    BU_Log_M_Vprintf_C(log_level, LOG_MD_ALL, log_format, log_content_va);
}

void BU_Log_PrintStack(eLOG_LEVEL log_level)
{
    CHECK_INITED();
}

static int info_of_uiview(UIView* view,char* buf,int size)
{
    CGRect frm = view.frame;
    CGRect bnd = view.bounds;
    CGPoint cnt = view.center;
    CGAffineTransform trs = view.transform;
    BOOL ext = view.exclusiveTouch;
    BOOL hid = view.hidden;
    char* rest_buf = buf;
    int mov_len = 0;
    int rest_len = size;
    
    snprintf(buf, size,
             "(%s) : \
             hidden=(%s) \
             frame=(%f,%f,%f,%f) \
             bounds=(%f,%f,%f,%f) \
             center=(%f,%f) \
             transfrom=(%f,%f,%f,%f,%f,%f) \
             exclusiveTouch=(%s) ",
             object_getClassName(view),
             hid?"YES":"NO",
             frm.origin.x,frm.origin.y,frm.size.width,frm.size.height,
             bnd.origin.x,bnd.origin.y,bnd.size.width,bnd.size.height,
             cnt.x,cnt.y,
             trs.a,trs.b,trs.c,trs.d,trs.tx,trs.ty,
             ext?"YES":"NO"
             );
    
    
    mov_len = strlen(rest_buf);
    rest_buf = &rest_buf[mov_len];
    rest_len -= mov_len;
    
    //for UIImageView Info
    if ([[view class] isSubclassOfClass:[UIImageView class]])
    {
        {
            UIImageView* nv = (UIImageView*)view;
            if (nv.image)
            {
                CGSize isz = nv.image.size;
                snprintf(rest_buf, rest_len,
                         "| Image Raw Size = (%f,%f) ",
                         isz.width,isz.height);
                
            }
        }
    }
    mov_len = strlen(rest_buf);
    rest_buf = &rest_buf[mov_len];
    rest_len -= mov_len;
    
    //for UILabel Info
    if ([[view class] isSubclassOfClass:[UILabel class]])
    {
        {
            UILabel* nv = (UILabel*)view;
            if (nv.text)
            {
                snprintf(rest_buf, rest_len,
                         "| Text=\"%s\" ",
                         [nv.text cStringUsingEncoding:NSUTF8StringEncoding]);
                
            }
        }
    }
    mov_len = strlen(rest_buf);
    rest_buf = &rest_buf[mov_len];
    rest_len -= mov_len;
    
    //for UIButton Info
    if ([[view class] isSubclassOfClass:[UIButton class]])
    {
        {
            UIButton* nv = (UIButton*)view;
            snprintf(rest_buf, rest_len,
                     "| States: ");
            mov_len = strlen(rest_buf);
            rest_buf = &rest_buf[mov_len];
            rest_len -= mov_len;
            for (UIButtonType btp = 0; btp <= UIButtonTypeContactAdd; ++btp)
            {
                snprintf(rest_buf, rest_len,
                         "t[%d]=\"%s\" ",
                         btp,
                         [[nv titleForState:btp] cStringUsingEncoding:NSUTF8StringEncoding]);
                mov_len = strlen(rest_buf);
                rest_buf = &rest_buf[mov_len];
                rest_len -= mov_len;
            }
        }
    }
    mov_len = strlen(rest_buf);
    //rest_buf = &rest_buf[mov_len];
    rest_len -= mov_len;
    
    //end
    if (rest_len > 1)
    {
        strcat(buf, "\n");
    }
    return strlen(buf);
}

static int log_view_tree_internal(char* prefix, UIView* root, char* buf, int size)
{
    const char PRE_FIX[] = "\t";
    int used_len = 0;
    if (root)
    {
        {
            //print parent node
            used_len += snprintf(&buf[used_len], size - used_len, "%s", prefix);
            used_len += info_of_uiview(root, &buf[used_len], size - used_len);
            //extren prefix
            int new_pre_len = strlen(prefix) + strlen(PRE_FIX);
            char* new_pre = malloc(new_pre_len + 1);
            memset(new_pre, 0, new_pre_len + 1);
            snprintf(new_pre, new_pre_len + 1, "%s%s",prefix,PRE_FIX);
            //print children node
            for (UIView* c in [root subviews])
            {
                used_len += log_view_tree_internal(new_pre, c, &buf[used_len], size - used_len);
            }
            //free prefix
            free(new_pre);
        }
    }
    return used_len;
}

void BU_Log_PrintViewTree(eLOG_LEVEL log_level, UIView* root)
{
    CHECK_INITED();
    const int BUF_LEN = 1024*1024;
    int used_len = 0;
    char buffer[BUF_LEN] = {0};
    
    used_len += snprintf(&buffer[used_len], BUF_LEN - used_len,
                        "\n>>>>>>>>>>> Start Of Tree View %s <<<<<<<<<<<\n\n",
                        [BU_Log_getDateTimeTag() cStringUsingEncoding:NSUTF8StringEncoding]);
    if (root)
    {
        used_len += log_view_tree_internal("", root, &buffer[used_len], BUF_LEN - used_len);
    }
    used_len += snprintf(&buffer[used_len], BUF_LEN - used_len,
                  "\n>>>>>>>>>>> End Of Tree View <<<<<<<<<<<\n\n");
    
    if(used_len > 0)
    {
        BU_Log_Printf_C(log_level, buffer);
    }
}

void BU_Log_PrintViewTreeFromUIWindow(eLOG_LEVEL log_level)
{
    CHECK_INITED();
    BU_Log_PrintViewTree(log_level, [[UIApplication sharedApplication].delegate window]);
}

NSString* BU_Log_getLogFileDirectory()
{
    return gLogDir;
}

char* BU_Log_getLogFileDirectory_C()
{
    return (char*)[gLogDir cStringUsingEncoding:NSUTF8StringEncoding];
}

void BU_Log_setModuleWithName(eLOG_MODULE module, NSString* fileName)
{
    if (fileName)
    {
        NSString* filePath = [[NSString stringWithFormat:@"%@%@",
                    gLogDir,
                    fileName
                    ] retain];
        [gLogModulePathTable[module] release];
        gLogModulePathTable[module] = filePath;
        resetFilePath(module, filePath);
    }
}

void BU_Log_setModuleWithName_C(eLOG_MODULE module, char* fileName)
{
    BU_Log_setModuleWithName(module, [NSString stringWithUTF8String:fileName]);
}

void BU_Log_setLogIsShowedOnlyForModule(eLOG_MODULE module)
{
    gShowedModule = module;
}

eLOG_MODULE BU_Log_getModuleForCurrentShowedLog()
{
    return gShowedModule;
}

NSString* BU_Log_getModuleLogFilePath(eLOG_MODULE module)
{
    return gLogModulePathTable[module];
}

char* BU_Log_getModuleLogFilePath_C(eLOG_MODULE module)
{
    return (char*)[gLogModulePathTable[module] cStringUsingEncoding:NSUTF8StringEncoding];
}

