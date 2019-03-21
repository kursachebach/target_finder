#!/usr/bin/env python3
import sys
import argparse

def is_clockwise(v1, v2):
	return -v1[0] * v2[1] + v1[1] * v2[0] > 0

def is_in_sector(v_target, alpha, gamma, r): 
    if r ** 2 <= v_target[0] ** 2 + v_target[1] ** 2: 
        return False 
	alpha_max = alpha + gamma / 2
	alpha_min = alpha - gamma / 2
    if 		(not is_clockwise((math.cos(alpha_max), math.sin(alpha_max)), v_target) 
        	and is_clockwise((math.cos(alpha_min), math.sin(alpha_min)), v_target)):
        return False 
    return True 

if __name__ == '__main__':
	# arguments x_target y_target x_station y_station alpha_station gamma_station r_station
	parser = argparse.ArgumentParser()
	parser.add_argument('x_target', type=int)
