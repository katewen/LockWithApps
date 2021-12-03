ARCHS = arm64
TARGET := iphone:clang:latest:9.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppLockTweak

AppLockTweak_FILES = Tweak.x
AppLockTweak_FRAEMEWORKS = UIKit Foundation
AppLockTweak_CFLAGS += -ObjC
AppLockTweak_CFLAGS += -fobjc-arc
AppLockTweak_CFLAGS += -Wno-error 

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
