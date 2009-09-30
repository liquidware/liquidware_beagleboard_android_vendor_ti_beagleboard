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

# keyboard
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/../../ea/generic/keyboards/usbkbd-no-pm.kl:system/usr/keylayout/qwerty.kl

# vold.conf
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/vold.conf:system/etc/vold.conf

# Bootsound
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/boot.wav:system/media/audio/ui/boot.wav

ifeq ($(strip $(BOARD_USES_ALSA_AUDIO)),true)
ifeq ($(wildcard $(LOCAL_PATH)/asound.conf),)
$(error $(LOCAL_PATH)/asound.conf not found, create one for your hardware)
else
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/asound.conf:system/etc/asound.conf
endif
endif

include frameworks/base/data/sounds/OriginalAudio.mk
