LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
include $(LOCAL_PATH)/../../../common.mk

ifeq ($(use_hwc2),true)

LOCAL_MODULE                  := hwcomposer.$(TARGET_BOARD_PLATFORM)
LOCAL_VENDOR_MODULE           := true
LOCAL_MODULE_RELATIVE_PATH    := hw
LOCAL_MODULE_TAGS             := optional
LOCAL_C_INCLUDES              := $(common_includes)
LOCAL_HEADER_LIBRARIES        := display_headers

LOCAL_CFLAGS                  := -Wno-missing-field-initializers -Wno-unused-parameter \
                                 -std=c++11 -fcolor-diagnostics\
                                 -DLOG_TAG=\"SDM\" $(common_flags)
LOCAL_CLANG                   := true

LOCAL_SHARED_LIBRARIES        := libsdmcore libqservice libbinder libhardware libhardware_legacy \
                                 libutils libcutils libsync libqdutils libqdMetaData \
                                 libdisplaydebug libsdmutils libc++ liblog libgrallocutils libui \
                                 libgpu_tonemapper libhidlbase libhidltransport \
                                 vendor.display.config@1.0 android.hardware.graphics.mapper@2.0 \
                                 android.hardware.graphics.allocator@2.0

ifeq ($(display_config_version), DISPLAY_CONFIG_1_1)
LOCAL_SHARED_LIBRARIES        += vendor.display.config@1.1
endif
ifeq ($(display_config_version), DISPLAY_CONFIG_1_2)
LOCAL_SHARED_LIBRARIES        += vendor.display.config@1.2 vendor.display.config@1.1
endif

# Allow implicit fallthroughs in hwc_display.cpp until they are fixed.
LOCAL_CFLAGS                  += -Wno-error=implicit-fallthrough

LOCAL_SRC_FILES               := hwc_session.cpp \
                                 hwc_session_services.cpp \
                                 hwc_display.cpp \
                                 hwc_display_builtin.cpp \
                                 hwc_display_pluggable.cpp \
                                 hwc_display_pluggable_test.cpp \
                                 hwc_display_virtual.cpp \
                                 hwc_debugger.cpp \
                                 hwc_buffer_sync_handler.cpp \
                                 hwc_color_manager.cpp \
                                 hwc_layers.cpp \
                                 hwc_callbacks.cpp \
                                 cpuhint.cpp \
                                 hwc_tonemapper.cpp \
                                 display_null.cpp \
                                 hwc_socket_handler.cpp

ifeq ($(TARGET_USES_GRALLOC1), true)
LOCAL_SRC_FILES               += hwc_buffer_allocator1.cpp
LOCAL_CFLAGS += -DUSE_GRALLOC1
else
LOCAL_SRC_FILES               += hwc_buffer_allocator.cpp
endif

ifeq ($(TARGET_HAS_WIDE_COLOR_DISPLAY), true)
    LOCAL_CFLAGS += -DFEATURE_WIDE_COLOR
endif

include $(BUILD_SHARED_LIBRARY)
endif
