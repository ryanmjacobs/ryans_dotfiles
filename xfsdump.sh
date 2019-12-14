#!/bin/bash

if [ "$HOSTNAME" != "mu2" ]; then
    >&2 echo "error: host not supported"
    exit 1
fi

label="$(hostname).l1.$(date +%Y%m%d).xfsdump"
media="ryans thinkpad x250 internal 500 gb ssd samsung evo"
time xfsdump -p10 -l1 -L "$label" -f "$label" -M "$media" /dev/sda1
