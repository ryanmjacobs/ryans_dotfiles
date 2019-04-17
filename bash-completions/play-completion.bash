#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

_play_completion() {
    [ ! -e "$HOME/.ytc/lookup.txt" ] && return

    while read valid_term; do
        #escaped="$(printf '%q' "$valid_term")"
        #COMPREPLY+=("$escaped")
        COMPREPLY+=("$valid_term")
    done < <("$DIR/play-completion-helper.c" "${COMP_WORDS[@]}")
}

complete -F _play_completion play
