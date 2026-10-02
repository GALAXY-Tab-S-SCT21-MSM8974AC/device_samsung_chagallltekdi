# Galaxy Tab S 10.5（SCT21）のデバイスツリー

> **English summary:** Unofficial LineageOS 20 device tree for the au (KDDI) Samsung Galaxy Tab S 10.5 **SCT21** (SM-T807J, codename `chagallltekdi`), a Japan-only Snapdragon 801 (MSM8974PRO-AC) variant — the global Tab S 10.5 models use Exynos. It builds on top of the phone-oriented [samsung-msm8974](https://github.com/samsung-msm8974) trees (shared with the Galaxy S5 / klte) without a tablet family common tree, overriding phone-specific defaults (e.g. screen density via `TARGET_SCREEN_DENSITY`) at the device level. Work in progress; nothing is confirmed working yet. Details below are in Japanese.

au（KDDI）の Galaxy Tab S 10.5（SCT21、SM-T807J、Samsung の製品名は chagallltekdi）を対象とする、LineageOS 20 の非公式のデバイスツリーである。SoC は Qualcomm MSM8974PRO-AC であり、Galaxy S5（klte）と共通の部分は samsung-msm8974 の各リポジトリを使う。

本ツリーは開発中であり、動作の確認された機能はまだない。

## 構成

| 区分 | リポジトリ | ブランチ |
|---|---|---|
| マニフェスト | LineageOS-UL/android（eBPF を持たないカーネル 3.4 でも起動するよう改造したもの） | lineage-20.0 |
| SoC 共通のツリー | GeniusJunP/device_samsung_msm8974-common（`ro.sf.lcd_density` をデバイス側で上書きできるようにした fork） | lineage-20 |
| カーネル | GeniusJunP/kernel_samsung_msm8974（`lineage_chagallltekdi_defconfig` を追加した fork） | lineage-20 |
| SoC 共通の blobs | samsung-msm8974/vendor_samsung | lineage-20 |
| Samsung 用の HAL | LineageOS/android_hardware_samsung | lineage-20 |

## ビルドの手順

1. LineageOS-UL のマニフェストで初期化し、上表のリポジトリを定義したローカルマニフェストを `.repo/local_manifests/` に置いて同期する。
   ```
   repo init -u https://github.com/LineageOS-UL/android.git -b lineage-20.0 --git-lfs
   repo sync -c
   ```
2. SCT21 固有の blobs を取り出す。取り出し元は、KDDI 版のファームウェア `SCT21KDU1CQG1`（Android 6.0.1）の `/system` である。端末を adb で接続して引数なしで実行するか、展開済みの `/system` のパスを引数に与える。`proprietary-files.txt` の各行は、この版の SHA-1 に固定されている。
   ```
   device/samsung/chagallltekdi/extract-files.sh [展開済みの /system のパス]
   ```
3. ビルドする。
   ```
   source build/envsetup.sh
   lunch lineage_chagallltekdi-userdebug
   m bacon
   ```
