# Object

## ObjectHeader

```go
type ObjectHeader {
    Flags Flags
    Index byte // BattleObjectのインデックスを表したり
    TypeAndSpriteOffset byte // 後述
    ListIndex byte
}
```

### TypeAndSpriteOffset

bit7-4 | bit3-0
-- | --
ObjectSpriteのBattleObjectでのオフセット | BattleObjectのType(1=t1, 3=t3, 4=t4)

### Flags

id(8bit) | expl
-- | -- 
0x01 | objectFlagActive
0x02 | objectFlagVisible
0x04 | objectFlagPauseUpdate
0x08 | objectFlagStopSpriteUpdate
0x10 | objectFlagUpdateDuringTimestop
0x20 | objectFlagUnk20
0x40 | objectFlagUnk40
0x80 | objectFlagUnk80

## ObjectSprite

```go
type ObjectSprite {
    Unk_00 byte // アニメーションに関連あり
    Unk_01 byte
    Unk_02 byte
    Unk_03 byte
    Unk_04 byte
    Unk_05 byte
    Unk_06 uint16
    Pad_08 byte[2]
    Unk_0a uint16
    Pad_0c byte[4]
    Unk_10 byte
    Unk_11 byte
    Unk_12 byte
    Unk_13 byte
    Unk_14 byte
    Unk_15 byte
    Unk_16 uint16
    Unk_18 uint32
    Unk_1c uint32
    Unk_20 uint32
    Unk_24 uint32
    Unk_28 uint32
    Unk_2c uint32
    Unk_30 uint32
    Unk_34 uint32
}
```