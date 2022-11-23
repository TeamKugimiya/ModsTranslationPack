#!/bin/bash

cd "$GITHUB_WORKSPACE" || exit

if [ "$1" = "1" ];then
  sed -i "s/GitVersion/git ${GITHUB_SHA::7}/1" pack.mcmeta
  echo "Add git version"
elif [ "$1" = "2" ];then
  sed -i "s/6GitVersion/f$2/1" pack.mcmeta
  echo "Add release tag version"
elif [ "$1" = "3" ];then
  if [ "$2" = "1.18.x" ];then 
    sed -i 's/9/8/1' pack.mcmeta
    echo "Change to 1.18.x format"
  elif [ "$2" = "1.19.x" ];then
    echo "1.19.x, no change format"
  else
    echo "Error, no value found..."
    exit 1
  fi
else
  echo "Error, no value found..."
  exit 1
fi
