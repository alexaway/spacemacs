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
   git clone git@github.com:alexaway/spacemacs.git .emacs.d
fi

cp ~/.emacs.d/.spacemacs ~/.spacemacs

cd ~/.emacs.d
git remote add alexaway git@github.com:alexaway/spacemacs.git

#尼玛crontab后面的那个-什么意思啊
(crontab -l 2>/dev/null; echo "0 * * * * /home/alexaway/.emacs.d/private/alexaway/syn.sh") | crontab -