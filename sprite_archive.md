# スプライトアーカイブ

スプライトアーカイブはスプライト情報をまとめたものです。

ロックマンエグゼにおけるスプライトアーカイブのデータフォーマットは次のようになっています。

```go
type SpriteArchive struct {
    MetadataHeader [4]byte // 後述
    AnimationPointerTable []SpriteAnimation
}

type SpriteAnimation struct {
    Frames []Frame
}

// size = 20bytes
type Frame struct {
    TileSet *TileSet
    Palettes *Palettes
    MiniAnimations []MiniAnimation
    ObjectLists []ObjectList
    Delay byte
    Zero1 byte
    Flags byte
    Zero2 byte
}

type TileSet struct {
    Size int
    BitmapData []byte
}

type Palette [16]uint16
type Palettes struct {
    PaletteSize int // 0x20
    PaletteDatum []Palette
}

type MiniAnimation = [](*MiniFrame)
type MiniFrame struct {
    ObjectListIndex byte
    Delay byte
    Flags byte
}

type ObjectList = [](*Object)
type Object struct {
    tileIdx byte // グラフィックデータの開始タイルのタイル番号
    X, Y int8
    Flag1, Flag2 byte 
}

```

ポインタを解決してフラットに書くと次のようになります

```go
type SpriteArchive struct {
    MetadataHeader [4]byte

    // AnimationPointerTable
    SpriteAnimation0 struct {
        Frame0 struct {
            TileSet struct {
                Size int
                BitmapData []byte
            }
            Palettes struct {
                PaletteSize int
                PaletteDatum [][16]uint16
            }
            MiniAnimations: []struct{
                ObjectListIndex byte
                Delay byte
                Flags byte
            }
            ObjectLists: []struct{
                tileIdx byte
                X, Y int8
                Flag1, Flag2 byte 
            }
            Delay, Zero1, Flags, Zero2 byte
        }
        Frame1 struct {...}
        FrameN struct {...}
    }
    SpriteAnimation1 struct {...}
    SpriteAnimationN struct {...}
}
```

## メタデータヘッダ(`.MetadataHeader`)

各スプライトアーカイブは4バイトのメタデータヘッダを先頭に持っています。

このブロックはエグゼシリーズでは使われておらず、スプライトのアニメーションロード時にスキップされているようです。

```
メタデータヘッダ (4 bytes):
+0x00: (byte) スプライトアーカイブのタイルセットで一番枚数が多いタイルセットのタイル枚数
+0x01: (byte) 0x00で固定？
+0x02: (byte) 0x01で固定？
+0x03: (byte) スプライトアーカイブが保持するアニメーションの数
```

タイル枚数(0x00)は基本的に最大値(size of bitmap data / 0x20)をとります。

## アニメーションポインタ(`.AnimationPointerTable`)

メタデータヘッダの直後にはアニメーションポインタのテーブルが続きます。

各アニメーションポインタは32bitで、テーブルのすべてのポインタはテーブル先頭を起点とした相対値です。

## フレームデータのリスト

それぞれのアニメーションは少なくとも1フレームを持っています。各フレームはサイズが20バイトで後述のデータフォーマットをしています。

すべてのポインタはアニメーションポインタのテーブル(の先頭)からの相対値をとります。

```
オフセット | 内容
--------------------------------------
0x00        タイルセットのポインタ(4byte)
0x04        パレットのポインタ(4byte)
0x08        ミニアニメーションへのポインタ(4byte)
0x0C        Objectsへのポインタ(4byte)
0x10        delay(1byte)
0x11        0x00で固定？(1byte)
0x12        flags(1byte)
                0x80  アニメーションの最後のフレームかどうか
                0x40  loop animation
0x13        0x00で固定？(1byte)
```

アニメーションの最後のフレームはflags(0x12)が必ず、アニメーションの終わりを表す0x80でなくてはいけません。

ただし、アニメーションの最後のフレームでflags(0x12)が0xc0(つまりbit7(0x80)とbit6(0x40)の両方が立っている)場合はアニメーションは最初のフレームからリスタートします。

## タイルセット

タイルセットの先頭には直後の4bppビットマップデータのサイズが格納されています。

```
タイルセット (4 + n bytes):
+0x00: (int) ビットマップデータのサイズ
+0x04: (byte[n]) 4bppビットマップデータ
```

ビットマップデータは複雑ですが8160バイトを超えることはありません。なぜならメタデータブロック内のタイルセットの最大タイル枚数を表すフィールドはbyteなので255以上は格納できないからです。(32×255=8160)

異なるフレームが同じタイルセットブロックを共有することもよくあります。

## パレットブロック

パレットブロックの先頭には各パレットのサイズ(常に0x20)が格納されており、その後に長さ1以上16以下のパレットの配列が続きます。

