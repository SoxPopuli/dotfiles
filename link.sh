#!/bin/bash

if [ $# -eq 0 ] 
then
    find . -maxdepth 1 -type d -not -path '.' -not -path './.git' | parallel $0
else
    # get full path
    src=$(readlink -f ${1})
    
    # remove ./ from path
    dst=$(echo "${HOME}/.config/${1}" | awk '{sub("/./", "/")}1')
    ln -shv "${src}" "${dst}"
fi
