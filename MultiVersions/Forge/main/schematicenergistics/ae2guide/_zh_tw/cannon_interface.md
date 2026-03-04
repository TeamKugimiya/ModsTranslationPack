---
navigation:
  parent: schematicenergistics-index.md
  title: 加農炮介面
  icon: schematicenergistics:cannon_interface
categories:
- schematicenergistics
item_ids: 
- schematicenergistics:cannon_interface
- schematicenergistics:cannon_interface_part
---

# 加農炮介面

一種能讓《動力機械》模組的藍圖加農炮，存取 AE2 網路及自動合成系統的方塊。

<GameScene zoom="2" background="transparent" interactive={false}>
    <Block id="schematicenergistics:cannon_interface" />
</GameScene>

---

## 使用方式
將其放置在藍圖加農炮旁，並連接至 AE2 網路，即可讓加農炮存取網路中的物品。

一門藍圖加農炮，一次只能連接一個加農炮介面。

<GameScene zoom="2" background="transparent" interactive={true}>
  <ImportStructure src="./structure/example.nbt"></ImportStructure>
</GameScene>


加農炮始終會優先取用其他容器（如儲物箱、木桶等）內的物品，之後才會嘗試從 AE2 網路中調取物品。

這表示外部容器內的資源，將會被優先消耗。

若已連接至網路，加農炮介面也會自動將火藥從 AE2 網路，輸出至藍圖加農炮中。

右鍵點擊方塊即可開啟使用介面。

你可以在此控制物品與火藥的合成與輸出設定，並查看目前連接的藍圖加農炮狀態。

---

## 合成配方

<Recipe id="cannon_interface" />
<Recipe id="cannon_interface_to_part" />
