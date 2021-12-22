# プログラムアドバンス

BN6 Falzar:
Pointers to PA combination lists: 080295B4
BN5 Colonel:
Pointers to PA combination lists: 08025260
BN4 Red Sun:
Pointers to PA combination list: 0801F4E0

First pointer is for Normal PAs, second pointer is for "Extra" PAs. BN4 only has one combination list.

The game first starts from either the Extra PAs pointer and Normal PAs pointer list. Then, pointers to PA combinations are loaded from the list and the PA combinations are checked for possible PAs. Since the Normal PAs pointer list is right after the Extra PAs pointer list, when Extra PAs Mode is enabled, both Extra PAs and Normal PAs are checked. For this reason, it is highly recommended to place the Normal PAs pointer list right after the Extra PAs pointer list.

A pointer list is terminated by an 0x00000000 entry.



Each PA combination consists of 2 static values, the rest varies depending on the type of PA.

0x00: Amount of chips in PA (8-bit)
0x01: Type of PA (0x00 for consecutive codes, 0x01 for chip combination (BN4) or 0x04 for chip combination (BN5, BN6)) (8-bit)

PA type 1 (consecutive codes):
0x02: Resulting PA chip (16-bit)
0x04: Required PA chip (16-bit)
NOTE: you cannot set the specific chip codes used in the PA, it will only check for the specified number of consecutive codes.

PA type 2 (chip combinations)
0x02: Resulting PA chip (16-bit)
0x04: Required PA chip 1 (16-bit)
0x06: Required PA chip 2 (16-bit)
etc.
NOTE: there is no padding if there is less than 5 required PA chips! This means that if you want to make a certain PA combination require more chips, it needs to be re-pointed to free space.


## 参考記事

- [BN4/BN5/BN6 Program Advance structure](https://forums.therockmanexezone.com/bn4-bn5-bn6-program-advance-structure-t5337.html)