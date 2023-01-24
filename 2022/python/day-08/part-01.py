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

def set_tree_visibility(current_max, y, x) -> int:
    if current_max < tree_grid[y][x]:
        current_max = tree_grid[y][x]
        tree_visibility_grid[y][x] = True 
    return current_max

# fill tree_visibility_grid 
for y in range(0, row_count):
    row = []
    for x in range(0, column_count):
        row.append(is_edge(y, x)) 
    tree_visibility_grid.append(row)

# left and right
for y in range(1, row_count - 1): # start on '1' and 'row_count - 1' as they are edges
    current_max_left = tree_grid[y][0]
    current_max_right = tree_grid[y][row_count - 1]
    for x in range(0, column_count):
        current_max_left = set_tree_visibility(current_max_left, y, x)  
    for x in range(column_count - 1, -1, -1):
        current_max_right = set_tree_visibility(current_max_right, y, x)  

# top and bottom
for x in range(1, column_count - 1): # start on '1' and 'column_count - 1' as they are edges
    current_max_top = tree_grid[0][x]
    current_max_bottom = tree_grid[row_count - 1][x]
    for y in range(1, row_count):
        current_max_top = set_tree_visibility(current_max_top, y, x)
    for y in range(row_count - 1, -1, -1):
        current_max_bottom = set_tree_visibility(current_max_bottom, y, x)

# side note: could find a way to combine code left/right/top/bottom

# count number of 'True' 
total = 0      
for row in tree_visibility_grid:
    total+= sum(row)

print(f"Consider your map; how many trees are visible from outside the grid? {total}")