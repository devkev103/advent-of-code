input = open("./2023/python/day-01/input.txt")

searchfors = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

class Position:
  def __init__(self, searchfor, position):
    self.searchfor = searchfor
    self.position = position

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
    # sort array in place
    positions.sort(reverse=False, key=lambda x: x.position)

    # take first and last positions in array; concatenate them together; convert to int and add to total
    total += int(positions[0].searchfor + positions[len(positions)-1].searchfor)

print('Consider your entire calibration document.')
print('What is the sum of all of the calibration values? {}'.format(total)) 