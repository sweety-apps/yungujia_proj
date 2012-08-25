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
LOCAL_PATH := $(call my-dir)/../GameHall

# tinyxml lib
#
include $(CLEAR_VARS)

LOCAL_MODULE    := libtinyxml

	
include $(BUILD_STATIC_LIBRARY)

# HallLogic
#
include $(CLEAR_VARS)

LOCAL_MODULE    := HallLogic
LOCAL_CPPFLAGS += -frtti
LOCAL_SRC_FILES := \
	XMLParser/tinystr.cpp \
	XMLParser/tinyxmlerror.cpp \
	XMLParser/tinyxmlParser.cpp \
	XMLParser/tinyxml.cpp\
	common/range.cpp \
	common/range_queue.cpp \
	common/utility.cpp \
	common/FixedBuffer.cpp \
	common/mutex.cpp \
	common/tea.cpp \
	common/MyTea.cpp \
	common/md5.cpp \
	common/SDEnCryZip.cpp \
	common/setting.cpp \
	\
	asynio/asyn_io_frame.cpp \
	asynio/asyn_io_device.cpp \
	asynio/asyn_io_handler.cpp \
	asynio/asyn_io_handler_manager.cpp \
	asynio/asyn_io_operation.cpp \
	asynio/asyn_io_operation_events.cpp \
	asynio/asyn_message_sender.cpp \
	asynio/asyn_message_events.cpp \
	asynio/asyn_tcp_device.cpp \
	asynio/asyn_tcp_listener.cpp \
	asynio/timeout_handler.cpp \
	\
	GameNet/command/DataXImpl.cpp \
	GameNet/command/GameCmdBase.cpp \
	GameNet/command/CmdCommon.cpp \
	GameNet/command/CmdAskStart.cpp \
	GameNet/command/CmdBalanceSvrDx.cpp \
	GameNet/command/CmdChat.cpp \
	GameNet/command/CmdChatNotify.cpp \
	GameNet/command/CmdExitRoom.cpp \
	GameNet/command/CmdGameActionNotify.cpp \
	GameNet/command/CmdGameSvrDx.cpp \
	GameNet/command/CmdGetDir.cpp \
	GameNet/command/CmdKickout.cpp \
	GameNet/command/CmdNonSessionDx.cpp \
	GameNet/command/CmdPing.cpp \
	GameNet/command/CmdQuitGame.cpp \
	GameNet/command/CmdGetUserGameInfo.cpp \
	GameNet/command/CmdReplay.cpp \
	GameNet/command/CmdSubmitAction.cpp \
	GameNet/command/GameCmdFlexFactory.cpp \
	GameNet/command/GameCmdFactory.cpp \
	GameNet/command/CmdHandlerFactory.cpp \
	\
	GameNet/abstract_c2s_cmd_handler.cpp \
	GameNet/vdt_c2s_cmd_handler.cpp \
	GameNet/vdt_tcp_cmd_handler.cpp \
	GameNet/NetworkMonitor.cpp \
	GameNet/GameUtil.cpp \
	GameNet/GameNetInstance.cpp \
	\
	HallLogic/HallContext.cpp \
	HallLogic/GameNetEventHandler.cpp \
	HallLogic/HallLogic.cpp \
	HallLogic/GameSession.cpp \
	HallLogic/GameSessionMgr.cpp \
	HallLogic/LoginUserStat.cpp \
	HallLogic/GameDirInfoMgr.cpp \
	HallLogic/StatisticsMgr.cpp \
	JniHelper.cpp \
	HallLogicAdapter.cpp

LOCAL_LDLIBS += -llog -lz -L$(SYSROOT)/../../../../sources/cxx-stl/stlport/libs/armeabi
LOCAL_STATIC_LIBRARIES := libtinyxml

include $(BUILD_SHARED_LIBRARY)
