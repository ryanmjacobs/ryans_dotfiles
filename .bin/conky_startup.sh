#!/bin/bash
################################################################################
# conky_startup.sh
#
# Starts up Conky, preconfigured for a 1400x900 display.
#
# Maintained By: Ryan Jacobs <ryan.mjacobs@gmail.com?
#  Last Updated: March 18, 2014
################################################################################

killall conky

cd "$HOME/.conky/System_Rings"
conky -c "$HOME/.conky/System_Rings/config/system_rings" &

cd "$HOME/.conky/CPUPanel"
conky -c "$HOME/.conky/CPUPanel/config/CPUPanel - 4 Core CPU" &

cd "$HOME/.conky/Digital_Clock"
conky -c "$HOME/.conky/Digital_Clock/config/digital_clock" &
