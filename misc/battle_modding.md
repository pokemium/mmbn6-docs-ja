# 対戦設定の改造

エグゼ6はエグゼシリーズ最後のゲームで、エグゼ5からのリビジョンをベースに、最も改造の自由度の高いゲームとなっています。また、このゲームではロックマン以外の様々なナビを自由に操ることができます。

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
0x00 Battlefield 
0x01 Unknown
0x02 Music
0x03 Battle Mode
0x04 Background
0x05 Battle Count
0x06 Panel Column Pattern
0x07 Unlock?
0x08 Battle Effects (4 bytes)
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

## 0x03 モード

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

ここは4byteあります。

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

Some notes:

In Boss Ranking Mode, defeating 1 enemy can still get you an S-rank. The other boss-specific rules apply.

`00000008`, Network Battle won't work and forces the battle to not load.

For `00000040`, this means you keep the HP you had at the end of the battle, similar to virus battles. If you ended with 1HP, you have 1HP back on the overworld.

`00000400` will make the second battle vs a 100HP MegaMan. It is unknown how to customize the sequence battle.

`00008000` forces lower enemy levels. If you use the Rare Virus Codebreaker code (32004804 0001), all viruses will be upgraded to their Rare form. This bit disables the code's behavior.

## 0x0C Object Setup Pointer

## References

- [MMBN6 Custom Battle Guide](https://forums.therockmanexezone.com/mmbn6-custom-battle-guide-t5316.html)