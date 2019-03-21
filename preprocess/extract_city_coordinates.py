#!/bin/env python3
import re
from bs4 import BeautifulSoup

def get_map_scale(rect_cord):
    dx = rect_cord[0] - rect_cord[2]
    dy = rect_cord[1] - rect_cord[3]
    ds = (dx + dy) / 2
    return 500 / ds

def extract_coordinate(area):
    return tuple(int(num) for num in re.findall(r'\d+', area['coords']))

def extract_coordinate_from_map(filepath):
    map_height = 6726
    with open(filepath) as html_file:
    	map_tag = BeautifulSoup(html_file, 'html.parser').map

    rect_cord = extract_coordinate(map_tag.find('area', title='Rect'))
    scale = get_map_scale(rect_cord)

    coordinates = {}
    for city in map_tag.find_all('area', shape='circle'):
        city_cord = tuple(x * scale for x in extract_coordinate(city)[:2])
        coordinates[city['title']] = city_cord

    return coordinates
