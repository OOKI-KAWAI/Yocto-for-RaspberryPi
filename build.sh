#!/bin/bash

# スタックサイズを無制限にする(コンパイラのセグメンテーションエラー回避のため)
ulimit -s unlimited

cd ~/work/poky/
# ビルド環境設定
source oe-init-build-env rpi-build
# ビルド実行
bitbake core-image-base