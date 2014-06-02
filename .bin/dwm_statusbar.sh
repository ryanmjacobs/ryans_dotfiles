#!/bin/bash
################################################################################
# dwm_statusbar.sh
#
# Script to generate the statusbar for dwm.
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
# May 13, 2014 -> Initial creation.
# May 28, 2014 -> Fixed bug that when the battery couldn't be readm it crashed.
################################################################################

# Global Constants
WIFI_DEVICE=wlp2s0
REFRESH_DELAY=1

while true; do
    # System Uptime
    DWM_UPTIME=$(simple_uptime) # Custom C binary to give correct uptime by Ryan

    # Power/Battery Status
    if [ "$(cat /sys/class/power_supply/AC0/online)" == 1 ]; then
        DWM_BATTERY="AC"
    elif [ "$(cat /sys/class/power_supply/BAT0/energy_now)" -gt "0" ]; then
        DWM_BATTERY=$((`cat /sys/class/power_supply/BAT0/energy_now` * 100 /\
                       `cat /sys/class/power_supply/BAT0/energy_full`))
    else
        DWM_BATTERY="NULL"
    fi

    # Wi-Fi eSSID
    cat /proc/net/route | grep $WIFI_DEVICE &>/dev/null
    IS_DEVICE_UP=$?
    if [ "$IS_DEVICE_UP" -eq "0" ]; then
        DWM_WIFI_ESSID=$(/sbin/iwgetid -r)
        DWM_WIFI_STRENGTH=$(awk 'NR==3 {print $3"%"}''' /proc/net/wireless |\
                            tr -d '.')
    else
        DWM_WIFI_ESSID="OFF"
    fi

    # Volume Level
    DWM_VOL=$(amixer -c0 sget Master | awk -vORS=' ' '/Mono:/ {print($6$4)}')

    # Date and Time
    DWM_CLOCK=$(date '+%a %b %d, %Y | %r')

    # Overall output command
    DWM_STATUS="\
Uptime: [$DWM_UPTIME] | WiFi: $DWM_WIFI_ESSID [$DWM_WIFI_STRENGTH] | \
Power: [$DWM_BATTERY%] | Vol: $DWM_VOL -- $DWM_CLOCK"

    xsetroot -name "$DWM_STATUS"
    sleep $REFRESH_DELAY
done
