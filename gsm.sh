#!/bin/bash -x

conn="GSM connection"
nmcli connection up "$conn"
nmcli connection modify "$conn" ipv4.dns 1.1.1.1
nmcli connection modify "$conn" ipv6.dns 2606:4700:4700::1111
