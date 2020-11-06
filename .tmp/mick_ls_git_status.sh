#!/bin/bash -x

DEBUG=false
MAX_AGE=900
real_ls_path="$(which ls)"

RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[0;33m'
CLR='\033[0m'

real_ls() {
    $DEBUG && >&2 echo
    "$real_ls_path" --color=auto --quoting-style=literal "$@"
    return $?
}

log() {
    $DEBUG && >&2 echo "$@"
}

function ls() {
    # quit early if git is not reachable
    &>/dev/null hash git || { real_ls "$@"; return $?; }

    # quit early if we are not in a git repo
    &>/dev/null git rev-parse || { real_ls "$@"; return $?; }

    branch="$(git branch --show-current)"
    tracking="$(git rev-parse --abbrev-ref --symbolic-full-name @{u})"
    top_level="$(git rev-parse --show-toplevel)"
    last_fetch="$(stat -c %Y "$top_level"/.git/FETCH_HEAD)"
    fetch_age="$(expr $(date +%s) - $last_fetch)"
    commit_lag="$(($(git rev-list --count $branch..$tracking)))"
    commit_lead="$(($(git rev-list --count $tracking..$branch)))"
    log "branch      : $branch"
    log "tracking    : $tracking"
    log "top_level   : $top_level"
    log "last_fetch  : $last_fetch unix_time"
    log "fetch_age   : $fetch_age seconds"
    log "commit_lag  : $commit_lag commit(s) behind $tracking"
    log "commit_lead : $commit_lead commit(s) ahead of $tracking"

    # if the last fetch was over $MAX_AGE seconds ago, do a git `remote update`
    if [ "$fetch_age" -gt $MAX_AGE ]; then
        git remote update --prune &>/dev/null
    fi

    # determine plurality for the word "commit" down below
    plural=
    (($commit_lag  >= 2)) && plural=s
    (($commit_lead >= 2)) && plural=s

    if [ "$commit_lag" -gt 0 ]; then
        $DEBUG && >&2 echo
        >&2 echo -e "NOTICE: ${YEL}You are ${RED}$commit_lag commit$plural${YEL} behind $tracking.${CLR}"
    elif [ "$commit_lead" -gt 0 ]; then
        $DEBUG && >&2 echo
        >&2 echo -e "NOTICE: ${YEL}You are ${GRN}$commit_lead commit$plural${YEL} ahead of $tracking.${CLR}"
    fi

    real_ls "$@"; return $?
}
