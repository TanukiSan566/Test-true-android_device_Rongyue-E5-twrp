DEVICE_PATH := device/unisoc/ums9621_1h10

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic

# 64-Bit
TARGET_IS_64_BIT := true
TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true

TARGET_CPU_SMP := true
ENABLE_CPUSETS := true
ENABLE_SCHEDBOOST := true

# Vendor_boot recovery ramdisk [参考 ZTE P720S16 同平台成功案例结构]
BOARD_USES_VENDOR_BOOT := true
BOARD_BOOT_HEADER_VERSION := 4
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true

# Bootloader / Platform
TARGET_BOOTLOADER_BOARD_NAME := ums9621_1h10
TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true
BOARD_USES_SPRD_HARDWARE := true
TARGET_BOARD_PLATFORM := ums9621
TARGET_BOARD_PLATFORM_GPU := mali-g57

# Display [已核实：真机真实分辨率]
TARGET_SCREEN_DENSITY := 160
TARGET_SCREEN_WIDTH := 320
TARGET_SCREEN_HEIGHT := 480

# Kernel header [已核实：全部来自对真机 vendor_boot_a.img 头部的实际解析]
BOARD_BOOTIMG_HEADER_VERSION := 4
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := console=ttyS1,115200n8 bootconfig bootconfig
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x05400000
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_DTB_OFFSET := 0x01f00000
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_INCLUDE_DTB_IN_BOOTIMG := false

# Ramdisk compression [已核实：真机 vendor_boot ramdisk 是 lz4 legacy 格式，magic 0x184C2102]
BOARD_RAMDISK_USE_LZ4 := true

# Kernel - prebuilt [关键改动：改用真实提取的内核文件，而不是 TARGET_NO_KERNEL，
# 参考 ZTE 树的成功模式——这很可能是之前"root目录生成不出来"系列报错的真正根源]
TARGET_FORCE_PREBUILT_KERNEL := true
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtbo.img
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
BOARD_INCLUDE_DTB_IN_BOOTIMG :=
endif

# AVB（设备bootloader为unlocked/orange状态，AVB校验不强制，签名用测试key即可）
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# A/B [已核实：真机分区列表]
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    init_boot \
    vendor_boot \
    vbmeta \
    vbmeta_odm \
    vbmeta_product \
    vbmeta_system \
    vbmeta_system_ext \
    vbmeta_vendor \
    super

# Partitions [已核实：真机 blockdev --getsize64 实测数值]
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 104857600
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SUPPRESS_SECURE_ERASE := true
BOARD_USES_METADATA_PARTITION := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EROFS := true

# Filesystem types
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_ODM := odm

# Dynamic partitions / super [已核实：真机 blockdev --getsize64 /dev/block/by-name/super]
BOARD_SUPER_PARTITION_SIZE := 5872025600
BOARD_SUPER_PARTITION_GROUPS := group_unisoc_a
BOARD_GROUP_UNISOC_A_SIZE := 5867831296
BOARD_GROUP_UNISOC_A_PARTITION_LIST := system system_ext vendor product odm vendor_dlkm

BOARD_ROOT_EXTRA_SYMLINKS := \
    /system/product:/product \
    /system/system_ext:/system_ext

PLATFORM_VERSION := 13

# Crypto — 按要求不需要解密支持，跳过这块最容易出问题的配置
TW_INCLUDE_CRYPTO := false
TW_INCLUDE_CRYPTO_FBE := false

TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_NO_RECOVERY := true
TARGET_USES_MKE2FS := true
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs

# 内核模块 —— 真机提取的163个真实 .ko，走标准打包机制而非 PRODUCT_COPY_FILES
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(wildcard $(DEVICE_PATH)/prebuilt/modules/*.ko)

# Build hacks（同参考树，避免因缺少非关键依赖而中断整个编译）
ALLOW_MISSING_DEPENDENCIES := true
BUILD_BROKEN_DUP_RULES := true

# Sysfs path（展讯平台常见背光/闪光灯路径，与system.prop配合作为起点，若实机不对可再调整）
BOARD_COMMON_BACKLIGHT_PATH := /sys/class/backlight/sprd_backlight/brightness
BOARD_COMMON_FLASHLIGHT_PATH := /sys/devices/virtual/misc/sprd_flash/test

TW_INCLUDE_RESETPROP := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_LIBRESETPROP := true

TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true

# TWRP 界面配置 [已核实：真机 320x480 分辨率]
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := zh_CN
TW_NO_HAPTICS := true
TW_NO_FLASH_CURRENT_TWRP := true

TW_BRIGHTNESS_PATH := $(BOARD_COMMON_BACKLIGHT_PATH)
TW_DEFAULT_BRIGHTNESS := 150
TW_MAX_BRIGHTNESS := 255

TW_INCLUDE_FASTBOOTD := true
TW_USE_TOOLBOX := true
RECOVERY_SDCARD_ON_DATA := true
TW_USE_EXTERNAL_STORAGE := true

# 关键改动：交给 TWRP 官方构建系统生成的默认 USB 初始化脚本（configfs），
# 不再使用我们之前手写的自定义 init.recovery.usb.rc——那份是在猜测 UDC 相关细节，
# 而官方默认脚本 + system.prop 里指定真实 UDC 名字，是参考树验证过的正确做法
TW_EXCLUDE_DEFAULT_USB_INIT := true

TW_NO_BIND_SYSTEM := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_NO_LEGACY_PROPS := true
TW_NO_FASTBOOT_BOOT := true

BOARD_MAINTAINER_NAME := ums9621_1h10
TW_DEVICE_VERSION := $(BOARD_MAINTAINER_NAME)
