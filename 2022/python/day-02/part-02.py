input = open("./2022/python/day-02/input.txt")

# lose = 0; win = 6; draw = 3; 
# rock =1; paper = 2; scissors = 3;
# X = lose
# Y = draw
# Z = win

score_decoder = {
    "A X": 3, # lose with scissors; 0 + 3
    "B X": 1, # lose with rock    ; 0 + 1 
    "C X": 2, # lose with paper   ; 0 + 2 

    "A Y": 4, # draw with rock    ; 3 + 1 
    "B Y": 5, # draw with paper   ; 3 + 2  
    "C Y": 6, # draw with scissors; 3 + 3 

    "A Z": 8, # win with paper   ; 6 + 2 
    "B Z": 9, # win with scissors; 6 + 3  
    "C Z": 7, # win with rock    ; 6 + 1 
}

total_score = sum([score_decoder[round.strip()] for round in input])

print('Following the Elf''s instructions for the second column, what would your total score be if everything goes exactly according to your strategy guide? {}'.format(total_score))