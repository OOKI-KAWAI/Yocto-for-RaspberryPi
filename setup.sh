#! /bin/bash

HOMEDIR=`pwd`
REPODIR=$HOMEDIR/work
BRANCH=kirkstone

# 作業用ディレクトリのオーナーが "yocto" でない場合、変更
OWNER=yocto
USER=` ls -ld $REPODIR | awk '{ print $3 }'`
if [[ "$USE" != "$OWNER" ]]; then
    sudo chown $OWNER:$OWNER $REPODIR
fi

# リファレンスディストリビューションの "poky" をクローン
cd $REPODIR
if [ ! -d poky ]; then
    git clone git://git.yoctoproject.org/poky || exit 1
fi

# LTSの "kirkstone(4.0.7)" で checkout
# リリースバージョンは下記で確認
# https://wiki.yoctoproject.org/wiki/Releases
cd $REPODIR/poky
NOWBRANCH=` git branch --contains | awk '{ print $2}'`
if [[ "$NOWBRANCH" != "$BRANCH" ]]; then
    git checkout -b $BRANCH refs/tags/kirkstone-4.0.7
fi

# OpenEmbedded Layer Index からラズパイ用BSPレイヤーをクローン
# レイヤーについては下記を確認
# https://layers.openembedded.org/layerindex/branch/master/layers/
if [ ! -d meta-raspberrypi ]; then
    git clone git://git.yoctoproject.org/meta-raspberrypi || exit 1
fi
# poky に合わせて "kirkstone" で checkout
cd $REPODIR/poky/meta-raspberrypi
NOWBRANCH=` git branch --contains | awk '{ print $2}'`
if [[ "$NOWBRANCH" != "$BRANCH" ]]; then
    git checkout -b $BRANCH origin/kirkstone
fi

# ラズパイ用レイヤーを追加
cd $REPODIR/poky
source oe-init-build-env rpi-build
bitbake-layers add-layer ../meta-raspberrypi/

# READMEを確認して依存レイヤーを追加
cd $REPODIR/poky
if [ ! -d meta-openembedded ]; then
    git clone git://git.openembedded.org/meta-openembedded || exit 1
fi
# poky に合わせて "kirkstone" で checkout
cd $REPODIR/poky/meta-openembedded
NOWBRANCH=` git branch --contains | awk '{ print $2}'`
if [[ "$NOWBRANCH" != "$BRANCH" ]]; then
    git checkout -b $BRANCH origin/kirkstone
fi

# add-layer する順番に注意
cd $REPODIR/poky/rpi-build
bitbake-layers add-layer ../meta-openembedded/meta-oe/
bitbake-layers add-layer ../meta-openembedded/meta-python/
bitbake-layers add-layer ../meta-openembedded/meta-multimedia/
bitbake-layers add-layer ../meta-openembedded/meta-networking/

# 下記を参照して指定するマシン名を追加する
# https://layers.openembedded.org/layerindex/branch/master/layer/meta-raspberrypi/
CONFPATH=$REPODIR/poky/rpi-build/conf/local.conf
NOW=` head -n 1 $CONFPATH | awk '{ print $1}'`
if [[ "$NOW" != "MACHINE" ]]; then
    sed -i '1iMACHINE \?= \"raspberrypi4-64\"\n' $CONFPATH
fi

# Yocto-for-RaspberryPi | MIT License | https://github.com/OOKI-KAWAI/Yocto-for-RaspberryPi/blob/main/LICENSE