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

# 内核模块 —— 从真机 stock vendor_boot 平台 ramdisk 里提取出的真实 .ko 文件
# 用 BOARD_VENDOR_RAMDISK_KERNEL_MODULES 走标准内核模块打包机制（自动生成 modules.load/modules.dep），
# 不能再用 PRODUCT_COPY_FILES 直接复制 —— 新版构建系统会把 .ko 当成未受管控的 ELF 文件拦下来
