#!/usr/bin/env python3
import math
import sys
import argparse

def is_in_sector_angle(point_angle, sector_start, sweep):
    """
    Calculate is point with angle point_angle in sector,
    that start at angle sector_start and go in counter-clockwise
    direction to angle sector_start + sweep.
    """
    #print('Sector start:', sector_start)
    #print('Sweep:', sweep)
    #print('Angle of point:', point_angle)
    if point_angle < sector_start:
        point_angle += 360
        #print('New angle of point', point_angle)
    return point_angle <= sector_start + sweep

def is_in_sector(point, radius, sector_start, sweep):
    point_angle = math.atan2(point[1], point[0]) / math.pi * 180
    if not is_in_sector_angle(point_angle, sector_start, sweep):
        return False
    return point[0] ** 2 + point[1] ** 2 <= radius ** 2

def is_in_station_fov(target_point, station_point, radius, alpha, gamma):
    point = target_point[0] - station_point[0], target_point[1] - station_point[1]
    sector_start = alpha - gamma / 2
    return is_in_sector(point, radius, sector_start, gamma)

if __name__ == '__main__':
	# arguments x_target y_target x_station y_station alpha_station gamma_station r_station
    parser = argparse.ArgumentParser()
    positional_arguments = [
        'x_target', 'y_target', 'x_station', 'y_station',
        'alpha_station', 'gamma_station', 'r_station'
    ]
    for argument in positional_arguments:
        parser.add_argument(argument, type=int)
    args = parser.parse_args()

    target_point = args.x_target, args.y_target
    station_point = args.x_station, args.y_station
    if is_in_station_fov(target_point, station_point, args.r_station, 
                         args.alpha_station, args.gamma_station):
        sys.exit(0)
    sys.exit(1)

