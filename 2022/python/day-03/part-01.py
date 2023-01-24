input = open("./2022/python/day-03/input.txt")

def letter_to_number(char):
    displacement = 0
    if(char.isupper()):
        displacement = 38
    else:
        displacement = 96
    return ord(char) - displacement

total_priorities = 0

for rucksack in input:
    comparment_1 = rucksack[: len(rucksack.strip()) // 2].strip()
    comparment_2 = rucksack[len(rucksack.strip()) // 2:].strip()
    total_priorities += (next(letter_to_number(char) for char in [*comparment_2]  if char in comparment_1)) # gets only the first match then breaks

print('Find the item type that appears in both compartments of each rucksack.')
print('What is the sum of the priorities of those item types? {}'.format(total_priorities))