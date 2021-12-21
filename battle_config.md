# 対戦設定

ここでの対戦は通信対戦だけではなく、ウィルス戦やナビ戦など様々な戦闘のことを指します。

エグゼ6はエグゼシリーズ最後のゲームで、エグゼ5からのリビジョンをベースにした、最も改造の自由度の高いゲームとなっています。

エグゼ6では、ロックマン以外の様々なナビを自由に操ることができるのも大きな特徴です。

このガイドでは、ヒートマン/アクアマンとの対戦をグレイガ/ファルザー版でそれぞれ利用します。

この対戦の対戦設定は

```
GregarJP: 0x80b2ca0
FalzarJP: 0x80b1430
```

にあります。

対戦設定のデータは次のようにならんでいるはずです: `00 64 16 00 FF 00 38 00 D7 98 41 00 16 18 0B 08`

対戦設定のデータフォーマットはBN5と同じで次のようになっています。

```
0x00 フィールド 
0x01 不使用
0x02 BGM
0x03 戦闘モード
0x04 背景
0x05 戦闘カウント
0x06 Panel Column Pattern
0x07 不明
0x08 特殊効果 (4 bytes)
0x0C Object Setup Pointer
```

## 0x00 フィールド

フォーマットの最初のバイトで使用するフィールドを指定します。230種類以上のステージから選ぶことができます。00は特別なパネルタイプのないプレーンなステージです。

## 0x01 使用されていない

確実に使われていません。

## 0x02 BGM

戦闘で使用するBGMを変更することができます。ゲーム内で使用されている曲であれば何でも使用できますし、音楽を使用しないことも可能です。音楽リストは以下の通りです。

```
00 = No Music
01 = Title Screen
02 = WWW Theme
03 = Cyber City Theme
04 = Indoors Theme
05 = School Theme
06 = Seaside Town Theme
07 = Sky Town Theme
08 = Green Town Theme
09 = Graveyard Area Theme
0A = Mr. Weather Comp Theme
0B = Event Occurance
0C = Crisis Theme
0D = Sad Theme
0E = Hero Theme
0F = Transmission
10 = Robo Control Comp
11 = Aquarium Comp
12 = Judge Tree Comp
13 = Network Theme
14 = Undernet Theme
15 = Virus Battle
16 = Boss Battle
17 = Final Battle
18 = Pavilion Theme
19 = Winner Theme
1A = Loser Theme
1B = Game Over
1C = Boss Prelude
1D = Credits
1E = Navi Customizer Theme
1F = Winnter Theme (short version)
20 = Pavilion Comp
21 = Theme of the CyberBeasts
22 = Crossover Battle Theme
23 = Shark Chase Theme
24 = ACDC Town
25 = Expo Theme
```

今回は`16`が入っています。

## 0x03 戦闘モード

チュートリアル戦闘など特殊な戦闘を行う際にはここを設定します。

```
00 = Normal Battle
01 = Crossover Battle
02 = Tutorial 1
03 = Tutorial 2
04 = Tutorial 3
05 = Beast Out Tutorial
06 = Virus Battler
07 = TomahawkMan Mini Game 
08 = Cross Tutorial
09 = DustMan Mini Game
0A = Hakushaku's Invincible Mode
0B = Hakushaku's Defeat
```

## 0x04 背景

戦闘中の背景です。

```
00 = Lan's HP BG
01 = ACDC HP BG
02 = Nothing
03 = Seaside HP BG
04 = Sky HP BG
05 = Green HP BG
06 = Robo Control Comp BG
07 = Generic Comp Green BG
08 = Generic Comp Purple BG
09 = Central Area BG
0A = Aquarium Comp BG
0B = Seaside Area BG
0C = Judgement Tree BG
0D = Green Area BG
0E = Sky Area BG
0F = Undernet BG
10 = Mr. Weather Comp BG
11 = Underground BG
12 = CyberBeast Comp BG
13 = ACDC Area BG
14 = Graveyard Area BG
15 = Mr. Weather Comp BG (storm)
```

## 0x05 戦闘カウント

イベントで連戦をやるときに、この戦闘が何戦目かを示すためのものです。通常の場合は`0`が入っています。

## 0x06 Panel Column Pattern

基本的には、赤青ともに3列のパネルがありますが、リベレートミッションではそれ以外の列構成になることもありえます。

