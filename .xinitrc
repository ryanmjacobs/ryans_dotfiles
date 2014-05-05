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
    # Power/Battery Status
    if [ "$( cat /sys/class/power_supply/AC0/online )" -eq "1" ]; then
        DWM_BATTERY="AC"
        DWM_RENEW_INT=3
    else
        DWM_BATTERY=$(( `cat /sys/class/power_supply/BAT0/energy_now` * 100 / `cat /sys/class/power_supply/BAT0/energy_full` ))
        DWM_RENEW_INT=30
    fi

    # Wi-Fi eSSID
    if [ "$( cat /sys/class/net/eth1/rfkill1/state )" -eq "1" ]; then
        DWM_ESSID=$( /sbin/iwgetid -r )
    else
        DWM_ESSID="OFF"
    fi

    # Keyboard layout
    if [ "`xset -q | awk -F \" \" '/Group 2/ {print($4)}'`" = "on" ]; then
        DWM_LAYOUT="ru"
    else
        DWM_LAYOUT="en"
    fi

    # Volume Level
    DWM_VOL=$( amixer -c1 sget Master | awk -vORS=' ' '/Mono:/ {print($6$4)}' )

    # Date and Time
    DWM_CLOCK=$( date '+%e %b %Y %a | %k:%M' )

    # Overall output command
    DWM_STATUS="WiFi: [$DWM_ESSID] | Lang: [$DWM_LAYOUT] | Power: [$DWM_BATTERY] | Vol: $DWM_VOL | $DWM_CLOCK"
    xsetroot -name "$DWM_STATUS"
    sleep $DWM_REFRESH_INT
done &

# Start the DM and/or WM and/or Background
#exec cinnamon-session
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &
exec dwm
