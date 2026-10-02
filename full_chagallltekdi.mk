#
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, device/samsung/chagallltekdi/device.mk)

PRODUCT_NAME := full_chagallltekdi
PRODUCT_DEVICE := chagallltekdi
PRODUCT_BRAND := samsung
# GMS の Quick Share は、メーカーが samsung の端末では Samsung 独自の Quick Share アプリに処理を任せ、自身を表示しない。
# LineageOS にはそのアプリがないため、msm8974-common の system.prop（ro.product.manufacturer=Google）と揃えて Google とする。
PRODUCT_MANUFACTURER := Google
PRODUCT_MODEL := SCT21