その列構成を示すのがこのバイトです。

下位6bitが列に対応しており0なら赤, 1なら青になります。

例えば`111000`、つまり`38`は赤青ともに3列の通常ステージになります。

今回はもちろん`38`です。

## 0x07 不明

使用されているかどうかも含めて不明です。

## 0x08 特殊効果

このフィールドは4byteあります。

ストーリー戦で強制的にこちらのHPをMaxにするなど特殊な処理を加えたい時に利用します。

```
00000001 = Boss Ranking Mode
00000002 = Show Results
00000004 = Start with Max HP
00000008 = Network Battle
00000010 = Recover to Max HP After Battle
00000020 = Allow Running and Keep Full Sync
00000040 = Keep HP After Battle
00000080 = Folder is Randomized
00000100 = Allow Game Over
00000200 = Unknown
00000400 = Multiplayer Sequence Battle
00000800 = Unknown
00001000 = Unknown
00004000 = Allow Locate Enemy SubChip and Keep Full Sync
00008000 = Force Low Enemy Level
00010000 = Unknown
00020000 = Unknown
00040000 = Unknown
00080000 = Unknown
00100000 = Disallow Dark Chips
```

**いくつかの注意点**

Boss Ranking Mode では、敵を1体倒してもSランクになることがあります。その他のボス固有のルールが適用されます。

`00000008`, Network Battle won't work and forces the battle to not load.

`00000040`の場合、これは、ウイルスバトルと同じように、バトル終了時のHPを維持することを意味します。HPが1だった場合、マップ上に戻ってもHPが1になります。

`00000400` will make the second battle vs a 100HP MegaMan. It is unknown how to customize the sequence battle.

`00008000` forces lower enemy levels. If you use the Rare Virus Codebreaker code (32004804 0001), all viruses will be upgraded to their Rare form. This bit disables the code's behavior.

## 0x0C Object Setup Pointer

このポインタは、Object Setupデータがある場所を指しています。これは、どのような敵やオブジェクトが戦闘中にいるのか、どこに現れるのかというデータです。デフォルト値はバージョンによって異なります。

上述の対戦設定をすべて設定した後は、「Object Setup」に移ります。上記の値を使って、お使いのバージョンのObject Setupを見つけてください。

オブジェクト設定のフォーマットは、前作と同じ、凝縮されたフォーマットとなっています。そのフォーマットを以下に記します。

```
0x00 オブジェクトタイプ
0x01 X座標, Y座標
0x02 Enemy Value (2 bytes)
```

### 0x00 オブジェクトタイプ

この値は、Enemy Value functions に直接影響します。この値を使って、岩や敵などのオブジェクトを赤や青の側に作ることができます。オブジェクトタイプの全リストは以下の通りです。

```
00 = Player-Controlled Navi
01 = Opponent Player-Controlled Navi
10 = Fight on Red Side
11 = Fight on Blue Side
20 = Mystery Data
30 = Rock
70 = Flag
80 = Rock Cube
90 = Guardian
A0 = Metal Cube
```

**いくつかの注意点**

00と01は、自分が普段操作している左のナビと、通信対戦で相手が操作している右のナビに割り当てられています。

例えば、値が`$11`だと敵に、`$10`だと味方になります。敵を味方にすると、HPが共有されず、敵は通常、ロックマンや自分がプレイしている他のナビだけをターゲットにするため、おかしな行動をとることがあります。

ミステリーデータが表示されるには、Enemy Value が`$0D`より大きいことが必要です。

フィールドに置ける岩は2つまでです。ただし、一度にフィールドに出せる「ストーンキューブ」は5個までです。

ストーンキューブは、後述の0x02の値が`$03`の時にアイスキューブになることができます。 また、0x03の値はストーンキューブのHPになり、最大256のHPを持つことができます。アイスキューブはHPの値を取りません。

フラッグは通常のゲームでは登場しませんが、BN3からの機能をそのまま受け継いでいます。敵の値がフラッグのHPになります。値00～7Fが自分のフラッグのHP、80～FFが相手のフラッグのHPになります。フラッグがデリートされると、そのフラッグがあった側の負けになります。エグゼ6ではフラッグのスプライトが削除されたので、出現するストーンキューブのアニメーションをスプライトとして使用します。

