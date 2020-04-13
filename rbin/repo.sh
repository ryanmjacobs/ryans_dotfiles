#!/bin/bash

for d in *; do
    [ ! -d "$d" ] && continue
    [ ! -e "$d/.git" ] && continue
    echo "$d"
    #mv "$d" "$d.git"
    #ln -sv "$d".git "$d"
done
