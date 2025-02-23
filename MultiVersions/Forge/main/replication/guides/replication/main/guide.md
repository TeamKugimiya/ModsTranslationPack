---
navigation:
  title: 複製科技
  icon: replication:replicator
item_ids:
  - replication:replicator
  - replication:matter_network_pipe
  - replication:identification_chamber
  - replication:disintegrator
  - replication:matter_tank
  - replication:replication_terminal
  - replication:chip_storage
---

# 複製科技

**複製科技** 是個讓你複製相同類型資源的科技模組。你能把泥土變成石頭，但不能把泥土變成鑽石。

## 重要概念

**物質管道**能將複製科技的機器連接在一起，並能自動執行一些流程：

* 傳輸**電力**：運作方式與其他模組的電力管道相同
* 傳輸**物質**：能將物質從**粉碎機**傳輸至**物質儲罐**，並從**物質儲罐**傳輸至**其他需要物質的機器**

**鑑定室**能掃描物品以取得它們的物質數值，並將資料儲存在晶片當中。  
將這些**晶片**儲存在**晶片儲存器**裡，來讓網路讀取這些數值。

**複製機**能設為「無限模式」，這會使機器持續複製某個物品，  
直到複製機輸出欄位滿了，或是所需物質已耗盡，你能在 GUI 中改變模式。

## 如何運作

轉換物品前，你需要使用**粉碎機**粉碎物品，取出它們的原始數值。  
使用這台機器，能將任何具有物質數值的物品，轉換成物質。  
掃描物品並將它們的數值儲存至晶片後，就能使用**複製終端**來請求物品。  
發送請求後，**複製機**會使用保存在物質儲罐的物質，從零開始複製物品，然後將其送回終端。

<GameScene zoom="4" interactive={true}>
  <ImportStructure src="setup.snbt" />
  <IsometricCamera  yaw="30" pitch="30" />
</GameScene>

## 物質百科

物質百科是個可搜尋的清單，讓你查詢什麼物品有什麼特殊的物質數值。  
你能在<ItemLink id="replication:replication_terminal" />的畫面中，點擊搜尋欄左側的按鈕來開啟它，或是直接點選終端右側的物質顯示區進入。

物質百科中的搜尋欄能使用：

* 任何物質名稱：會顯示所有包含該物質的物品
* 「`地>10`」：會顯示所有地物質大於 10 的物品
* 「`地獄=20`」：會顯示所有剛好地獄物質等於 20 的物品
* 「`量子<6`」：會顯示所有量子物質小於 6 的物品
* 「`!地`」：會顯示所有不含地物質的物品
* 「`*金屬`」：會顯示只有金屬物質的物品