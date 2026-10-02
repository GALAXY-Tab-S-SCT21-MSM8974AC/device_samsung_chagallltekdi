#
# SPDX-License-Identifier: Apache-2.0
#

COMMON_PATH := device/samsung/msm8974-common

# SCT21 固有の blobs（extract-files.sh で SCT21 の純正 /system から取り出す）。
# PRODUCT_COPY_FILES は同じ配置先が複数あると最初の組を採用するため、Wi-Fi の nvram など
# Galaxy S5 の klte-common と配置先が重なる blobs で SCT21 の版を優先させるよう、最初に継承する。
$(call inherit-product, vendor/samsung/chagallltekdi/chagallltekdi-vendor.mk)

PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# Audio
# SCT21 のスピーカーは 2 つあり、Galaxy S5 と異なる経路（LINEOUT3/4）を使う。mixer_paths.xml は純正の版を元にする。
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    $(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml

# Display
# TODO: SCT21 のパネルの輝度と nits の対応を測定する。PoC では Galaxy S5 の値を流用する。
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/displayconfig/klte/display_id_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_0.xml

# Keylayout
# 入力デバイスの名前（gpio-keys、sec_touchkey）は Galaxy S5 と同じであり、
# タッチキーは戻る（158）と履歴（254）の 2 つを報告する。
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/keylayout/klte/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(COMMON_PATH)/keylayout/klte/sec_touchkey.kl:system/usr/keylayout/sec_touchkey.kl

# Fingerprint
$(call inherit-product, $(COMMON_PATH)/fingerprint/product.mk)

# Init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/init.chagallltekdi.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.chagallltekdi.rc

# NFC
$(call inherit-product, $(COMMON_PATH)/nfc/pn547/product.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml

# RIL
PRODUCT_PACKAGES += \
    libcnefeatureconfig \
    libril_shim \
    librmnetctl

# Sensors
# 純正の SCT21 が持つセンサーの機能のみを宣言する。common.mk の既定値は Galaxy S5 の構成である。
TARGET_SENSOR_PERMISSIONS := accelerometer compass gyroscope light

$(call inherit-product, device/samsung/msm8974-common/common.mk)
$(call inherit-product, vendor/samsung/klte-common/klte-common-vendor.mk)

# common.mk は Galaxy S5 の画面（xxhdpi）を前提に値を定める。SCT21 の純正の表示密度は 320（xhdpi）である。
# PRODUCT_* 変数は inherit-product の時点で継承元の値を連結する目印を持つため、
# 継承の後で := により置き換え、common.mk の値を連結させない。
PRODUCT_AAPT_CONFIG := normal large xlarge
PRODUCT_AAPT_PREF_CONFIG := xhdpi
PRODUCT_CHARACTERISTICS := tablet
