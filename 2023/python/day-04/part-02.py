import logging, sys
logging.basicConfig(stream=sys.stderr, level=logging.INFO)

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
    cards_won = []
    def __init__(self, input):
        self.input = input

    def ParseCard(self):
        logging.debug(self.input)
        split = self.input.split(":")
        self.card_number = int([x for x in split[0].split(" ") if x != ""][1])
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
    
    def CardsWon(self):
        self.cards_won = [x for x in range(self.card_number+1, self.card_number + len(self.matching_numbers) +1)]

    def __repr__(self):
        return f"card_number: {self.card_number}; winning_numbers: {self.winning_numbers};game_numbers: {self.game_numbers}; matching_numbers: {self.matching_numbers}; cards_won: {self.cards_won}"

cards = Cards(input)
cards.CreateCards()

total_points = 0
for card in cards.cards:
    card.GetMathingNumbers()
    card.CardsWon()
    logging.debug(card)
    total_points += card.GetPoints()


def recursion(all_cards, cards, total_cards) -> int:
    for card in cards:
        winning_cards = []
        for winning_card in card.cards_won:
            winning_cards.append(all_cards[winning_card-1])
            logging.debug(f"winning_cards: {winning_card}")
        total_cards += len(winning_cards)
        logging.debug(f"total won this round: {len(winning_cards)}")
        logging.debug(f"total won: {total_cards}")
        
        total_cards = recursion(all_cards, winning_cards, total_cards)
            
    return total_cards

total_cards = 0
total_cards = recursion(cards.cards, cards.cards, total_cards)

total_cards += len(cards.cards)

logging.info("Process all of the original and copied scratchcards until no more scratchcards are won.")
logging.info(f"Including the original set of scratchcards, how many total scratchcards do you end up with? {total_cards}")