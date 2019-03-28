#!/bin/bash
# Выводит параметры всех рлс в формате:
# rls_id x y alpha sweep radius

rls_stations_file="rls_stations.txt"
rls_characteristics_file="rls_characteristics.txt"
city_coordinates_file="city_coordinates.txt"

declare -A rls_characteristics
while read station_name station_x station_y; do
    if [[ ${station_name} == "#"* ]]; then
        continue
    fi
    rls_characteristics[${station_name}]="${station_x} ${station_y}"
done < "${rls_characteristics_file}"

declare -A city_coordinates
while read city_name city_x city_y; do
    if [[ ${city_name} == "#"* ]]; then 
        continue
    fi 
    city_coordinates[${city_name}]="${city_x} ${city_y}"
done < "${city_coordinates_file}"

while read station_id place alpha station_name; do
    if [[ ${station_id} == "#"* ]]; then
        continue
    fi
    if [[ ${place} == "x="* ]]; then
        x=${place%,y=*}
        x=${x:2}
        y=${place#*y=}
    else
        coordinates=(${city_coordinates[${place}]})
        x=${coordinates[0]}
        y=${coordinates[1]}
    fi
    if [[ ${station_name} == "r="* ]]; then
        radius=${station_name#r=}
        sweep=360
    else
        characteristics=(${rls_characteristics[${station_name}]})
        sweep=${characteristics[0]}
        radius=${characteristics[1]}
    fi
    echo ${station_id} ${x} ${y} ${alpha} ${sweep} ${radius}
done < "${rls_stations_file}"
