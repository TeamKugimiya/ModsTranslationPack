#!/bin/bash

# Import Common Libary
# shellcheck source=/dev/null
source ./.github/scripts/Common_Library.sh

# Vars
version=$1

home=/config/workspace/Project-Efina/ModsTranslationPack
workflow_path=${home:-$GITHUB_WORKSPACE}

## Move MultiVersions folder

workdir_move () {
  module_mode=$1

  if [ "$module_mode" = "1" ]; then
    cd "$workflow_path/MultiVersions" || exit
  elif [ "$module_mode" = "2" ]; then
    cd "$workflow_path" || exit
  else
    error_func
  fi
}

## Merge Patcher folder

merge_patcher () {
  command_excuter "cp -r Patcher/* $workflow_path/assets" "成功合併 Patcher！" "合併 Patcher 時發生錯誤！"
}

## MultiVersions Combiner
### TODO
### Because there only less few mod need this
### So it only just combine Fabric/global mods now

multiversion_combiner () {
  version=$1

  enable_global_debug=false

  if [ "$enable_global_debug" = false ]; then
    mods_list_fabric=(Fabric/global/*)

    for i in "${mods_list_fabric[@]}"; do
      workdir_path="$(mktemp -d)"

      mod_name=${i#Fabric/global/}
      original_path=${i//"Fabric/global"/assets}

      echo "🔧 製作 $mod_name 混合"
      command_excuter "cp $i/lang/zh_tw.json $workdir_path/zh_tw_multi.json" "成功複製 $mod_name 多語言至目的地" "在複製 $mod_name 多語言時發生問題"
      command_excuter "cp $workflow_path/$original_path/lang/zh_tw.json $workdir_path/zh_tw_original.json" "成功複製 $mod_name 原始翻譯至目的地" "在複製 $mod_name 原始翻譯時發生問題"

      echo "🔧 混合並移動檔案"
      cd "$workdir_path" || exit

      command_excuter "jq -s 'add' zh_tw_multi.json zh_tw_original.json > zh_tw.json" "成功混合！" "混合失敗！"
      command_excuter "cp zh_tw.json $workflow_path/$original_path/lang" "完成混合 $mod_name" "複製 $mod_name 成品時發生錯誤"
      workdir_move 1
    done
  fi

  if [ "$version" = "1.18.x" ]; then
    mods_list_forge_1_18=(Forge/1.18/*)

    for i in "${mods_list_forge_1_18[@]}"; do
      mod_name=${i#Forge/1.18/}
      original_path=${i//"Forge/1.18"/assets}

      echo "🔧 移動 $mod_name 至資料夾"
      command_excuter "cp $i/lang/zh_tw.json $workflow_path/$original_path/lang" "完成移動（$mod_name）" "移動 $mod_name 時發生錯誤"
    done
  fi
}

## Clean up unuse folder

cleanup_original () {
  echo "🧹 清理原始語言檔..."
  command_excuter "rm -v assets/*/lang/en_us.json" "成功清理原始語言檔" "在清理原始語言檔時發生錯誤"
  command_excuter "rm -rv assets/*/patchouli_books/*/en_us" "成功清理原始指南資料夾" "在清理原始指南資料夾時發生錯誤"
  echo "   "
  echo "🧹 清理多版本語言原始語言檔..."
  command_excuter "rm -v MultiVersions/Fabric/*/*/lang/en_us.json" "成功清理 Fabric 原始語言檔" "在清理 Fabric 原始語言檔時發生錯誤"
  command_excuter "rm -v MultiVersions/Forge/*/*/lang/en_us.json" "成功清理 Forge 原始語言檔" "在清理 Forge 原始語言檔時發生錯誤"
  echo "   "
  echo "🧹 清理 Markdown 文件..."
  command_excuter "rm -v README.md" "成功清理 README.md" "在清理 README.md 時發生錯誤"
  command_excuter "rm -v CHANGELOG.md" "成功清理 CHANGELOG.md" "在清理 CHANGELOG.md 時發生錯誤"
  command_excuter "rm -rv docs/" "成功清理 docs 資料夾" "在清理 docs 資料夾時發生錯誤"
}

cleanup () {
  echo "🧹 清理多版本語言資料夾..."
  command_excuter "rm -rv MultiVersions/" "成功清理多版本語言資料夾" "在清理多版本語言資料夾時發生錯誤"
}

# Run functions

## First clean up orignal en_us files & markdown docs
cleanup_original

## Second move to MultiVersions folder and merge patcher
workdir_move 1
merge_patcher

## Thrid combiner!
multiversion_combiner "$version"

# Last move to workdir root, and clean up MultiVersions folder
workdir_move 2
cleanup
