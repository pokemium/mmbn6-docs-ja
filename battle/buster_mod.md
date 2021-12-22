# ロックバスターの改造

まずはバスターテーブルについて。

`BusterTable (0x8011de4)`には、バスタールーチンを指すポインタが入ったテーブルがあります。148個のポインタが入っています。

バスター`0x00`は通常のバスターで、そのポインタは`0x8012037`です。バスター`0x93`はヘルズローリングで、そのポインタは`0x8012c37`です。

新しいバスターを追加する場合は、このテーブルを再ポイントして空きスペースを確保し（ポインタは`0x80117D0 (FalzarUS)`にあります）、最後に自分のポインタを追加する必要があります（バスター`94h`から始まります）。

これらのポインタのそれぞれは、バスターの特別な「攻撃準備」ルーチンを指しています。

このルーチンはダメージを計算し、アタックタイプ、レベルモディファイア、サブレベルなどを設定します。新しいバスターを追加したい場合は、[このテンプレート](http://theprof9.webs.com/bustertemplate.raw)をダウンロードして、必要なバスターのデータを入力してください。

Open this file in a hex editor and input the attack data for the Buster attack:

```
0000000C: Counter enable value (untested)
00000018: Delay (might not work)
0000001C: Attacking element
00000020: Level modifier
00000024: Base damage
00000026: Extra damage per Buster level
0000002E: Attack type
00000038: Sublevel 1
00000039: Sublevel 2
0000003A: Sublevel 3
0000003B: Sublevel 4
```

Each of these offsets is marked with "AA", so don't forgot to replace with 00 the bytes you don't need.

When you're done, load it into free space. As a pointer to your newly imported Buster routine, use the address you loaded it into +1h.

This way, you can use any chip attack or even boss attack as a Buster. Time Freeze chips don't seem to work correctly for some reason, though.

## 参考記事

- [Buster modding](https://forums.therockmanexezone.com/buster-modding-t5360.html)
