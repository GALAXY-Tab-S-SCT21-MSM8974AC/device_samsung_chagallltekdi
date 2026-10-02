#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/samsung/chagallltekdi
COMMON_PATH := device/samsung/msm8974-common

include $(COMMON_PATH)/BoardConfigCommon.mk

# Bluetooth
# TODO: SCT21 の純正には bt_vendor.conf がないため、Galaxy S5 用の設定を流用する。
# チップが BCM4350 と BCM4354 のどちらの名前で応答するかは、初回起動時の libbt-vendor のログで確認する。
BOARD_CUSTOM_BT_CONFIG := $(COMMON_PATH)/bluetooth/vnd_klte.txt
BOARD_HAVE_SAMSUNG_BLUETOOTH := true

# Build Fingerprint
BUILD_FINGERPRINT := KDDI/SCT21/SCT21:6.0.1/MMB29M/SCT21KDU1CQG1:user/release-keys

# Display
TARGET_SCREEN_DENSITY := 320
# common.mk は Galaxy S5 の 1920x1080 を設定する。inherit-product で取り込まれる common.mk は
# device.mk の後に評価されるため、製品の設定より後に読まれる BoardConfig で SCT21 の値に置き換える。
TARGET_SCREEN_HEIGHT := 1600
TARGET_SCREEN_WIDTH := 2560

# Kernel
TARGET_KERNEL_CONFIG := lineage_chagallltekdi_defconfig

# OTA
TARGET_OTA_ASSERT_DEVICE := chagallltekdi,SCT21

# Partition
# 値は SCT21 の /proc/partitions と by-name の対応から得た。
BOARD_CACHEIMAGE_PARTITION_SIZE := 209715200
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2621440000

# Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../$(COMMON_PATH)/recovery/recovery_keys.c

# Include
# samsung_lights.h の sysfs のパスが Galaxy S5 と異なるため、SCT21 用のヘッダーを使う。
TARGET_SPECIFIC_HEADER_PATH := $(DEVICE_PATH)/include

# Fingerprint
include $(COMMON_PATH)/fingerprint/board.mk

# TODO: RIL。SCT21 は Samsung の libsec-ril.so を使うが、Galaxy S5 の lineage-20 は Qualcomm の RIL に移行済みである。
# PoC ではモバイルデータ通信を対象外とし、radio の設定を含めない。

include vendor/samsung/chagallltekdi/BoardConfigVendor.mk
include vendor/samsung/klte-common/BoardConfigVendor.mk
