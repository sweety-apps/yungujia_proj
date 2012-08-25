#调试的时候，需要根据实际情况修改arm-eabi-addr2line.exe的路径
#你需要定位的.so文件和地址需要从eclipse的日志里面去看
/cygdrive/d/AndroidTools/android-ndk-r5b/toolchains/arm-eabi-4.4.0/prebuilt/windows/bin/arm-eabi-addr2line.exe -f -e ../obj/local/armeabi/libHallLogic.so 0008bb56