---
navigation:
    parent: epp_intro/epp_intro-index.md
    title: ME 裝罐機
    icon: expatternprovider:caner
categories:
- extended devices
item_ids:
- expatternprovider:caner
---

# ME 裝罐機

<BlockImage id="expatternprovider:caner" scale="8"></BlockImage>

ME 裝罐機是一台能將事物「裝罐」的機器，包括流體、《通用機械》氣體、《植物魔法》魔力，甚至是能量！

第一個欄位用來放置欲裝填的事物，第二個欄位則用來放置欲使用的容器。

這台機器運作時需要能量，每次運作時消耗 80 AE。

![GUI](../pic/caner_gui.png)

預設情況下，這台機器只能裝填流體，你需要安裝對應的擴充模組，來使其能夠裝填其他事物。

### 支援的擴充模組：
- 應用通量 - Applied Flux
- 應用能源｜通用機械擴充 - Applied Mekanistics
- 應用能源｜植物魔法擴充 - Applied Botanics Addon

## 使用 ME 裝罐機自動合成

這台機器只能從頂部或底部接收能量或連接至網路。

<GameScene zoom="6" background="transparent">
  <ImportStructure src="../structure/caner_example.snbt"></ImportStructure>
</GameScene>

這是 ME 裝罐機的簡單設置。當 ME 裝罐機從 <ItemLink id="ae2:pattern_provider" /> 接收原材料時，將會自動向其發送裝填完的物品回網路。

<GameScene zoom="6" background="transparent">
  <ImportStructure src="../structure/caner_auto.snbt"></ImportStructure>
</GameScene>

樣板必須只能編寫欲裝填的事物，以及用來裝填的容器。此處是一些範例：

將水裝桶：

![P1](../pic/fill_water.png)

為能量平板充能（需要安裝《Applied Flux》模組）：

![P1](../pic/fill_energy.png)


## 排出事物

ME 裝罐機在清空模式下，也可以從容器中排出事物。你需要在樣板中，將輸入與輸出顛倒過來。
