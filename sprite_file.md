# スプライトファイル

ロックマンエグゼにおけるスプライトファイルのデータフォーマットは次のようになっています。

スプライトファイルは[スプライトアーカイブ(アニメーションポインタの集合)](sprite_archive.md)に加えて実際のアニメーションデータも含んだものです。

```go
type Spr4BppData []byte // 4bpp?
type Palette [16]uint16
type OamData [5]byte // 後述

type SpriteFile struct {
    // スプライトアーカイブと同じ内容
    MetadataHeader [4]byte
    AnimationPointerTable []SpriteAnimation

    // raw data
    AnimationData [5][4]byte
    SpriteData struct {
        SprSize uint32
        Spr4BppDatum []Spr4BppData 
    }
    PaletteData struct {
        PaletteSize uint32
        PaletteDatum []Palette
    }
    JunkData [3][4]byte
    OamDatum []OamData
}
```

## メタデータヘッダ(`.MetadataHeader`)

[アーカイブファイル](./sprite_archive.md)のメタデータヘッダと内容は同じです。

## アニメーションデータ(`.AnimationData`)

アニメーションデータは4バイトのデータが5個集まってできています。

```
Bytes | Expl.
---------------
0-3:      グラフィックサイズへのポインタ
            - reads 4 bytes to determine # of bytes to load for graphics
4-7:      パレットサイズへのポインタ
            - reads 4 bytes to determine # of bytes to load for palette
8-11:     ゴミデータへのポインタ(使われていません)
12-16:    OAMデータへのポインタ
            - all regular sprites have a pointer of 00000004
            - pointers are relative to initial read point
            - mugshots use more pointers than regular sprites
17-20:    アニメーションの長さ・タイプ
            - 2バイト×2で構成((0xXX, 0xYY) x2)
            - 0xXX: delay(1/60秒単位)
            - 0xYY: アニメーションタイプ
              - 0x00: 通常(このフレームをdelayの間保持)
              - 0x80: アニメーションの終わり
              - 0xc0: ループアニメーションの終端
```

## スプライトデータ(`.SpriteData`)

- スプライトデータの先頭には1つのスプライトのサイズを表す4バイトのデータが格納されています。
- スプライトデータは1ピクセル=4bitです。

## パレットデータ(`.PaletteData`)

- パレットデータも先頭にはパレット1つのサイズを表す4バイトのデータが格納されています。
- パレットデータは16色で構成されており、最初の色は透明です。
- すべてのパレットは、次から次へと続き、ランダムアクセスされることはありません。

## ゴミデータ(`.JunkData`)

- スプライトに影響を与えない、4バイトデータ×3
- オフセット`00000004`を指すポインタから始まり、`FF800100 FFFFFFFF`と続きます。

## OAMデータ(`.OamDatum`)

OAMデータの配列です。

各OAMデータは5byteで、スプライトの次元、パレットのインクリメント(量)、位置データがセットされています。

配列の終わりには終端記号として`FF FF FF FF FF`がきます。

### 各OAMデータ(5byte, `OamData`)のフォーマット

```
Offset | Expl.
---------------
0:       タイル。アニメーションデータで設定した位置に基づいて、どのタイルからビルドを開始するかを決定します。
1:       X座標。
2:       Y座標。
3:       OAMのサイズ・回転(上位ニブル: 回転、下位ニブル: サイズ)
          0x0X: 反転無し
          0x4X: X反転
          0x8X: Y反転
          0xCX: XY反転
          0xX0: 8x8タイル
          0xX1: 16x16タイル
          0xX2: 32x32タイル
          0xX3: 64x64タイル
4:       OAM modifier/palette increment(left side sets a new palette, right side sets modified size)
          - ex. 10 means the next palette will be used for the entire sprite
          - only the first OAM can use this
          - modifier: see "OAM Modifier Table"
```

## 参考記事

- [BN Sprite File Format](https://forums.therockmanexezone.com/viewtopic.php?p=178724#p178724)

