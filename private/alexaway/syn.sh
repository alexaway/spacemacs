#!/bin/sh

if [ -n $(git ls-files -m) ]
then
    git pull
    git add .
    git commit -m "$(date)"
    git push
fi
