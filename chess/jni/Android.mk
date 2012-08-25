# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)
include $(LOCAL_PATH)/ChessCore.mk
include $(LOCAL_PATH)/AI.mk

include $(CLEAR_VARS)
LOCAL_MODULE    	:= androidchess
LOCAL_C_INCLUDES 	:= 	$(LOCAL_PATH)\
$(LOCAL_PATH)/../core/ \
$(SYSROOT)/../../../../sources/cxx-stl/stlport/stlport \
$(LOCAL_PATH)/../Headers/ $(LOCAL_PATH)/../AI/ 

LOCAL_SRC_FILES   += \
./ChessLogicJNI.cpp 

LOCAL_LDLIBS := -L$(SYSROOT)/usr/lib -llog


#LOCAL_CFLAGS 	+= -O2 -MD -DLINUX -D_ANDROID_LINUX
LOCAL_CFLAGS 	+= -g -MD -D_DEBUG -DLINUX -D_ANDROID_LINUX 

LOCAL_SHARED_LIBRARIES += ai chesscore 
LOCAL_LDLIBS 			+= -lz -L$(SYSROOT)/../../../../sources/cxx-stl/stlport/libs/armeabi

include $(BUILD_SHARED_LIBRARY)

include $(LOCAL_PATH)/GameHall.mk