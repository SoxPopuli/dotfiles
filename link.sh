#!/bin/bash

if [ $# -eq 0 ] 
then
    find . -maxdepth 1 -type d -not -path '.' -not -path './.git' | parallel $0
else
    ln -shv "${1}" "${HOME}/.config/${1}"
fi
