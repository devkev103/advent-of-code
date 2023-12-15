import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.INFO)

input = open("./2023/python/day-02/input.txt")
sum_of_power = 0

class Pull:
  def __init__(self, pull):
    self.amount_of_cubes = int(pull[0])
    self.color = pull[1]

for line in input:
    logging.debug(line)
    logging.info(line[:line.index(":")])
    game_number = int(line[:line.index(":")].split(" ")[1])
    games = line.strip()[line.index(":")+2:].split(";")
    cube_min = {}
    logging.debug(games)
    for game in games:
        rounds = game.split(",")
        for round in rounds:
            pull = Pull(round.strip().split(" "))
            if (pull.color not in cube_min):
              cube_min[pull.color] = int(pull.amount_of_cubes )
            elif (cube_min[pull.color] < pull.amount_of_cubes):
                logging.debug(f"Adding {pull.color} {pull.amount_of_cubes}")
                cube_min[pull.color] = int(pull.amount_of_cubes)
    logging.debug(cube_min)

    result = 1
    for key in cube_min:
        result = result * cube_min[key]

    logging.debug(result)
    sum_of_power += result
                
logging.info("For each game, find the minimum set of cubes that must have been present.") 
logging.info(f" What is the sum of the power of these sets? {sum_of_power}")