#!/bin/bash

# neat looping utilities
# examples:
#   $ 2x echo hello  $ x2 echo hello  $ x3 echo -n world
#   hello            hello            world world world
#   hello            hello

xx() { while true; do "$@"; done }
for n in {2..20}; do
    eval "${n}x() { for n in `seq -s' ' $n`; do" '$@; done }'
    eval "x${n}() { for n in `seq -s' ' $n`; do" '$@; done }'
done
