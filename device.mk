LOCAL_PATH := device/unisoc/ums9621_1h10

PRODUCT_USE_DYNAMIC_PARTITIONS := true

# A/B
TARGET_IS_VAB := true
ENABLE_VIRTUAL_AB := true

# Boot Control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl \
    android.hardware.boot@1.1-impl.recovery \
    android.hardware.boot@1.1-service

PRODUCT_PACKAGES += \
    bootctrl.default \
    bootctrl.unisoc \
    bootctrl.unisoc.recovery

PRODUCT_PACKAGES_DEBUG += \
    bootctl

# Fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    android.hardware.fastboot@1.0-impl-mock.recovery \
    fastbootd

PRODUCT_ENFORCE_VINTF_MANIFEST := true

# API — 这套 twrp-12.1 老源码的 BOARD_SYSTEMSDK_VERSIONS 校验是写死的白名单
# （只认 28-32），33 无论怎么配置都不被识别，所以这里用 31，
# 跟已验证成功的参考树保持一致。这只是编译期的兼容性声明值，
# 不影响真机上安卓13系统的实际运行。
PRODUCT_SHIPPING_API_LEVEL := 31

# 内核模块 —— 从真机 stock vendor_boot 平台 ramdisk 里提取出的真实 .ko 文件，
# 放进 prebuilt/modules/ 目录后这里会自动全部复制进 vendor ramdisk
PRODUCT_COPY_FILES += $(foreach f,$(wildcard $(LOCAL_PATH)/prebuilt/modules/*.ko), \
    $(f):$(TARGET_COPY_OUT_VENDOR_RAMDISK)/lib/modules/$(notdir $(f)))
