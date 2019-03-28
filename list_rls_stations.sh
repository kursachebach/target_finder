#!/bin/bash

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
