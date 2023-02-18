#!/bin/bash

commit_message=$(git log -n 1 --pretty=format:%s)
type_list="feat|fix|chore|ci|docs|refactor|mods_feat|mods_update|mods_fix|mods_improve|mods_localize|mods_remove"
regex="^($type_list)(\((.*?)\))?: (.*?)$"

if [[ "$commit_message" =~ $regex ]]; then
  echo "提交訊息「$commit_message」驗證通過！"
else
  echo "::error ::錯誤！提交訊息「$commit_message」並未遵守約定式提交格式。"
  exit 1
fi
