#!/bin/bash

cat\
  | awk '{ print strftime("%s: "), $0; fflush(); }'\
  | tee log
