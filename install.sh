#!/usr/bin/env bash

git submodule update --remote --recursive

just -f "./tools/tmux-sessionizer/justfile" install clean-release
