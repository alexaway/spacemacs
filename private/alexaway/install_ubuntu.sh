#!/bin/sh

<<<<<<< HEAD
apt-get install unity-tweak-tool conky-all git clang build-essential cmake python-dev global
=======
apt-get --assume-yes install unity-tweak-tool conky-all git clang build-essential cmake python-dev
>>>>>>> def25a7eb3c5bb1e0befd8550e4cc3e44baa48de

add-apt-repository ppa:noobslab/themes
apt-get update
apt-get --assume-yes install flatabulous-theme

add-apt-repository ppa:noobslab/icons
apt-get update
apt-get install ultra-flat-icons

apt-get --assume-yes install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
chsh -s /bin/zsh

add-apt-repository ppa:ubuntu-elisp/ppa
apt-get update
apt-get --assume-yes install emacs-snapshot
