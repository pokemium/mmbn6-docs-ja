# プログラムアドバンス(PA)

```
BN6 Falzar:
Pointers to PA combination lists: 080295B4

BN5 Colonel:
Pointers to PA combination lists: 08025260

BN4 Red Sun:
Pointers to PA combination list: 0801F4E0
```

最初のポインタはノーマルPA、2番目のポインタは エクストラPA(?)を示しています。BN4の組み合わせリストは1つだけです。

ゲームはまず、エクストラPAポインタとノーマルPAポインタのどちらかのリストからスタートします。

そして、リストからPAの組み合わせのポインタが読み込まれ、PAの組み合わせが可能かどうかチェックされます。

ノーマルPAのポインタリストは、エクストラPAのポインタリストの直後にあるので、エクストラPAモードが有効な場合、エクストラPAとノーマルPAの両方がチェックされます。このため、ノーマルPAポインタリストをエクストラPAポインタリストの直後に配置することを強くお勧めします。

ポインタリストは終端記号として`0x00000000`のエントリが必要です。

各PAの組み合わせを表すオブジェクトは、少なくとも次の2つのプロパティを持っています。残りはPAの種類によって異なります。

```
0x00: PAを構成するチップの数 (8-bit)
0x01: PAタイプ (8-bit)
       0x00: consecutive codes
       0x01: chip combination (BN4)
       0x04: chip combination (BN5, BN6)
```

## PAタイプ1 (consecutive codes)

種類が同じチップで構成されるPAです。例: ギガキャノン1(キャノンABC)

この種類のPAはコードがアルファベット順に連続しているので`consecutive codes`と便宜上呼びます。

```
0x02: PAによって得られるチップ(例: ギガキャノン1) (16-bit)
0x04: PAに必要なチップ(例: キャノン) (16-bit)
```

ここではPAで使用するチップコード(の先頭コード)を設定することはできません。あくまでここの値は指定された数の連続したコードがあるかどうかをチェックするのに使うだけです。

## PAタイプ2 (chip combinations)

種類が違う別のチップを組み合わせて作るPAです。例: サンアンドムーン(リュウセイグンR + アタック+30* + アンインストールR)

```
0x02: PAによって得られるチップ (16-bit)
0x04: PAに必要なチップ1 (16-bit)
0x06: PAに必要なチップ2 (16-bit)
...
```

NOTE: there is no padding if there is less than 5 required PA chips! This means that if you want to make a certain PA combination require more chips, it needs to be re-pointed to free space.


## 参考記事

- [BN4/BN5/BN6 Program Advance structure](https://forums.therockmanexezone.com/bn4-bn5-bn6-program-advance-structure-t5337.html)

