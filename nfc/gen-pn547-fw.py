#!/usr/bin/env python3
#
# SPDX-License-Identifier: Apache-2.0
#
"""純正の PN547 のファームウェアのライブラリから、ビルド用の C のソースを生成する。

純正の libpn547_fw.so はテキスト再配置を含み、Android 6 以降のリンカは NFC のプロセスでの読み込みを拒否する。
また、LineageOS の NXP の HAL が読む gphDnldNfc_DlSeq を公開しない。ファームウェアの本体
（gphDnldNfc_DlSequence）と長さ（gphDnldNfc_DlSeqSz）を取り出し、msm8974-common の
nfc/pn547/src/libpn547_fw.c と同じ形の定義として出力する。

使い方: gen-pn547-fw.py <純正の libpn547_fw.so> <出力先のディレクトリ>
出力先には libpn547_fw.c と、それをビルドして /vendor/firmware に置く Android.bp を書く。
"""
import struct
import sys
from pathlib import Path

ANDROID_BP = """//
// このファイルは device/samsung/chagallltekdi/nfc/gen-pn547-fw.py が生成する。
//

cc_library_shared {
    name: "libpn547_fw_chagallltekdi",
    vendor: true,
    installable: false,
    compile_multilib: "32",
    srcs: ["libpn547_fw.c"],
}

prebuilt_firmware {
    name: "libpn547_fw",
    src: ":libpn547_fw_chagallltekdi",
    filename: "libpn547_fw.so",
    vendor: true,
}
"""


def read_symbols(data):
    """ELF32 の動的シンボル表から、名前と（ファイル上の位置、大きさ）の対応を返す。"""
    if data[:4] != b"\x7fELF" or data[4] != 1:
        sys.exit("ELF32 ではない")
    shoff, = struct.unpack_from("<I", data, 0x20)
    shentsize, shnum = struct.unpack_from("<HH", data, 0x2E)
    sections = [struct.unpack_from("<IIIIIIIIII", data, shoff + i * shentsize) for i in range(shnum)]
    dynsym = next(s for s in sections if s[1] == 11)  # SHT_DYNSYM
    strtab = sections[dynsym[6]]

    def to_offset(addr):
        for s in sections:
            if s[3] and s[3] <= addr < s[3] + s[5] and s[1] != 8:  # SHT_NOBITS を除く
                return addr - s[3] + s[4]
        sys.exit(f"アドレス {addr:#x} を含むセクションがない")

    symbols = {}
    for i in range(dynsym[5] // 16):
        name_off, value, size = struct.unpack_from("<III", data, dynsym[4] + i * 16)
        name = data[strtab[4] + name_off:].split(b"\0", 1)[0].decode()
        if name in ("gphDnldNfc_DlSequence", "gphDnldNfc_DlSeqSz"):
            symbols[name] = (to_offset(value), size)
    return symbols


def c_array(name, payload):
    lines = [", ".join(f"0x{b:02x}" for b in payload[i:i + 12]) for i in range(0, len(payload), 12)]
    return f"const unsigned char {name}[] = {{\n    " + ",\n    ".join(lines) + "\n};\n"


def main():
    src, out = Path(sys.argv[1]), Path(sys.argv[2])
    data = src.read_bytes()
    symbols = read_symbols(data)
    for name in ("gphDnldNfc_DlSequence", "gphDnldNfc_DlSeqSz"):
        if name not in symbols:
            sys.exit(f"{name} がない")
    seq_off, seq_size = symbols["gphDnldNfc_DlSequence"]
    sz_off, sz_size = symbols["gphDnldNfc_DlSeqSz"]
    sequence = data[seq_off:seq_off + seq_size]
    length = data[sz_off:sz_off + sz_size]
    # 版は配列の 5 バイト目（メジャー）と 4 バイト目（マイナー）にある。HAL の照合と同じ位置である。
    print(f"FW {sequence[5]:02X}.{sequence[4]:02X}, {seq_size} bytes, DlSeqSz {length.hex()}")

    out.mkdir(parents=True, exist_ok=True)
    (out / "libpn547_fw.c").write_text(
        f"/* {src.name} から gen-pn547-fw.py が生成する。 */\n\n"
        + c_array("gphDnldNfc_DlSequence", sequence)
        + "\nconst unsigned char* gphDnldNfc_DlSeq = gphDnldNfc_DlSequence;\n\n"
        + c_array("gphDnldNfc_DlSeqSz", length))
    (out / "Android.bp").write_text(ANDROID_BP)


main()
