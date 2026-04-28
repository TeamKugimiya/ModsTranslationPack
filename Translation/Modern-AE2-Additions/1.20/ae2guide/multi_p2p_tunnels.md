---
navigation:
    parent: ae2:items-blocks-machines/items-blocks-machines-index.md
    title: P2P 多通道
    icon: mae2:pattern_multi_p2p_tunnel
    position: 210
categories:
 - devices
item_ids:
- mae2:redstone_multi_p2p_tunnel
- mae2:item_multi_p2p_tunnel
- mae2:fluid_multi_p2p_tunnel
- mae2:fe_multi_p2p_tunnel
- mae2:eu_multi_p2p_tunnel
- mae2:pattern_multi_p2p_tunnel
---

# 點對點通道
P2P 多通道運作原理與 [P2P 單通道](ae2:items-blocks-machines/p2p_tunnels.md) 相同，但能同時擁有多個輸入端！

在非慣用手上拿著 <ItemLink id="ae2:memory_card" />，對著其他 P2P 多通道點擊右鍵，可以設定更多輸入端。

舉個例子，下圖中的 3 個漏斗，會將物品發送至 3 個輸出端。

<GameScene zoom="3" background="transparent">
    <ImportStructure src="mae2:assets/assemblies/p2p/multi_item.snbt" />
    <IsometricCamera yaw="100" pitch="30" />
</GameScene>

這 3 個紅石 P2P 多通道，能充當中繼器輸入端的 OR 閘。
<GameScene zoom="3" background="transparent">
    <ImportStructure src="mae2:assets/assemblies/p2p/multi_redstone.snbt" />
    <IsometricCamera yaw="15" pitch="30" />
</GameScene>

這 3 個樣板 P2P 多通道，會共享這 4 台分子組裝器。
<GameScene zoom="3" background="transparent">
    <ImportStructure src="mae2:assets/assemblies/p2p/multi_pattern.snbt" />
    <IsometricCamera yaw="15" pitch="30" />
</GameScene>

## 備註
若你對缺席的 ME P2P 多通道感到好奇，這是因為 <ItemLink id="ae2:me_p2p_tunnel" />，已經模糊了輸入與輸出端之間的界線。

由於 [頻道](ae2:ae2-mechanics/channels.md) 沒有方向性，多個輸入端可以很容易地被更多輸出端取代。

至於為什麼沒有光源 P2P 多通道，因為我不認為有任何人會需要它們，並且也不想浪費時間編寫它們的程式碼。
