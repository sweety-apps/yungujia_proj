
################  libchesscore.so   ################
include $(CLEAR_VARS)
LOCAL_MODULE		:= chesscore
LOCAL_C_INCLUDES 	:= $(SYSROOT)/../../../../sources/cxx-stl/stlport/stlport \
			$(LOCAL_PATH)/../core/ \
			   $(LOCAL_PATH)/../Headers/ $(LOCAL_PATH)/../AI/ 

LOCAL_SRC_FILES		:= ../core/Chessman.cpp	       \
						../core/CnChessLogic.cpp  \
						../core/xqgame.cpp  \
						../core/NetServer.cpp \
						../Headers/common.cpp \
						../Headers/CnChess_PlayerInfo.cpp
						
LOCAL_CFLAGS 		+= -g -MD -D_DEBUG -DLINUX
#LOCAL_CFLAGS 		+= -O2 -MD -DLINUX
LOCAL_LDLIBS := -L$(SYSROOT)/usr/lib -llog
LOCAL_LDLIBS 		+= -lz -L$(SYSROOT)/../../../../sources/cxx-stl/stlport/libs/armeabi 


LOCAL_SHARED_LIBRARIES +=  ai 
include $(BUILD_SHARED_LIBRARY)
#include $(BUILD_STATIC_LIBRARY)