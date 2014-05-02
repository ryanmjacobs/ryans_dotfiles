#!/bin/bash
################################################################################
# brightness.sh
#
# Brightness control for Lenovo v570 Arch Linux install.
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com>
#  Last Updated: March 20, 2014
################################################################################

if [ $(id -u) -ne 0 ]; then
    printf "Not running as root.\n"
    exit 1
fi

if [ $# != 2 ]; then
    printf "Brightness control for Lenovo v570 Arch Linux install.\n"
    printf "Usage: %s <set|inc|dec> <percentage>\n" $FUNCNAME
    exit 1
fi

PERCENTAGE=$(echo $2*0.01 | bc)
BRIGHTNESS_FILE='/sys/class/backlight/intel_backlight/brightness'
MAX_BRIGHTNESS_FILE='/sys/class/backlight/intel_backlight/max_brightness'
MAX_BRIGHTNESS=$(cat $MAX_BRIGHTNESS_FILE)
CURRENT_BRIGHTNESS=$(cat $BRIGHTNESS_FILE)

# BASH Round Function
# Arg 1: Number to round
# Arg 2: Decimal places to round to
########################################
function round() {
    if [ $2 -gt 64 ]; then
        echo $(printf %.64f $(echo "scale=64;(((10^64)*$1)+0.5)/(10^64)" | bc))
    else
        echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
    fi
}

if [ $1 == 'set' ]; then
    SET=$(round $(echo $MAX_BRIGHTNESS*$PERCENTAGE | bc) 0)
    NEW_VALUE=$SET
elif [ $1 == 'inc' ]; then
    INC=$(round $(echo $MAX_BRIGHTNESS*$PERCENTAGE | bc) 0)
    NEW_VALUE=$(echo $CURRENT_BRIGHTNESS+$INC | bc)
elif [ $1 == 'dec' ]; then
    DEC=$(round $(echo $MAX_BRIGHTNESS*$PERCENTAGE | bc) 0)
    NEW_VALUE=$(echo $CURRENT_BRIGHTNESS-$DEC | bc)
else
    printf "Brightness control for Lenovo v570 Arch Linux install.\n"
    printf "Usage: %s <inc|dec> <percentage>\n" $FUNCNAME
    exit 1
fi

if [ $NEW_VALUE -gt $MAX_BRIGHTNESS ]; then
    NEW_VALUE=$MAX_BRIGHTNESS
elif [ $NEW_VALUE -lt 0 ]; then
    NEW_VALUE=0
fi

echo $NEW_VALUE | tee $BRIGHTNESS_FILE &>/dev/null
