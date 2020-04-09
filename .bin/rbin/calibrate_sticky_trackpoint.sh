#!/bin/bash

prefix="/sys/devices/rmi4-00/rmi4-00.fn03/serio2"

# check root...
# check if paths exist...

echo 2   > "$prefix"/drift_time
echo 120 > "$prefix"/sensitivity
echo 180 > "$prefix"/speed
