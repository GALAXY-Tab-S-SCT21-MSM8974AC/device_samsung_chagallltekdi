#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
#
# SCT21 固有の blobs のみを取り出す。SoC 共通の blobs は samsung-msm8974/vendor_samsung を使うため、
# Galaxy S5 のツリーと異なり msm8974-common の extract-files.sh を呼ばない。
# 使い方: extract-files.sh [展開済みの純正 /system のパス]（省略時は adb で端末から取り出す）

set -e

DEVICE=chagallltekdi
VENDOR=samsung

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

if [ $# -eq 0 ]; then
    SRC=adb
elif [ $# -eq 1 ]; then
    SRC=$1
else
    echo "usage: $0 [PATH_TO_EXPANDED_ROM]"
    exit 1
fi

setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false

extract "${MY_DIR}/proprietary-files.txt" "${SRC}"
extract "${MY_DIR}/proprietary-files-pn547.txt" "${SRC}"

VENDOR_DIR="${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}"
python3 "${MY_DIR}/nfc/gen-pn547-fw.py" \
    "${VENDOR_DIR}/proprietary/vendor/firmware/libpn547_fw.so" "${VENDOR_DIR}/nfc"

"${MY_DIR}/setup-makefiles.sh"