`$A0`の場合、メタルキューブはブラストマンの戦闘時に使用される壊れないオブジェクトです。ダストマンのチップや雪玉で取り除くことができます。

![](./images/Flag_exe3.gif)

### 0x01 X座標, Y座標

座標は1つの値に凝縮されています。これまでと同様の値が適用されます。

以下の値を使用し、それらを追加することで、目的のパネルにオブジェクトを配置することができます。例えば、通常、プレーヤーは中央左の「22」、相手は中央右の「25」からスタートします。

```
[10]
[20]
[30]
```

```
[01][02][03][04][05][06]
```

### 0x02 Enemy Value

Enemy Valueがは2バイトで表します。

00～FFはウイルスを、0100～01FFはナビを扱います。また、Enemy Valueの1バイト目はフラッグのHPとしても機能します。全エネミーリストは以下の通りです。

```
00 = Test Virus
01 = Mettaur
02 = Mettaur2
03 = Mettaur3
04 = Mettaur SP
05 = Rare Mettaur
06 = Rare Mettaur2
07 = Piranha
08 = Piranha2
09 = Piranha3
0A = Piranha SP
0B = Rare Piranha
0C = Rare Piranha2
0D = HeadyA
0E = HeadyH
0F = HeadyW
10 = HeadyE
11 = Rare Heady
12 = Rare Heady2
13 = Swordy
14 = Swordy2
15 = Swordy3
16 = Swordy SP
17 = Rare Swordy
18 = Rare Swordy2
19 = KillerEye
1A = DemonEye
1B = JokersEye
1C = KillerEye SP
1D = Rare KillerEye
1E = Rare KillerEye2
1F = Quaker
20 = Shaker
21 = Breaker
22 = Quaker SP
23 = Rare Quaker
24 = Rare Quaker2
25 = Catack
26 = Cateen
27 = Catapult
28 = Catack SP
29 = Rare Catack
2A = Rare Catack2
2B = Champy
2C = Chumpy
2D = Chimpy
2E = Champy SP
2F = Rare Champy
30 = Rare Champy2
31 = WindBox
32 = VaccuumFan
33 = WindBox2
34 = VaccuumFan2
35 = Rare Box
36 = Rare Fan
37 = Trumpy
38 = Tuby
39 = Tromby
3A = MuteAnt
3B = Xylos
3C = Trumpy SP
3D = OldStove
3E = OldStove2
3F = OldStove3
40 = OldStove SP
41 = Rare OldStove
42 = Rare OldStove2
43 = HauntedCandle
44 = HauntedCandle2
45 = HauntedCandle3
46 = HauntedCandle SP
47 = Rare HauntedCandle
48 = Rare HauntedCandle2
49 = Kettle
4A = Kettle
4B = SuperKettle
4C = Kettle DX
4D = Kettle SP
4E = Rare Kettle
4F = Puffy
50 = Puffy2
51 = Puffy3
52 = Puffy SP
53 = Rare Puffy
54 = Rare Puffy2
55 = StarFish
56 = StarFish2
57 = StarFish3
58 = StarFish SP
59 = Rare StarFish
5A = Rare StarFish2
5B = EarthDragon
5C = ThunderDragon
5D = WaterDragon
5E = WoodDragon
5F = WhiteDragon
60 = BlackDragon
61 = ScareCrow
62 = ScareCrow2
63 = ScareCrow3
64 = ScareCrow SP
65 = Rare ScareCrow
66 = Rare ScareCrow2
67 = PulseBulb
68 = PulseBulb2
69 = PulseBulb3
6A = PulseBulb SP
6B = Rare PulseBulb
6C = Rare PulseBulb2
6D = BigHat
6E = BigHat2
6F = BigHat3
70 = BigHat SP
71 = Rare BigHat
72 = Rare BigHat2
73 = BombCorn
74 = MegaCorn
75 = GigaCorn
76 = BombCorn SP
77 = Rare BombCorn
78 = Rare BombCorn2
79 = Shrubby
7A = Shrubby2
7B = Shrubby3
7C = Shrubby SP
7D = Rare Shrubby
7E = Rare Shrubby2
7F = HoneyBomber
80 = HoneyBomber2
81 = HoneyBomber3
82 = HoneyBomber SP
83 = Rare HoneyBobmer
84 = Rare HoneyBomber2
85 = Gunner
86 = Shooter
87 = Sniper
88 = Gunner SP
89 = Rare Gunner
8A = Rare Gunner2
8B = FighterPlane
8C = FighterPlane2
8D = FighterPlane3
8E = FighterPlane SP
8F = Rare FighterPlane
90 = Rare FighterPlane2
91 = DarkMech
92 = ElecMech
93 = DoomMech
94 = DarkMech SP
95 = Rare DarkMech
96 = Rare DarkMech2
97 = SnakeArm
98 = SnakeArm2
99 = SnakeArm3
9A = SnakeArm SP
9B = Rare SnakeArm
9C = Rare SnakeArm2
9D = Armadill
9E = Armadill2
9F = Armadill3
A0 = Armadill SP
A1 = Rare Armadill
A2 = Rare Armadill2
A3 = Cragger
A4 = MetalCragger
A5 = BigCragger
A6 = Cragger SP
A7 = Rare Cragger
A8 = Rare Cragger2
A9 = Nightmare
AA = BlackMare
AB = DarkMare
AC = Nightmare SP
AD = Rare Nightmare
AE = Rare Nightmare2
AF = Flying Garbage 1
B0 = Flying Garbage 2
B1 = Flying Garbage 3
B2 = Nothing
B3 = Nothing
B4 = Nothing
B5 = Totem Pole 1
B6 = Totem Pole 2
B7 = Totem Pole 3
B8 = Totem Pole 4
B9 = Totem Pole 5
BA = Totem Pole 6
BB = Mettaur
BC = Mettaur 2
BD = Mettaur 3
BE = Mettaur SP
BF = Rare Mettaur
C0 = Rare Mettaur2
C1 = Mettaur1
C2 = Mettaur1 EX
C3 = Mettaur2
C4 = Mettaur2 EX
C5 = Mettaur3
C6 = Mettaur3 EX
C7 = Tuby
C8 = Tuby EX
C9 = Tuby2
CA = Tuby2 EX
CB = Tuby3
CC = Tuby3 EX
CD = Flag
CE = Rock
CF = Otenko
D0 = RockCube
D1 = IceCube
D2 = Nothing
D3 = Nothing
D4 = BombCube
D5 = BlackBomb
D6 = Wind
D7 = Fan
D8 = TimeBomb
D9 = TimeBomb+
DA = Nothing
DB = Anubis
DC = PoisonPharoah
DD = Fanfare
DE = Discord
DF = Timpani
E0 = Silence
E1 = DarkSonic
E2 = VDoll
E3 = Guradian
E4 = Voltz
E5 = AirSpin
E6 = ChaosLord
E7 = RedFruit
E8 = ChemicalFlash
E9 = ModMegaman
EA = BassCrossMegaman
```

