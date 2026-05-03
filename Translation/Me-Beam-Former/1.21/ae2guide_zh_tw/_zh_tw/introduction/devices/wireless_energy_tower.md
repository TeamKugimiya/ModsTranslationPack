---
navigation:
  parent: introduction/index.md
  title: 無線能源塔
  position: 4
  icon: me_beam_former:wireless_energy_tower
categories:
  - me_beam_former devices
item_ids:
  - me_beam_former:wireless_energy_tower
---

# 無線能源塔

<Row gap="20">
<ItemImage id="me_beam_former:wireless_energy_tower" scale="4" />
<GameScene zoom="8" background="transparent">
  <ImportStructure src="../../structure/wireless_energy_tower.snbt" />
</GameScene>
</Row>

用於無線傳輸能量。

## 綁定方式

- 使用<ItemLink id="me_beam_former:laser_binding_tool" />，將塔與塔建立連線以形成電網（雙向）。
- 也可以將塔與具備能量介面的機器建立連線（單向：塔 -> 機器）。

## 連線範圍

- 水平範圍：X/Z 方向各不超過 20 格。
- 垂直範圍：Y 方向不超過 256 格。
