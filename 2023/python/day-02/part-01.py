import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.INFO)

input = open("./2023/python/day-02/input.txt")
sum_of_ids = 0
max_cubes = {
    'red': 12,
    'green': 13,
    'blue': 14,
}


def is_pull_possible(pull) -> bool:
    if int(pull[0]) > max_cubes[pull[1]]:
        return False
    else:
        return True


for line in input:
    logging.debug(line)
    logging.info(line[:line.index(":")])
    game_number = int(line[:line.index(":")].split(" ")[1])
    games = line.strip()[line.index(":")+2:].split(";")
    is_possible = True
    logging.debug(games)
    for game in games:
        rounds = game.split(",")
        for round in rounds:
            if is_possible:
                logging.debug(round.strip())
                pull = round.strip().split(" ")
                logging.debug(pull)
                is_possible = is_pull_possible(pull)
                if (is_possible):
                    logging.debug("This pull is possible")
                else:
                    logging.info(f"Game {game_number} is not possible")
                

    if (is_possible):
        logging.info(f"Game {game_number} is possible")
        sum_of_ids += game_number
    
logging.info("Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes.") 
logging.info(f"What is the sum of the IDs of those games? {sum_of_ids}")