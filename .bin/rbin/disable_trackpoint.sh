#!/bin/bash -x

prop="$(xinput list | grep TrackPoint | cut -d= -f2 | cut -f1)"
xinput set-prop "$prop" "Device Enabled" 0
