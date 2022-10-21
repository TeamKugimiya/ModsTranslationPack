#!/bin/bash

list_dir () {
  find ../assets/ -maxdepth 1 -type d -exec echo "$1" \; > "$2"
}

readme_generate () {
    file_name=readme_result.md
    list_dir '<li>{}</li>' $file_name
    sed -i "s+<li>../assets/</li>++" $file_name
    sed -i "s+<li>../assets/minecraft</li>++" $file_name
    sed -i "s+../assets/++" $file_name
    sed -i "/^$/d" $file_name
}

modslist_generate () {
    file_name=modslist_result.md
    list_dir '| {} | :x: |  |  |' $file_name
    sed -i "1s+| ../assets/ | :x: |  |  |++" $file_name
    sed -i "s+| {} | ../assets/minecraft | :x: |  |  |++" $file_name
    sed -i "s+../assets/++" $file_name
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
      sed -i "s+$2$x_placeholder+$2$question_placeholder 已提交上 Crowdin（或同步） |  |+" $file_name
    fi
}

# Main
readme_generate
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
modslist_added_mod_generate "2" "fluxnetworks" "https://github.com/SonarSonic/Flux-Networks/pull/482"
