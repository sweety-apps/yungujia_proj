//
//  Logger.h
//  base_utilities
//
//  Created by lijinxin on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef base_utilities_Logger_h
#define base_utilities_Logger_h

#import <UIKit/UIKit.h>

#pragma mark - Type Defines

typedef int eLOG_TARGET;

#define LOG_TG_NONE (0)
#define LOG_TG_CONCOLE (1)
#define LOG_TG_DB (2)
#define LOG_TG_FILE (3)
#define LOG_TG_NET_REPORT (4)

typedef enum {
    LOG_LV_ALL = 0,
    LOG_LV_WARNING = 1,
    LOG_LV_ERROR = 2,
    LOG_LV_COUNT,
    } eLOG_LEVEL;

typedef enum {
    LOG_MD_ALL = 0,
    LOG_MD_UI = 1,
    LOG_MD_NET = 2,
    LOG_MD_LOGIC = 3,
    LOG_MD_COUNT,
}eLOG_MODULE;

#pragma mark - Base Functions

void BU_Log_Init(eLOG_TARGET log_type, eLOG_LEVEL which_level_should_be_shown, NSString* dir);
void BU_Log_Init_C(eLOG_TARGET log_type, eLOG_LEVEL which_level_should_be_shown, char* dir);
void BU_Log_Printf(eLOG_LEVEL log_level, NSString* log_format,...);
void BU_Log_Vprintf(eLOG_LEVEL log_level, NSString* log_format, va_list log_content_va);
void BU_Log_Printf_C(eLOG_LEVEL log_level, char* log_format,...);
void BU_Log_Vprintf_C(eLOG_LEVEL log_level, char* log_format, va_list log_content_va);
void BU_Log_PrintStack(eLOG_LEVEL log_level);
void BU_Log_PrintViewTree(eLOG_LEVEL log_level, UIView* root);
void BU_Log_PrintViewTreeFromUIWindow(eLOG_LEVEL log_level);
void BU_Log_setModuleWithName(eLOG_MODULE module, NSString* fileName);
void BU_Log_setModuleWithName_C(eLOG_MODULE module, char* fileName);
void BU_Log_setLogIsShowedOnlyForModule(eLOG_MODULE module);
eLOG_MODULE BU_Log_getModuleForCurrentShowedLog();

void BU_Log_M_Printf(eLOG_LEVEL log_level, eLOG_MODULE module, NSString* log_format,...);
void BU_Log_M_Vprintf(eLOG_LEVEL log_level, eLOG_MODULE module, NSString* log_format, va_list log_content_va);
void BU_Log_M_Printf_C(eLOG_LEVEL log_level, eLOG_MODULE module, char* log_format,...);
void BU_Log_M_Vprintf_C(eLOG_LEVEL log_level, eLOG_MODULE module, char* log_format, va_list log_content_va);

NSString* BU_Log_getLogFileDirectory();
char* BU_Log_getLogFileDirectory_C();
NSString* BU_Log_getDateTimeTag();
int BU_Log_getDateTimeTag_C(char* buffer, int buffer_size);
NSString* BU_Log_getModuleLogFilePath(eLOG_MODULE module);
char* BU_Log_getModuleLogFilePath_C(eLOG_MODULE module);

#pragma mark - Log Configure

#ifndef DEFAULT_LOG_TARGET
#if DEBUG
#define DEFAULT_LOG_TARGET (LOG_TG_CONCOLE)
#else
#define DEFAULT_LOG_TARGET (LOG_TG_NONE)
#endif
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

#ifndef DEFAULT_SHOW_MODULE
#define DEFAULT_SHOW_MODULE LOG_MD_ALL
#endif

#pragma mark - USAGE MACRO
#pragma mark for ObjC

