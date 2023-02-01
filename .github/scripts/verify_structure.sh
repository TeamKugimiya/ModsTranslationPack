#!/bin/bash

[ -z "$1" ] && echo "No Input!" && exit 1

array_list=("$1"/*)
remove_path_name="$1"
matrix_workflow_name="$2"

array_missing_mods=()
fail_status=false

for path in "${array_list[@]}"; do
  if [ -f "$path/lang/en_us.json" ] && [ -f "$path/lang/zh_tw.json" ]; then
    # shellcheck disable=SC2001
    name=$(echo "$path" | sed "s+$remove_path_name/++")
    echo "$name 模組語言驗證成功！"
  else
    # shellcheck disable=SC2001
    name=$(echo "$path" | sed "s+$remove_path_name/++")
    echo "::error ::❎ 錯誤！$name 模組並未包含原始或翻譯語言檔。"
    array_missing_mods+=("$name")
  fi
done

if [ "${#array_missing_mods[@]}" -gt 0 ]; then
  echo "⚠️ 缺少原始或模組語言檔的清單（$matrix_workflow_name）：" >> "$GITHUB_STEP_SUMMARY"
  echo "" >> "$GITHUB_STEP_SUMMARY"
  fail_status=true
  for missing in "${array_missing_mods[@]}"; do   
    echo "- $missing" >> "$GITHUB_STEP_SUMMARY"
  done
  echo "" >> "$GITHUB_STEP_SUMMARY"
fi

if [ $fail_status = true ]; then
  exit 1
fi
