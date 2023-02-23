#!/bin/bash

# スタックサイズを無制限にする(コンパイラのセグメンテーションエラー回避のため)
ulimit -s unlimited

cd ~/work/poky/
# ビルド環境設定
source oe-init-build-env rpi-build
# ビルド実行
bitbake core-image-base

# Yocto-for-RaspberryPi | MIT License | https://github.com/OOKI-KAWAI/Yocto-for-RaspberryPi/blob/main/LICENSE