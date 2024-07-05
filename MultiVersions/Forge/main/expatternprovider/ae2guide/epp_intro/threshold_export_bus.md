---
navigation:
    parent: epp_intro/epp_intro-index.md
    title: ME 閥值輸出匯流排
    icon: expatternprovider:threshold_export_bus
categories:
- extended devices
item_ids:
- expatternprovider:threshold_export_bus
---

# ME 閥值輸出匯流排

<GameScene zoom="8" background="transparent">
  <ImportStructure src="../structure/cable_threshold_export_bus.snbt"></ImportStructure>
</GameScene>

ME 閥值輸出匯流排只會在 ME 網路中，儲存的某物品數量高於／低於所設閥值時運作。

## 範例

![GUI](../pic/thr_bus_gui1.png)

銅錠的閥值設為 128，因此當網路儲存的銅錠數量大於 128 時，匯流排才會輸出銅錠。

![GUI](../pic/thr_bus_gui2.png)

閥值與前個例子相同，但模式設為「低於閥值時運作」。當網路儲存的銅錠數量低於 128 時，匯流排才會輸出銅錠。

