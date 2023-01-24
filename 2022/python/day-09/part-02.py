input = open("./2022/python/day-09/input.txt")

grid_size = 1000
initial_point = int(grid_size / 2)
rope_length = 10
debug = False
rope = []

for x in range(rope_length):
    rope.append({"id": x, "y": initial_point, "x": initial_point})

def get_direction(point, current_knot, leading_knot):
    direction = None
    if point in ["x"]:
        if current_knot["x"] < leading_knot["x"]:
            direction = "R"
        elif current_knot["x"] > leading_knot["x"]:
            direction = "L"
    if point in ["y"]:
        if current_knot["y"] < leading_knot["y"]:
            direction = "D"
        elif current_knot["y"] > leading_knot["y"]:
            direction = "U"
    return direction 

def is_adjacent(head_knot, tail_knot) -> bool:
     adjacent = True
     if abs(tail_knot["x"] - head_knot["x"] ) > 1:
          adjacent = False
     elif abs(tail_knot["y"] - head_knot["y"] ) > 1:
          adjacent = False
     return adjacent

def move_knot(direction, knot):
     if direction == 'R':
          knot["x"] += 1
     elif direction == 'L':
          knot["x"] -= 1
     elif direction == 'D':
          knot["y"] += 1
     elif direction == 'U':
          knot["y"] -= 1

def create_grid(size, filler) -> list:
    grid = []
    for y in range(size):
        row = []
        for x in range(size):
            row.append(filler)
        grid.append(row)
    return grid

def print_tail_grid(grid):
    for row in grid: # need list in reverse as "U" 
        print([str(x).replace("0", ".").replace("1", "#") for x in row])

def print_rope_knots(grid_size, rope):
    grid = create_grid(grid_size, ".")
    for knot in rope[::-1]:
        grid[knot["y"]][knot["x"]] = str(knot["id"])
    for row in grid:
        print(row)

tail_grid = create_grid(grid_size, 0)

for line in input:
     parts = line.strip().split(' ')
     direction, movement = parts[0], int(parts[1])
     print(f"moving {line.strip()}")
     for move in range(movement):
        for knot_number in range(rope_length):
            current_knot = next((knot for knot in rope if knot['id'] == knot_number), None)

            if knot_number != 0: # not head knot
                leading_knot = next((knot for knot in rope if knot['id'] == knot_number - 1), None)
                x_direction = get_direction("x", current_knot, leading_knot)
                y_direction = get_direction("y", current_knot, leading_knot)

            if knot_number == 0: # head knot
                move_knot(direction, current_knot)
                if debug:
                    print(f"  head knot moved: {current_knot}")
            elif not is_adjacent(leading_knot, current_knot):
                if x_direction != None:
                    move_knot(x_direction, current_knot)
                    if debug:
                        print(f"  moved x direction {x_direction}: {current_knot}")

                if y_direction != None:
                    move_knot(y_direction, current_knot)
                    if debug:
                        print(f"  moved y direction {y_direction}: {current_knot}")
            else:
                if debug:
                    print(f"  not moving knot: {current_knot}")
            
            if knot_number == rope_length - 1: # is the tail (last) knot
                    tail_grid[current_knot["y"]][current_knot["x"]] = 1
                    if debug:
                        print(f'  updating grid {current_knot}')

        if debug:
            print_rope_knots(grid_size, rope)
            print('')


if debug: # for debugging the sample; helpful to see tail path for input-sample-large - you will also need to adjust grid size to 50
    print("tail grid")
    print_tail_grid(tail_grid)

total = 0      
for row in tail_grid:
    total+= sum(row)
print(f"Simulate your complete series of motions on a larger rope with ten knots. How many positions does the tail of the rope visit at least once? {total}")