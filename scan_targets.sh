#!/bin/bash

station_pattern="$1"

target_dir="/tmp/GenTargets/Targets"

rls_stations=()
while read -r line; do
    read id endline <<<"$line"
    if [[ "${id}" != "$station_pattern" ]]; then
        continue
    fi
    rls_stations+=("${line}")
    read 
done < <( ./list_rls_stations.sh )

declare -A founded_targets

scan_targets()
{
    while read target_id target_x target_y; do
        for station in "${rls_stations[@]}"; do
            station_params=(${station})
            station_id=${station_params[0]}
            station_x=${station_params[1]}
            station_y=${station_params[2]}
            station_alpha=${station_params[3]}
            station_gamma=${station_params[4]}
            station_r=${station_params[5]}
            is_in_fov=$(echo "is_in_station_fov(${target_x}, ${target_y}, ${station_x}, ${station_y}, ${station_alpha}, ${station_gamma}, ${station_r});" | bc -l math.bc)
            if [[ "${is_in_fov}" == "1" ]]; then
                #echo ${station_id}:${target_id}:${1} ${target_x} ${target_y}
                key="${station_id}:${target_id}:${1}"
                value="${target_x}:${target_y}"
                founded_targets[${key}]=${value}
            fi
        done
    done < <( ./get_last_update.sh )
}

get_speed() {
    speed=$(( $1 - $2 ))
    if (( speed < 0 )); then
        speed=$(( -speed ))
    fi
    echo $speed
}

iteration=0
while ((++iteration)); do
    # scan all targets 
    # founded targets are saved in 
    scan_targets ${iteration}

    echo ${iteration}
    echo 'ALERT!!'

    if ((iteration <= 2)); then
        continue
    fi

    old_iteration=$(( iteration - 2 ))
    for key in "${!founded_targets[@]}"; do
        IFS=':' read station_id target_id i <<<${key}
        if (( i <= old_iteration )); then
            unset founded_targets[${key}]
        fi
    done

    declare -A station_target_map
    for key in "${!founded_targets[@]}"; do
        IFS=':' read station_id target_id i <<<${key}
        IFS=':' read target_x target_y <<<${founded_targets[${key}]}
        station_target=${station_id}:${target_id}
        coords=${station_target_map[${station_target}]}
        coords=${coords}${coords:+:}${target_x}:${target_y}
        station_target_map[${station_target}]=${coords}
    done

    for key in "${!station_target_map[@]}"; do
        IFS=':' read station_id target_id <<<${key}
        IFS=':' read x0 y0 x1 y1 <<<${station_target_map[${key}]}
        if [[ ${x1} == "" ]]; then
            continue
        fi
        speed=$(get_speed $x0 $x1)
        if (( speed == 0 )); then
            continue
        fi

        target_type='block'
        if (( speed < 249 )); then
            target_type='plane'
        elif (( speed < 1000 )); then
            target_type='rocket'
        fi

        echo $station_id $target_id $speed $target_type

    done
    unset station_target_map 
done
