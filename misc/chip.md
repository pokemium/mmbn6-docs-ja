# チップデータ

```go
type ChipData struct {
	Code                      [4]byte // 0xFF=None, 0x00=A, 0x19=Z, 0x1A=*
	AttackingElement          byte
	Rarity                    byte // 00=☆1, 01=☆2, ..., 04=☆5
	ChipElement               byte // 後述
	Library                   byte // 00=standard, 01=mega, 02=giga
	MB                        byte // chip size
	SpecialChipAttack         byte // 後述
	CounterEnable             byte // 後述
	AttackType                byte
	LevelModifier             byte
	Unused_0d                 [2]byte
	LockonEnable              byte
	SubLevel                  byte
	SubSubLevel               byte
	SubSubSubLevel1           byte
	SubSubSubLevel2           byte
	ChipUseDelayFrames        byte
	LibraryNumber             byte
	SecretLibraryTrigger      byte
	LockonType                byte // 後述
	AlphabetizedSortPackOrder uint16
	AttackPower               uint16
	IDSortPackOrder           uint16
	Unused_1e                 uint16
	ChipIcon                  uint32
	ChipImage                 uint32
	ChipPalette               uint32
}
```

## ChipElement

```
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
```

## SpecialChipAttack	

```
20= dark chip (vansishes from lib)
4A= regular
DA= attack is HP lost			(attack must = 03FC)
C2= dependent on buster			(attack must = 0400)
D7= ds chip?
DB= Number ball effect 			(attack must = 03FD)
D2= Custom sword effect			(attack must = 03FB)
DB= muramasa effect			(attack must = 03FC)
F0= dark chip
```

## CounterEnable

```
00= Can't counter
1E= Can counter
94= Can counter
```

## LockonType

```
00= No jump
01= Jump 1 panel forward every use
02= Point blank;In front of target
03= Jump to the middle of target column
04= Jump to second panel in front of target
05= Jump to third panel in front of target
06= 03
07= 04
08= 05
09= Jump to second panel in the middle column of target
0A= Jump to farthest panel from target
0B= 04
0C= 02
0D= 02
0E= Jump to center-back panel
0F= 05
10= Jump to third panel, mid-column of target
11= 04
12= 02
```
