input = open("./2022/python/day-12/input.txt")

grid = []

for line in input:
    grid.append([*line.strip()])

class QItem:
    def __init__(self, row, col, dist):
        self.row = row
        self.col = col
        self.dist = dist
 
    def __repr__(self):
        return f"QItem({self.row}, {self.col}, {self.dist})"
 
def minDistance(grid, start_row, start_col):
    source = QItem(0, 0, 0)
    source.row = start_row
    source.col = start_col
 
    # To maintain location visit status
    visited = [[False for _ in range(len(grid[0]))]
               for _ in range(len(grid))]
     
    # applying BFS on matrix cells starting from source
    queue = []
    queue.append(source)
    visited[source.row][source.col] = True
    while len(queue) != 0:
        source = queue.pop(0)
        current_elevation =  'a' if grid[source.row][source.col] == 'S' else grid[source.row][source.col]
 
        # Destination found;
        if (grid[source.row][source.col] == 'E'):
            return source.dist
 
        # moving up
        if isValid(source.row - 1, source.col, grid, visited, current_elevation):
            queue.append(QItem(source.row - 1, source.col, source.dist + 1))
            visited[source.row - 1][source.col] = True
 
        # moving down
        if isValid(source.row + 1, source.col, grid, visited, current_elevation):
            queue.append(QItem(source.row + 1, source.col, source.dist + 1))
            visited[source.row + 1][source.col] = True
 
        # moving left
        if isValid(source.row, source.col - 1, grid, visited, current_elevation):
            queue.append(QItem(source.row, source.col - 1, source.dist + 1))
            visited[source.row][source.col - 1] = True
 
        # moving right
        if isValid(source.row, source.col + 1, grid, visited, current_elevation):
            queue.append(QItem(source.row, source.col + 1, source.dist + 1))
            visited[source.row][source.col + 1] = True
 
    return -1
 
 
# checking where move is valid or not
def isValid(x, y, grid, visited, origin_elevation):
    if ((x >= 0 and y >= 0) and
        (x < len(grid) and y < len(grid[0])) and
            (can_climb(origin_elevation, grid[x][y])) and
            (visited[x][y] == False)):
        return True
    return False

def can_climb(origin, destination):
    destination = 'z' if destination == "E" else destination
    if(get_current_elevation(destination) <= get_current_elevation(origin) or 
        get_current_elevation(origin) + 1 == get_current_elevation(destination)):
        return True
    return False

def get_current_elevation(letter):
    return ord(letter) - 96
 
minimum = 10000
for row in range(len(grid)):
    for col in range(len(grid[0])):
        if grid[row][col] in ('a', 'S'):
            current = minDistance(grid, row, col)
            if current < minimum and current != -1:
                minimum = current

print(f"What is the fewest steps required to move starting from any square with elevation a to the location that should get the best signal? {minimum}")