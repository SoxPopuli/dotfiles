#!/bin/env bash

for dir in $(find . -maxdepth 1 -type d -not -path '.' -not -path './.git')
do
    ln -Tsrv "${dir}" "${HOME}/.config/${dir}"
done