#ifndef LOGA
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGA(...) BU_Log_Printf(LOG_LV_ALL,##__VA_ARGS__)
#else
#define LOGA(...)
#endif
#endif
#ifndef LOGW
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGW(...) BU_Log_Printf(LOG_LV_WARNING,##__VA_ARGS__)
#else
#define LOGW(...)
#endif
#endif
#ifndef LOGE
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGE(...) BU_Log_Printf(LOG_LV_ERROR,##__VA_ARGS__)
#else
#define LOGE(...)
#endif
#endif

#ifndef LOGA_UI
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGA_UI(...) BU_Log_M_Printf(LOG_LV_ALL,LOG_MD_UI,##__VA_ARGS__)
#else
#define LOGA_UI(...)
#endif
#endif
#ifndef LOGW_UI
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGW_UI(...) BU_Log_M_Printf(LOG_LV_WARNING,LOG_MD_UI,##__VA_ARGS__)
#else
#define LOGW_UI(...)
#endif
#endif
#ifndef LOGE_UI
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGE_UI(...) BU_Log_M_Printf(LOG_LV_ERROR,LOG_MD_UI,##__VA_ARGS__)
#else
#define LOGE_UI(...)
#endif
#endif

#ifndef LOGA_NET
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGA_NET(...) BU_Log_M_Printf(LOG_LV_ALL,LOG_MD_NET,##__VA_ARGS__)
#else
#define LOGA_NET(...)
#endif
#endif
#ifndef LOGW_NET
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGW_NET(...) BU_Log_M_Printf(LOG_LV_WARNING,LOG_MD_NET,##__VA_ARGS__)
#else
#define LOGW_NET(...)
#endif
#endif
#ifndef LOGE_NET
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGE_NET(...) BU_Log_M_Printf(LOG_LV_ERROR,LOG_MD_NET,##__VA_ARGS__)
#else
#define LOGE_NET(...)
#endif
#endif

#ifndef LOGA_LOGIC
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGA_LOGIC(...) BU_Log_M_Printf(LOG_LV_ALL,LOG_MD_LOGIC,##__VA_ARGS__)
#else
#define LOGA_LOGIC(...)
#endif
#endif
#ifndef LOGW_LOGIC
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGW_LOGIC(...) BU_Log_M_Printf(LOG_LV_WARNING,LOG_MD_LOGIC,##__VA_ARGS__)
#else
#define LOGW_LOGIC(...)
#endif
#endif
#ifndef LOGE_LOGIC
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGE_LOGIC(...) BU_Log_M_Printf(LOG_LV_ERROR,LOG_MD_LOGIC,##__VA_ARGS__)
#else
#define LOGE_LOGIC(...)
#endif
#endif

#pragma mark for C

#ifndef LOGAC
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGAC(...) BU_Log_Printf_C(LOG_LV_ALL,##__VA_ARGS__)
#else
#define LOGAC(...)
#endif
#endif
#ifndef LOGWC
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGWC(...) BU_Log_Printf_C(LOG_LV_WARNING,##__VA_ARGS__)
#else
#define LOGWC(...)
#endif
#endif
#ifndef LOGEC
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGEC(...) BU_Log_Printf_C(LOG_LV_ERROR,##__VA_ARGS__)
#else
#define LOGEC(...)
#endif
#endif

#ifndef LOGAC_UI
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGAC_UI(...) BU_Log_M_Printf_C(LOG_LV_ALL,LOG_MD_UI,##__VA_ARGS__)
#else
#define LOGAC_UI(...)
#endif
#endif
#ifndef LOGWC_UI
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGWC_UI(...) BU_Log_M_Printf_C(LOG_LV_WARNING,LOG_MD_UI,##__VA_ARGS__)
#else
#define LOGWC_UI(...)
#endif
#endif
#ifndef LOGEC_UI
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGEC_UI(...) BU_Log_M_Printf_C(LOG_LV_ERROR,LOG_MD_UI,##__VA_ARGS__)
#else
#define LOGEC_UI(...)
#endif
#endif

#ifndef LOGAC_NET
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGAC_NET(...) BU_Log_M_Printf_C(LOG_LV_ALL,LOG_MD_NET,##__VA_ARGS__)
#else
#define LOGAC_NET(...)
#endif
#endif
#ifndef LOGWC_NET
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGWC_NET(...) BU_Log_M_Printf_C(LOG_LV_WARNING,LOG_MD_NET,##__VA_ARGS__)
#else
#define LOGWC_NET(...)
#endif
#endif
#ifndef LOGEC_NET
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGEC_NET(...) BU_Log_M_Printf_C(LOG_LV_ERROR,LOG_MD_NET,##__VA_ARGS__)
#else
#define LOGEC_NET(...)
#endif
#endif

#ifndef LOGAC_LOGIC
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGAC_LOGIC(...) BU_Log_M_Printf_C(LOG_LV_ALL,LOG_MD_LOGIC,##__VA_ARGS__)
#else
#define LOGAC_LOGIC(...)
#endif
#endif
#ifndef LOGWC_LOGIC
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGWC_LOGIC(...) BU_Log_M_Printf_C(LOG_LV_WARNING,LOG_MD_LOGIC,##__VA_ARGS__)
#else
#define LOGWC_LOGIC(...)
#endif
#endif
#ifndef LOGEC_LOGIC
#if  (DEFAULT_LOG_TARGET != LOG_TG_NONE)
#define LOGEC_LOGIC(...) BU_Log_M_Printf_C(LOG_LV_ERROR,LOG_MD_LOGIC,##__VA_ARGS__)
#else
#define LOGEC_LOGIC(...)
#endif
#endif

#endif