```
0101 = HeatMan
0102 = HeatMan EX
0103 = HeatMan SP
0104 = HeatMan RV
0105 = HeatMan BX
0106 = 
0107 = ElecMan
0108 = ElecMan EX
0109 = ElecMan SP
010A = ElecMan RV
010B = ElecMan BX
010C = 
010D = SlashMan
010E = SlashMan EX
010F = SlashMan SP
0110 = SlashMan RV
0111 = SlashMan BX
0112 = 
0113 = KillerMan
0114 = KillerMan EX
0115 = KillerMan SP
0116 = KillerMan RV
0117 = KillerMan BX
0118 = 
0119 = ChargeMan
011A = ChargeMan EX
011B = ChargeMan SP
011C = ChargeMan RV
011D = ChargeMan BX
011E = 
011F = AquaMan
0120 = AquaMan EX
0121 = AquaMan SP
0122 = AquaMan RV
0123 = AquaMan BX
0124 = 
0125 = TomahawkMan
0126 = TomahawkMan EX
0127 = TomahawkMan SP
0128 = TomahawkMan RV
0129 = TomahawkMan BX
012A = 
012B = TenguMan
012C = TenguMan EX
012D = TenguMan SP
012E = TenguMan RV
012F = TenguMan BX
0130 = 
0131 = GroundMan
0132 = GroundMan EX
0133 = GroundMan SP
0134 = GroundMan RV
0135 = GroundMan BX
0136 = 
0137 = DustMan
0138 = DustMan EX
0139 = DustMan SP
013A = DustMan RV
013B = DustMan BX
013C = 
013D = ProtoMan
013E = ProtoMan EX
013F = ProtoMan SP
0140 = ProtoMan FZ
0141 = ProtoMan BX
0142 = 
0143 = BlastMan
0144 = BlastMan EX
0145 = BlastMan SP
0146 = BlastMan RV
0147 = BlastMan BX
0148 = 
0149 = DiveMan
014A = DiveMan EX
014B = DiveMan SP
014C = DiveMan RV
014D = DiveMan BX
014E = 
014F = CircusMan
0150 = CircusMan EX
0151 = CircusMan SP
0152 = CircusMan RV
0153 = CircusMan BX
0154 = 
0155 = JudgeMan
0156 = JudgeMan EX
0157 = JudgeMan SP
0158 = JudgeMan RV
0159 = JudgeMan BX
015A = 
015B = ElementMan
015C = ElementMan EX
015D = ElementMan SP
015E = ElementMan RV
015F = ElementMan BX
0160 = 
0161 = Hakushaku
0162 = Hakushaku EX
0163 = Hakushaku SP
0164 = Hakushaku RV
0165 = Hakushaku BX
0166 = 
0167 = Colonel
0168 = Colonel EX
0169 = Colonel SP
016A = Colonel RV
016B = Colonel BX
016C = 
016D = Bass
016E = Bass BX
016F = Bass SP
0170 = Bass SP
0171 = Bass BX *
0172 = Bass XX
0173 = Gregar
0174 = Gregar EX
0175 = Gregar SP
0176 = Gregar RV
0177 = Gregar BX
0178 = 
0179 = Falzar
017A = Falzar EX
017B = Falzar SP
017C = Falzar RV
017D = Falzar BX
017E = 
017F = Hakushaku
0180 = Hakushaku EX
0181 = Hakushaku SP
0182 = Hakushaku RV
0183 = Hakushaku BX
0184 = 
0185 = Gregar Beast
0186 = Gregar Beast EX
0187 = Gregar Beast SP
0188 = Gregar Beast RV
0189 = Gregar Beast BX
018A = 
018B = Falzar Beast
018C = Falzar Beast EX
018D = Falzar Beast SP
018E = Falzar Beast RV
018F = Falzar Beast BX
0190 = 
0191 = MegaMan
0192 = MegaMan
0193 = MegaMan
0194 = MegaMan
0195 = MegaMan
0196 = MegaMan
0197 = MegaMan
0198 = MegaMan
0199 = MegaMan
019A = MegaMan
019B = MegaMan
019C = MegaMan
019D = MegaMan
019E = MegaMan
019F = MegaMan
01A0 = MegaMan
01A1 = HeatMan
01A2 = ElecMan
01A3 = SlashMan
01A4 = KillerMan
01A5 = ChargeMan
01A6 = AquaMan
01A7 = TomahawkMan
01A8 = TenguMan
01A9 = GroundMan
01AA = DustMan
01AB = ProtoMan
```

