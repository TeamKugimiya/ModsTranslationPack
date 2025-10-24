---
navigation:
  parent: aae_intro/aae_intro-index.md
  title: 進階雙向匯流排
  icon: advanced_ae:advanced_io_bus_part
categories:
  - advanced items
item_ids:
  - advanced_ae:advanced_io_bus_part
---

# 進階雙向匯流排

<GameScene zoom="8" background="transparent">
  <ImportStructure src="../structure/cable_advanced_io_bus.snbt"></ImportStructure>
</GameScene>

進階雙向匯流排是一種功能強大的工具，用於與外部儲存容器互動。

透過將 <ItemLink id="advanced_ae:import_export_bus_part"/> 與 <ItemLink id="advanced_ae:stock_export_bus_part"/> 相互結合來取得。

它繼承了這兩種設備的全部功能。

此外，進階雙向匯流排的運作速度，比 <ItemLink id="ae2:export_bus"/> 快上 8 倍。

它需要一些時間來逐漸提升速度，但在完成暖機之後將會達到極致的速度。

## 輸出

進階雙向匯流排會根據其篩選器的設定進行輸出，直到目標容器中的物品數量，達到設定值後停止。

在匯流排介面的左側有一顆設定按鈕，能讓使用者選擇是否要對物品的儲量進行調節。

## 輸入

進階雙向匯流排也會將任何沒有在篩選器中設定為「輸出」的物品，輸入回 ME 系統當中。

輸入與輸出的操作是分開計算的，因此匯流排不會因為只專注於執行其中一項操作而卡住。

當匯流排啟用調節模式時，它會優先將超出設定數量的任何物品，輸入回 ME 系統。

如果還有多的運作能力，它才會將那些沒有在篩選器中設定為「輸出」的物品，輸入回 ME 系統。

<RecipeFor id="advanced_ae:advanced_io_bus_part"/>