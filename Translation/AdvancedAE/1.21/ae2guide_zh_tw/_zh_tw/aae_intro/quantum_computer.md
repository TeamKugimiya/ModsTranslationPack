---
navigation:
  parent: aae_intro/aae_intro-index.md
  title: 量子電腦
  icon: advanced_ae:quantum_core
categories:
  - advanced devices
item_ids:
  - advanced_ae:quantum_unit
  - advanced_ae:quantum_core
  - advanced_ae:quantum_structure
  - advanced_ae:quantum_accelerator
  - advanced_ae:quantum_multi_threader
  - advanced_ae:quantum_storage_128
  - advanced_ae:quantum_storage_256
  - advanced_ae:data_entangler
---

# 量子電腦

量子電腦是一種特殊的合成電腦。

只要有足夠的合成儲存空間，就能處理無限量的合成請求。

<GameScene zoom="2" background="transparent">
  <ImportStructure src="../structure/quantum_computer_multiblock.snbt"></ImportStructure>
</GameScene>

---

## 量子核心

<BlockImage id="advanced_ae:quantum_core" p:powered="true" p:formed="true" scale="4"></BlockImage>

量子核心是量子電腦的核心元件。

內建 256M 的合成儲存空間，以及 8 個協同處理器執行緒。

單獨放置時，核心即可構成一台功能完整的量子電腦，並具備所有相關優勢。

但若用於搭建多方塊結構，則可以打造出性能更強大的電腦。

當作為獨立電腦使用時，必須透過頂部或底部連結至 ME 系統。

---

## 量子儲存器

<Row gap="20">
<BlockImage id="advanced_ae:quantum_storage_128" scale="4"></BlockImage>
<BlockImage id="advanced_ae:quantum_storage_256" scale="4"></BlockImage>
</Row>

這種方塊用於擴充量子核心的合成儲存容量，有效提升量子電腦能同時執行的任務數量。

提供兩種規格，容量分別是 128M 和 256M。

---

## 量子資料纏結器

<BlockImage id="advanced_ae:data_entangler" scale="4"></BlockImage>

資料纏結器是一種特殊方塊，會影響多方塊結構中的所有儲存方塊。

使量子電腦能在多個維度中儲存資料，使儲存空間擴增 4 倍

每個量子電腦多方塊結構中僅能放置一個。

---

## 量子加速器

<BlockImage id="advanced_ae:quantum_accelerator" scale="4"></BlockImage>

量子加速器為量子電腦多方塊結構，提供額外 8 個協同處理器。

請注意，量子電腦處理的所有合成樣板，都能共享這些協同處理器，

因此大量投資這些可能是個好主意。

---

## 量子多執行緒處理器

<BlockImage id="advanced_ae:quantum_multi_threader" scale="4"></BlockImage>

多執行緒處理器與資料纏結器功能相似，

使加速器能在多個維度中執行更多執行緒，使其協同處理能力提升 4 倍。

每個量子電腦多方塊結構僅能放置一個。

---

## 量子結構

<Row gap="20">
<BlockImage id="advanced_ae:quantum_structure" scale="4"></BlockImage>
<BlockImage id="advanced_ae:quantum_structure" p:formed="true" scale="4"></BlockImage>
<BlockImage id="advanced_ae:quantum_structure" p:formed="true" p:powered="true" scale="4"></BlockImage>
</Row>

這些方塊用於搭建量子電腦的框架，並負責連接所有網路元件。

---

## 多方塊結構

搭建量子電腦多方塊結構時，必須遵守下列規則：
- 最大尺寸為 7x7x7（外部尺寸）
- 結構內部不得有空心，可用「<ItemLink id="advanced_ae:quantum_unit" />」填充，但無額外益處
- 結構中必須包含一個「<ItemLink id="advanced_ae:quantum_core" />」
- 結構中最多一個「<ItemLink id="advanced_ae:data_entangler" />」
- 結構中最多一個「<ItemLink id="advanced_ae:quantum_multi_threader" />」
- 結構外層必須使用「<ItemLink id="advanced_ae:quantum_structure" />」
- 結構內部不得使用「<ItemLink id="advanced_ae:quantum_structure" />」

---

## 伺服器設定

伺服器設定檔可調整多項數值，例如：
- 多方塊結構的最大尺寸
- 量子加速器提供的協同處理器數量
- 量子多執行緒處理器的最大數量
- 多執行緒處理器的執行緒乘數
- 資料纏結器的最大數量
- 資料纏結器的儲存容量乘數

你目前實例的限制，可在物品的工具提示中查看。