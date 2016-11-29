#!/bin/sh

cd ~/.emacs.d/private/alexaway/
ssh-add 1>/dev/null 2>&1

rm -rf *.gpg
for data in $(ls | grep '[^README]'.org$)
do
    rm -rf "$data".bak
    <passwd | gpg -c --passphrase-fd 0 "$data"
    mv "$data" "$data".bak
done


git pull alexaway
if [ "$(git ls-files -m)" = "" ]
then
    echo "do nothing"
else    
    git add .
    git commit -m "$(date)"
    git push -u alexaway
fi

for data in $(ls | grep '[^README]'.gpg$)
do
    <passwd | gpg --passphrase-fd 0 "$data"
done

