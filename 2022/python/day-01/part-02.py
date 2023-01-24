input = open("./2022/python/day-01/input.txt")

elfs = []
calories = 0
for calorie in input:
    if calorie == "\n":
        elfs.append(calories)
        calories = 0
    else:
        calories += int(calorie)

print('Find the top three Elves carrying the most Calories.') 
print('How many Calories are those Elves carrying in total? {}'.format(sum(sorted(elfs, reverse=True)[:3])))