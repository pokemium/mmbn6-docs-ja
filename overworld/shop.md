# ショップ

ここでのショップは、

- アスタランド
- インターネット上のショップ
- バグのかけら交換屋
- サブチップ

といったゼニーやバグのかけらとアイテムを交換してくれる概念全体を指します。

## 概要

ショップのデータはショップエントリとショップアイテムエントリの2つに分かれて格納されています。

`ShopList (GregarJP: 0x8047ba4)`にはショップエントリの配列が格納されています。この配列は固定サイズで、終端記号はありません。

`ShopItemList (GregarJP: 0x8048d9c)` にはショップアイテムのエントリープールがあります。この配列は固定サイズですが、`0x00`は終端記号として扱われます。

各ショップエントリには、アイテムプールの先頭からの相対的なオフセットが並んでいます。ショップがロードされると、指定されたオフセットから始まるプールから指定された数のアイテムが読み込まれます。

新しいゲームを開始すると、ショップのアイテムプール全体が `0x020032C8 (FalzarUS)` にコピーされ、ゲーム中はそこにずっと配置されています。これは、HPメモリなどのアイテムを購入したときにゲームがアイテムの金額を変更できるようにするためです。

ショップエントリの開始オフセットは、ROM 内のアイテムプールと RAM 内のアイテムプールの両方に使用されます。

チート対策として、RAM内のアイテムプール(金額なし)とROM内のアイテムプールが異なる場合、購入を拒否するようにしています。`0x0804740C (FalzarUS)` と `0x08047416 (FalzarUS)` のチェックを無効にするには、`0x0804740C (FalzarUS)` と `0x08047416 (FalzarUS)` をヌルアウトしてください。（他にも無効にする必要がフラグがあるかもしれません）

## フォーマット

```go
type pointer = uint32

// ショップエントリ(16byte)
type Shop struct {
    Type uint32 // 0=通常ショップ,1=バグのかけら交換屋,2=チップ取り寄せ
    CompShopTextArchive pointer
    ShopItemPoolStartOffset uint32
    MaxNumberOfItems uint32 // Max number of items in shop to load
}

// ショップアイテムエントリ(8byte)
type ShopItem struct {
    Type byte // 0=無,1=アイテム,2=チップ,3=ナビカス
    Amount byte // 在庫数
    Index uint16 // Item/BattleChip/Programのインデックス
    Metadata byte // チップの場合:チップコード, ナビカスの場合:色
    Unused byte
    Price uint16 // 1につき 100z or バグのかけら1個
}
```

## 参考記事

- [BN3/BN4/BN5/BN6 shop notes](https://forums.therockmanexezone.com/bn3-bn4-bn5-bn6-shop-notes-t5338.html)

