input = open("./2022/python/day-01/input.txt")

calories = 0
most_calories = 0
for calorie in input:
    if calorie == "\n":
        if calories > most_calories:
            most_calories = calories
        calories = 0
    else:
        calories += int(calorie)

print('Find the Elf carrying the most Calories.') 
print('How many total Calories is that Elf carrying? {}'.format(most_calories))