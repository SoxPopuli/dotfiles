#!/bin/bash

if [ $# -eq 0 ] 
then
    find . -maxdepth 1 -type d -not -path '.' -not -path './.git' | parallel $0
else
    cd "$1"
    echo "Pulling $1..."
    git pull
    cd ..
fi
