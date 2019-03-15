#!/bin/bash

mkdir -p "$HOME/.ytc"

h="$(md5sum <<< "$*" | cut -d' ' -f1)"

_play() {
    if [ -e "$HOME/.ytc/$h"* ]; then
        mpv --vo=null "$HOME/.ytc/$h"*
        exit
    fi
}

alias silence="&>/dev/null"

prune() {
    pushd "$HOME/.ytc"

    a=""
    for b in *; do
        if [ -n "$a" ]; then
            if cmp -s "$a" "$b"; then
                rm "$b"
                ln "$a" "$b"
            fi
        fi

        a="$b"
    done

    popd
}

_play # attempt to play cached file and exit

# otherwise download
youtube-dl --default-search=auto "$*" -o "$HOME/.ytc/$h" -f bestaudio
echo "$h $*" >> "$HOME/.ytc/lookup.txt"
prune

# then play and exit
_play
