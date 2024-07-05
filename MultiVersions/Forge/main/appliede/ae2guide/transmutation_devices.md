---
navigation:
  parent: appliede-index.md
  title: 轉換裝置
  icon: emc_interface
  position: 10
categories:
  - appliede
item_ids:
  - appliede:emc_interface
  - appliede:cable_emc_interface
  - appliede:emc_export_bus
  - appliede:emc_import_bus
  - appliede:learning_card
---

# 轉換裝置

<GameScene zoom="4" background="transparent">
  <ImportStructure src="assemblies/transmutation_devices.snbt" />
  <IsometricCamera yaw="195" pitch="30" />
</GameScene>

作為現有 AE2 <ItemLink id="ae2:interface" />、<ItemLink id="ae2:export_bus" /> 以及 <ItemLink id="ae2:import_bus" /> 的補充，

AppliedE 為這些設備提供了對應裝置，其功能幾乎與原生的 AE2 設備完全相同，並且仍然可以處理正常的物品。

主要的區別在於，這些物品在進行處理時，會是由 EMC 轉換而來，又或是被轉換成 EMC。

每個裝置都可以篩選任何物品，但這些物品必須先由放置 <ItemLink id="appliede:emc_module">轉換模組</ItemLink> 的玩家習得，裝置才能夠執行相應的功能。

對於 <ItemLink id="appliede:emc_interface" />，若物品未先被玩家習得以提前讓網路所知，

網路將不會讓這類物品，進入其內部儲存轉換成 EMC。

同樣的，<ItemLink id="appliede:emc_import_bus" /> 也將不會抽取任何未習得的物品。

## 煉金術精通卡

<ItemImage id="learning_card" scale="4" />

然而，若使用者必須提前習得所有物品，才能將其自動抽取進 ME 系統並轉換成 EMC，那麼這將很快成為一件繁瑣的工作。

因此，<ItemLink id="appliede:learning_card" /> 可以被安裝在 <ItemLink id="appliede:emc_interface" /> 或 <ItemLink id="appliede:emc_import_bus" /> 中，

以便它們自動習得輸入進網路的物品，不過前提是這些物品要具有 EMC 值。

需要注意的是，這些輸入進網路的物品，只會被裝置的擁有者習得，也就是放置輸入匯流排和介面的玩家。

## 配方

<Recipe id="appliede:emc_interface" />
<RecipeFor id="appliede:emc_export_bus" />
<RecipeFor id="appliede:emc_import_bus" />
<RecipeFor id="appliede:learning_card" />
