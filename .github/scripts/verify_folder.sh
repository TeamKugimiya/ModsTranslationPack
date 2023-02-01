#!/bin/bash

# Array assets folder

list=(assets/*)

# Check langauge have original langauge file & trnalsate

for i in "${list[@]}"; do
  if [ -f "$i/lang/en_us.json" ] && [ -f "$i/lang/zh_tw.json" ]; then
    # shellcheck disable=SC2001
    name=$(echo "$i" | sed 's+assets/++')
    json-diff -k "$i/lang/en_us.json" "$i/lang/zh_tw.json"
    echo "$name 模組語言驗證成功！"
  else
    # shellcheck disable=SC2001
    name=$(echo "$i" | sed 's+assets/++')
    echo "::error ::❎ 錯誤！$name 模組並未包含原始或翻譯語言檔。"
    # exit 1
  fi
done
