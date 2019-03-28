#!/bin/bash

target_dir="/tmp/GenTargets/Targets"

rls_stations=()
while read -r line; do
    rls_stations+=("${line}")
done < <( ./list_rls_stations.sh )

for i in "${rls_stations[@]}"; do
    echo $i
done

while read target_id target_x target_y; do
    echo $target_id
done < <( ./get_last_update.sh "$target_dir" )
