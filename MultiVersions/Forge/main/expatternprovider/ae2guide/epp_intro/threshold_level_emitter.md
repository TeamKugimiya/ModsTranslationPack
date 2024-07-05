---
navigation:
    parent: epp_intro/epp_intro-index.md
    title: ME 閥值位準發射器
    icon: expatternprovider:threshold_level_emitter
categories:
- extended devices
item_ids:
- expatternprovider:threshold_level_emitter
---

# ME 閥值位準發射器

<GameScene zoom="8" background="transparent">
  <ImportStructure src="../structure/cable_threshold_level_emitter.snbt"></ImportStructure>
</GameScene>

其運作原理與 RS 閂鎖器類似。當網路中某物品的數量低於下限閾值時，它會停止輸出紅石訊號；
當數量大於上限閾值時，它會開始輸出紅石訊號。

舉個例子：假設下限閾值設為 100，上限閾值設為 150。

起初網路中還沒有物品，所以發射器不會運作。

當物品數量增加並超過 150 時，發射器將會開始發送紅石訊號。

當數量減少並小於 150 時，發射器仍會繼續發送紅石訊號。

最終，當數量減少到小於 100 時，發射器將會停止輸出紅石訊號。
