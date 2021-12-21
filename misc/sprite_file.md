# スプライトファイル

ロックマンエグゼにおけるスプライトファイルのデータフォーマットは次のようになっています。

スプライトファイルはスプライトアーカイブ(アニメーションポインタの集合)に加えて実際のアニメーションデータも含んだものです。

なので、[スプライトアーカイブ](sprite_archive.md)を先に読んでおくことを推奨します。

```go

type Spr4BppData []byte // 4bpp?
type Palette [16]uint16

type SpriteFile struct {
    // same as sprite archive
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
    // oam data
}
```

## アニメーションデータ

アニメーションデータは4バイトのデータが5個集まってできています。

- data1: グラフィックサイズへのポインタ
- data2: パレットサイズへのポインタ
- data3: ゴミデータへのポインタ
  - 使われていない
- data4: OAMデータへのポインタ
  - all regular sprites have a pointer of 00000004
  - pointers are relative to initial read point
  - mugshots use more pointers than regular sprites
- data5: アニメーションの長さ・タイプ
  - 2バイト×2で構成(0x00xx, 0x00yy)
  - 0x00xx: delay(1/60秒単位)
  - 0x00yy: アニメーションタイプ
    - 0x00: 通常(このフレームをdelayの間保持)
    - 0x80: アニメーションの終わり
    - 0xc0: ループアニメーションの終端

## スプライトデータ

- スプライトデータの先頭には1つのスプライトのサイズを表す4バイトのデータが格納されています。
- スプライトデータは1ピクセル=4bitです。

## パレットデータ

- パレットデータも先頭にはパレット1つのサイズを表す4バイトのデータが格納されています。
- パレットデータは16色で構成されており、最初の色は透明です。
- すべてのパレットは、次から次へと続き、ランダムアクセスされることはありません。


## ゴミデータ

- スプライトに影響を与えない 4バイトデータ×3
- 00000004のポインタから始まり、FF800100 FFFFFFFFと続きます。

## OAMデータ

- sets the sprite dimensions, palette increment, and position
- each OAM is built using 5 bytes of data
    * tile: determines which tile to start building from based on the position set by animation data
    * x-position: sets x-position of the tile (FF is a negative position and 01 is a positive position)
    * y-position: sets y-position of the tile
    * OAM size/rotation: left side of the byte sets rotation, right side sets size
- 00= no flip
- 40= horizontal flip
- 80= vertical flip
- C0= horizontal-vertical flip

- 00= 8x8 tile
- 01= 16x16 tile
- 02= 32x32 tile
- 03= 64x64 tile
    * OAM modifier/palette increment: left side sets a new palette, right side sets modified size
- ex. 10 means the next palette will be used for the entire sprite
- only the first OAM can use this
- modifier: see "OAM Modifier Table"
- new OAM data follows directly after the last OAM data
- to end oam data set FF FF FF FF FF