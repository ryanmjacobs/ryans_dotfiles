#!/bin/bash
# ... because I like to store random files with urls in them to read later...

for f in ~/*; do
    # skip directories
    [ -d "$f" ] && continue

    # skip big files
    bytes="$(stat --printf="%s" "$f")"
    [ "$bytes" -gt 16384 ] && continue

    grep -q 'http' "$f" && echo "$f"
done
