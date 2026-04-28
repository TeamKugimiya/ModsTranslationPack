---
navigation:
  parent: enderdrives_intro/enderdrives_intro-index.md
  title: 磁帶物品儲存單元
  icon: enderdrives:tape_disk
categories:
  - tapedrives
item_ids:
  - enderdrives:tape_disk
---

# 磁帶儲存單元

磁帶儲存單元是強大的 AE2 相容儲存單元，專門用於處理「含有大量 NBT 資料的物品」。

例如：工具、盔甲、附魔裝備，或任何帶有獨特標籤的物品。

在傳統的 ME 儲存單元中，這類物品通常會迅速填滿類型空間。

與典型的 AE2 儲存單元不同，磁帶單元的位元組使用量，

會根據儲存物品的實際「NBT 大小」動態調整，讓你對系統有更精細的控制。

磁帶單元「不會」主動告訴 AE2，它是符合篩選條件物品的首選路徑，請手動調整「ME 驅動器」的優先權。

<Row gap="10">
  <Column>
    <ItemImage id="enderdrives:tape_disk" />
  </Column>
  <Column>
    <ItemLink id="enderdrives:tape_disk" />
  </Column>
</Row>

---

## 運作原理

每個磁帶單元僅允許儲存具有非標準 NBT、盔甲、工具或不可堆疊的物品。

---

## 位元組與類型限制

磁帶單元同時執行**類型限制**與**位元組使用限制**：

- 類型限制：獨特物品可儲存的種類上限（例如：附魔書、自訂盔甲）。
- 位元組使用限制：基於每個物品的「NBT 資料大小」。  
  帶有大量標籤的物品（如《神化》模組的裝備），會因為 NBT 數量較多，而佔用更多空間。

磁帶單元的設計旨在「優先處理含有大量 NBT 的物品」，

這使其成為儲存裝備，或特殊單件物品的完美選擇，且不會佔用傳統儲存單元的類型空間。

---


## 何時該使用磁帶單元？

在以下情況下，請使用磁帶單元而非傳統儲存單元：

- 你正在儲存盔甲、工具或裝備等「**不可堆疊物品**」。
- 你需要空間來存放「**含有大量 NBT 的模組物品**」。
- 你希望將特殊物品，與一般的 ME 儲存單元區隔開來。

當一般的儲存單元因為「類型限制」而難以負荷時，就是磁帶單元大放異彩的時候。

---

## IO 埠傳輸

磁帶單元在使用 IO 埠進行傳輸時，會「自動調節速率（限速）」。

這是因為處理含有大量 NBT 的物品，可能會產生極大負擔，

自動限速能防止系統一次性傾倒所有資料，而導致遊戲當機。

---

## 可以儲存什麼？

磁帶單元專門用於大量 NBT、不可堆疊或自訂物品，而非一般的散件物品儲存。

---

### 支援儲存的物品

| 物品                                 | 範例                                     |
|-------------------------------------|------------------------------------------|
| <ItemImage id="minecraft:diamond_chestplate" /> | 帶有附魔的**鑽石胸甲**        |
| <ItemImage id="minecraft:enchanted_book" />     | 帶有附魔的**附魔書**          |
| <ItemImage id="minecraft:splash_potion" />      | 帶有效果的**藥水**            |
| <ItemImage id="minecraft:netherite_pickaxe" />  | 帶有耐久度損耗的**工具**       |

---

### 不支援儲存的物品

| 物品                              | 原因                            |
|-----------------------------------|--------------------------------|
| <ItemImage id="minecraft:cobblestone" /> | 無 NBT、可堆疊           |
| <ItemImage id="minecraft:wheat" />       | 無 NBT、可堆疊           |
| <ItemImage id="minecraft:oak_log" />     | 無 NBT、可堆疊           |
| <ItemImage id="minecraft:apple" />       | 無 NBT、可堆疊           |
| <ItemImage id="minecraft:iron_ingot" />  | 無 NBT、可堆疊           |

---

