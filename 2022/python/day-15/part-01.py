import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.INFO)

input = open("./2022/python/day-15/input.txt")

class Coordinate:
    def __init__(self, coordinate_list):
        self.x, self.y = int(coordinate_list[0].replace("x=", "").replace(",", "")), int(coordinate_list[1].replace("y=", "").replace(":", ""))

    def print_coordinate(self):
        logging.debug(f"coordinate: {self.x}, {self.y}")

class SensorBeacon:
    def __init__(self, sensor, beacon):
        self.sensor = sensor
        self.beacon = beacon
        self.distance = self.get_manhattan_distance(beacon)
        self.ranges = self.get_covered_range()
        logging.debug(f"sensor: ({sensor.x},{sensor.y}), beacon: ({beacon.x},{beacon.y}) -- closest beacon is {self.distance} units away")

    def print_info(self):
        logging.info(f"sensor: ({self.sensor.x},{self.sensor.y}), beacon: ({self.beacon.x},{self.beacon.y})")

    def get_manhattan_distance(self, point):
        return abs(self.sensor.x - point.x) + abs(self.sensor.y - point.y)

    def get_covered_range(self) -> list:
        covered = []
        min = self.sensor.y - self.distance
        max = self.sensor.y + self.distance
        logging.debug(f"sensor ({self.sensor.x}, {self.sensor.y}), Y range of {min} - {max}")

        # bottom 
        counter = 0
        for y in range(min, sensor.y):
            covered.append({"y": y, "x_min": self.sensor.x - counter, "x_max": self.sensor.x + counter})
            counter += 1

        # top
        counter = self.distance
        for y in range(sensor.y, max + 1):
            covered.append({"y": y, "x_min": self.sensor.x - counter, "x_max": self.sensor.x + counter})
            counter = counter - 1

        return covered

sensor_symbol = "S"
beacon_symbol = "B"
covered_symbol = "#"
empty_symbol = "."
zerozero_origin_symbol = "O"
sensorbeacon_pairs = []

def print_grid(sensorbeacons):
    grid_size = 50
    grid = []
    for x in range(-grid_size, grid_size):
        grid.append([empty_symbol for i in range(-grid_size, grid_size)])

    for sensorbeacon in sensorbeacons:
        grid[sensorbeacon.sensor.y+grid_size][sensorbeacon.sensor.x+grid_size] = sensor_symbol
        grid[sensorbeacon.beacon.y+grid_size][sensorbeacon.beacon.x+grid_size] = beacon_symbol
        for ranges in sensorbeacon.ranges:
            for x in range(ranges["x_min"], ranges["x_max"]+1):
                if grid[ranges["y"]+grid_size][x+grid_size] == empty_symbol:
                    grid[ranges["y"]+grid_size][x+grid_size] = covered_symbol

    grid[grid_size][grid_size] = zerozero_origin_symbol
    for line in (grid):
        print(''.join(line))

for line in input:
    parts = line.strip().split(' ')
    sensor = Coordinate(parts[2:4])
    beacon = Coordinate(parts[8:10])
    sensorbeacon = SensorBeacon(sensor, beacon)
    sensorbeacon_pairs.append(sensorbeacon)
    logging.info(f"processed sensor: ({sensorbeacon.sensor.x}, {sensorbeacon.sensor.y})")

# row_y = 10 # input-sample.txt
row_y = 2000000 # input.txt
first = True
for sensorbeacon in sensorbeacon_pairs:
    for ranges in sensorbeacon.ranges:
        if ranges["y"] == row_y:
            logging.debug(f"ranges: {ranges}")
            if first:
                min, max, first = ranges["x_min"], ranges["x_max"], False
                logging.debug(f"min: {min}, max: {max}")
            else:
                min = ranges["x_min"] if ranges["x_min"] < min else min
                max = ranges["x_max"] if ranges["x_max"] > max else max

# get list of sensors or beacons in row
sensorbeacon_in_row = []
for sensorbeacon in sensorbeacon_pairs:
    if sensorbeacon.beacon.y == row_y:
        obj = {sensorbeacon.beacon.x, sensorbeacon.beacon.y}
        if obj not in sensorbeacon_in_row:
            sensorbeacon_in_row.append(obj)
    if sensorbeacon.sensor.y == row_y:
        obj = {sensorbeacon.sensor.x, sensorbeacon.sensor.y}
        if obj not in sensorbeacon_in_row:
            sensorbeacon_in_row.append(obj)

# useful for visualizing input-sample
if row_y == 10:
    print_grid(sensorbeacon_pairs)

covered_spaces = (max-min) + 1 - len(sensorbeacon_in_row)
logging.info(f"Consult the report from the sensors you just deployed. In the row where y={row_y}, how many positions cannot contain a beacon? {covered_spaces}")