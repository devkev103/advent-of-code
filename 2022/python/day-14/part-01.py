import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.INFO)

input = open("./2022/python/day-14/input.txt")

grid_size = 1000
air_symbol = "."
rock_symbol = "#"
sand_symbol = "O"
sand_origin_symbol = "+"
sand_origin_coordinate = "500,0"
grid = []

class Coordinate:
    def __init__(self, coordinate):
        self.x, self.y = [int(x) for x in coordinate.strip().split(',')]

    def print_coordinate(self):
        logging.debug(f"sand piece: {self.x}, {self.y}")

# create grid of air 
for x in range(grid_size):
    grid.append([air_symbol for i in range(grid_size)])

def add_rocks(coordinate_list):
    for point in coordinate_list:
        logging.debug(f"create rock at {point.x}, {point.y}")
        grid[point.y][point.x] = rock_symbol

def get_line_coordinates(point_1, point_2) -> list:
    if (point_1.y == point_2.y):
        min = point_1.x if point_1.x < point_2.x else point_2.x
        return [Coordinate(f"{min + x},{point_1.y}") for x in range(abs(point_1.x - point_2.x) + 1)]
    elif (point_1.x == point_2.x):
        min = point_1.y if point_1.y < point_2.y else point_2.y
        return [Coordinate(f"{point_1.x},{min + x}") for x in range(abs(point_1.y - point_2.y) + 1)]
    else:
        raise NotImplementedError("the creation of this rock line is not implemented")

def process_rock_line(rocks):
    rock_1 = rocks[0]

    for x in range(1, len(rocks)):
        rock_2 = rocks[x]
        logging.debug(f"creating rock line for {rock_1} -> {rock_2}")
        add_rocks(get_line_coordinates(Coordinate(rock_1), Coordinate(rock_2)))
        rock_1 = rock_2

def print_grid(origin, offset_x, offset_y):
    for line in (grid[0:offset_y]):
        print(''.join(line[origin-offset_x:origin+offset_x]))

def add_one_sand():
    sand = Coordinate(sand_origin_coordinate)
    can_sand_drop = True
    status = "successfully added one sand"

    while (can_sand_drop):
        if sand.y > last_rock_formation:
            can_sand_drop = False
            status = "sand falls into abyss"
        elif (grid[sand.y + 1][sand.x] == air_symbol):
            sand.y += 1
            sand.print_coordinate()
        elif(grid[sand.y + 1][sand.x - 1] == air_symbol):
            sand.y += 1
            sand.x -= 1
            sand.print_coordinate()
        elif(grid[sand.y + 1][sand.x + 1] == air_symbol):
            sand.y += 1
            sand.x += 1
            sand.print_coordinate()
        else:
            grid[sand.y][sand.x] = sand_symbol
            can_sand_drop = False

    return status


for line in input:
    process_rock_line(line.strip().split("->"))

# sand starting point 
sand_origin = Coordinate(sand_origin_coordinate)
grid[sand_origin.y][sand_origin.x] = sand_origin_symbol

# get last rock formation
last_rock_formation = grid_size
for x in range(grid_size - 1, 0 , -1):
    if rock_symbol in grid[x]:
        last_rock_formation = x
        break

print_grid(500, 75, last_rock_formation+2)        

# start adding sand
counter = 0
while 1 == 1:
    if add_one_sand() == "sand falls into abyss":
        break
    counter += 1

print_grid(500, 75, last_rock_formation+2)

logging.info(f"Using your scan, simulate the falling sand. How many units of sand come to rest before sand starts flowing into the abyss below? {counter}")