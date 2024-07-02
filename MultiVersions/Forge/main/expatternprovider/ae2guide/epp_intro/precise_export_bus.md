---
navigation:
    parent: epp_intro/epp_intro-index.md
    title: ME 精確輸出匯流排
    icon: expatternprovider:precise_export_bus
categories:
- extended devices
item_ids:
- expatternprovider:precise_export_bus
---

# ME 精確輸出匯流排

<GameScene zoom="8" background="transparent">
  <ImportStructure src="../structure/cable_precise_export_bus.snbt"></ImportStructure>
</GameScene>

ME 精確輸出匯流排會按指定數量輸出物品／流體。只有在容器能完全接收所設數量的事物時，匯流排才會向其輸出。

## 範例

![GUI](../pic/pre_bus_gui1.png)

這張圖表示匯流排每次運作時，會輸出 3 個鵝卵石。當網路中的鵝卵石數量低於 3 時‧匯流排將會停止輸出。

![GUI](../pic/pre_bus_gui2.png)

當目標容器無法完全接收所設數量的物品時，匯流排也同樣會停止輸出。由於儲物箱現在只能再容納 2 個鵝卵石，因此輸出匯流排將會停止運作。
