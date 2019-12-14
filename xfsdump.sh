#!/bin/bash

case "$HOSTNAME" in
    mu2)
        device=/dev/sda1
        media="ryans thinkpad x250 internal 500 gb ssd samsung evo";;
    delta)
        device=/dev/sdc1
        media="ryans thinkpad t440p home disk";;
    *)
        >&2 echo "error: host not supported"
        exit 1
esac

label="$HOSTNAME.l1.$(date +%Y%m%d).xfsdump"
time xfsdump -p10 -l1 -L "$label" -f "$label" -M "$media" "$device"
