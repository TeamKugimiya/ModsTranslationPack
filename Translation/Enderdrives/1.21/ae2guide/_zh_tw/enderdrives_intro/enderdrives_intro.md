---
navigation:
  parent: enderdrives_intro/enderdrives_intro-index.md
  title: 終界物品儲存單元
  icon: enderdrives:ender_disk_1k
categories:
  - enderdrives
item_ids:
  - enderdrives:ender_disk_1k
  - enderdrives:ender_disk_4k
  - enderdrives:ender_disk_16k
  - enderdrives:ender_disk_64k
  - enderdrives:ender_disk_256k
  - enderdrives:ender_disk_creative
---

# 終界單元

終界單元是功能強大的儲存單元，透過頻率設定，

能讓不同的 ME 系統、維度，甚至是不同的玩家之間達成同步儲存。

<Row gap="10">
  <Column>
    <ItemImage id="enderdrives:ender_disk_1k" />
  </Column>
  <Column>
    <ItemLink id="enderdrives:ender_disk_1k" />
  </Column>
</Row>

<Row gap="10">
  <Column>
    <ItemImage id="enderdrives:ender_disk_4k" />
  </Column>
  <Column>
    <ItemLink id="enderdrives:ender_disk_4k" />
  </Column>
</Row>

<Row gap="10">
  <Column>
    <ItemImage id="enderdrives:ender_disk_16k" />
  </Column>
  <Column>
    <ItemLink id="enderdrives:ender_disk_16k" />
  </Column>
</Row>

<Row gap="10">
  <Column>
    <ItemImage id="enderdrives:ender_disk_64k" />
  </Column>
  <Column>
    <ItemLink id="enderdrives:ender_disk_64k" />
  </Column>
</Row>

<Row gap="10">
  <Column>
    <ItemImage id="enderdrives:ender_disk_256k" />
  </Column>
  <Column>
    <ItemLink id="enderdrives:ender_disk_256k" />
  </Column>
</Row>

---

## 運作原理
每個終界單元都配有頻率、共享範圍與傳輸模式的設定：
- **頻率**: 具有相同頻率的單元，將共享同一個儲存空間。
- **共享範圍**: 決定誰可以存取該單元（公用、私人或隊伍）。
- **傳輸模式**: 控制物品的傳輸方向（雙向、僅輸入、僅輸出）。

不論位於何處，具有相同頻率與共享範圍的單元，都將存取「**同一個虛擬儲存空間**」。

---

## 類型限制
與傳統的 AE2 儲存單元不同，終界單元的限制僅基於物品「類型」。

由於後端儲存物品的方式，唯一的硬性限制是物品種類的數量。

每種物品你實際上可以儲存高達 2^63 - 1（即 9,223,372,036,854,775,807）個。

但請注意，網路的能量消耗，會隨著該頻率中儲存的物品總量增加而提高！

---

## 基準測試
每個伺服器開始產生效能負擔的類型上限都不同。

你可以使用指令「/enderdrives autobenchmark」來測試你的伺服器。

為了獲得準確的結果，你需要開啟一個連接至單元的終端機，並將該單元設為「私人」且選定頻率。

基準測試將持續進行，直到 TPS 降至 18 以下，這可能需要幾分鐘的時間。

我的個人平均值約為 275,000 種。

> 275,000/255 ≈ 1078。

這代表我必須在 107.8 個 ME 驅動器中，插滿 256k 終界單元，並存滿不同種類的物品，才會開始出現效能問題。

實際的建議最大類型數，可能更高或更低，此限制由同一世界中，所有使用該單元的玩家共同承擔。

---

## 傳輸模式
每個單元都可以設定為以下三種**傳輸模式**之一：

- ![PEGui1](../pic/transport_bidirectional_alt.png) **雙向**_（預設）_  
  標準 ME 儲存單元行為，可自由存入與取出物品。


- ![PEGui1](../pic/transport_input_alt.png) **僅輸入**  
  物品可以存入但無法取出。適用於自動化緩衝區或同步輸入。


- ![PEGui1](../pic/transport_output_alt.png) **僅輸出**  
  物品可以取出但無法存入。非常適合作為輸出緩衝區使用或唯讀存取。

---

## 共享範圍與隱私

每個單元還具備**共享範圍**設定，用以控制誰能存取該儲存空間：
-  **公用**_（預設）_  
   公用模式！任何使用相同頻率的玩家，都能存取此共享儲存空間。


-  **私人**  
  與你的 UUID 綁定。只有你能建立存取此頻率的單元，  
  但任何使用你 ME 系統的其他使用者，仍可透過系統介面存取此空間內容。


-  **隊伍**  
  與你的 FTB 隊伍成員共享。所有成員皆可建立並存取相同頻率的單元。
