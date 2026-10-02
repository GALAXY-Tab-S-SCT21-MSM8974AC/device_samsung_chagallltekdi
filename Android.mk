#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),chagallltekdi)

# TrustZone のアプリは apnhlos パーティション（/firmware/image）にある。msm8974-common が作らない
# SCT21 のアプリへのリンクを /vendor/firmware に作る。securefp は指紋の HAL が使う。
FIRMWARE_IMAGES := \
    $(foreach f,dmverity fp_asm securefp t2_ks_mi tz_ccm tz_iccc tz_otp, \
        $(f).b00 $(f).b01 $(f).b02 $(f).b03 $(f).mdt)

FIRMWARE_SYMLINKS := $(addprefix $(TARGET_OUT_VENDOR)/firmware/,$(FIRMWARE_IMAGES))
$(FIRMWARE_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "Firmware link: $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf /firmware/image/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += $(FIRMWARE_SYMLINKS)

endif
