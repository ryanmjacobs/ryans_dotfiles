#!/bin/bash

_play_sh_completion() {
    lookup="$HOME/.ytc/lookup.txt"
    [ ! -e "$lookup" ] && return

    all_terms=()
    while read line; do
        term="$(echo "$line" | cut -d' ' -f2-)"
        blank="68b329da9893e34099c7d8ad5cb9c940" # md5sum of nothing
        [ "$term" == "$blank" ] && continue
        all_terms+=("$term")
    done < "$lookup"
}

complete -F _play_sh_completion play.sh
