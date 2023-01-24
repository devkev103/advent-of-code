input = open("./2022/python/day-10/input.txt")

register = 1
cycle_counter = 0
signal_strength = []
cycle_stops = [20, 60, 100, 140, 180, 220]

for command in input:
    if command.startswith("noop"):
        cycle_counter += 1
        if cycle_counter in cycle_stops:
            signal_strength.append(int(cycle_counter * register))
    else:
        instruction, value = command.split(" ")

        if instruction == "addx":
            for x in range(2):
                cycle_counter += 1
                if cycle_counter in cycle_stops:
                    signal_strength.append(int(cycle_counter * register))
            register += int(value)

print(f"Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles. What is the sum of these six signal strengths? {sum(signal_strength)}")