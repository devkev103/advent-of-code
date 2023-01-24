input = open("./2022/python/day-05/input.txt")

crates_raw = []
instructions = []

# parse the output into separate lists
for line in input:
    if("[" in line):
        crates_raw.append(line.rstrip())
    elif line.startswith(' 1'):
        crate_number_footer = [int(number) for number in [*line.strip()] if number != ' ']
    elif line.startswith('move'):
        instructions.append(line.strip())

# parse the crate_stacks into lists; column by column
crate_stacks = []
counter = 1
offset = 0

while counter <= max(crate_number_footer):
    stack = [line[1+offset:2+offset] for line in crates_raw if line[1+offset:2+offset].strip()]  
    crate_stacks.append(stack[::-1]) # reverse the list
    offset += 4
    counter += 1

print(f"Initial crate configuration: {crate_stacks}")

# iterate through the instructions
for instruction in instructions:
    parts = instruction.split(' ')
    for x in range(0, int(parts[1])):
        value = crate_stacks[int(parts[3])-1].pop()
        crate_stacks[int(parts[5])-1].append(value)
    # print(crate_stacks) # for debugging

# pop the top off each crate_stack and join each letter
top_of_stacks = ''.join([x.pop() for x in crate_stacks])
print(f'After the rearrangement procedure completes, what crate ends up on top of each stack? {top_of_stacks}')