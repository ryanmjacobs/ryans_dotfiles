#!/bin/bash

awk '{ print strftime("%s: "), $0; fflush(); }'\
  | tee -a "$(date +%s).log"
