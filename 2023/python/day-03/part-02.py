# absolute mess .....

import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

input = open("./2023/python/day-03/input.txt")
sum_of_number_parts = 0

class Coordinate:
  def __init__(self, x, y):
    self.x = x
    self.y = y
    self.value = ""

  def is_equal(self, coordinate) -> bool:
     if self.x == coordinate.x and self.y == coordinate.y:
        return True
     else:
        return False

  def __repr__(self):
    return f"row: {self.x}; col: {self.y}; value: {self.value}"

class GearRatio:
  def __init__(self, coordinate):
     self.coordinate = coordinate
     self.has_star = False
     self.values = []
  def add_gear(self, has_star, value):
        if not self.has_star:
          self.has_star = has_star
        self.values.append(int(value))
  def __repr__(self):
     return f"coordinate: {self.coordinate}; has_star: {self.has_star}; values: {self.values}"

class EnginePart:
  def __init__(self):
        self.coordinates = []
        self.value = ""
        self.has_symbol = False
        self.has_star_symbol = False
        self.valid_coordinates = []       

  def get_value(self):
     return int(self.value)
  
  def __repr__(self):
    return f"value: {self.value}; has_symbol: {self.has_symbol}; has_star_symbol: {self.has_star_symbol}; coordinate: {self.valid_coordinates}"
  
  def check_for_symbol(self):
    if len(self.valid_coordinates) > 0:
      self.has_symbol = True   
    if len([x for x in self.valid_coordinates if x.value == "*"]) > 0:
       self.has_star_symbol = True

class Grid:
  grid = []

  def __init__(self, input):
    for line in input:
        self.grid.append([*line.strip()])
        self.x_bound = len(self.grid[0]) - 1
        self.y_bound = len(self.grid) - 1

  def check_boundery(self, coordinate: Coordinate) -> bool:
    if coordinate.x <= self.x_bound and coordinate.x >= 0 and coordinate.y <= self.y_bound and coordinate.y >= 0:
       # logging.debug("within boundery")
       return True
    else:
      # logging.debug("not within boundery")
      return False
    
  def get_potential_coordinates(self, coordinate):
    potential_coordinates = []

    potential_coordinates.append(Coordinate(coordinate.x-1, coordinate.y-1))
    potential_coordinates.append(Coordinate(coordinate.x+1, coordinate.y+1))

    potential_coordinates.append(Coordinate(coordinate.x, coordinate.y-1))
    potential_coordinates.append(Coordinate(coordinate.x, coordinate.y+1))

    potential_coordinates.append(Coordinate(coordinate.x-1, coordinate.y))
    potential_coordinates.append(Coordinate(coordinate.x+1, coordinate.y))

    potential_coordinates.append(Coordinate(coordinate.x-1, coordinate.y+1))
    potential_coordinates.append(Coordinate(coordinate.x+1, coordinate.y-1))

    return potential_coordinates

  def get_valid_coordinates(self, coordinates):
    valid_coordinates = []

    for coordinate in coordinates:
      if self.check_boundery(coordinate):
        coordinate.value = self.grid[coordinate.x][coordinate.y]
        if coordinate.value != '.' and not coordinate.value.isnumeric():
          valid_coordinates.append(coordinate)

    return valid_coordinates

  def append_valid_coordinates(self, engine_part, coordinates):
     for coordinate in coordinates:
        should_add = True
        for engine_coordinate in engine_part.valid_coordinates:
           if engine_coordinate.x == coordinate.x and engine_coordinate.y == coordinate.y:
              logging.debug("coordinate has already been added")
              should_add = False
        if should_add:
           engine_part.valid_coordinates.append(coordinate)
     

  def get_engine_parts(self):
     engine_parts = []

     for row in range(0, self.x_bound+1):
        engine_part = EnginePart()
        for col in range(0, self.y_bound+1):
           logging.debug(f"row: {row}; col: {col}; val: {self.grid[row][col]}")
           if self.grid[row][col].isnumeric():
              logging.debug(f"current engine_part: {engine_part}")
              engine_part.coordinates.append(Coordinate(row, col))
              engine_part.value += self.grid[row][col]
              coordinates_with_symbols = self.get_valid_coordinates(self.get_potential_coordinates(Coordinate(row, col)))
              self.append_valid_coordinates(engine_part, coordinates_with_symbols)
              # if len(coordinates_with_symbols) > 0:
                # engine_part.valid_coordinates.append(*coordinates_with_symbols)
              logging.debug(engine_part.value)
              # if not engine_part.has_symbol:
                # engine_part.has_symbol = self.check_for_symbol(Coordinate(row, col))
           else:
              logging.debug(f"final engine_part: {engine_part}")
              if len(engine_part.value) > 0:
                engine_parts.append(engine_part)
                logging.debug(f"adding value: {engine_part.value}")
              engine_part = EnginePart()

        if len(engine_part.value) > 0:
                engine_parts.append(engine_part)
     return engine_parts
              
grid = Grid(input)
engine_parts = grid.get_engine_parts()

# print grid
for row in grid.grid:
   logging.debug(row)

# part 01
for engine_part in engine_parts:
    engine_part.check_for_symbol()

gear_ratio_sum = 0

gear_ratios = []

for engine_part in engine_parts:
   for coordinate in engine_part.valid_coordinates:
      has_been_added = False
      for gear_ratio in gear_ratios:
         if gear_ratio.coordinate.is_equal(coordinate):
          has_been_added = True
          gear_ratio.add_gear(engine_part.has_star_symbol, engine_part.value)
      
      if not has_been_added:
        gear_ratio = GearRatio(coordinate)
        gear_ratio.add_gear(engine_part.has_star_symbol, engine_part.value)
        gear_ratios.append(gear_ratio)

logging.debug(gear_ratios)

for gear_ratio in gear_ratios:
   if gear_ratio.has_star and len(gear_ratio.values) == 2:
      logging.debug(f"gear ratio: {gear_ratio.values[0]} * {gear_ratio.values[1]} = {gear_ratio.values[0] * gear_ratio.values[1]}")
      gear_ratio_sum += gear_ratio.values[0] * gear_ratio.values[1]   
     

logging.info(engine_parts)

logging.info(f"What is the sum of all of the gear ratios in your engine schematic? {gear_ratio_sum}")