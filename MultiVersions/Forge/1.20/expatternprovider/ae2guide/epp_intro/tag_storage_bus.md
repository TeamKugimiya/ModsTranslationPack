---
navigation:
    parent: epp_intro/epp_intro-index.md
    title: ME 標籤儲存匯流排
    icon: expatternprovider:tag_storage_bus
categories:
- extended devices
item_ids:
- expatternprovider:tag_storage_bus
---

# ME 標籤儲存匯流排

<GameScene zoom="8" background="transparent">
  <ImportStructure src="../structure/cable_tag_storage_bus.snbt"></ImportStructure>
</GameScene>

ME 標籤儲存匯流排是能以物品，或流體標籤篩選的 <ItemLink id="ae2:storage_bus" />，且支援一些基礎的邏輯判斷。

此處是一些範例：

- 只接受原礦

forge:raw_materials/*

- 接受所有錠與寶石

forge:ingots/* | forge:gems/*

