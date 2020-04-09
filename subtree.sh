#!/bin/bash

cd $(git rev-parse --show-toplevel)

for cmd in add pull; do
    git subtree "$cmd" --squash\
        --prefix .vim/bundle/Vundle.vim\
        https://github.com/VundleVim/Vundle.vim master
done
