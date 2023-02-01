#!/bin/bash

make_file () {
  file_name=ModsList.md
  mods_count=$(ls assets/ | wc -l)
  touch $file_name
  {
    echo "# 模組清單"
    echo ""
    echo "此清單用於記錄模組翻譯回饋至該模組專案"
    echo ""
    echo "目前已收錄 \`\`$mods_count\`\` 個模組"
    echo ""
    echo "| 模組名稱 | 貢獻 | PR | 翻譯變動 |"
    echo "| ------ | ------ | ------ | ------ |"
  } > $file_name
}

list_dir () {
  find assets/ -maxdepth 1 -type d -exec echo "$1" \; >> "$2"
}

modslist_generate () {
  file_name=modslist_result.md
  list_dir '| {} | :x: |  |  |' $file_name
  sed -i "1s+| assets/ | :x: |  |  |++" $file_name
  sed -i "s+assets/++" $file_name
  sed -i "/^$/d" $file_name
}

modslist_added_mod_generate () {
  file_name=modslist_result.md
  x_placeholder=" | :x: |  |  |"
  question_placeholder=" | :question: |"
  check_placeholder=" | :heavy_check_mark: |"

  if [ "$1" = 1 ]; then
    sed -i "s+$2$x_placeholder+$2$check_placeholder [已回饋]($3) |  |+" $file_name
  elif [ "$1" = 2 ]; then
    sed -i "s+$2$x_placeholder+$2$check_placeholder [已回饋]($3) | :heavy_exclamation_mark: |+" $file_name
  elif [ "$1" = 3 ]; then
    sed -i "s+$2$x_placeholder+$2$question_placeholder [等待合併]($3) |  |+" $file_name
  elif [ "$1" = 4 ]; then
    sed -i "s+$2$x_placeholder+$2$question_placeholder Crowdin |  |+" $file_name
  fi
}

sort_file () {
  sort -o modslist_result_sorted.md modslist_result.md
}

combind_file () {
  cat modslist_result_sorted.md >> ModsList.md
  mv ModsList.md docs/ModsList.md
  rm modslist_result_sorted.md modslist_result.md
}

# Main
modslist_generate

## Status Code
#
# 1 已回饋
# 2 已回饋，但翻譯在本專案有更新
# 3 等待合併
# 4 提交上 Crowdin 或同步 Crowdin

### Screencapper
modslist_added_mod_generate "2" "screencapper" "https://github.com/Deftu/Screencapper/pull/6"

## Sodium & Sodium Extra
modslist_added_mod_generate "4" "sodium"
modslist_added_mod_generate "4" "sodium-extra"

## Auto ModPack
modslist_added_mod_generate "1" "automodpack" "https://github.com/Skidamek/AutoModpack/pull/64"

## EnergyMeter
modslist_added_mod_generate "2" "energymeter" "https://github.com/AlmostReliable/energymeter-forge/pull/26"

### TrashCans
modslist_added_mod_generate "3" "trashcans" "https://github.com/SuperMartijn642/TrashCans/pull/20"

### Flux Networks
modslist_added_mod_generate "1" "fluxnetworks" "https://github.com/SonarSonic/Flux-Networks/pull/482"

### YetAnotherConfigLib
modslist_added_mod_generate "1" "yet-another-config-lib" "https://github.com/isXander/YetAnotherConfigLib/pull/31"

### ExNihiloSequentia
modslist_added_mod_generate "1" "exnihiloae" "https://github.com/NovaMachina-Mods/ExNihiloSequentia/pull/380"
modslist_added_mod_generate "1" "exnihilomekanism" "https://github.com/NovaMachina-Mods/ExNihiloSequentia/pull/380"
modslist_added_mod_generate "1" "exnihilosequentia" "https://github.com/NovaMachina-Mods/ExNihiloSequentia/pull/380"
modslist_added_mod_generate "1" "exnihilothermal" "https://github.com/NovaMachina-Mods/ExNihiloSequentia/pull/380"
modslist_added_mod_generate "1" "exnihilotinkers" "https://github.com/NovaMachina-Mods/ExNihiloSequentia/pull/380"

### LanguageReload
modslist_added_mod_generate "1" "languagereload" "https://github.com/Jerozgen/LanguageReload/pull/20"

### BorderlessMining
modslist_added_mod_generate "1" "borderlessmining" "https://github.com/comp500/BorderlessMining/pull/56"

### SlimefunToEMI
modslist_added_mod_generate "3" "sftoemi" "https://github.com/JustAHuman-xD/SlimefunToEMI/pull/2"

### CITResewn
modslist_added_mod_generate "1" "citresewn" "https://github.com/SHsuperCM/CITResewn/pull/219"
modslist_added_mod_generate "1" "citresewn-defaults" "https://github.com/SHsuperCM/CITResewn/pull/219"

### Fabric Capes
modslist_added_mod_generate "1" "capes" "https://github.com/CaelTheColher/Capes/pull/85"

### EntityCulling
modslist_added_mod_generate "1" "entityculling" "https://github.com/tr7zw/EntityCulling/pull/94"

### GraphUtil
modslist_added_mod_generate "1" "graphutil" "https://github.com/tr7zw/GraphUtil/pull/4"

# Finish
sort_file
make_file
combind_file
