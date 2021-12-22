# バスティングレベル

大体次のような感じで、各バトル終了時のバスティングレベルをゲームが計算してくれます。9つの条件を使ってバスティングレベルを計算しています。

```
Check 1: Busting Time (singleplayer,multiplayer)
Virus:
00:05:00 - 06
00:12:00 - 05
00:36:00 - 04
more     - 03
Navi:
00:30:00 - 10
00:40:00 - 08
00:50:00 - 06
more     - 04
NetBattle
00:30:00 - 10
00:45:00 - 08
01:00:00 - 06
more     - 04

Check 2: Times Hit (singleplayer)
CurrentBustingLevel increases by (#TimesHit * -1) + 1
upto +1 points
as low as -3 points

Check 3: Times Moved (singleplayer)
If you moved less than 3 times, +1 point

Check 4: Multiple Deletes (singleplayer)
CurrentBustingLevel increases by (#ofsimultanious deletes -1) * 2

Check 5: Remaining HP (multiplayer)
more than 0    +0
more than half +1
more than 3/4  +2
no damage      +3

Check 6: Recovery Chips (multiplayer)
1 used: -1 point
2-3 or more: -((#recoverychips used -1 )*2) points
max lost: -4

Check 7: HP Difference (multiplayer)
For every 100 hp your opponent has more than you get 1 point (max 4)
For every 100 hp you have more than your opponent you lose 1 point (max lost -4)

Check 8: Number of Counters (singleplayer,multiplayer)
Current busting level increases by # of counters
up to +3

Check 9: Cross Used (singleplayer)
If you did not use a cross busting level +1
```

## 参考記事

- [MMBN 6 Busting Level Calculations](https://forums.therockmanexezone.com/mmbn-6-busting-level-calculations-t5315.html)
