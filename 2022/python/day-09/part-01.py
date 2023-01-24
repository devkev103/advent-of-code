input = open("./2022/python/day-09/input.txt")

grid_size = 1000
initial_point = 40
rope_grid = []

for y in range(grid_size):
     row = []
     for x in range(grid_size):
          row.append(0)
     rope_grid.append(row)

# initial point
rope_grid[initial_point][initial_point] = 1

head_knot = {"x": initial_point, "y": initial_point}
tail_knot = {"x": initial_point, "y": initial_point}

def move_knot(direction, knot):
     if direction == 'R':
          knot["x"] += 1
     elif direction == 'L':
          knot["x"] -= 1
     elif direction == 'U':
          knot["y"] += 1
     elif direction == 'D':
          knot["y"]  -= 1

def move_knot_diagonally(direction, knot, head_knot):
     if direction == 'R':
          knot["x"] = head_knot["x"] - 1
          knot["y"] = head_knot["y"] 
     elif direction == 'L':
          knot["x"] = head_knot["x"] + 1
          knot["y"] = head_knot["y"] 
     elif direction == 'U':
          knot["y"] = head_knot["y"] - 1 
          knot["x"] = head_knot["x"]  
     elif direction == 'D':
          knot["y"] = head_knot["y"] + 1
          knot["x"] = head_knot["x"]  

def is_diagonal(head_knot, tail_knot) -> bool:
     diagonal = False
     if tail_knot["x"] != head_knot["x"] and tail_knot["y"] != head_knot["y"]:
          diagonal = True
     return diagonal 

def is_adjacent(head_knot, tail_knot) -> bool:
     adjacent = True
     if abs(tail_knot["x"] - head_knot["x"] ) > 1:
          adjacent = False
     elif abs(tail_knot["y"] - head_knot["y"] ) > 1:
          adjacent = False
     return adjacent

for line in input:
     parts = line.strip().split(' ')
     for move in range(int(parts[1])):
          move_knot(parts[0], head_knot) # move head_knot
          diagonal = is_diagonal(head_knot, tail_knot)

          if not is_adjacent(head_knot, tail_knot) and diagonal:
               move_knot_diagonally(parts[0], tail_knot, head_knot)
               rope_grid[tail_knot["y"]][tail_knot["x"]] = 1
          elif not is_adjacent(head_knot, tail_knot):
               move_knot(parts[0], tail_knot)
               rope_grid[tail_knot["y"]][tail_knot["x"]] = 1

# for debugging the sample; helpful to see tail path
# for row in rope_grid[::-1]: # need list in reverse as "U" 
#     print(row)

# count number of 'True' 
total = 0      
for row in rope_grid:
    total+= sum(row)

print(f"Simulate your complete hypothetical series of motions. How many positions does the tail of the rope visit at least once? {total}")