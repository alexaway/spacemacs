#!/bin/sh

apt-get install unity-tweak-tool conky-all git clang

add-apt-repository ppa:noobslab/themes
apt-get update
apt-get install flatabulous-theme

add-apt-repository ppa:noobslab/icons
apt-get update
apt-get install ultra-flat-icons

apt-get install zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
chsh -s /bin/zsh

add-apt-repository ppa:ubuntu-elisp/ppa
apt-get update
apt-get install emacs-snapshot
