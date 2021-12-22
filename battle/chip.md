# チップデータ

## フォーマット

```
0x00 Chip Code1,2,3,4
	00 = A
	19 = Z
	1A = *
	FF = None
0x04 攻撃時の属性 (1 byte) (チップの種類によっては使わない場合もある)
	Bits 0-3: 基本属性
		0x00 = 無
		0x01 = 火
		0x02 = 水
		0x03 = 雷
		0x04 = 木
	Bit 4: ブレイク属性がついているか
	Bit 5: 風属性がついているか
	Bit 6: カーソル属性がついているか
	Bit 7: ソード属性がついているか
0x05 レア度	(1 byte)
	00 = 星1
	01 = 星2
	02 = 星3
	03 = 星4
	04 = 星5
0x06 属性アイコン (1 byte) (実際の攻撃属性とは結びついていないことに注意)
	00= Fire
	01= Aqua
	02= Elec
	03= Wood
	04= +/-
	05= Sword
	06= Cursor
	07= Object
	08= Wind
	09= Break
	0A= Null
0x07 ライブラリでの区分 (1 byte)
	0x00 = スタンダード
	0x01 = メガ
	0x02 = ギガ
	0x03 = 無し
	0x04 = P.A.
0x08 チップ容量(~MB) (1 byte)
0x09 チップの表示フラグ (1byte)
	Bit 0: 暗転チップ (表示にのみ使用)
	Bit 1:  攻撃力を表示する
	Bit 2:  ナビチップ (表示にのみ使用)
	Bit 3:  ?
	Bit 4:  攻撃力を"???"と表示する
	Bit 5:  ダークチップ
	Bit 6:  ライブラリ内に表示される
	Bit 7: 攻撃力が変動する
0x0A カウンターについてのプロパティ	(1 byte)
	Bits 0-6: このチップが相手の攻撃に対してカウンターをとれるフレーム数
	Bit 7: このチップがダメージを与えることができる暗転チップである場合にセットされます。このときのカウンターフレーム(bit0-6)は正である必要があります。
0x0B Attack family (1byte)
0x0C Attack subfamily (1byte)
0x0D DarkSoul MegaMan usage behavior (1byte)
0x0E Unknown (8-bit unknown)
0x0F Lock-on enable (1-bit flag)
0x10 Attack parameter 1 (1 byte)
0x11 Attack parameter 2 (1 byte)
0x12 Attack parameter 3 (1 byte)
0x13 Attack parameter 4 (1 byte)
0x14 Chip use delay frames (1 byte)
0x15 Library number (1 byte) (BN6)
0x16 Chip Library flags (8-bit bitfield) (NOTE: For unknown reasons, BigHook is labeled a Falzar Giga chip and MetrKnuk is labeled a Gregar Giga chip.)
	0x01 = Secret Library chip
	0x02 = ?
	0x04 = Gregar Giga chip
	0x08 = Falzar Giga chip
	0x10 = Chip cannot be traded
	0x20 = Chip does not appear in Pack
	0x40 = Modifier chip (Atk+10, WhiCapsl, etc.)
	0x80 = ?
0x17 Lock-onタイプ (1byte)
0x18 Alphabet sort position (2bytes)
0x1A チップの攻撃力 (2bytes)
0x1C ID sort position (2bytes)
0x1E Battle Chip Gate usage limit (1byte)
0x1F ダークチップID (1byte) (0xFFFF以外の値を設定した場合、チップを使用するたびにBugFragが消費されます。BugFragが残っていない場合は、次の表にしたがって別のチップに変更されます。)
	0x00 = Sword
	0x01 = Thunder
	0x02 = Recov10
	0x03 = Invisibl
	0x04 = Atk+10
0x20 チップアイコンを指すポインタ (32-bit pointer)
0x24 チップ画像を指すポインタ (32-bit pointer)
0x28 チップパレット(?)を指すポインタ (32-bit pointer)
```

## 参考記事

- [Chip Data Format](https://forums.therockmanexezone.com/chip-data-format-t5362-s30.html#p342034)
