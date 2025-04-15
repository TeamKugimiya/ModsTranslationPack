---
navigation:
  parent: aae_intro/aae_intro-index.md
  title: ME 吞吐量監控器
  icon: advanced_ae:throughput_monitor
categories:
  - advanced items
item_ids:
  - advanced_ae:throughput_monitor
  - advanced_ae:throughput_monitor_configurator
---

# ME 吞吐量監控器

<GameScene zoom="8" background="transparent">
<ImportStructure src="../structure/throughput_monitors.snbt"></ImportStructure>
<IsometricCamera yaw="195" pitch="30" />
</GameScene>

吞吐量監控器是監控器的另一種版本，

除了具備 <ItemLink id="ae2:storage_monitor" /> 的相同功能外，還提供吞吐量儀表功能。

它能追蹤單一物品／流體的數量變化，並向使用者顯示每秒的變動量。

其運作**無需占用頻道**。

## 快捷鍵

*   手拿物品對著監控器點擊右鍵，或使用流體容器對其連按兩下右鍵，  
可將監控目標設定為該物品／流體。
*   空手對著監控器點擊右鍵，可清除監控目標。
*   空手對著監控器 Shift + 點擊右鍵，可將監控器上鎖，避免誤觸。

## 吞吐量監控設定器

<ItemImage id="advanced_ae:throughput_monitor_configurator" scale="4"></ItemImage>

吞吐量監控設定器是一種用於變更顯示資料的工具。

手拿設定器對著監控器點擊右鍵，會使其在以下三種模式間輪換：

* 物品／刻
* 物品／秒
* 物品／分

注意：切換模式後，需等待讀數穩定，初始數值可能不準確！