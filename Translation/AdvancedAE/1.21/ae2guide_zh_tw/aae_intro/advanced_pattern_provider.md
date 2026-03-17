---
navigation:
  parent: aae_intro/aae_intro-index.md
  title: ME 進階樣板供應器
  icon: advanced_ae:adv_pattern_provider
categories:
  - advanced devices
item_ids:
  - advanced_ae:adv_pattern_provider
  - advanced_ae:small_adv_pattern_provider
  - advanced_ae:adv_pattern_provider_part
  - advanced_ae:small_adv_pattern_provider_part
---

# ME 進階樣板供應器

<Row gap="20">
<BlockImage id="advanced_ae:adv_pattern_provider" scale="8"></BlockImage>
<BlockImage id="advanced_ae:adv_pattern_provider" p:push_direction="up" scale="8"></BlockImage>
<GameScene zoom="8" background="transparent">
  <ImportStructure src="../structure/cable_app_part.snbt"></ImportStructure>
</GameScene>
</Row>

ME 進階樣板供應器是一種新型態的 <ItemLink id="ae2:pattern_provider" />，

可由標準版本或 <ItemLink id="expatternprovider:ex_pattern_provider" />升級而成。

其獨特之處在於，能為樣板的個別材料，設定指定的輸入方向。

這項功能讓需要特定面輸入的機器，僅需使用單一方塊即可完成自動化，無需搭配任何管道！

*指的就是你，《通用機械》。*

![AAEGui](../pic/app_gui.png)

若要使用此功能，你需要將一個編碼過的普通樣板，放入<ItemLink id="advanced_ae:adv_pattern_encoder" />。

編輯完成後取出，即可獲得<ItemLink id="advanced_ae:adv_processing_pattern" />，然後將其放入進階樣板供應器中使用。
