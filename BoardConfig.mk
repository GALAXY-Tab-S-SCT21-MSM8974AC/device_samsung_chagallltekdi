#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/samsung/chagallltekdi
COMMON_PATH := device/samsung/msm8974-common

# VINTF
TARGET_TOUCH_HAL_MANIFEST := $(DEVICE_PATH)/manifest-touch.xml

include $(COMMON_PATH)/BoardConfigCommon.mk

# Bluetooth
# SCT21 のチップ（BCM4354）は BCM4350C0 の名前で応答し、libbt-vendor は bcm4350 の名前のパッチを選ぶ。
# SCT21 の純正のパッチと Galaxy S5 のパッチはいずれも「BCM4354 37.4MHz SEMCO-B80 K-LTE」の版違いであるため、
# Galaxy S5 用の設定と新しい版のパッチをそのまま使う。
BOARD_CUSTOM_BT_CONFIG := $(COMMON_PATH)/bluetooth/vnd_klte.txt
BOARD_HAVE_SAMSUNG_BLUETOOTH := true

# Build Fingerprint
# GMS の端末の登録で使われる値を、認証済みの純正の値に揃える。Play Integrity の判定に使われる値は、
# GMS のプロセスに対して PIF-inject が別途差し替える。
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

# RIL
# SCT21 の純正は Samsung の libsec-ril.so を使うが、同じ au の Galaxy S5（kltekdi）と同様に、
# klte-common の Qualcomm の RIL（libril-qc-qmi-1.so）を使う。
include $(COMMON_PATH)/radio/single/board.mk
TARGET_LD_SHIM_LIBS += \
    /system/vendor/lib/libril-qc-qmi-1.so|libril_shim.so

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

include vendor/samsung/chagallltekdi/BoardConfigVendor.mk
include vendor/samsung/klte-common/BoardConfigVendor.mk
