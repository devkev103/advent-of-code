input = open("./2022/python/day-02/input.txt")

# lose = 0; win = 6; draw = 3; 
# A/X is Rock worth 1;
# B/Y is Paper worth 2;
# C/Z is scissors worth 3;

score_decoder = {
    "A X": 4, # draw with rock    ; 3 + 1
    "A Y": 8, # win with paper    ;  6 + 2
    "A Z": 3, # lose with scissors; 0 + 3
    "B X": 1, # lose with rock    ; 0 + 1
    "B Y": 5, # draw with paper   ; 3 + 2
    "B Z": 9, # win with scissors ;  6 + 3 
    "C X": 7, # win with rock     ;  6 + 1
    "C Y": 2, # lose with paper   ; 0 + 2
    "C Z": 6, # draw with scissors; 3 + 3
}

total_score = sum([score_decoder[round.strip()] for round in input])

print('What would your total score be if everything goes exactly according to your strategy guide? {}'.format(total_score))