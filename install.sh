#!/bin/env bash

git submodule init
git submodule sync

just -f "./tools/tmux-sessionizer/justfile" install
