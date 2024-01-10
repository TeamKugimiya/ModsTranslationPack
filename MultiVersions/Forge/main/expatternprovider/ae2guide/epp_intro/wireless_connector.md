---
navigation:
    parent: epp_intro/epp_intro-index.md
    title: ME 無線網路連接器
    icon: expatternprovider:wireless_connect
categories:
- extended devices
item_ids:
- expatternprovider:wireless_connect
- expatternprovider:wireless_tool
---

# ME 無線網路連接器

<Row gap="20">
<BlockImage id="expatternprovider:wireless_connect" scale="6"></BlockImage>
<ItemImage id="expatternprovider:wireless_tool" scale="6"></ItemImage>
</Row>

ME 無線網路連接器能夠像 <ItemLink id="ae2:quantum_link" /> 一樣，相連兩個不同的網路。
但擁有連線距離限制，且無法進行跨維度連結。

## 建立網路連線

使用 ME 無線網路設定工具，點擊兩台不同的無線網路連接器後，便能夠在兩者間建立連線。

潛行 + 點擊右鍵能夠清除「ME 無線網路設定工具」的目前設定。

成功建立連線之後，ME 無線網路連接器將會改變其外觀紋理。

尚未建立連線的 ME 無線網路連接器：

<GameScene zoom="5" background="transparent">
  <ImportStructure src="../structure/wireless_connector_off.snbt"></ImportStructure>
</GameScene>

已建立連線的 ME 無線網路連接器：

<GameScene zoom="5" background="transparent">
  <ImportStructure src="../structure/wireless_connector_on.snbt"></ImportStructure>
</GameScene>

## 耗電量

隨著連線距離越長，ME 無線網路連接器將需要消耗更多能量。
耗電量與連線距離間的關係並非線性，因此當連線距離太長，能量成本將會變得額外高昂。

你可以使用 <ItemLink id="ae2:energy_card" /> 來節省能量，每張卡片都能夠減少 10% 耗電量。

