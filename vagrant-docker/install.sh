#!/bin/bash

# exit immediately if something fails
set -e

# freshen up aptitude
sudo apt-get update -y -qq > /dev/null
sudo apt-get upgrade -y -qq > /dev/null

# install stuff to help install stuff
sudo apt-get -y -q install git unzip

# configure passwordless sudo
usermod -a -G admin vagrant
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

# fail asap if sed blew it
sudo date

# Installing Docker, bash script via https://docs.docker.com/installation/ubuntulinux/
[ -e /usr/lib/apt/methods/https ] || {
  apt-get install apt-transport-https
}
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install lxc-docker

# download the packer binary
wget -q -O ~/packer.zip https://dl.bintray.com/mitchellh/packer/packer_0.7.5_linux_amd64.zip

# unzip to the 'packer' directory in homedir and cleanup .zip
unzip ~/packer.zip -d ~/packer
rm ~/packer.zip
