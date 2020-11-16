#!/bin/bash

if [ $# -ne 1 ]; then
    >&2 echo "usage: $(basename "$0") <dump_level>"
    exit 1
fi
level="$1"

case "$HOSTNAME" in
    aa)
        device=/dev/sda2
        media="ryans thinkpad x250 internal ssd - 1366x768 lcd";;
    mu)
        device=/dev/sda1
        media="ryans thinkpad x240 internal ssd - newcastle server supervisor";;
    mu2)
        device=/dev/sda1
        media="ryans thinkpad x250 internal 500 gb ssd samsung evo";;
    delta)
        device=/dev/sdc1
        media="ryans thinkpad t440p home disk";;
    xi)
        device=/dev/sda1
        media="ryans thinkpad x250 with fpga root disk";;
    kk)
        device=/dev/nvme0n1p1
        media="ryans ryzen desktop kk void linux internal nvme ssd";;
    roz)
        device=/
        media="roz 2700x desktop";;
    *)
        >&2 echo "error: host not supported"
        exit 1
esac

label="$HOSTNAME.l${level}.$(date +%Y%m%d).xfsdump"
nproc="$(nproc)"
time xfsdump -p10 -l $level -L "$label" -M "$media" - "$device"\
    | pigz --verbose > "${label}.gz"
