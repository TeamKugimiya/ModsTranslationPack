#!/bin/bash

path=$1

if [ ! -z "$path" ]; then
  mv en_us.json "assets/$path/lang"
  json-diff -k "assets/$path/lang/zh_tw.json" "assets/$path/lang/en_us.json"
else
  echo "Input is empty."
fi