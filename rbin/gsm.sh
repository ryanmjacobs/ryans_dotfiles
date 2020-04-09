#!/bin/bash

conn="GSM connection"
retry_sec=10

if [ "$(id -u)" -ne 0 ]; then
    >&2 echo "error: must be root"
    exit 1
fi

sync() {
    # nmcli is dumb and appends these DNS servers to the existing ones
    # ... I just want to overwrite goddammit
   #nmcli connection modify "$conn" ipv4.dns 1.1.1.1
   #nmcli connection modify "$conn" ipv6.dns 2606:4700:4700::1111

    nmcli connection up "$conn"
    cat <<EOF | sudo tee /etc/resolv.conf
nameserver 1.1.1.1
nameserver 2606:4700:4700::1111
EOF
}

for n in `seq 3`; do
    sync && exit 0

    >&2 echo "error: failed to enact settings... retrying in $retry_sec seconds"
    sleep "$retry_sec"
done
