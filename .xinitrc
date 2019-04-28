#!/bin/bash
################################################################################
# Personal .xinitrc file
#
# Author: Ryan Jacobs <ryan.mjacobs@gmail.com>
#
# March 18, 2014 -> File creation.
# April 16, 2014 -> Disable terminal bell.
################################################################################

is_triple_monitor_setup() {
    xrandr --output DP2-2 |& grep "not found" && return 1 || return 0
}

# modify X scaling based on triple monitor setup
tmpxr="$(mktemp)"
cp "$HOME/.Xresources" "$tmpxr"
is_triple_monitor_setup || grep -v Xft "$HOME/.Xresources" > "$tmpxr"
xrdb "$tmpxr"
rm "$tmpxr"

# Disable double-tap = click on touchpad
#synclient TapButton1=0 TapButton2=0 TapButton3=0

# Dwm Statusbar
dwmstatus.sh &

# Dunst Notification Daemon
dunst &

# Keep the colors pleasing
redshift &
#redshift -l 38:-121 &

# nice java windows
wmname LG3D

# start compositor
compton -CG -D 0 &

# Set the background wallpaper
#feh --bg-scale $HOME/.bin/wallpapers/Sea_Fury.jpg &
feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg &

# triple monitor setup
if is_triple_monitor_setup; then
    sleep 2

    xrandr \
        --output eDP1 --off \
        --output DP2-1 --off \
        --output DP2-2 --primary --mode 3840x2160 --pos 2880x0 --rotate normal \
        --output DP2-3 --mode 1920x1080 --pos 0x0 --rotate normal --scale 1.5x1.5
    feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg
fi &

# continuosly set bg in case resolution ever changes
while true; do
    feh --bg-scale $HOME/.bin/wallpapers/blue_lagoon.jpg
    sleep 60
done &

# Allow the Super (windows/command keys) to be used as Alt
xmodmap -e "remove mod4 = Super_L"
xmodmap -e "remove mod4 = Super_R"
xmodmap -e "add mod1 = Super_L"
xmodmap -e "add mod1 = Super_R"

# Edge-scrolling instead of two-finger
xinput set-prop 13 297 1, 1, 1 # edge-srolling
xinput set-prop 13 298 0, 0    # two-finger scrolling

# Start the WM
exec dwm
