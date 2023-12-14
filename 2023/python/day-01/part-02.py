input = open("./2023/python/day-01/input.txt")

searchfors = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

help_dict = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
}

class Position:
  def __init__(self, searchfor, position):
    self.searchfor = searchfor
    self.position = position
    
    if searchfor.isnumeric():
       self.value = str(searchfor)
    else:
       self.value = str(help_dict[searchfor])

total = 0
for line in input:
    positions = []
    print(line)
    for searchfor in searchfors:
        position = 0
        while position != -1:
            position = line.find(searchfor, position)
            if position != -1:
                positions.append(Position(searchfor, position))
                position += 1

    positions.sort(reverse=False, key=lambda x: x.position)
    total += int(positions[0].value + positions[len(positions)-1].value)

print('Consider your entire calibration document.')
print('What is the sum of all of the calibration values? {}'.format(total)) 