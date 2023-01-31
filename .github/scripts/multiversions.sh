#!/bin/bash

# Vars
version=$1

# home=/config/workspace/Project-Efina/ModsTranslationPack
workflow_path=${home:-$GITHUB_WORKSPACE}

## Common function

# Error function
error () {
    echo "::error ::❗ 錯誤！模式或參數錯誤。"
    exit 128
}

# Status function
status_echoer () {
  status=$1
  message=$2

  if [ "$status" = true ]; then
    echo "✅ $message"
  elif [ "$status" = false ]; then
    echo "::error ::❎ $message"
    exit 1
  else
    error
  fi
}

# Command passer function

command_pass () {
  command=$1
  message_success=$2
  message_fail=$3

  if $command; then
    status_echoer true "$message_success"
  else
    status_echoer false "$message_fail"
  fi
}

## Move MultiVersions folder

workdir_move () {
  module_mode=$1

  if [ "$module_mode" = "1" ]; then
    cd "$workflow_path/MultiVersions" || exit
  elif [ "$module_mode" = "2" ]; then
    cd "$workflow_path" || exit
  else
    error
  fi
}

## Merge Patcher folder

merge_patcher () {
  if cp -r Patcher/* "$workflow_path/assets"; then
  status_echoer true "成功合併 Patcher！"
  else
  status_echoer false "合併 Patcher 時發生錯誤！"
  fi
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

      # shellcheck disable=SC2001
      mod_name=$(echo "$i" | sed 's+Fabric/global/++')
      # shellcheck disable=SC2001
      original_path=$(echo "$i" | sed 's+Fabric/global/+assets/+')

      echo "🔧 製作 $mod_name 混合"
      command_pass "cp $i/lang/zh_tw.json $workdir_path/zh_tw_multi.json" "成功複製 $mod_name 多語言至目的地" "在複製 $mod_name 多語言時發生問題"
      command_pass "cp $workflow_path/$original_path/lang/zh_tw.json $workdir_path/zh_tw_original.json" "成功複製 $mod_name 原始翻譯至目的地" "在複製 $mod_name 原始翻譯時發生問題"

      echo "🔧 混合並移動檔案"
      cd "$workdir_path" || exit

      if jq -s 'add' zh_tw_multi.json zh_tw_original.json > zh_tw.json; then
        status_echoer true "成功混合！"
      else
        status_echoer false "混合失敗！"
      fi
      command_pass "cp zh_tw.json $workflow_path/$original_path/lang" "完成混合 $mod_name" "複製 $mod_name 成品時發生錯誤"
      workdir_move 1
    done
  fi

  if [ "$version" = "1.18.x" ]; then
    mods_list_forge_1_18=(Forge/1.18/*)

    for i in "${mods_list_forge_1_18[@]}"; do
      # shellcheck disable=SC2001
      mod_name=$(echo "$i" | sed 's+Forge/1.18/++')
      # shellcheck disable=SC2001
      original_path=$(echo "$i" | sed 's+Forge/1.18/+assets/+')
      
      echo "🔧 移動 $mod_name 至資料夾 $i $mod_name $original_path"
      command_pass "cp $i/lang/zh_tw.json $workflow_path/$original_path/lang" "完成移動（$mod_name）" "移動 $mod_name 時發生錯誤"
    done
  fi
}

## Clean up unuse folder

cleanup_original () {
  echo "🧹 清理原始語言檔..."
  command_pass "rm -v assets/*/lang/en_us.json" "成功清理原始語言檔" "在清理原始語言檔時發生錯誤"
  command_pass "rm -rv assets/*/patchouli_books/*/en_us" "成功清理原始指南資料夾" "在清理原始指南資料夾時發生錯誤"
  echo "   "
  echo "🧹 清理多版本語言原始語言檔..."
  command_pass "rm -v MultiVersions/Fabric/*/*/lang/en_us.json" "成功清理 Fabric 原始語言檔" "在清理 Fabric 原始語言檔時發生錯誤"
  command_pass "rm -v MultiVersions/Forge/*/*/lang/en_us.json" "成功清理 Forge 原始語言檔" "在清理 Forge 原始語言檔時發生錯誤"
  echo "   "
  echo "🧹 清理 Markdown 文件..."
  command_pass "rm -v README.md" "成功清理 README.md" "在清理 README.md 時發生錯誤"
  command_pass "rm -v CHANGELOG.md" "成功清理 CHANGELOG.md" "在清理 CHANGELOG.md 時發生錯誤"
  command_pass "rm -rv docs/" "成功清理 docs 資料夾" "在清理 docs 資料夾時發生錯誤"
}

cleanup () {
  echo "🧹 清理多版本語言資料夾..."
  command_pass "rm -rv MultiVersions/" "成功清理多版本語言資料夾" "在清理多版本語言資料夾時發生錯誤"
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
