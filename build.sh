#!/bin/bash

# スタックサイズを無制限にする(コンパイラのセグメンテーションエラー回避のため)
ulimit -s unlimited

cd ~/work/poky/
# ビルド環境設定
source oe-init-build-env rpi-build
# ビルド実行
WAIT_TIME=5
COMMAND_STATUS=1
while [ $COMMAND_STATUS -ne 0 ]; do
  bitbake core-image-base
  COMMAND_STATUS=$?
  sleep $WAIT_TIME
done

# Yocto-for-RaspberryPi | MIT License | https://github.com/OOKI-KAWAI/Yocto-for-RaspberryPi/blob/main/LICENSE