**いくつかの注意点**

Test Virus は攻撃をしてこないHP500のメットールです。

Enemies AF-B1 are the Flying Garbage enemies needed for the DustMan mini game. As DustMan, you crush or inhale the garbage. B2-B3 don't work properly.

Enemies B5-B7 are the Totem Pole enemies needed for the TomahawkMan mini game. As TomahawkMan, you chop at the poles until they are all defeated. B5-B7 are the 3 versions used by the game but B8-BA are more difficult versions which don't show up correctly.

Mettaurs BB-C0 are the same as the regular Mettaur except they have no name and always drop Cannon *.

Enemies C1-CC are leftover Crossover Battle enemies from BN5. The names are the same, but the versions aren't the same anymore.

Enemy values CD-EA are leftover names from BN5's Operation Battle. In-battle, they all appear as Mettaurs.

Enemy values 0191-019F all appear as a 4000 HP MegaMan.Values 01A0-01AB are names used to identify controllable characters and are recognized by enemies as hittable. In-battle, they all appear as a 100 HP MegaMan.

## 最後に

これでエグゼ6の対戦設定の説明は終わりです。

ここで述べたことを理解すれば次の動画のような戦闘を作ることも可能になります。

http://youtube.com/watch?v=3SdZWCKdgMo

## References

- [MMBN6 Custom Battle Guide](https://forums.therockmanexezone.com/mmbn6-custom-battle-guide-t5316.html)
