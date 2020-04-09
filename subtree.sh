#!/bin/bash

cd $(git rev-parse --show-toplevel)

git subtree pull --squash\
    --prefix .vim/bundle/Vundle.vim\
    https://github.com/VundleVim/Vundle.vim\
    master
