#!/bin/bash

#targets_path=${1}
targets_path=/tmp/GenTargets/Targets/
max_target_count=${2:-30}

split_filename () {
    local IFS='.'
    echo ${1}
}

# List all files in diretory sorted by date. One filename by line
#ls -t1 $1
declare -A targets
target_count=0
for filename in $(ls -t1 "${targets_path}"); do
    filename_separated=$(split_filename ${filename})
    fileparts=(${filename_separated})
    target_id=${fileparts[2]}
    if [[ -z "${targets[${target_id}]}" ]]; then
        targets[${target_id}]=${filename}
        target_count=$(($target_count + 1))
        if  [[ $(( $target_count - $max_target_count )) == 0 ]]; then
            break
       fi
    fi
done

for target_id in "${!targets[@]}"; do
    echo ${target_id} $(cat "${targets_path}/${targets[${target_id}]}")
done
