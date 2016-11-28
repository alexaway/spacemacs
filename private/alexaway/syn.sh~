#!/bin/sh

cd ~/.emacs.d/private/alexaway/
if [ -n $(git ls-files -m) ]
then
    git pull alexaway
    git add .
    git commit -m "$(date)"
    git push alexaway
fi
