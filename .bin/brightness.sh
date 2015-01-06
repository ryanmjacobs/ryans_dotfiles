#!/bin/bash
################################################################################
# brightness.sh
#
# Brightness control for Lenovo v570 Arch Linux install.
# Author: Ryan Jacobs <ryan.mjacobs@gmail.com>
#
# March 20, 2014 -> Creation date.
#   May 05, 2014 -> Added get command.
#  July 08, 2014 -> Remove unnecessary usage of tee.
#   Jan 06, 2014 -> Replace $FUNCNAME w/ $0.
################################################################################

function help_msg() {
    printf "Brightness control for Lenovo v570 Arch Linux install.\n"
    printf "Usage: %s <set|inc|dec> <percentage>\n" $0
    printf "                 OR                 \n"
    printf "       %s <get>\n" $0
    exit 1
}


if [ $(id -u) -ne 0 ]; then
    printf "please run as root.\n"
    exit 1
fi

if [ $# -lt 1 ]; then
    help_msg
fi

if   [ $1 == 'set' ] && [ $# -ne 2 ]; then
    help_msg
elif [ $1 == 'inc' ] && [ $# -ne 2 ]; then
    help_msg
elif [ $1 == 'dec' ] && [ $# -ne 2 ]; then
    help_msg
elif [ $1 == 'get' ] && [ $# -ne 1 ]; then
    help_msg
fi

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

### Mainline ###
BRIGHTNESS_FILE='/sys/class/backlight/intel_backlight/brightness'
MAX_BRIGHTNESS_FILE='/sys/class/backlight/intel_backlight/max_brightness'
MAX_BRIGHTNESS=$(cat $MAX_BRIGHTNESS_FILE)
CURRENT_BRIGHTNESS=$(cat $BRIGHTNESS_FILE)
if   [ $1 == 'set' ]; then
    PERCENTAGE=$(echo $2*0.01 | bc)
    SET=$(round $(echo $MAX_BRIGHTNESS*$PERCENTAGE | bc) 0)
    NEW_VALUE=$SET
elif [ $1 == 'inc' ]; then
    PERCENTAGE=$(echo $2*0.01 | bc)
    INC=$(round $(echo $MAX_BRIGHTNESS*$PERCENTAGE | bc) 0)
    NEW_VALUE=$(echo $CURRENT_BRIGHTNESS+$INC | bc)
elif [ $1 == 'dec' ]; then
    PERCENTAGE=$(echo $2*0.01 | bc)
    DEC=$(round $(echo $MAX_BRIGHTNESS*$PERCENTAGE | bc) 0)
    NEW_VALUE=$(echo $CURRENT_BRIGHTNESS-$DEC | bc)
elif [ $1 == 'get' ]; then
    printf "Current Brightness: %s\n" $(round $(echo "scale=2;$CURRENT_BRIGHTNESS*100/$MAX_BRIGHTNESS" | bc) 0)
    exit 0
else
    help_msg
fi

if [ $NEW_VALUE -gt $MAX_BRIGHTNESS ]; then
    NEW_VALUE=$MAX_BRIGHTNESS
elif [ $NEW_VALUE -lt 0 ]; then
    NEW_VALUE=0
fi

echo $NEW_VALUE > $BRIGHTNESS_FILE
