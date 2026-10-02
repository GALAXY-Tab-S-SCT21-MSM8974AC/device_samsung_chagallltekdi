#
# SPDX-License-Identifier: Apache-2.0
#

# SCT21 は通話機能を持たず、LTE のデータ通信のみを行うタブレットである。
# データ通信に電話の基盤が要るため、wifionly ではない tablet の構成を使う。
$(call inherit-product, vendor/lineage/config/common_full_tablet.mk)

$(call inherit-product, device/samsung/chagallltekdi/full_chagallltekdi.mk)

PRODUCT_DEVICE := chagallltekdi
PRODUCT_NAME := lineage_chagallltekdi
