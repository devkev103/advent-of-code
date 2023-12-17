import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

input = open("./2023/python/day-04/input.txt")

class Cards:
    cards = []
    def __init__(self, input):
        self.input = input
        
    def CreateCards(self):
        for card in input:
            card = Card(card.strip())
            card.ParseCard()
            self.cards.append(card)

class Card:
    winning_numbers = []
    game_numbers = []
    matching_numbers = []
    def __init__(self, input):
        self.input = input

    def ParseCard(self):
        logging.debug(self.input)
        split = self.input.split(":")
        self.card_number = split[0].split(" ")[1]
        split = split[1].split("|")
        self.winning_numbers = [x for x in split[0].strip().split(" ") if x != ""]
        self.game_numbers = [x for x in split[1].strip().split(" ") if x != ""]

    def GetMathingNumbers(self):
        self.matching_numbers = [i for i in self.winning_numbers if i in self.game_numbers]

    def GetPoints(self) -> int:
        points = 0
        for number in range(0, len(self.matching_numbers)):
            if points == 0:
                points = 1
            else:
                points = points * 2
        return points

    def __repr__(self):
        return f"card_number: {self.card_number}; winning_numbers: {self.winning_numbers}; game_numbers: {self.game_numbers}; matching_numbers: {self.matching_numbers}"

cards = Cards(input)
cards.CreateCards()

total_points = 0
for card in cards.cards:
    card.GetMathingNumbers()
    logging.debug(card)
    total_points += card.GetPoints()

logging.info("Take a seat in the large pile of colorful cards.")
logging.info(f"How many points are they worth in total? {total_points}")

