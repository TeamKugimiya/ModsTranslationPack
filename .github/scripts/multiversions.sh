#!/bin/bash

# Import Common Libary
# shellcheck source=/dev/null
source ./.github/scripts/Common_Library.sh

# Vars Settings
version=$1
# home=/config/workspace/Project-Efina/ModsTranslationPack/
workflow_path=${home:-$GITHUB_WORKSPACE}
multiversion_path=$workflow_path/MultiVersions
pack_path=$workflow_path/pack

### Functions ###

## Setup pack
setup_pack () {
  echo "初始化翻譯包資料夾"
  mkdir -p pack/assets
  command_excuter "cp -r $multiversion_path/configs/* $pack_path" "成功移動設定！" "移動設定時發生錯誤！"
  command_excuter "cp -r LICENSE $pack_path" "成功移動授權條款！" "移動授權條款時發生錯誤！"
  command_excuter "cp -r $multiversion_path/Forge/main/* $pack_path/assets" "成功移動主版本！" "移動主版本時發生錯誤！"
  command_excuter "cp -r $multiversion_path/Patcher/* $pack_path/assets" "成功合併 Patcher！" "合併 Patcher 時發生錯誤！"
  echo "移動授權條款相關檔案"
  command_excuter "mv $multiversion_path/Override/LICENSE_* $pack_path" "成功移動授權條款資料！" "移動授權條款資料時發生錯誤！"
}

# Mixer

mixer () {
  local platform=$1
  local version=$2
  local multi_path=$multiversion_path
  local dest_pack=$pack_path

  echo "$platform 版本 $version"

  for i in "$multi_path/$platform/$version"/*; do
    folder_name=$(basename "$i")
    dest_folder="$dest_pack/$folder_name"

    if [ -d "$dest_folder" ]; then
      if [ -f "$i/lang/.gitkeep" ]; then
        echo "📄 $folder_name 存在相同的資料夾名，但擁有忽略檔案，不進行混和而直接覆蓋 ($dest_folder)"
        command_excuter "cp -r $i $dest_pack" "移動 $folder_name 完成" "移動 $folder_name 出現問題！"
      else
        echo "📄 $folder_name 存在相同的資料夾名，進行混和 ($dest_folder)"
        command_excuter "mv $dest_folder/lang/zh_tw.json $dest_folder/lang/zh_tw_ori.json" "完成製作副本" "製作副本時出現錯誤"
        jq -s 'add' "$i/lang/zh_tw.json" "$dest_folder/lang/zh_tw_ori.json" > "$dest_folder/lang/zh_tw.json"
        command_excuter "rm $dest_folder/lang/zh_tw_ori.json" "成功移除副本" "移除副本時出現錯誤"
      fi
    else
      echo "🖊️ $folder_name 未存在相同資料夾，進行純粹移動 ($dest_folder)"
      command_excuter "cp -r $i $dest_pack" "移動 $folder_name 完成" "移動 $folder_name 出現問題！"
    fi
  done

  echo "   "
}

## MultiVersions

multiversion () {
    local version=$1
    local pack_path=$pack_path/assets

  if [ "$version" = "1.19.x" ]; then
    mixer "Fabric" "main"
  elif [ "$version" = "1.18.x" ]; then
    mixer "Fabric" "main"
    mixer "Fabric" "1.18"
    mixer "Forge" "1.18"
  else
    echo "⚠️ 未知版本"
    exit 1
  fi
}

## Cleaning

cleaning () {
  local platform=$1
  local version=$2
  local patchouli_books_clean=${3:-false}
  local path=$multiversion_path

  echo "🧹 清理 $platform 平台的 $version 原始語言檔..."
  command_excuter "rm -v $path/$platform/$version/*/lang/en_us.json" "成功清理 $platform 平台的 $version 原始語言檔" "在清理 $platform 平台的 $version 原始語言檔時發生錯誤"
  if [ "$patchouli_books_clean" = true ]; then
    command_excuter "rm -rv $path/$platform/$version/*/patchouli_books/*/en_us" "成功清理 $platform 平台的 $version 原始指南資料夾" "在清理 $platform 平台的 $version 原始指南資料夾時發生錯誤"
  fi
  echo "   "
}

clean () {
  cleaning "Forge" "main" true
  cleaning "Forge" "1.18"
  cleaning "Fabric" "main"
  cleaning "Fabric" "1.18"
}

## Main

main () {
  clean
  setup_pack
  multiversion "$version"
}

main
