input = open("./2022/python/day-03/input.txt")

def letter_to_number(char):
    displacement = 0
    if(char.isupper()):
        displacement = 38
    else:
        displacement = 96
    return ord(char) - displacement

total_priorities = 0

while 1==1:
    # parse file every three lines; i don't love it but it works
    rucksack_1 = input.readline().strip()
    rucksack_2 = input.readline().strip()
    rucksack_3 = input.readline().strip()

    if rucksack_1 == '':
        break

    total_priorities += next(letter_to_number(char) for char in [*rucksack_1]  if char in rucksack_2 and char in rucksack_3)

print('Find the item type that corresponds to the badges of each three-Elf group.')
print('What is the sum of the priorities of those item types? {}'.format(total_priorities))