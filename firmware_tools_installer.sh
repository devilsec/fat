#!/bin/bash

#############################################
# This script is only for systems that are:
# 1) DEBIAN BASED
# 2) USE GCC 10 BY DEFAULT
# 3) HAVE BASH
#############################################

# Description:	install FAT and binwalk
# Author:		Sadeli
# Date:			January 2021

# password is needed to configure fat.config
read -s -p "Enter sudo password:" password

# update
sudo apt update

# make sure basic tools are installed
sudo apt install git curl unzip python python3 python3-pip -y
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python get-pip.py
rm get-pip.py

# Install dependencies for firmware-analysis-toolkit
sudo apt install python3-magic python3-distutils gcc-8-base libmagic1 -y
python -m pip install python-magic

# install dependencies for sasquatch
sudo apt install python-dev zlib1g-dev liblzma-dev liblzo2-dev -y
python -m pip install backports.lzma
python3 -m pip install backports.lzma

# install dependencies for fermadyne
sudo apt install busybox-static fakeroot dmsetup kpartx netcat-openbsd nmap python3-psycopg2 snmp uml-utilities util-linux vlan -y

# install qemu as a dependency for fermadyne
sudo apt install qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils -y

# clone fat
git clone --recursive https://github.com/attify/firmware-analysis-toolkit.git

# install sasquatch
cd firmware-analysis-toolkit
git clone https://github.com/devttys0/sasquatch.git
cd sasquatch
CFLAGS=-fcommon ./build.sh
cd ..

# install binwalk and its dependencies
git clone https://github.com/ReFirmLabs/binwalk.git
cd binwalk
sudo python setup.py install
sudo python3 setup.py install
sudo ./deps.sh --yes

# install fermadyne
cd ..
git clone --recursive https://github.com/firmadyne/firmadyne.git
cd firmadyne
sudo ./setup.sh
sudo ./download.sh

# configure firmadyne
sudo sed -i "s|\#FIRMWARE_DIR=\/home\/vagrant\/firmadyne\/|FIRMWARE_DIR=$PWD\/|g" firmadyne.config

# configure firmware-analysis-toolkit
cd ..
echo "[DEFAULT]" > fat.config
echo "sudo_password=$password" >> fat.config
echo "firmadyne_path=$PWD/firmadyne" >> fat.config
