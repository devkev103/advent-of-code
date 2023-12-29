import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.INFO)

input = open("./2023/python/day-05/input.txt")

class Map:
    
    def __init__(self, input):
        self.name = input[0].replace(':', '')
        self.ranges = []
        for range_input in input[1:]:
            self.ranges.append(Range(range_input))

    def GetLocation(self, initial_location):
        for range in self.ranges:
            new_location = range.GetLocation(initial_location)

            if new_location != initial_location:
                logging.debug("new location found")
                return new_location
            else:
                initial_location = new_location
        return initial_location

    def __repr__(self) -> str:
        return f"name: {self.name}; ranges: {self.ranges}"

class Range:
    def __init__(self, input):
        input_split = input.split(" ")
        self.destination_range_start = int(input_split[0])
        self.source_range_start =int(input_split[1])
        self.range_length = int(input_split[2])

    def GetLocation(self, initial_location) -> int:
        if self.source_range_start <= initial_location < self.source_range_start + self.range_length:
            logging.debug(f"{initial_location} is in the range of {self.source_range_start} length {self.range_length}")
            initial_location = initial_location - self.source_range_start  + self.destination_range_start
            logging.debug(f"new location: {initial_location}")
        else:
            logging.debug(f"{initial_location} is not in the range of {self.source_range_start} length {self.range_length}")
        return initial_location
        
    def __repr__(self) -> str:
        return f"dest_range_start: {self.destination_range_start}; source_range_start: {self.source_range_start}; range_length: {self.range_length}"

seeds = []
maps = []
map_input = []
for line in input:
    if line.startswith("seeds"):
        seeds = [int(x) for x in line.split(":")[1].strip().split(" ")]
        logging.debug(seeds)
    elif line == "\n":
        logging.debug("empty line;")
        if len(map_input) > 0:
            logging.debug("parse input and reset")
            maps.append(Map(map_input))
            map_input.clear()
    else:
        map_input.append(line.strip())
        logging.debug(f"add line: {line.strip()}")

# parse the last map
maps.append(Map(map_input))

lowest_location = -1
while len(seeds) > 0:
    start_range = seeds.pop(0)
    length = seeds.pop(0)
    logging.info(f"start_range: {start_range} for length of {length}")
    
    for location in range(start_range, start_range+length):
        logging.debug(f"{location}")
        for map in maps:
            logging.debug(map)
            location = map.GetLocation(location)
            logging.debug(f"current location: {location}")
            logging.debug("")
        logging.debug(f"appending location: {location}")    
        
        if lowest_location == -1 or location < lowest_location:
            lowest_location = location

logging.info(f"What is the lowest location number that corresponds to any of the initial seed numbers? {lowest_location}")