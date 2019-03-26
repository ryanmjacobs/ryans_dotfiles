#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

_play_sh_completion() {
    [ ! -e "$HOME/.ytc/lookup.txt" ] && return

    while read valid_term; do
        COMPREPLY+=("$valid_term")
    done < <("$DIR/play.sh-completion-helper.c" "${COMP_WORDS[@]}")
}

complete -F _play_sh_completion play.sh
