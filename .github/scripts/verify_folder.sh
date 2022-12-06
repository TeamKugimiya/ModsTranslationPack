#!/bin/bash

find assets/* -prune -type d | while IFS= read -r d; do 
  if [ -f "$d/lang/zh_tw.json" ]; then
    name=$(echo "$d" | sed 's+assets/++' | sed 's+/lang/++')
    echo "$name 翻譯檔案驗證通過！"
  else
    name=$(echo "$d" | sed 's+assets/++' | sed 's+/lang/++')
    echo "::error ::錯誤！ $name 模組並未包含翻譯檔案"
    exit 1
  fi
done
