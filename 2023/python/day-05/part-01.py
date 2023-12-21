import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

input = open("./2023/python/day-05/input-sample.txt")

class Map:
    
    def __init__(self, input):
        self.name = input[0].replace(':', '')
        self.ranges = []
        for range_input in input[1:]:
            self.ranges.append(Range(range_input))

    def __repr__(self) -> str:
        return f"name: {self.name}; ranges: {self.ranges}"

class Range:
    def __init__(self, input):
        input_split = input.split(" ")
        self.destination_range_start = int(input_split[0])
        self.source_range_start =int(input_split[1])
        self.range_length = int(input_split[2])
        
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

for map in maps:
    logging.debug(map)
    logging.debug("")