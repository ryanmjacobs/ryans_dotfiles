#!/bin/bash

if [ $# -ne 1 ]; then
    >&2 echo "usage: $(basename $0) <dump_level>"
    exit 1
fi
level="$1"

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

label="$HOSTNAME.l${level}.$(date +%Y%m%d).xfsdump"
time xfsdump -p10 -l $level -L "$label" -f "$label" -M "$media" "$device"
