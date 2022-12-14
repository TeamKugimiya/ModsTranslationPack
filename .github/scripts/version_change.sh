#!/bin/bash

cd "$GITHUB_WORKSPACE" || exit

module_mode=$1
version=$2

case $module_mode in
  "1")
    sed -i "s/GitVersion/git ${GITHUB_SHA::7}/1" pack.mcmeta
    echo "Add git version"
    ;;
  "2")
    sed -i "s/6GitVersion/b$2/1" pack.mcmeta
    echo "Add release tag version"
    ;;
  "3")
    if [ "$version" = "1.18.x" ];then 
      sed -i 's/9/8/1' pack.mcmeta
      echo "Change to 1.18.x format"
    elif [ "$version" = "1.19.x" ];then
      echo "1.19.x, no change format"
    else
      echo "Error, no value found..."
      exit 1
    fi
    ;;
  *)
    echo "Error, no value found..."
    exit 128
    ;;
esac
