#!/bin/bash

_play_sh_completion() {
    lookup="$HOME/.ytc/lookup.txt"
    [ ! -e "$lookup" ] && return
    ./play.sh-completion-helper.c "${COMP_WORDS[@]}"
}

complete -F _play_sh_completion play.sh
