input = open("./2022/python/day-04/input.txt")

counter = 0

for pairs in input:
    sections = pairs.strip().split(',')
    elf_1 = sections[0].split('-')
    elf_2 = sections[1].split('-')
    if(        
        (int(elf_2[0]) <= int(elf_1[0]) <= int(elf_2[1]))
        or (int(elf_1[0]) <= int(elf_2[0]) <= int(elf_1[1]))

        or (int(elf_2[0]) <= int(elf_1[1]) <= int(elf_2[1]))
        or (int(elf_1[0]) <= int(elf_2[1]) <= int(elf_1[1]))
    ):
        counter += 1

print('In how many assignment pairs do the ranges overlap {}'.format(counter))