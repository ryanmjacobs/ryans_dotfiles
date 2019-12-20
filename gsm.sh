#!/bin/bash -x

conn="GSM connection"
retry_sec=10

sync() {
    nmcli connection up "$conn"
    nmcli connection modify "$conn" ipv4.dns 1.1.1.1
    nmcli connection modify "$conn" ipv6.dns 2606:4700:4700::1111
}

for n in `seq 3`; do
    sync && exit 0

    >&2 echo "error: failed to enact settings... retrying in $retry_sec seconds"
    sleep "$retry_sec"
done
