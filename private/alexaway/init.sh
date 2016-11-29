#!/bin/sh

cd ~
if [ -e .gitconfig ]
then 
    rm .gitconfig
    git config --global user.name alexaway
    git config --global user.email 1527381991@qq.com
    git config --global core.editor eamcs
    git config --global color.ui true
    git config --global push.default simple
fi

if [ -d .emacs.d ]
then
   echo "the .emacs.d directory exists!"
   mv .emacs.d .emacs.d.bak
fi
git clone git@github.com:alexaway/spacemacs.git .emacs.d

cp ~/.emacs.d/.spacemacs ~/.spacemacs

cd ~/.emacs.d
git remote add alexaway git@github.com:alexaway/spacemacs.git

#尼玛crontab后面的那个-什么意思啊
(crontab -l 2>/dev/null; echo "0 * * * * /home/alexaway/.emacs.d/private/alexaway/syn.sh") | crontab -

git clone https://github.com/Valloric/ycmd.git ~/.ycmd
cd ~/.ycmd
git submodule update --init --recursive
./build.py --all

cp ~/.emacs.d/private/alexaway/cc_args.py ~/.ycmd/

cd ~
echo "alias sye=\"source ~/.emacs.d/private/alexaway/syn.sh\""<<.zshrc
