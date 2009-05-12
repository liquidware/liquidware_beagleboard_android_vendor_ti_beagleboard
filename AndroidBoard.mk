LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PREBUILT_KERNEL),)
TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/kernel
endif

file := $(INSTALLED_KERNEL_TARGET)
ALL_PREBUILT += $(file)
$(file): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)

ifeq ($(TARGET_PROVIDES_INIT_RC),true)
file := $(TARGET_ROOT_OUT)/init.rc
$(file): $(LOCAL_PATH)/init.rc | $(ACP)
	$(transform-prebuilt-to-target)
ALL_PREBUILT += $(file)
endif

file := $(TARGET_OUT_KEYLAYOUT)/usbkbd.kl
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/usbkbd.kl | $(ACP)
	$(transform-prebuilt-to-target)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := usbkbd.kcm
include $(BUILD_KEY_CHAR_MAP)

ifeq ($(strip $(BOARD_USES_ALSA_AUDIO)),true)
ifeq ($(wildcard $(LOCAL_PATH)/asound.conf),)
$(error $(LOCAL_PATH)/asound.conf not found, create one for your hardware)
else
file := $(TARGET_ROOT_OUT)/system/etc/asound.conf
$(file): $(LOCAL_PATH)/asound.conf | $(ACP)
	$(transform-prebuilt-to-target)
ALL_PREBUILT += $(file)
endif
endif
