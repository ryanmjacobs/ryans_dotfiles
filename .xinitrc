#!/bin/bash
################################################################################
# Personal .xinitrc file
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
# March 18, 2014 -> Original Creation.
# April 16, 2014 -> Disable terminal bell.
################################################################################

# Merge in the user .Xresources file
xrdb -merge $HOME/.Xresources

# Disable terminal bell
xset b off

# Dwm Statusbar
while true; do
    WIFI_DEVICE=wlp2s0

    # System Uptime
    DWM_UPTIME=$(uptime | awk '{print $1}')

    # Power/Battery Status
    if [ "$(cat /sys/class/power_supply/AC0/online)" -eq "1" ]; then
        DWM_BATTERY="AC"
        DWM_RENEW_INT=3
    else
        DWM_BATTERY=$((`cat /sys/class/power_supply/BAT0/energy_now` * 100 / `cat /sys/class/power_supply/BAT0/energy_full`))
        DWM_RENEW_INT=30
    fi

    # Wi-Fi eSSID
    cat /proc/net/route | grep $WIFI_DEVICE &>/dev/null
    IS_DEVICE_UP=$?
    if [ "$IS_DEVICE_UP" -eq "0" ]; then
        DWM_WIFI_ESSID=$(/sbin/iwgetid -r)
        DWM_WIFI_STRENGTH=$(awk 'NR==3 {print $3"%"}''' /proc/net/wireless | tr -d '.')
    else
        DWM_WIFI_ESSID="OFF"
    fi

    # Volume Level
    DWM_VOL=$(amixer -c0 sget Master | awk -vORS=' ' '/Mono:/ {print($6$4)}')

    # Date and Time
    DWM_CLOCK=$(date '+%a %b%e, %Y | %r')

    # Overall output command
    DWM_STATUS="Uptime: [$DWM_UPTIME] | WiFi: $DWM_WIFI_ESSID [$DWM_WIFI_STRENGTH] | Power: [$DWM_BATTERY%] | Vol: $DWM_VOL -- $DWM_CLOCK"
    xsetroot -name "$DWM_STATUS"
    sleep $DWM_REFRESH_INT
done &

# Start the DM and/or WM and/or Background
#exec cinnamon-session
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &
exec dwm
