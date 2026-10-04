# Galaxy Tab S 10.5（SCT21）のデバイスツリー

> **English summary:** Unofficial LineageOS 20 device tree for the au (KDDI) Samsung Galaxy Tab S 10.5 **SCT21** (SM-T807J, codename `chagallltekdi`), a Japan-only Snapdragon 801 (MSM8974PRO-AC) variant — the global Tab S 10.5 models use Exynos. It builds on top of the phone-oriented [samsung-msm8974](https://github.com/samsung-msm8974) trees (shared with the Galaxy S5 / klte) without a tablet family common tree, overriding phone-specific defaults (e.g. screen density via `TARGET_SCREEN_DENSITY`) at the device level. Work in progress. The userdata partition is not encrypted (see below). Details below are in Japanese.

au（KDDI）の Galaxy Tab S 10.5（SCT21、SM-T807J、Samsung の製品名は chagallltekdi）を対象とする、LineageOS 20 の非公式のデバイスツリーである。SoC は Qualcomm MSM8974PRO-AC であり、Galaxy S5（klte）と共通の部分は samsung-msm8974 の各リポジトリを使う。

本ツリーは開発中である。

## 動作の状況

| 状況 | 機能 |
|---|---|
| 動作を確認した | 起動、画面、明るさの自動調整、タッチ、タッチキー、Wi-Fi、Bluetooth、スピーカー、センサー、背面と前面のカメラ、指紋 |
| 未確認 | モバイルデータ（SIM での確認をしていない）、カメラのフラッシュ |
| 組み込まない | NFC（理由は `device.mk` のコメントに記す） |

## 既知の制約

- データの領域（`/data`）は暗号化されない。Android 13 は端末全体の暗号化（FDE）に対応せず、ファイル単位の暗号化（FBE）はカーネルのファイルシステムの暗号化（fscrypt）を要する。共有カーネル（3.4）の msm8974 の機種は、いずれもこれを有効にしていない。共通ツリーは FDE の指定を fstab から除いている（samsung-msm8974 の `0670fc6`）。本ツリーは暗号化を実現しない。

## 構成

ビルドに必要なリポジトリは、`local_manifests/` の 2 つのローカルマニフェストに定義してある。

| ファイル | 内容 |
|---|---|
| `local_manifests/chagallltekdi.xml` | SCT21 のためのリポジトリ |
| `local_manifests/upstream.xml` | LineageOS-UL のフォークのうち本家に遅れているものを、本家の更新を取り込んだ fork に差し替える |

| 区分 | リポジトリ | ブランチ | 理由 |
|---|---|---|---|
| マニフェスト | LineageOS-UL/android | lineage-20.0 | eBPF を持たないカーネル 3.4 でも Android 13 が起動するよう、system/bpf や system/netd などを改造している |
| デバイスツリー | GALAXY-Tab-S-SCT21-MSM8974AC/device_samsung_chagallltekdi（本リポジトリ） | lineage-20 | — |
| SoC 共通のツリー | GALAXY-Tab-S-SCT21-MSM8974AC/device_samsung_msm8974-common | lineage-20 | samsung-msm8974 の fork。`ro.sf.lcd_density` をデバイス側で上書きできるようにした |
| カーネル | GALAXY-Tab-S-SCT21-MSM8974AC/kernel_samsung_msm8974 | lineage-20 | samsung-msm8974 の fork。`lineage_chagallltekdi_defconfig` を追加した |
| SoC 共通の blobs | samsung-msm8974/vendor_samsung | lineage-20 | — |
| Samsung 用の HAL | LineageOS/android_hardware_samsung | lineage-20 | — |
| DNG SDK | GALAXY-Tab-S-SCT21-MSM8974AC/android_external_dng_sdk | lineage-20.0 | 本家の更新が Android 13 にない SDK 向けの libjpeg を要求するため、その指定を除いた |
| UL のフォーク 12 件 | GALAXY-Tab-S-SCT21-MSM8974AC/android_*-ul | lineage-20.0 | UL は 2025-04 で更新が止まり、本家はセキュリティの修正を取り込み続けている。本家の更新を取り込んだ fork |
| APN | LineageOS/android_vendor_apn | main | 本家は APN のデータを vendor/lineage から移した |

## ビルドの手順

1. LineageOS-UL のマニフェストで初期化し、本リポジトリのローカルマニフェストを置いて同期する。
   ```
   repo init -u https://github.com/LineageOS-UL/android.git -b lineage-20.0 --git-lfs
   mkdir -p .repo/local_manifests
   curl -fsSL -o .repo/local_manifests/chagallltekdi.xml https://raw.githubusercontent.com/GALAXY-Tab-S-SCT21-MSM8974AC/device_samsung_chagallltekdi/lineage-20/local_manifests/chagallltekdi.xml
   curl -fsSL -o .repo/local_manifests/upstream.xml https://raw.githubusercontent.com/GALAXY-Tab-S-SCT21-MSM8974AC/device_samsung_chagallltekdi/lineage-20/local_manifests/upstream.xml
   repo sync -c
   ```
2. SCT21 固有の blobs を取り出す。取り出し元は、KDDI 版のファームウェア `SCT21KDU1CQG1`（Android 6.0.1）の `/system` である。端末を adb で接続して引数なしで実行するか、展開済みの `/system` のパスを引数に与える。`proprietary-files.txt` の各行は、この版の SHA-1 に固定されている。
   ```
   device/samsung/chagallltekdi/extract-files.sh [展開済みの /system のパス]
   ```
3. ビルドする。soong の解析は 13 GB 前後のメモリを使うため、物理メモリとスワップを合わせて 16 GB 以上を用意する。
   ```
   source build/envsetup.sh
   lunch lineage_chagallltekdi-userdebug
   m bacon
   ```
