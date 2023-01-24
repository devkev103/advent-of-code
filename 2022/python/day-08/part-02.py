import math

with open("./2022/python/day-08/input.txt") as input:
     lines = input.readlines()

tree_grid = []
tree_visibility_grid = []

# parse into a grid
for line in lines:
    tree_grid.append([*line.strip()])

row_count = len(tree_grid)
column_count = len(tree_grid[0])

def is_edge(y, x) -> bool:
    if ((y in range(0, row_count) and x == 0) # left side
        or (y in range(0, row_count) and x == column_count - 1) # right side
        or y == 0 # top row
        or y == row_count - 1): # bottom row
        return True
    else:
        return False

def get_adjacent_points(direction, point_y, point_x):
    if (direction == 'left'):
        return point_y, point_x - 1
    elif (direction == 'right'):
        return point_y, point_x + 1
    elif (direction == 'top'):
        return point_y - 1, point_x
    elif (direction == 'bottom'):
        return point_y + 1, point_x

def calculate_tree_visibility_count(direction, y, x, adjacent_y, adjacent_x) -> int:
    if (direction in ['left', 'right']):
        return abs(x - adjacent_x)     
    elif (direction in ['top', 'bottom']):
        return abs(y - adjacent_y)        

def get_visible_tree_count_by_direction(direction, y, x):
    # print(f"direction: {direction}, y: {y}, x: {x}")
    current_height = tree_grid[y][x]
    adjacent_y, adjacent_x = get_adjacent_points(direction, y, x)
    # print(f"ad_y: {adjacent_y}, ad_x: {adjacent_x}")
    adjacent_height = tree_grid[adjacent_y][adjacent_x]
    while adjacent_height < current_height and not is_edge(adjacent_y, adjacent_x):
            adjacent_y, adjacent_x = get_adjacent_points(direction, adjacent_y, adjacent_x)
            adjacent_height = tree_grid[adjacent_y][adjacent_x]
            # print(f"{adjacent_y} {adjacent_x}")
    return calculate_tree_visibility_count(direction, y, x, adjacent_y, adjacent_x)

visible_tree_count = []
highest_scenic_score = 0

for y_value in range(1, row_count - 1): # start on '1' and 'row_count - 1' as they are edges
    for x_value in range(1, column_count - 1): # start on '1' and 'column_count - 1' as they are edges 
        # print(f"y: {y_value}, x: {x_value}")
        for direction in ["left", "right", "top", "bottom"]:
            visible_tree_count.append(get_visible_tree_count_by_direction(direction, y_value, x_value))
        
        if math.prod(visible_tree_count) > highest_scenic_score:
            highest_scenic_score = math.prod(visible_tree_count)
        visible_tree_count.clear()

print(f"Consider each tree on your map. What is the highest scenic score possible for any tree? {highest_scenic_score}")