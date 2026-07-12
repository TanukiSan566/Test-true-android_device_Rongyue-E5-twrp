# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Enable virtual A/B OTA
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Inherit some common twrp stuff.
$(call inherit-product-if-exists, vendor/twrp/config/common.mk)

# Inherit from ums9621_1h10 device
$(call inherit-product, device/unisoc/ums9621_1h10/device.mk)

PRODUCT_DEVICE := ums9621_1h10
PRODUCT_NAME := twrp_ums9621_1h10
PRODUCT_BRAND := unisoc
PRODUCT_MODEL := LXX516
PRODUCT_MANUFACTURER := unisoc
