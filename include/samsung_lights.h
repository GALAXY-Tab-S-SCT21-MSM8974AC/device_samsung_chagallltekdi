/*
 * SPDX-License-Identifier: Apache-2.0
 */

#pragma once

/*
 * 値は SCT21 の /sys/class/leds で確認した。
 * タッチキーのバックライトは tc300k のドライバーが button-backlight として提供する。
 * SCT21 は通知 LED を持たないため、LED_BLINK_NODE を定義しない。lights の HAL は、
 * 未定義の場合に通知、電池、注意喚起の各ライトを登録しない。
 */
#define PANEL_BRIGHTNESS_NODE "/sys/class/leds/lcd-backlight/brightness"
#define PANEL_MAX_BRIGHTNESS_NODE "/sys/class/leds/lcd-backlight/max_brightness"
#define BUTTON_BRIGHTNESS_NODE "/sys/class/leds/button-backlight/brightness"
