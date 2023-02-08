#!/bin/bash

# Error function
error_func () {
  error_message=${1:-❗ 錯誤！模式或參數錯誤。}
  echo "::error ::$error_message" >&2
  exit 128
}

# Status function
status_echoer () {
  status=$1
  message=$2
  no_exit=${3:-false}

  if [ "$status" = true ]; then
    echo "✅ $message"
  elif [ "$status" = false ]; then
    echo "::error ::❎ $message" >&2
    if [ "$no_exit" = false ]; then 
      :
    elif [ "$no_exit" = true ]; then
      exit 1
    else
      error_func "無效的狀態碼：$no_exit"
    fi
  else
    error_func "無效的狀態碼：$status"
  fi
}

# Command executer function
command_excuter () {
  command=$1
  message_success=${2:-指令執行成功}
  message_fail=${3:-指令執行失敗}
  no_exit=${4:-false}

  if [ -z "$command" ]; then
    error_func "缺少指令參數"
  fi

  if eval "$command"; then
    status_echoer true "$message_success"
  else
    status_echoer false "$message_fail" "$no_exit"
  fi
}
