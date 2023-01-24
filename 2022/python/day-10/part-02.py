input = open("./2022/python/day-10/input.txt")

register = 1
cycle_counter = 0
crt_screen = []
crt_row = ""

def determine_pixel(register, cycle_counter):
    pixel = "."
    crt_position = (cycle_counter - 1) % 40

    if register - 1 <= crt_position <= register + 1:
        pixel = "#"

    return pixel

for command in input:
    if command.startswith("noop"):
        cycle_counter += 1

        crt_row += determine_pixel(register, cycle_counter)

        if cycle_counter % 40 == 0: # appned row and reset
            crt_screen.append(crt_row)
            crt_row = "" 
    else:
        instruction, value = command.split(" ")

        if instruction == "addx":
            for x in range(2):
                cycle_counter += 1

                crt_row += determine_pixel(register, cycle_counter)

                if cycle_counter % 40 == 0: # appned row and reset
                    crt_screen.append(crt_row)
                    crt_row = "" 

            register += int(value)

print(f"Render the image given by your program. What eight capital letters appear on your CRT?")
for row in crt_screen:
    print(row)