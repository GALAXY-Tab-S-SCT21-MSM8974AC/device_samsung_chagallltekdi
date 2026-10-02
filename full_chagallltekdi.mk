#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, device/samsung/chagallltekdi/device.mk)

PRODUCT_NAME := full_chagallltekdi
PRODUCT_DEVICE := chagallltekdi
PRODUCT_BRAND := samsung
PRODUCT_MANUFACTURER := samsung
PRODUCT_MODEL := SCT21
