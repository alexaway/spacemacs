#!/bin/sh

cd ~/.emacs.d/private/alexaway/
ssh-add 1>/dev/null 2>&1


git pull alexaway
if [ "$(git ls-files -m)" = "" || "$(git diff --cached --name-only --diff-filter=A)" = "" ]
then
    echo "do nothing"
else    
    git add .
    git commit -m "$(date)"
    git push -u alexaway
fi
