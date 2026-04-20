---
navigation:
  title: 能量儀表
  icon: meter
item_ids:
  - meter
---

# 能量儀表

歡迎閱讀《能量儀表》模組介紹！

<br clear="all" />

![](assets/preview.png)

<FloatingImage src="assets/logo.png" align="right"/>

能量儀表是一款小型內容模組，  
新增了名為 <ItemLink id="meter" components="rarity=epic"/> 的方塊，讓你可以測量能量的流量。

這個方塊的運作方式類似線纜：傳入的請求會直接轉送至輸出端。

這些請求的數值都會被記錄下來，並依照可調整的「間隔值」計算出流量。

除了完整的使用者介面外，  
這個方塊的正面也有一個數位顯示器，讓你隨時都能查看當前流量。

顯示器可以朝任意方向旋轉，包括朝上或朝下。

> 由於能量儀表的正面要用來顯示資訊，因此只有其餘五個面可以設為輸入或輸出。

若你想查看先前各個間隔的流量，能量儀表的 UI 也提供了圖表檢視。

它會顯示最近 10 次間隔的測量結果，並且可以暫停。

介面中還提供了許多額外的設定選項，  
除了不同的測量方式外，也可以調整測量間隔與計算模式。
<br/>

更多資訊請參閱[介面](interface.md)。

<br clear="all" />
<RecipeFor id="meter"/>
