
################  libai.so   ################
include $(CLEAR_VARS)
LOCAL_MODULE		:= ai
LOCAL_C_INCLUDES 	:= $(SYSROOT)/../../../../sources/cxx-stl/stlport/stlport \
				$(LOCAL_PATH)/../ai/ \
				$(LOCAL_PATH)/../core/ \
				$(LOCAL_PATH)/../headers/

LOCAL_SRC_FILES		:= ../ai/AIMoveOperation.cpp	       \
						../ai/CnChessAI.cpp  \
						../ai/Eveluation.cpp    \
						../ai/MoveGenerator.cpp  \
						../ai/NegaMaxEngine.cpp  \
						../ai/SearchEngine.cpp
						
LOCAL_CFLAGS 		+= -g -MD -D_DEBUG -DLINUX
#LOCAL_CFLAGS 		+= -O2 -MD -DLINUX
LOCAL_LDLIBS 		+= -lz 
LOCAL_SHARED_LIBRARIES +=   
include $(BUILD_SHARED_LIBRARY)
#include $(BUILD_STATIC_LIBRARY)
