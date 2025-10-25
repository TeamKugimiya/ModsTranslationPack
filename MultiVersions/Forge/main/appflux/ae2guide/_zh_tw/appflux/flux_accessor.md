---
navigation:
  parent: appflux/appflux-index.md
  title: 通量存取器
  icon: appflux:flux_accessor
categories:
- flux accessor
item_ids:
- appflux:flux_accessor
- appflux:part_flux_accessor
---

# 通量存取器

<Row>
<BlockImage id="appflux:flux_accessor" scale="8"></BlockImage>
<GameScene zoom="8" background="transparent">
  <ImportStructure src="../structure/flux_accessor.snbt"></ImportStructure>
</GameScene>
</Row>

通量存取器可以用來輸入／輸出 ME 網路中儲存的能量。

在預設情況下，它們沒有傳輸速率的限制，但這可以在模組的設定檔中調整。

---

這台設備有「快速」與「普通」兩種模式。

在快速模式下，它會每刻輸出能量，若大量使用可能會導致遊戲卡頓。

在普通模式下，它會根據目標裝置的儲存能量來決定輸出量，這樣就不會造成卡頓問題。

> 注意：本文所提及的「能量」，是指儲存在你的[能量儲存單元](./flux_cells.md)中的 FE 能量，  
而非[能量電池](ae2:items-blocks-machines/energy_cells.md)中的 AE 能量。

