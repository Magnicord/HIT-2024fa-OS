#!/bin/sh

# Harbin Insitute of Technology
# Operating System - Setup Script
#
# $Author$: Dr. GuoJun LIU<guojunos@163.com>
# $Update$: 2020-05-20

export OSLAB_INSTALL_PATH=$PWD
cat guojunos.icon

install_dep_amd64() {
    echo "* Install dependencies for x86_64(amd64) arch now......"
    sudo apt-get -y install build-essential
    sudo apt-get -y install qemu-system-x86
    sudo apt-get -y install xorg-dev libgtk2.0-dev
    # sudo apt-get -y install bochs bochs-x bochs-sdl
    echo "* Install dependencies for x86_64(amd64) arch now......\033[34mDone\033[0m"
}

configure_for_amd64() {
    echo -n "* Copy run script to oslab......"
    cp -r amd64/* $OSLAB_INSTALL_PATH
    echo "\033[34mDone\033[0m"
}

# Common Code
if [ "$1" ] && ([ "$1" = "-s" ] || [ "$1" = "--skip-update" ]); then
    echo -n "* Begin to setup......3 sec to start"; sleep 1
    echo -n "\r* Begin to setup......2 sec to start"; sleep 1
    echo -n "\r* Begin to setup......1 sec to start"; sleep 1
    echo "\r* Begin to setup......                          "
else
    echo -n "* Update apt sources......3 sec to start"; sleep 1
    echo -n "\r* Update apt sources......2 sec to start"; sleep 1
    echo -n "\r* Update apt sources......1 sec to start"; sleep 1
    echo "\r* Update apt sources......                      "
    sudo apt-get update
fi

echo -n "* Create oslab main directory......"
[ -d $OSLAB_INSTALL_PATH ] || mkdir $OSLAB_INSTALL_PATH
echo "\033[34mDone\033[0m"

echo -n "* Create linux-0.11 directory......"
[ -d $OSLAB_INSTALL_PATH/linux-0.11 ] || mkdir $OSLAB_INSTALL_PATH/linux-0.11
echo "\033[34mDone\033[0m"

# Extract linux-0.11
echo -n "* Extract linux-0.11......"
tar zxf common/linux-0.11.tar.gz -C $OSLAB_INSTALL_PATH/linux-0.11
cp common/linux-0.11.tar.gz $OSLAB_INSTALL_PATH
echo "\033[34mDone\033[0m"

# Extract hdc image
echo -n "* Extract hdc image......"
tar zxf common/hdc.tar.gz -C $OSLAB_INSTALL_PATH/
echo "\033[34mDone\033[0m"

# Copy common files
echo -n "* Copy common files......"
cp -r common/files $OSLAB_INSTALL_PATH
cp -r common/bochs $OSLAB_INSTALL_PATH
echo "\033[034mDone\033[0m"

# for amd64
if [ `getconf LONG_BIT` = "64" ]
then
    install_dep_amd64
    configure_for_amd64
fi

echo "\033[34m* Installation finished. \033[0m"
