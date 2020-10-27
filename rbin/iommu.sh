#!/bin/bash

prev_group=

for d in /sys/kernel/iommu_groups/*/devices/*; do
    n=${d#*/iommu_groups/*}
    group=${n%%/*}
    name="$(lspci -nns "${d##*/}")"

    if [ "$group" != "$prev_group" ]; then
        echo "----"
        prev_group="$group"
    fi
    echo "IOMMU GROUP $group // $name"
done
