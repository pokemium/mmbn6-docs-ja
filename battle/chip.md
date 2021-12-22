# チップデータ

## フォーマット

```
0x00 Chip Code1,2,3,4
	00 = A
	19 = Z
	1A = *
	FF = None
0x04 Attacking element (1 byte) (NOTE: This value doesn't do anything for some chips)
	Bits 0-3: primary element
		0x00 = Null
		0x01 = Heat
		0x02 = Aqua
		0x03 = Elec
		0x04 = Wood
	Bit 4: Break toggle
		0x00 = No Break damage
		0x01 = Deals Break damage
	Bit 5: Wind toggle
		0x00 = No Wind damage
		0x01 = Deals Wind damage
	Bit 6: Cursor toggle
		0x00 = No Cursor damage
		0x01 = Deals Cursor damage
	Bit 7: Sword toggle
		0x00 = No Sword damage
		0x01 = Deals Sword damage
0x05 Rarity	(1 byte)
	00 = 1 star
	01 = 2 star
	02 = 3 star
	03 = 4 star
	04 = 5 star
0x06 Element icon (1 byte) (NOTE: Does not affect actual attack element!)
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
0x07 Library (1 byte)
	0x00= Standard
	0x01= Mega
	0x02= Giga
	0x03 = None
	0x04 = P.A.
0x08 MB capacity (1 byte)
0x09 Chip effect flags (8-bit bitfield)
	0x01 = Screen-dimming chip (indicator only)
	0x02 = Show attack power
	0x04 = Navi chip (indicator only)
	0x08 = ?
	0x10 = Show attack power as "???"
	0x20 = DarkChip
	0x40 = Appears in Library
	0x80 = Variable attack power
0x0A Counter Enable	(1 byte)
	Bits 0-6: amount of frames this chip can counter hit (when YOU use it).
	Bit 7: Set if chip is screen-dimming attack that can deal damage. If set, counter frames must be positive.
0x0B: Attack family (1byte)
0x0C: Attack subfamily (1byte)
0x0D: DarkSoul MegaMan usage behavior (1byte)
0x0E: Unknown (8-bit unknown)
0x0F: Lock-on enable (1-bit flag)
0x10: Attack parameter 1 (8-bit value)
0x11: Attack parameter 2 (8-bit value)
0x12: Attack parameter 3 (8-bit value)
0x13: Attack parameter 4 (8-bit value)
0x14: Chip use delay frames (8-bit value)
0x15: Karma requirement (8-bit value) (BN5)
	0 = Neutral
	1 = Requires Light
	2 = Requires Dark
0x15: Library number (8-bit value) (BN6)
0x16: Chip Library flags (8-bit bitfield) (NOTE: For unknown reasons, BigHook is labeled a Falzar Giga chip and MetrKnuk is labeled a Gregar Giga chip.)
	0x01 = Secret Library chip
	0x02 = ?
	0x04 = Gregar Giga chip
	0x08 = Falzar Giga chip
	0x10 = Chip cannot be traded
	0x20 = Chip does not appear in Pack
	0x40 = Modifier chip (Atk+10, WhiCapsl, etc.)
	0x80 = ?
0x17: Lock-on type (1byte)
0x18: Alphabet sort position (2bytes)
0x1A: Attack power (2bytes)
0x1C: ID sort position (2bytes)
0x1E: Battle Chip Gate usage limit (1byte)
0x1F: ダークチップID (1byte) (0xFFFF以外の値を設定した場合、チップを使用するたびにBugFragが消費されます。BugFragが残っていない場合は、次の表にしたがって別のチップに変更されます。)
	0x00 = Sword
	0x01 = Thunder
	0x02 = Recov10
	0x03 = Invisibl
	0x04 = Atk+10
0x20: Chip icon pointer (32-bit pointer)
0x24: Chip image pointer (32-bit pointer)
0x28: Chip palette pointer (32-bit pointer)
```

## 参考記事

- [Chip Data Format](https://forums.therockmanexezone.com/chip-data-format-t5362-s30.html#p342034)
