#!/bin/sh

cd ~/.emacs.d/private/alexaway/
if [ -n $(git ls-files -m) ]
then
    git pull alexaway/master
    git add .
    git commit -m "$(date)"
    git push alexaway/master
fi