このデータフォーマットからはパレットの配列の長さ、つまりパレットブロックにパレットがいくつ含まれているかを知ることができません。

最良の方法は、スプライトアーカイブに存在するすべてのポインタのリストを作成し、次のポインタに到達するまでパレットをロードすることでしょう。

各パレットはRGB555形式の色(2バイト)を16色持っています。

```
パレットブロック (4 + n * 32 bytes):
+0x00: 0x20
+0x04: ([n][16]uint16) パレットデータ([16]uint16)の配列
```

各フレームは一度に1つのパレットしか使えないので、タイルセット同様に、異なるフレームが同じパレットブロックを共有することもよくあります。

## ミニアニメーション

ミニアニメーションは少し特殊です。

本質的には、object listsを入れ替えることで、各フレーム自体をアニメーション化することができます。

各フレームには少なくとも1つのミニアニメーションが必要で、大多数のスプライトにとっては静的なオブジェクトリストに過ぎません。

ミニアニメーションはほとんど使われていません。また配列の先頭のミニアニメーションはデフォルトのミニアニメーションとして扱われます。

ミニアニメーションブロックは32bitのミニアニメーションのポインタテーブルからなります。このミニアニメーションのポインタはテーブルの先頭からの相対値で表されます。

各ミニアニメーションは少なくとも1つのミニフレーム(3バイト)から構成されています。

```
ミニフレーム (3 bytes):
+0x00: (byte) index of object list to use
+0x01: (byte) delay
+0x02: (byte) flags
```

flags(+0x02)の内容はフレームデータのflagsと同じです。

ミニフレームの最後は `[0xff, 0xff, 0xff]`となっています。

## object lists

配列がネストしているので混乱しないように注意してください。 `object lists` > `object list` > `object` です。

object listsはミニアニメーションと連動して動作します。

ミニアニメーションは、モーションを実現するために、OAMメモリ内のobject listsをスワップアウトします。

アニメーションの各フレームには少なくとも1つのobject listが必要で、通常はデフォルトの（静的な）ミニアニメーションに使用されます。

ミニアニメーションと同様に、object listsブロックは、各object listsの32ビットポインタのポインタテーブルとなっています。このポインタはテーブル先頭からの相対値をとります。

各object listは、オブジェクト(5バイト)の配列で構成されています。技術的には空の配列にすることもできますが、これは推奨されません。

```
オブジェクト (5 bytes):
+0x00: (byte) グラフィックデータの開始タイル
+0x01: (sbyte) 左上のX座標
+0x02: (sbyte) 左上のY座標
+0x03: (byte) flags 1
+0x04: (byte) flags 2

flags 1:
bits 0-1: オブジェクトサイズ(後述)
bits 2-5: 使用しない
bit 6: X反転
bit 7: Y反転

flags 2:
bits 0-1: オブジェクトシェイプ(後述)
bits 2-3: 使用しない
bits 4-7: パレットインデックス
```

オブジェクトサイズとオブジェクトシェイプの両方が揃ってオブジェクトのピクセルサイズが決定します。

8x8のタイルが複数集まったオブジェクトの場合、左から右、上から下へオブジェクトの開始タイルとして設定されたタイル(+0x00)からロードされていきます。

 (size, shape) | ピクセルサイズ
 -- | -- 
 (0, 0) | 8x8
 (0, 1) | 16x8
 (0, 2) | 8x16
 (1, 0) | 16x16
 (1, 1) | 32x8
 (1, 2) | 8x32
 (2, 0) | 32x32
 (2, 1) | 32x16
 (2, 2) | 16x32
 (3, 0) | 64x64
 (3, 1) | 64x32
 (3, 2) | 32x64

パレットインデックスは、現在 VRAM にロードされているパレットではなく、このフレームが使用するパレットブロックを指します。

object list内のすべてのオブジェクトは同じパレットを使用しなければならないので、アニメーションの各フレームでも同じことが言えます。

各オブジェクトのエントリは GBA OBJスプライトに変換され、OAMメモリにコピーされます。object listの終わりには 5 バイトの `[0xFF 0xFF 0xFF 0xFF 0xFF]` がきます。

## ゴミデータ

スプライトアーカイブにはゴミデータが含まれていることがあります。

ミニアニメーションやオブジェクトリストのデータブロックは常に４の倍数にパディングされていますが、実際のゲームのスプライトアーカイブではパディングする必要がない場合でも常に４の倍数にパディングされていてその余分なバイトがゴミデータになっているようです。

ゴミデータのパターンは明らかにされていませんが、完全に使われていないので、無視しても大丈夫です。

## 参考記事

- [BN Sprite Archive Format (revised)](https://forums.therockmanexezone.com/bn-sprite-archive-format-revised-t5403.html)
