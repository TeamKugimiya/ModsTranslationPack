---
navigation:
    parent: ae2:items-blocks-machines/items-blocks-machines-index.md
    title: 樣板 P2P 通道
    icon: mae2:pattern_p2p_tunnel
categories:
 - devices
item_ids:
- mae2:pattern_p2p_tunnel
---

# 樣板通道

<GameScene zoom="4" background="transparent">
    <ImportStructure src="mae2:assets/assemblies/p2p/single_pattern.snbt" />
    <IsometricCamera yaw="15" pitch="30"/>
</GameScene>

樣板 P2P 通道專門用來傳輸 [樣板供應器](ae2:items-blocks-machines/pattern_provider.md) 發送出的[樣板](ae2:items-blocks-machines/patterns.md)材料。

貼在通道輸入端的供應器，會將樣板材料發送到，通道輸出端面向的任何機器。

除此之外，機器能藉由將配方產物送進通道的輸出端，將產物回傳進供應器來送回網路。

透過 P2P 通道發送樣板材料，其運作方式就如同供應器位於隧道的輸出端一樣。

這表示阻擋模式會針對每台機器單獨生效，且同一份配方材料絕不會被拆分給多個輸出端。

此外，特殊的樣板互動方式也能正常運作（例如直接將材料發送到子網路，或利用[分子組裝器](ae2:items-blocks-machines/molecular_assembler.md)）。
