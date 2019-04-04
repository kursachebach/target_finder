#!/bin/bash

target_dir="/tmp/GenTargets/Targets"

rls_stations=()
while read -r line; do
    rls_stations+=("${line}")
done < <( ./list_rls_stations.sh )

while true; do
while read target_id target_x target_y; do
    for station in "${rls_stations[@]}"; do
        station_params=(${station})
        station_x=${station_params[1]}
        station_y=${station_params[2]}
        station_alpha=${station_params[3]}
        station_gamma=${station_params[4]}
        station_r=${station_params[5]}
        is_in_fov=$(echo "is_in_station_fov(${target_x}, ${target_y}, ${station_x}, ${station_y}, ${station_alpha}, ${station_gamma}, ${station_r});" | bc -l is_in_sector.bc)
        if [[ "${is_in_fov}" == "1" ]]; then
            echo scan ${target_id} ${station_params[0]} ${station_x} ${station_y} ${target_x} ${target_y}
        fi
    done
done < <( ./get_last_update.sh )
done
