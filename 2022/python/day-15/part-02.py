import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

debug = False
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
        # self.ranges = self.get_covered_range()
        logging.debug(f"sensor: ({sensor.x},{sensor.y}), beacon: ({beacon.x},{beacon.y}) -- closest beacon is {self.distance} units away")

    def print_info(self):
        logging.info(f"sensor: ({self.sensor.x},{self.sensor.y}), beacon: ({self.beacon.x},{self.beacon.y})")

    def get_manhattan_distance(self, point):
        return abs(self.sensor.x - point.x) + abs(self.sensor.y - point.y)

    def y_range(self):
        logging.debug(f"sensor ({self.sensor.x}, {self.sensor.y}) Y range with distance {self.distance} : {self.sensor.y - self.distance} - {self.sensor.y + self.distance}")
        return [self.sensor.y - self.distance, self.sensor.y + self.distance]

        DEBUG:root:getting range list for sensor (246553, 343125), y_value of 451361 with distance 1684902
        DEBUG:root:sensor (246553, 343125) Y range with distance 1684902 : -1341777 - 2028027
        DEBUG:root:ranges: {'y': 451361, 'x_min': -1330113, 'x_max': 1823219, 'sensor_x': 246553, 'sensor_y': 343125}

        343125 - 451361

    def get_covered_range_row(self, y_value) -> list:
        logging.debug(f"getting range list for sensor ({self.sensor.x}, {self.sensor.y}), y_value of {y_value} with distance {self.distance}")
        y_ranges = self.y_range()
        if y_ranges[0] <= y_value <= y_ranges[1]:
            value = abs(self.distance - abs(self.sensor.y - y_value))
            obj = {"y": y_value, "x_min": self.sensor.x - value, "x_max": self.sensor.x + value, "sensor_x": self.sensor.x, "sensor_y": self.sensor.y}
            return obj
        else:
            return None

    def get_covered_range(self) -> list:
        covered = []
        min = self.sensor.y - self.distance
        max = self.sensor.y + self.distance
        logging.debug(f"getting range list for sensor ({self.sensor.x}, {self.sensor.y}), Y range of {min} - {max}")

        # bottom 
        counter = 0
        for y in range(min, sensor.y):
            covered.append({"y": y, "x_min": self.sensor.x - counter, "x_max": self.sensor.x + counter, "sensor_x": self.sensor.x, "sensor_y": self.sensor.y})
            counter += 1

        # top
        counter = self.distance
        for y in range(sensor.y, max + 1):
            covered.append({"y": y, "x_min": self.sensor.x - counter, "x_max": self.sensor.x + counter, "sensor_x": self.sensor.x, "sensor_y": self.sensor.y})
            counter = counter - 1

        return covered


sensorbeacons = []
for line in input:
    parts = line.strip().split(' ')
    sensor = Coordinate(parts[2:4])
    beacon = Coordinate(parts[8:10])
    sensorbeacon = SensorBeacon(sensor, beacon)
    sensorbeacons.append(sensorbeacon)
    logging.info(f"processed sensor: ({sensorbeacon.sensor.x}, {sensorbeacon.sensor.y})")

for row_y in range(451361, 451361+1):
    # logging.info(f"current processing y line {row_y}")
    first = True
    current_ranges = []
    for sensorbeacon in sensorbeacons:

        '''
        for ranges in sensorbeacon.ranges:
            if ranges["y"] == row_y:
                logging.debug(f"ranges: {ranges}")
                old_current_ranges.append(ranges)
        '''

        ranges = sensorbeacon.get_covered_range_row(row_y)
        if ranges is not None:    
            logging.debug(f"ranges: {ranges}")
            current_ranges.append(ranges)
            if first:
                min, max, first = ranges, ranges, False
            else:
                min = ranges if ranges["x_min"] < min["x_min"] else min
                max = ranges if ranges["x_max"] > max["x_max"] else max

    for r in range(len(current_ranges)):
        if min["x_min"] <= current_ranges[r]["x_min"] <= min["x_max"]:
            if current_ranges[r]["x_max"] > min["x_max"]:
                logging.debug(f"current x_min {current_ranges[r]} lies within min {min} range. updating min['x_max']")
                min["x_max"] = current_ranges[r]["x_max"]

    # is a continious line?
    if min["x_max"] >= max["x_min"]:
        logging.debug("forms a continous line")
    else:
        logging.debug("does not form a continous line")
        break

print(current_ranges)
# print(old_current_ranges)
    

logging.debug(f"min: {min}, max: {max}")   
# tuning_frequency = ((min["x_max"] + 1) * 4000000) + min["y"]

# logging.info(f"Find the only possible position for the distress beacon. What is its tuning frequency? {tuning_frequency}")

print("")
print(sensorbeacons[16].get_covered_range_row(451361))
# print(sensorbeacons[16].get_covered_range())

# INFO:root:min: {'y': 451361, 'x_min': -1330113, 'x_max': 3243876}, max: {'y': 451361, 'x_min': 3689789, 'x_max': 4309257}