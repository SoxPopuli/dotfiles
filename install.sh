#!/usr/bin/env bash

git submodule init
git submodule sync
git submodule update

just -f "./tools/tmux-sessionizer/justfile" install clean-release
